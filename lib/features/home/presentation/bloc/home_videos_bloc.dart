import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/bloc/droppable_completer.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'home_videos_event.dart';
import 'home_videos_state.dart';

@injectable
class HomeVideosBloc extends Bloc<HomeVideosEvent, HomeVideosState> {
  final GetVideosUseCase getVideosUseCase;
  static const int _pageSize = 20;
  int _requestGeneration = 0;
  int _refreshErrorSeq = 0;

  HomeVideosBloc(this.getVideosUseCase) : super(const HomeVideosInitial()) {
    on<FetchVideos>(
      _onFetchVideos,
      transformer: droppable(),
    );
    on<RefreshVideos>(
      _onRefreshVideos,
      transformer: droppableCompleter((e) => e.completer),
    );
    on<ChangeCefrFilter>(
      _onChangeCefrFilter,
      transformer: restartable(),
    );
  }

  List<VideoEntity> _mapVideosWithNewFlag(List<VideoEntity> items, int page) {
    final isPage1 = page == 1;
    return items.asMap().entries.map((entry) {
      final isNew = isPage1 && entry.key < 10;
      return entry.value.copyWith(isNew: isNew);
    }).toList();
  }

  Future<void> _onChangeCefrFilter(
    ChangeCefrFilter event,
    Emitter<HomeVideosState> emit,
  ) async {
    if (state is HomeVideosLoading && state.currentCefr == event.cefr) {
      return;
    }

    final generation = ++_requestGeneration;
    final cached = getVideosUseCase.getCached(
      pageSize: _pageSize,
      cefr: event.cefr,
    );
    if (cached != null) {
      emit(HomeVideosLoaded(
        videos: _mapVideosWithNewFlag(cached.items, cached.page),
        hasReachedMax: cached.hasReachedMax,
        currentPage: cached.page,
        totalItems: cached.totalItems,
        currentCefr: event.cefr,
      ));
      return;
    }
    emit(HomeVideosLoading(currentCefr: event.cefr));

    final result = await getVideosUseCase(
      page: 1,
      pageSize: _pageSize,
      cefr: event.cefr,
    );
    if (generation != _requestGeneration) return;

    result.fold(
      (failure) =>
          emit(HomeVideosError(failure.message, currentCefr: event.cefr)),
      (data) => emit(HomeVideosLoaded(
        videos: _mapVideosWithNewFlag(data.items, data.page),
        hasReachedMax: data.hasReachedMax,
        currentPage: data.page,
        totalItems: data.totalItems,
        currentCefr: event.cefr,
      )),
    );
  }

  Future<void> _onFetchVideos(
    FetchVideos event,
    Emitter<HomeVideosState> emit,
  ) async {
    final currentCefr = state.currentCefr;
    final generation = _requestGeneration;

    if (state is HomeVideosInitial || state is HomeVideosError) {
      final cached = getVideosUseCase.getCached(
        pageSize: _pageSize,
        cefr: currentCefr,
      );
      if (cached != null) {
        emit(HomeVideosLoaded(
          videos: _mapVideosWithNewFlag(cached.items, cached.page),
          hasReachedMax: cached.hasReachedMax,
          currentPage: cached.page,
          totalItems: cached.totalItems,
          currentCefr: currentCefr,
        ));
        return;
      }
      emit(HomeVideosLoading(currentCefr: currentCefr));

      final result = await getVideosUseCase(
        page: 1,
        pageSize: _pageSize,
        cefr: currentCefr,
      );
      if (generation != _requestGeneration) return;
      result.fold(
        (failure) =>
            emit(HomeVideosError(failure.message, currentCefr: currentCefr)),
        (data) => emit(HomeVideosLoaded(
          videos: _mapVideosWithNewFlag(data.items, data.page),
          hasReachedMax: data.hasReachedMax,
          currentPage: data.page,
          totalItems: data.totalItems,
          currentCefr: currentCefr,
        )),
      );
      return;
    }

    if (state is HomeVideosLoaded) {
      final currentState = state as HomeVideosLoaded;
      if (currentState.hasReachedMax || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true, clearLoadMoreError: true));

      final nextPage = currentState.currentPage + 1;
      final result = await getVideosUseCase(
        page: nextPage,
        pageSize: _pageSize,
        cefr: currentState.currentCefr,
      );
      if (generation != _requestGeneration) return;

      result.fold(
        (failure) => emit(currentState.copyWith(
          isLoadingMore: false,
          loadMoreError: failure.message,
        )),
        (data) {
          final existingIds = currentState.videos.map((v) => v.id).toSet();
          final uniqueItems = data.items.where((v) => existingIds.add(v.id)).toList();
          final mappedItems = _mapVideosWithNewFlag(uniqueItems, data.page);
          emit(currentState.copyWith(
            videos: currentState.videos + mappedItems,
            hasReachedMax: data.hasReachedMax || data.items.isEmpty,
            currentPage: data.page,
            totalItems: data.totalItems,
            isLoadingMore: false,
            clearLoadMoreError: true,
          ));
        },
      );
    }
  }

  Future<void> _onRefreshVideos(
    RefreshVideos event,
    Emitter<HomeVideosState> emit,
  ) async {
    try {
      final generation = ++_requestGeneration;
      final currentCefr = state.currentCefr;
      final hasExistingData = state is HomeVideosLoaded;
      if (!hasExistingData) {
        emit(HomeVideosLoading(currentCefr: currentCefr));
      } else if ((state as HomeVideosLoaded).isLoadingMore) {
        // In-flight load-more was invalidated by ++_requestGeneration above.
        emit((state as HomeVideosLoaded).copyWith(isLoadingMore: false));
      }
      final result = await getVideosUseCase(
        page: 1,
        pageSize: _pageSize,
        cefr: currentCefr,
        forceRefresh: true,
      );
      if (generation != _requestGeneration) return;
      result.fold(
        (failure) {
          if (state is HomeVideosLoaded) {
            emit(
              (state as HomeVideosLoaded).copyWith(
                isLoadingMore: false,
                refreshError: failure.message,
                refreshErrorId: ++_refreshErrorSeq,
              ),
            );
          } else {
            emit(HomeVideosError(failure.message, currentCefr: currentCefr));
          }
        },
        (data) => emit(HomeVideosLoaded(
          videos: _mapVideosWithNewFlag(data.items, data.page),
          hasReachedMax: data.hasReachedMax,
          currentPage: data.page,
          totalItems: data.totalItems,
          currentCefr: currentCefr,
        )),
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }
}
