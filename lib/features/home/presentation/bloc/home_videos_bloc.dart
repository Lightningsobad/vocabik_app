import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'home_videos_event.dart';
import 'home_videos_state.dart';

@injectable
class HomeVideosBloc extends Bloc<HomeVideosEvent, HomeVideosState> {
  final GetVideosUseCase getVideosUseCase;
  static const int _pageSize = 20;

  HomeVideosBloc(this.getVideosUseCase) : super(const HomeVideosInitial()) {
    on<FetchVideos>(
      _onFetchVideos,
      transformer: droppable(),
    );
    on<RefreshVideos>(_onRefreshVideos);
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

    emit(HomeVideosLoading(currentCefr: event.cefr));
    final result = await getVideosUseCase(
      page: 1,
      pageSize: _pageSize,
      cefr: event.cefr,
    );

    result.fold(
      (failure) => emit(HomeVideosError(failure.message, currentCefr: event.cefr)),
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

    if (state is HomeVideosInitial || state is HomeVideosError) {
      emit(HomeVideosLoading(currentCefr: currentCefr));
      final result = await getVideosUseCase(
        page: 1,
        pageSize: _pageSize,
        cefr: currentCefr,
      );
      result.fold(
        (failure) => emit(HomeVideosError(failure.message, currentCefr: currentCefr)),
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
      if (currentState.hasReachedMax) return;

      final nextPage = currentState.currentPage + 1;
      final result = await getVideosUseCase(
        page: nextPage,
        pageSize: _pageSize,
        cefr: currentState.currentCefr,
      );

      result.fold(
        (failure) => emit(HomeVideosError(failure.message, currentCefr: currentState.currentCefr)),
        (data) {
          final mappedItems = _mapVideosWithNewFlag(data.items, data.page);
          emit(data.items.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : HomeVideosLoaded(
                  videos: currentState.videos + mappedItems,
                  hasReachedMax: data.hasReachedMax,
                  currentPage: data.page,
                  totalItems: data.totalItems,
                  currentCefr: currentState.currentCefr,
                ));
        },
      );
    }
  }

  Future<void> _onRefreshVideos(
    RefreshVideos event,
    Emitter<HomeVideosState> emit,
  ) async {
    final currentCefr = state.currentCefr;
    emit(HomeVideosLoading(currentCefr: currentCefr));
    final result = await getVideosUseCase(
      page: 1,
      pageSize: _pageSize,
      cefr: currentCefr,
    );
    result.fold(
      (failure) => emit(HomeVideosError(failure.message, currentCefr: currentCefr)),
      (data) => emit(HomeVideosLoaded(
        videos: _mapVideosWithNewFlag(data.items, data.page),
        hasReachedMax: data.hasReachedMax,
        currentPage: data.page,
        totalItems: data.totalItems,
        currentCefr: currentCefr,
      )),
    );
  }
}
