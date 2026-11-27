import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/core/network/dio_cancel_token.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/features/discover/domain/usecases/get_playlists_usecase.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/usecases/get_trending_videos_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_video_categories_usecase.dart';
import 'package:vocabik_app/shared/domain/usecases/get_videos_usecase.dart';

import 'discover_event.dart';
import 'discover_state.dart';

@injectable
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetVideosUseCase _getVideosUseCase;
  final GetTrendingVideosUseCase _getTrendingVideosUseCase;
  final GetPlaylistsUseCase _getPlaylistsUseCase;
  final GetVideoCategoriesUseCase _getVideoCategoriesUseCase;
  static const int _pageSize = 20;
  int _requestGeneration = 0;
  int? _inFlightLoadMoreGeneration;
  int _refreshErrorSeq = 0;
  bool _browseDataStale = false;
  bool _isRefreshingCategories = false;
  AppCancelToken? _libraryCancelToken;
  AppCancelToken? _loadMoreCancelToken;

  DiscoverBloc(
    this._getVideosUseCase,
    this._getTrendingVideosUseCase,
    this._getPlaylistsUseCase,
    this._getVideoCategoriesUseCase,
  ) : super(_initialState(_getVideoCategoriesUseCase)) {
    on<DiscoverVideosFetched>(_onVideosFetched);
    on<DiscoverSearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: restartable(),
    );
    on<DiscoverFilterChanged>(_onFilterChanged, transformer: restartable());
    on<DiscoverRefreshRequested>(_onRefreshRequested);
    on<DiscoverCategoriesUpdated>(_onCategoriesUpdated);
  }

  static DiscoverState _initialState(GetVideoCategoriesUseCase useCase) {
    final cached = useCase.getCached();
    return DiscoverState(
      categories: cached,
      isCategoriesLoading: cached.isEmpty,
    );
  }

  @override
  Future<void> close() {
    _libraryCancelToken?.cancel();
    _loadMoreCancelToken?.cancel();
    return super.close();
  }

  Future<void> _onVideosFetched(
    DiscoverVideosFetched event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state.status == DiscoverStatus.initial) {
      unawaited(_refreshCategoriesInBackground());
      await _fetchDiscoverData(emit);
      return;
    }

    // Retry initial/library failure when no videos are loaded.
    // Keep already-loaded Trending & Playlists intact when possible.
    if (state.status == DiscoverStatus.failure &&
        state.displayedVideos.isEmpty) {
      if (state.categories.isEmpty) {
        if (!state.isCategoriesLoading) {
          emit(state.copyWith(isCategoriesLoading: true));
        }
        unawaited(_refreshCategoriesInBackground());
      }
      final canRetryLibraryOnly =
          state.searchQuery.isNotEmpty ||
          state.trendingStatus == DiscoverStatus.success ||
          state.playlistStatus == DiscoverStatus.success;
      if (canRetryLibraryOnly) {
        await _fetchLibraryOnly(emit, searchQuery: state.searchQuery);
      } else {
        await _fetchDiscoverData(emit);
      }
      return;
    }

    // Load more for library, scoped to current generation so stale in-flight
    // requests from previous filters cannot starve newer generations.
    final generation = _requestGeneration;
    if (state.hasReachedMax ||
        state.status == DiscoverStatus.loading ||
        state.isLoadingMore ||
        _inFlightLoadMoreGeneration == generation) {
      return;
    }

    _inFlightLoadMoreGeneration = generation;
    _loadMoreCancelToken?.cancel();
    final cancelToken = DioCancelToken();
    _loadMoreCancelToken = cancelToken;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    final nextPage = state.currentPage + 1;
    try {
      final result = await _getVideosUseCase(
        page: nextPage,
        pageSize: _pageSize,
        cefr: state.cefr,
        genre: state.genre,
        duration: state.duration,
        exerciseType: state.exerciseType,
        searchQuery: state.searchQuery,
        cancelToken: cancelToken,
      );
      if (generation != _requestGeneration) return;

      result.fold(
        (failure) {
          if (failure is CancelledFailure) return;
          emit(
            state.copyWith(
              isLoadingMore: false,
              loadMoreError: failure.message,
            ),
          );
        },
        (paginatedResult) {
          final existingIds = state.displayedVideos.map((v) => v.id).toSet();
          final uniqueItems = paginatedResult.items
              .where((v) => existingIds.add(v.id))
              .toList();
          final allVideos = List<VideoEntity>.of(state.displayedVideos)
            ..addAll(uniqueItems);
          emit(
            state.copyWith(
              status: DiscoverStatus.success,
              displayedVideos: allVideos,
              totalItems: paginatedResult.totalItems,
              hasReachedMax:
                  paginatedResult.hasReachedMax ||
                  paginatedResult.items.isEmpty,
              currentPage: paginatedResult.page,
              isLoadingMore: false,
              clearLoadMoreError: true,
            ),
          );
        },
      );
    } finally {
      if (_inFlightLoadMoreGeneration == generation) {
        _inFlightLoadMoreGeneration = null;
      }
      if (identical(_loadMoreCancelToken, cancelToken)) {
        _loadMoreCancelToken = null;
      }
    }
  }

  Future<void> _onSearchQueryChanged(
    DiscoverSearchQueryChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    final query = event.query.trim();
    if (query == state.searchQuery &&
        !_browseDataStale &&
        (state.status == DiscoverStatus.success ||
            state.status == DiscoverStatus.loading)) {
      return;
    }

    // When exiting search mode, ensure Trending & Playlists are populated and
    // synced with any filter changes made while searching.
    if (query.isEmpty) {
      final needsBrowseFetch =
          _browseDataStale ||
          state.trendingStatus != DiscoverStatus.success ||
          state.playlistStatus != DiscoverStatus.success;
      if (needsBrowseFetch) {
        await _fetchDiscoverData(emit, searchQuery: '');
        return;
      }
    }

    await _fetchLibraryOnly(emit, searchQuery: query);
  }

  Future<void> _onFilterChanged(
    DiscoverFilterChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state.searchQuery.isNotEmpty) {
      _browseDataStale = true;
      await _fetchLibraryOnly(
        emit,
        cefr: event.cefr,
        genre: event.genre,
        duration: event.duration,
        exerciseType: event.exerciseType,
        searchQuery: state.searchQuery,
      );
      return;
    }

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
    if (state.categories.isEmpty && !state.isCategoriesLoading) {
      emit(state.copyWith(isCategoriesLoading: true));
    }
    unawaited(_refreshCategoriesInBackground(forceRefresh: true));
    try {
      if (state.searchQuery.isNotEmpty) {
        await _fetchLibraryOnly(
          emit,
          searchQuery: state.searchQuery,
          preserveExistingData: true,
          forceRefresh: true,
        );
      } else {
        await _fetchDiscoverData(emit, preserveExistingData: true);
      }
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  void _onCategoriesUpdated(
    DiscoverCategoriesUpdated event,
    Emitter<DiscoverState> emit,
  ) {
    final nextCategories = event.categories ?? state.categories;
    if (!listEquals(nextCategories, state.categories) ||
        state.isCategoriesLoading) {
      emit(
        state.copyWith(
          categories: nextCategories,
          isCategoriesLoading: false,
        ),
      );
    }
  }

  Future<void> _refreshCategoriesInBackground({bool forceRefresh = false}) async {
    if (_isRefreshingCategories) return;
    _isRefreshingCategories = true;
    try {
      final result = await _getVideoCategoriesUseCase(forceRefresh: forceRefresh);
      result.fold(
        (_) {
          if (!isClosed && state.isCategoriesLoading) {
            add(const DiscoverCategoriesUpdated(null));
          }
        },
        (categories) {
          if (!isClosed &&
              (!listEquals(categories, state.categories) ||
                  state.isCategoriesLoading)) {
            add(DiscoverCategoriesUpdated(categories));
          }
        },
      );
    } catch (_) {
      // Background refresh is best-effort; preserve cached categories.
      if (!isClosed && state.isCategoriesLoading) {
        add(const DiscoverCategoriesUpdated(null));
      }
    } finally {
      _isRefreshingCategories = false;
    }
  }

  Future<void> _fetchLibraryOnly(
    Emitter<DiscoverState> emit, {
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
    required String searchQuery,
    bool preserveExistingData = false,
    bool forceRefresh = false,
  }) async {
    final generation = ++_requestGeneration;
    _libraryCancelToken?.cancel();
    _loadMoreCancelToken?.cancel();
    _inFlightLoadMoreGeneration = null;
    final cancelToken = DioCancelToken();
    _libraryCancelToken = cancelToken;

    final targetCefr = cefr ?? state.cefr;
    final targetGenre = genre ?? state.genre;
    final targetDuration = duration ?? state.duration;
    final targetExerciseType = exerciseType ?? state.exerciseType;
    final hasExistingData =
        preserveExistingData && state.displayedVideos.isNotEmpty;

    if (!hasExistingData) {
      emit(
        state.copyWith(
          cefr: targetCefr,
          genre: targetGenre,
          duration: targetDuration,
          exerciseType: targetExerciseType,
          searchQuery: searchQuery,
          status: DiscoverStatus.loading,
          displayedVideos: const [],
          totalItems: 0,
          hasReachedMax: false,
          currentPage: 1,
          isLoadingMore: false,
          clearLoadMoreError: true,
          clearRefreshError: true,
        ),
      );
    } else if (state.isLoadingMore) {
      emit(state.copyWith(isLoadingMore: false));
    }

    try {
      final result = await _getVideosUseCase(
        page: 1,
        pageSize: _pageSize,
        cefr: targetCefr,
        genre: targetGenre,
        duration: targetDuration,
        exerciseType: targetExerciseType,
        searchQuery: searchQuery,
        forceRefresh: forceRefresh,
        cancelToken: cancelToken,
      );
      if (generation != _requestGeneration) return;

      result.fold(
        (failure) {
          if (failure is CancelledFailure) return;
          if (hasExistingData) {
            emit(
              state.copyWith(
                isLoadingMore: false,
                refreshError: failure.message,
                refreshErrorId: ++_refreshErrorSeq,
              ),
            );
            return;
          }
          emit(
            state.copyWith(
              status: DiscoverStatus.failure,
              errorMessage: failure.message,
              isLoadingMore: false,
              clearLoadMoreError: true,
            ),
          );
        },
        (paginatedResult) {
          emit(
            state.copyWith(
              status: DiscoverStatus.success,
              displayedVideos: paginatedResult.items,
              totalItems: paginatedResult.totalItems,
              hasReachedMax:
                  paginatedResult.hasReachedMax ||
                  paginatedResult.items.isEmpty,
              currentPage: paginatedResult.page,
              isLoadingMore: false,
              clearLoadMoreError: true,
              clearRefreshError: true,
            ),
          );
        },
      );
    } finally {
      if (identical(_libraryCancelToken, cancelToken)) {
        _libraryCancelToken = null;
      }
    }
  }

  Future<void> _fetchDiscoverData(
    Emitter<DiscoverState> emit, {
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
    String? searchQuery,
    bool preserveExistingData = false,
  }) async {
    final generation = ++_requestGeneration;
    _libraryCancelToken?.cancel();
    _loadMoreCancelToken?.cancel();
    _inFlightLoadMoreGeneration = null;
    final cancelToken = DioCancelToken();
    _libraryCancelToken = cancelToken;

    final targetCefr = cefr ?? state.cefr;
    final targetGenre = genre ?? state.genre;
    final targetDuration = duration ?? state.duration;
    final targetExerciseType = exerciseType ?? state.exerciseType;
    final targetSearchQuery = searchQuery ?? state.searchQuery;

    final hasExistingData =
        preserveExistingData &&
        (state.displayedVideos.isNotEmpty ||
            state.trendingVideos.isNotEmpty ||
            state.playlists.isNotEmpty);

    if (!hasExistingData) {
      emit(
        state.copyWith(
          cefr: targetCefr,
          genre: targetGenre,
          duration: targetDuration,
          exerciseType: targetExerciseType,
          searchQuery: targetSearchQuery,
          status: DiscoverStatus.loading,
          trendingStatus: DiscoverStatus.loading,
          playlistStatus: DiscoverStatus.loading,
          displayedVideos: const [],
          totalItems: 0,
          trendingVideos: const [],
          playlists: const [],
          hasReachedMax: false,
          currentPage: 1,
          isLoadingMore: false,
          clearLoadMoreError: true,
          clearRefreshError: true,
        ),
      );
    } else if (state.isLoadingMore) {
      // In-flight load-more was invalidated by ++_requestGeneration above.
      emit(state.copyWith(isLoadingMore: false));
    }

    try {
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
        searchQuery: targetSearchQuery,
        forceRefresh: preserveExistingData,
        cancelToken: cancelToken,
      );

      final playlistsFuture = _getPlaylistsUseCase(page: 1, pageSize: 10);

      final trendingResult = await trendingFuture;
      final libraryResult = await libraryFuture;
      final playlistsResult = await playlistsFuture;
      if (generation != _requestGeneration) return;

      _browseDataStale = false;

      List<VideoEntity> trendingVideos = hasExistingData
          ? state.trendingVideos
          : [];
      DiscoverStatus trendingStatus = hasExistingData
          ? state.trendingStatus
          : DiscoverStatus.success;
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
      DiscoverStatus playlistStatus = hasExistingData
          ? state.playlistStatus
          : DiscoverStatus.success;
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
          if (failure is CancelledFailure) return;
          if (hasExistingData && state.displayedVideos.isNotEmpty) {
            emit(
              state.copyWith(
                trendingStatus: trendingStatus,
                trendingVideos: trendingVideos,
                playlistStatus: playlistStatus,
                playlists: playlists,
                isLoadingMore: false,
                refreshError: failure.message,
                refreshErrorId: ++_refreshErrorSeq,
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
          emit(
            state.copyWith(
              status: DiscoverStatus.success,
              trendingStatus: trendingStatus,
              trendingVideos: trendingVideos,
              playlistStatus: playlistStatus,
              playlists: playlists,
              displayedVideos: paginatedResult.items,
              totalItems: paginatedResult.totalItems,
              hasReachedMax:
                  paginatedResult.hasReachedMax ||
                  paginatedResult.items.isEmpty,
              currentPage: paginatedResult.page,
              isLoadingMore: false,
              clearLoadMoreError: true,
              clearRefreshError: true,
            ),
          );
        },
      );
    } finally {
      if (identical(_libraryCancelToken, cancelToken)) {
        _libraryCancelToken = null;
      }
    }
  }
}
