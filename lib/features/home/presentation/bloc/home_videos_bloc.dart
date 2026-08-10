import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'home_videos_event.dart';
import 'home_videos_state.dart';

@injectable
class HomeVideosBloc extends Bloc<HomeVideosEvent, HomeVideosState> {
  final GetVideosUseCase getVideosUseCase;
  static const int _pageSize = 20;

  HomeVideosBloc(this.getVideosUseCase) : super(HomeVideosInitial()) {
    on<FetchVideos>(
      _onFetchVideos,
      transformer: droppable(),
    );
    on<RefreshVideos>(_onRefreshVideos);
  }

  Future<void> _onFetchVideos(
    FetchVideos event,
    Emitter<HomeVideosState> emit,
  ) async {
    if (state is HomeVideosInitial) {
      emit(HomeVideosLoading());
      final result = await getVideosUseCase(page: 1, pageSize: _pageSize);
      result.fold(
        (failure) => emit(HomeVideosError(failure.message)),
        (data) => emit(HomeVideosLoaded(
          videos: data.items,
          hasReachedMax: data.hasReachedMax,
          currentPage: data.page,
        )),
      );
      return;
    }

    if (state is HomeVideosLoaded) {
      final currentState = state as HomeVideosLoaded;
      if (currentState.hasReachedMax) return;

      final nextPage = currentState.currentPage + 1;
      final result = await getVideosUseCase(page: nextPage, pageSize: _pageSize);
      
      result.fold(
        (failure) => emit(HomeVideosError(failure.message)),
        (data) {
          emit(data.items.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : HomeVideosLoaded(
                  videos: currentState.videos + data.items,
                  hasReachedMax: data.hasReachedMax,
                  currentPage: data.page,
                ));
        },
      );
    }
  }

  Future<void> _onRefreshVideos(
    RefreshVideos event,
    Emitter<HomeVideosState> emit,
  ) async {
    emit(HomeVideosLoading());
    final result = await getVideosUseCase(page: 1, pageSize: _pageSize);
    result.fold(
      (failure) => emit(HomeVideosError(failure.message)),
      (data) => emit(HomeVideosLoaded(
        videos: data.items,
        hasReachedMax: data.hasReachedMax,
        currentPage: data.page,
      )),
    );
  }
}
