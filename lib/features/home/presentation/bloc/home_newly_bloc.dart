import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'home_newly_event.dart';
import 'home_newly_state.dart';

@injectable
class HomeNewlyBloc extends Bloc<HomeNewlyEvent, HomeNewlyState> {
  final GetVideosUseCase getVideosUseCase;

  HomeNewlyBloc(this.getVideosUseCase) : super(const HomeNewlyInitial()) {
    on<FetchNewlyVideos>(
      _onFetchNewlyVideos,
      transformer: droppable(),
    );
    on<RefreshNewlyVideos>(
      _onRefreshNewlyVideos,
      transformer: droppable(),
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

    emit(HomeNewlyLoading(currentCefr: event.cefr));
    final result = await getVideosUseCase(
      page: 1,
      pageSize: 10,
      cefr: event.cefr,
    );

    result.fold(
      (failure) => emit(HomeNewlyError(failure.message, currentCefr: event.cefr)),
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
    emit(HomeNewlyLoading(currentCefr: currentCefr));
    final result = await getVideosUseCase(
      page: 1,
      pageSize: 10,
      cefr: currentCefr,
    );
    result.fold(
      (failure) => emit(HomeNewlyError(failure.message, currentCefr: currentCefr)),
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
    final currentCefr = state.currentCefr;
    final result = await getVideosUseCase(
      page: 1,
      pageSize: 10,
      cefr: currentCefr,
    );
    result.fold(
      (failure) => emit(HomeNewlyError(failure.message, currentCefr: currentCefr)),
      (data) {
        final newVideos =
            data.items.map((e) => e.copyWith(isNew: true)).toList();
        emit(HomeNewlyLoaded(videos: newVideos, currentCefr: currentCefr));
      },
    );
  }
}
