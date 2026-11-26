import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

enum DiscoverStatus { initial, loading, success, failure }

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final DiscoverStatus trendingStatus;
  final DiscoverStatus playlistStatus;
  final List<VideoEntity> trendingVideos;
  final List<PlaylistEntity> playlists;
  final List<VideoCategoryEntity> categories;
  final List<VideoEntity> displayedVideos; // Library list from API
  final int totalItems;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? loadMoreError;
  final String? refreshError;
  final int refreshErrorId;
  final String searchQuery;
  final String cefr;
  final String genre;
  final String exerciseType;
  final String duration;
  final String errorMessage;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.trendingStatus = DiscoverStatus.initial,
    this.playlistStatus = DiscoverStatus.initial,
    this.trendingVideos = const [],
    this.playlists = const [],
    this.categories = const [],
    this.displayedVideos = const [],
    this.totalItems = 0,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.refreshError,
    this.refreshErrorId = 0,
    this.searchQuery = '',
    this.cefr = '',
    this.genre = '',
    this.exerciseType = '',
    this.duration = '',
    this.errorMessage = '',
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    DiscoverStatus? trendingStatus,
    DiscoverStatus? playlistStatus,
    List<VideoEntity>? trendingVideos,
    List<PlaylistEntity>? playlists,
    List<VideoCategoryEntity>? categories,
    List<VideoEntity>? displayedVideos,
    int? totalItems,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
    String? refreshError,
    int? refreshErrorId,
    bool clearRefreshError = false,
    String? searchQuery,
    String? cefr,
    String? genre,
    String? exerciseType,
    String? duration,
    String? errorMessage,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      trendingStatus: trendingStatus ?? this.trendingStatus,
      playlistStatus: playlistStatus ?? this.playlistStatus,
      trendingVideos: trendingVideos ?? this.trendingVideos,
      playlists: playlists ?? this.playlists,
      categories: categories ?? this.categories,
      displayedVideos: displayedVideos ?? this.displayedVideos,
      totalItems: totalItems ?? this.totalItems,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError
          ? null
          : (loadMoreError ?? this.loadMoreError),
      refreshError: clearRefreshError
          ? null
          : (refreshError ?? this.refreshError),
      refreshErrorId: refreshErrorId ?? this.refreshErrorId,
      searchQuery: searchQuery ?? this.searchQuery,
      cefr: cefr ?? this.cefr,
      genre: genre ?? this.genre,
      exerciseType: exerciseType ?? this.exerciseType,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        trendingStatus,
        playlistStatus,
        trendingVideos,
        playlists,
        categories,
        displayedVideos,
        totalItems,
        currentPage,
        hasReachedMax,
        isLoadingMore,
        loadMoreError,
        refreshError,
        refreshErrorId,
        searchQuery,
        cefr,
        genre,
        exerciseType,
        duration,
        errorMessage,
      ];
}
