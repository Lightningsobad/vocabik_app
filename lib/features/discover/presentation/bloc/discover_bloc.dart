import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'discover_event.dart';
import 'discover_state.dart';

@injectable
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetVideosUseCase _getVideosUseCase;
  static const int _pageSize = 20;

  DiscoverBloc(this._getVideosUseCase) : super(const DiscoverState()) {
    on<DiscoverVideosFetched>(
      _onVideosFetched,
      transformer: droppable(),
    );
    on<DiscoverSearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: restartable(),
    );
    on<DiscoverFilterChanged>(
      _onFilterChanged,
      transformer: restartable(),
    );
    on<DiscoverRefreshRequested>(
      _onRefreshRequested,
      transformer: droppable(),
    );
  }

  Future<void> _onVideosFetched(
    DiscoverVideosFetched event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == DiscoverStatus.initial) {
        emit(state.copyWith(status: DiscoverStatus.loading));
        
        final result = await _getVideosUseCase(
          page: 1,
          pageSize: _pageSize,
          cefr: state.cefr,
          genre: state.genre,
          window: state.window,
        );

        result.fold(
          (failure) => emit(state.copyWith(
            status: DiscoverStatus.failure,
            errorMessage: failure.message,
          )),
          (paginatedResult) {
            final allVideos = paginatedResult.items;
            final displayedVideos = _filterLocal(allVideos, state.searchQuery, state.duration);
            emit(state.copyWith(
              status: DiscoverStatus.success,
              allFetchedVideos: allVideos,
              displayedVideos: displayedVideos,
              hasReachedMax: paginatedResult.totalPages <= 1,
              currentPage: 1,
            ));
          },
        );
        return;
      }

      final nextPage = state.currentPage + 1;
      final result = await _getVideosUseCase(
        page: nextPage,
        pageSize: _pageSize,
        cefr: state.cefr,
        genre: state.genre,
        window: state.window,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: DiscoverStatus.failure,
          errorMessage: failure.message,
        )),
        (paginatedResult) {
          final allVideos = List<VideoEntity>.of(state.allFetchedVideos)..addAll(paginatedResult.items);
          final displayedVideos = _filterLocal(allVideos, state.searchQuery, state.duration);
          emit(state.copyWith(
            status: DiscoverStatus.success,
            allFetchedVideos: allVideos,
            displayedVideos: displayedVideos,
            hasReachedMax: nextPage >= paginatedResult.totalPages,
            currentPage: nextPage,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: DiscoverStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSearchQueryChanged(
    DiscoverSearchQueryChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    final query = event.query;
    final displayedVideos = _filterLocal(state.allFetchedVideos, query, state.duration);
    
    emit(state.copyWith(
      searchQuery: query,
      displayedVideos: displayedVideos,
    ));
  }

  Future<void> _onFilterChanged(
    DiscoverFilterChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    final cefr = event.cefr ?? state.cefr;
    final genre = event.genre ?? state.genre;
    final window = event.window ?? state.window;
    final duration = event.duration ?? state.duration;

    // Determine if we need to call API or just local filter
    final needsApiCall = cefr != state.cefr || genre != state.genre || window != state.window;

    emit(state.copyWith(
      cefr: cefr,
      genre: genre,
      window: window,
      duration: duration,
      status: needsApiCall ? DiscoverStatus.loading : state.status,
    ));

    if (needsApiCall) {
      final result = await _getVideosUseCase(
        page: 1,
        pageSize: _pageSize,
        cefr: cefr,
        genre: genre,
        window: window,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: DiscoverStatus.failure,
          errorMessage: failure.message,
        )),
        (paginatedResult) {
          final allVideos = paginatedResult.items;
          final displayedVideos = _filterLocal(allVideos, state.searchQuery, duration);
          emit(state.copyWith(
            status: DiscoverStatus.success,
            allFetchedVideos: allVideos,
            displayedVideos: displayedVideos,
            hasReachedMax: paginatedResult.totalPages <= 1,
            currentPage: 1,
          ));
        },
      );
    } else {
      // Just apply local filters if only duration changed
      final displayedVideos = _filterLocal(state.allFetchedVideos, state.searchQuery, duration);
      emit(state.copyWith(displayedVideos: displayedVideos));
    }
  }

  Future<void> _onRefreshRequested(
    DiscoverRefreshRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverStatus.loading));
    
    final result = await _getVideosUseCase(
      page: 1,
      pageSize: _pageSize,
      cefr: state.cefr,
      genre: state.genre,
      window: state.window,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: DiscoverStatus.failure,
        errorMessage: failure.message,
      )),
      (paginatedResult) {
        final allVideos = paginatedResult.items;
        final displayedVideos = _filterLocal(allVideos, state.searchQuery, state.duration);
        emit(state.copyWith(
          status: DiscoverStatus.success,
          allFetchedVideos: allVideos,
          displayedVideos: displayedVideos,
          hasReachedMax: paginatedResult.totalPages <= 1,
          currentPage: 1,
        ));
      },
    );
  }

  List<VideoEntity> _filterLocal(List<VideoEntity> allVideos, String query, String duration) {
    var filtered = allVideos;
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((video) => 
        video.title.toLowerCase().contains(lowerQuery)
      ).toList();
    }
    
    // Duration filter logic (mocked for now since VideoEntity has no duration field)
    // Could be implemented here when API supports it.
    
    return filtered;
  }
}
