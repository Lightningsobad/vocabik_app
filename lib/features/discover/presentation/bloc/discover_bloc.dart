import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/features/discover/domain/usecases/get_playlists_usecase.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'discover_event.dart';
import 'discover_state.dart';

@injectable
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetVideosUseCase _getVideosUseCase;
  final GetTrendingVideosUseCase _getTrendingVideosUseCase;
  final GetPlaylistsUseCase _getPlaylistsUseCase;
  static const int _pageSize = 20;
  int _requestGeneration = 0;

  DiscoverBloc(
    this._getVideosUseCase,
    this._getTrendingVideosUseCase,
    this._getPlaylistsUseCase,
  ) : super(const DiscoverState()) {
    on<DiscoverVideosFetched>(_onVideosFetched, transformer: droppable());
    on<DiscoverSearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: restartable(),
    );
    on<DiscoverFilterChanged>(_onFilterChanged, transformer: restartable());
    on<DiscoverRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onVideosFetched(
    DiscoverVideosFetched event,
    Emitter<DiscoverState> emit,
  ) async {
    // Initial fetch (or retry initial failure when no videos are loaded)
    if (state.status == DiscoverStatus.initial ||
        (state.status == DiscoverStatus.failure &&
            state.allFetchedVideos.isEmpty)) {
      await _fetchDiscoverData(emit);
      return;
    }

    // Load more for library
    if (state.hasReachedMax ||
        state.status == DiscoverStatus.loading ||
        state.isLoadingMore) {
      return;
    }

    final generation = _requestGeneration;
    emit(state.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    final nextPage = state.currentPage + 1;
    final result = await _getVideosUseCase(
      page: nextPage,
      pageSize: _pageSize,
      cefr: state.cefr,
      genre: state.genre,
      duration: state.duration,
      exerciseType: state.exerciseType,
    );
    if (generation != _requestGeneration) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          loadMoreError: failure.message,
        ),
      ),
      (paginatedResult) {
        final existingIds = state.allFetchedVideos.map((v) => v.id).toSet();
        final uniqueItems = paginatedResult.items
            .where((v) => existingIds.add(v.id))
            .toList();
        final allVideos = List<VideoEntity>.of(state.allFetchedVideos)
          ..addAll(uniqueItems);
        final displayedVideos = _filterLocal(
          allVideos,
          state.searchQuery,
        );
        emit(
          state.copyWith(
            status: DiscoverStatus.success,
            allFetchedVideos: allVideos,
            displayedVideos: displayedVideos,
            hasReachedMax:
                paginatedResult.hasReachedMax || paginatedResult.items.isEmpty,
            currentPage: paginatedResult.page,
            isLoadingMore: false,
            clearLoadMoreError: true,
          ),
        );
      },
    );
  }

  Future<void> _onSearchQueryChanged(
    DiscoverSearchQueryChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    final query = event.query;
    final displayedVideos = _filterLocal(
      state.allFetchedVideos,
      query,
    );

    emit(state.copyWith(searchQuery: query, displayedVideos: displayedVideos));
  }

  Future<void> _onFilterChanged(
    DiscoverFilterChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    await _fetchDiscoverData(
      emit,
      cefr: event.cefr,
      genre: event.genre,
      duration: event.duration,
      exerciseType: event.exerciseType,
    );
  }

  Future<void> _onRefreshRequested(
    DiscoverRefreshRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    try {
      await _fetchDiscoverData(emit, preserveExistingData: true);
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  Future<void> _fetchDiscoverData(
    Emitter<DiscoverState> emit, {
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
    bool preserveExistingData = false,
  }) async {
    final generation = ++_requestGeneration;
    final targetCefr = cefr ?? state.cefr;
    final targetGenre = genre ?? state.genre;
    final targetDuration = duration ?? state.duration;
    final targetExerciseType = exerciseType ?? state.exerciseType;

    final hasExistingData = preserveExistingData &&
        (state.allFetchedVideos.isNotEmpty ||
            state.trendingVideos.isNotEmpty ||
            state.playlists.isNotEmpty);

    if (!hasExistingData) {
      emit(state.copyWith(
        cefr: targetCefr,
        genre: targetGenre,
        duration: targetDuration,
        exerciseType: targetExerciseType,
        status: DiscoverStatus.loading,
        trendingStatus: DiscoverStatus.loading,
        playlistStatus: DiscoverStatus.loading,
        displayedVideos: const [],
        trendingVideos: const [],
        playlists: const [],
        allFetchedVideos: const [],
        hasReachedMax: false,
        currentPage: 1,
        isLoadingMore: false,
        clearLoadMoreError: true,
      ));
    } else if (state.isLoadingMore) {
      // In-flight load-more was invalidated by ++_requestGeneration above.
      emit(state.copyWith(isLoadingMore: false));
    }

    final trendingFuture = _getTrendingVideosUseCase(
      cefr: targetCefr,
      genre: targetGenre,
      duration: targetDuration,
      exerciseType: targetExerciseType,
    );

    final libraryFuture = _getVideosUseCase(
      page: 1,
      pageSize: _pageSize,
      cefr: targetCefr,
      genre: targetGenre,
      duration: targetDuration,
      exerciseType: targetExerciseType,
    );

    final playlistsFuture = _getPlaylistsUseCase(
      page: 1,
      pageSize: 10,
    );

    final trendingResult = await trendingFuture;
    final libraryResult = await libraryFuture;
    final playlistsResult = await playlistsFuture;
    if (generation != _requestGeneration) return;

    List<VideoEntity> trendingVideos =
        hasExistingData ? state.trendingVideos : [];
    DiscoverStatus trendingStatus =
        hasExistingData ? state.trendingStatus : DiscoverStatus.success;
    trendingResult.fold(
      (failure) {
        if (!hasExistingData || state.trendingVideos.isEmpty) {
          trendingStatus = DiscoverStatus.failure;
        }
      },
      (data) {
        trendingVideos = data;
        trendingStatus = DiscoverStatus.success;
      },
    );

    List<PlaylistEntity> playlists = hasExistingData ? state.playlists : [];
    DiscoverStatus playlistStatus =
        hasExistingData ? state.playlistStatus : DiscoverStatus.success;
    playlistsResult.fold(
      (failure) {
        if (!hasExistingData || state.playlists.isEmpty) {
          playlistStatus = DiscoverStatus.failure;
        }
      },
      (data) {
        playlists = data.items;
        playlistStatus = DiscoverStatus.success;
      },
    );

    libraryResult.fold(
      (failure) {
        if (hasExistingData && state.allFetchedVideos.isNotEmpty) {
          emit(
            state.copyWith(
              trendingStatus: trendingStatus,
              trendingVideos: trendingVideos,
              playlistStatus: playlistStatus,
              playlists: playlists,
              isLoadingMore: false,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: DiscoverStatus.failure,
            trendingStatus: trendingStatus,
            trendingVideos: trendingVideos,
            playlistStatus: playlistStatus,
            playlists: playlists,
            errorMessage: failure.message,
            isLoadingMore: false,
            clearLoadMoreError: true,
          ),
        );
      },
      (paginatedResult) {
        final allVideos = paginatedResult.items;
        final displayedVideos = _filterLocal(
          allVideos,
          state.searchQuery,
        );
        emit(
          state.copyWith(
            status: DiscoverStatus.success,
            trendingStatus: trendingStatus,
            trendingVideos: trendingVideos,
            playlistStatus: playlistStatus,
            playlists: playlists,
            allFetchedVideos: allVideos,
            displayedVideos: displayedVideos,
            hasReachedMax:
                paginatedResult.hasReachedMax || paginatedResult.items.isEmpty,
            currentPage: paginatedResult.page,
            isLoadingMore: false,
            clearLoadMoreError: true,
          ),
        );
      },
    );
  }

  List<VideoEntity> _filterLocal(
    List<VideoEntity> allVideos,
    String query,
  ) {
    var filtered = allVideos;
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered
          .where((video) => video.title.toLowerCase().contains(lowerQuery))
          .toList();
    }
    return filtered;
  }
}
