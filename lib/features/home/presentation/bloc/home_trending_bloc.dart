import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/bloc/droppable_completer.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';

import 'home_trending_event.dart';
import 'home_trending_state.dart';

@injectable
class HomeTrendingBloc extends Bloc<HomeTrendingEvent, HomeTrendingState> {
  final GetTrendingVideosUseCase getTrendingVideosUseCase;
  int _requestGeneration = 0;

  HomeTrendingBloc(this.getTrendingVideosUseCase)
      : super(const HomeTrendingInitial()) {
    on<FetchTrendingVideos>(
      _onFetchTrendingVideos,
      transformer: droppable(),
    );
    on<RefreshTrendingVideos>(
      _onRefreshTrendingVideos,
      transformer: droppableCompleter((e) => e.completer),
    );
    on<ChangeTrendingCefrFilter>(
      _onChangeTrendingCefrFilter,
      transformer: restartable(),
    );
  }

  Future<void> _onChangeTrendingCefrFilter(
    ChangeTrendingCefrFilter event,
    Emitter<HomeTrendingState> emit,
  ) async {
    if (state is HomeTrendingLoading && state.currentCefr == event.cefr) {
      return;
    }

    final generation = ++_requestGeneration;
    final cached = getTrendingVideosUseCase.getCached(cefr: event.cefr);
    if (cached != null) {
      emit(HomeTrendingLoaded(videos: cached, currentCefr: event.cefr));
      return;
    }
    emit(HomeTrendingLoading(currentCefr: event.cefr));

    final result = await getTrendingVideosUseCase(cefr: event.cefr);
    if (generation != _requestGeneration) return;

    result.fold(
      (failure) =>
          emit(HomeTrendingError(failure.message, currentCefr: event.cefr)),
      (data) => emit(HomeTrendingLoaded(videos: data, currentCefr: event.cefr)),
    );
  }

  Future<void> _onFetchTrendingVideos(
    FetchTrendingVideos event,
    Emitter<HomeTrendingState> emit,
  ) async {
    final currentCefr = state.currentCefr;
    final generation = _requestGeneration;
    final cached = getTrendingVideosUseCase.getCached(cefr: currentCefr);

    if (cached != null) {
      emit(HomeTrendingLoaded(videos: cached, currentCefr: currentCefr));
      return;
    }
    emit(HomeTrendingLoading(currentCefr: currentCefr));

    final result = await getTrendingVideosUseCase(cefr: currentCefr);
    if (generation != _requestGeneration) return;

    result.fold(
      (failure) =>
          emit(HomeTrendingError(failure.message, currentCefr: currentCefr)),
      (data) => emit(HomeTrendingLoaded(videos: data, currentCefr: currentCefr)),
    );
  }

  Future<void> _onRefreshTrendingVideos(
    RefreshTrendingVideos event,
    Emitter<HomeTrendingState> emit,
  ) async {
    try {
      final generation = ++_requestGeneration;
      final currentCefr = state.currentCefr;
      final result = await getTrendingVideosUseCase(
        cefr: currentCefr,
        forceRefresh: true,
      );
      if (generation != _requestGeneration) return;

      result.fold(
        (failure) {
          if (state is! HomeTrendingLoaded) {
            emit(HomeTrendingError(failure.message, currentCefr: currentCefr));
          }
        },
        (data) =>
            emit(HomeTrendingLoaded(videos: data, currentCefr: currentCefr)),
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }
}
