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
    on<DiscoverRefreshRequested>(_onRefreshRequested, transformer: droppable());
  }

  Future<void> _onVideosFetched(
    DiscoverVideosFetched event,
    Emitter<DiscoverState> emit,
  ) async {
    // Initial fetch (both trending & library)
    if (state.status == DiscoverStatus.initial) {
      await _fetchDiscoverData(emit);
      return;
    }

    // Load more for library
    if (state.hasReachedMax || state.status == DiscoverStatus.loading) return;

    final nextPage = state.currentPage + 1;
    final result = await _getVideosUseCase(
      page: nextPage,
      pageSize: _pageSize,
      cefr: state.cefr,
      genre: state.genre,
      duration: state.duration,
      exerciseType: state.exerciseType,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DiscoverStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (paginatedResult) {
        final allVideos = List<VideoEntity>.of(state.allFetchedVideos)
          ..addAll(paginatedResult.items);
        final displayedVideos = _filterLocal(
          allVideos,
          state.searchQuery,
        );
        emit(
          state.copyWith(
            status: DiscoverStatus.success,
            allFetchedVideos: allVideos,
            displayedVideos: displayedVideos,
            hasReachedMax: nextPage >= paginatedResult.totalPages,
            currentPage: nextPage,
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
    await _fetchDiscoverData(emit);
  }

  Future<void> _fetchDiscoverData(
    Emitter<DiscoverState> emit, {
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
  }) async {
    final targetCefr = cefr ?? state.cefr;
    final targetGenre = genre ?? state.genre;
    final targetDuration = duration ?? state.duration;
    final targetExerciseType = exerciseType ?? state.exerciseType;

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
    ));

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

    List<VideoEntity> trendingVideos = [];
    DiscoverStatus trendingStatus = DiscoverStatus.success;
    trendingResult.fold(
      (failure) => trendingStatus = DiscoverStatus.failure,
      (data) => trendingVideos = data,
    );

    List<PlaylistEntity> playlists = [];
    DiscoverStatus playlistStatus = DiscoverStatus.success;
    playlistsResult.fold(
      (failure) => playlistStatus = DiscoverStatus.failure,
      (data) => playlists = data.items,
    );

    libraryResult.fold(
      (failure) => emit(
        state.copyWith(
          status: DiscoverStatus.failure,
          trendingStatus: trendingStatus,
          trendingVideos: trendingVideos,
          playlistStatus: playlistStatus,
          playlists: playlists,
          errorMessage: failure.message,
        ),
      ),
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
            hasReachedMax: paginatedResult.totalPages <= 1,
            currentPage: 1,
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
