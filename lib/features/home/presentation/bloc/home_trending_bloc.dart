import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'home_trending_event.dart';
import 'home_trending_state.dart';

@injectable
class HomeTrendingBloc extends Bloc<HomeTrendingEvent, HomeTrendingState> {
  final GetVideosUseCase getVideosUseCase;

  HomeTrendingBloc(this.getVideosUseCase) : super(HomeTrendingInitial()) {
    on<FetchTrendingVideos>(
      _onFetchTrendingVideos,
      transformer: droppable(),
    );
    on<RefreshTrendingVideos>(
      _onRefreshTrendingVideos,
      transformer: droppable(),
    );
  }

  Future<void> _onFetchTrendingVideos(
    FetchTrendingVideos event,
    Emitter<HomeTrendingState> emit,
  ) async {
    emit(HomeTrendingLoading());
    final result = await getVideosUseCase(page: 1, pageSize: 10);
    result.fold(
      (failure) => emit(HomeTrendingError(failure.message)),
      (data) => emit(HomeTrendingLoaded(videos: data.items)),
    );
  }

  Future<void> _onRefreshTrendingVideos(
    RefreshTrendingVideos event,
    Emitter<HomeTrendingState> emit,
  ) async {
    final result = await getVideosUseCase(page: 1, pageSize: 10);
    result.fold(
      (failure) => emit(HomeTrendingError(failure.message)),
      (data) => emit(HomeTrendingLoaded(videos: data.items)),
    );
  }
}
