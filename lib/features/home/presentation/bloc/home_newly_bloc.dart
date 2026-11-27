import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/bloc/droppable_completer.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'home_newly_event.dart';
import 'home_newly_state.dart';

@injectable
class HomeNewlyBloc extends Bloc<HomeNewlyEvent, HomeNewlyState> {
  final GetVideosUseCase getVideosUseCase;
  static const int _pageSize = 10;
  int _requestGeneration = 0;

  HomeNewlyBloc(this.getVideosUseCase) : super(const HomeNewlyInitial()) {
    on<FetchNewlyVideos>(
      _onFetchNewlyVideos,
      transformer: droppable(),
    );
    on<RefreshNewlyVideos>(
      _onRefreshNewlyVideos,
      transformer: droppableCompleter((e) => e.completer),
    );
    on<ChangeNewlyCefrFilter>(
      _onChangeNewlyCefrFilter,
      transformer: restartable(),
    );
  }

  Future<void> _onChangeNewlyCefrFilter(
    ChangeNewlyCefrFilter event,
    Emitter<HomeNewlyState> emit,
  ) async {
    if (state is HomeNewlyLoading && state.currentCefr == event.cefr) {
      return;
    }

    final generation = ++_requestGeneration;
    final cached = getVideosUseCase.getCached(
      pageSize: _pageSize,
      cefr: event.cefr,
    );
    if (cached != null) {
      final cachedVideos =
          cached.items.map((e) => e.copyWith(isNew: true)).toList();
      emit(HomeNewlyLoaded(videos: cachedVideos, currentCefr: event.cefr));
      return;
    }
    emit(HomeNewlyLoading(currentCefr: event.cefr));

    final result = await getVideosUseCase(
      page: 1,
      pageSize: _pageSize,
      cefr: event.cefr,
    );
    if (generation != _requestGeneration) return;

    result.fold(
      (failure) =>
          emit(HomeNewlyError(failure.message, currentCefr: event.cefr)),
      (data) {
        final newVideos =
            data.items.map((e) => e.copyWith(isNew: true)).toList();
        emit(HomeNewlyLoaded(videos: newVideos, currentCefr: event.cefr));
      },
    );
  }

  Future<void> _onFetchNewlyVideos(
    FetchNewlyVideos event,
    Emitter<HomeNewlyState> emit,
  ) async {
    final currentCefr = state.currentCefr;
    final generation = _requestGeneration;
    final cached = getVideosUseCase.getCached(
      pageSize: _pageSize,
      cefr: currentCefr,
    );
    if (cached != null) {
      final cachedVideos =
          cached.items.map((e) => e.copyWith(isNew: true)).toList();
      emit(HomeNewlyLoaded(videos: cachedVideos, currentCefr: currentCefr));
      return;
    }
    emit(HomeNewlyLoading(currentCefr: currentCefr));

    final result = await getVideosUseCase(
      page: 1,
      pageSize: _pageSize,
      cefr: currentCefr,
    );
    if (generation != _requestGeneration) return;

    result.fold(
      (failure) =>
          emit(HomeNewlyError(failure.message, currentCefr: currentCefr)),
      (data) {
        final newVideos =
            data.items.map((e) => e.copyWith(isNew: true)).toList();
        emit(HomeNewlyLoaded(videos: newVideos, currentCefr: currentCefr));
      },
    );
  }

  Future<void> _onRefreshNewlyVideos(
    RefreshNewlyVideos event,
    Emitter<HomeNewlyState> emit,
  ) async {
    try {
      final generation = ++_requestGeneration;
      final currentCefr = state.currentCefr;
      final result = await getVideosUseCase(
        page: 1,
        pageSize: _pageSize,
        cefr: currentCefr,
        forceRefresh: true,
      );
      if (generation != _requestGeneration) return;

      result.fold(
        (failure) {
          if (state is! HomeNewlyLoaded) {
            emit(HomeNewlyError(failure.message, currentCefr: currentCefr));
          }
        },
        (data) {
          final newVideos =
              data.items.map((e) => e.copyWith(isNew: true)).toList();
          emit(HomeNewlyLoaded(videos: newVideos, currentCefr: currentCefr));
        },
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }
}
