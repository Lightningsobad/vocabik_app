import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';

import 'home_trending_event.dart';
import 'home_trending_state.dart';

@injectable
class HomeTrendingBloc extends Bloc<HomeTrendingEvent, HomeTrendingState> {
  final GetTrendingVideosUseCase getTrendingVideosUseCase;

  HomeTrendingBloc(this.getTrendingVideosUseCase)
      : super(const HomeTrendingInitial()) {
    on<FetchTrendingVideos>(
      _onFetchTrendingVideos,
      transformer: droppable(),
    );
    on<RefreshTrendingVideos>(
      _onRefreshTrendingVideos,
      transformer: droppable(),
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

    emit(HomeTrendingLoading(currentCefr: event.cefr));
    final result = await getTrendingVideosUseCase(cefr: event.cefr);
    result.fold(
      (failure) => emit(HomeTrendingError(failure.message, currentCefr: event.cefr)),
      (data) => emit(HomeTrendingLoaded(videos: data, currentCefr: event.cefr)),
    );
  }

  Future<void> _onFetchTrendingVideos(
    FetchTrendingVideos event,
    Emitter<HomeTrendingState> emit,
  ) async {
    final currentCefr = state.currentCefr;
    emit(HomeTrendingLoading(currentCefr: currentCefr));
    final result = await getTrendingVideosUseCase(cefr: currentCefr);
    result.fold(
      (failure) => emit(HomeTrendingError(failure.message, currentCefr: currentCefr)),
      (data) => emit(HomeTrendingLoaded(videos: data, currentCefr: currentCefr)),
    );
  }

  Future<void> _onRefreshTrendingVideos(
    RefreshTrendingVideos event,
    Emitter<HomeTrendingState> emit,
  ) async {
    final currentCefr = state.currentCefr;
    final result = await getTrendingVideosUseCase(cefr: currentCefr);
    result.fold(
      (failure) => emit(HomeTrendingError(failure.message, currentCefr: currentCefr)),
      (data) => emit(HomeTrendingLoaded(videos: data, currentCefr: currentCefr)),
    );
  }
}
