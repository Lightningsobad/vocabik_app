import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'home_newly_event.dart';
import 'home_newly_state.dart';

@injectable
class HomeNewlyBloc extends Bloc<HomeNewlyEvent, HomeNewlyState> {
  final GetVideosUseCase getVideosUseCase;

  HomeNewlyBloc(this.getVideosUseCase) : super(HomeNewlyInitial()) {
    on<FetchNewlyVideos>(
      _onFetchNewlyVideos,
      transformer: droppable(),
    );
    on<RefreshNewlyVideos>(
      _onRefreshNewlyVideos,
      transformer: droppable(),
    );
  }

  Future<void> _onFetchNewlyVideos(
    FetchNewlyVideos event,
    Emitter<HomeNewlyState> emit,
  ) async {
    emit(HomeNewlyLoading());
    final result = await getVideosUseCase(page: 1, pageSize: 10);
    result.fold(
      (failure) => emit(HomeNewlyError(failure.message)),
      (data) => emit(HomeNewlyLoaded(videos: data.items)),
    );
  }

  Future<void> _onRefreshNewlyVideos(
    RefreshNewlyVideos event,
    Emitter<HomeNewlyState> emit,
  ) async {
    final result = await getVideosUseCase(page: 1, pageSize: 10);
    result.fold(
      (failure) => emit(HomeNewlyError(failure.message)),
      (data) => emit(HomeNewlyLoaded(videos: data.items)),
    );
  }
}
