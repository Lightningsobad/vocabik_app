import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

enum DiscoverStatus { initial, loading, success, failure }

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final DiscoverStatus trendingStatus;
  final DiscoverStatus playlistStatus;
  final List<VideoEntity> trendingVideos;
  final List<PlaylistEntity> playlists;
  final List<VideoEntity> allFetchedVideos; // Original library list from API
  final List<VideoEntity> displayedVideos; // Filtered library list
  final int currentPage;
  final bool hasReachedMax;
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
    this.allFetchedVideos = const [],
    this.displayedVideos = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
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
    List<VideoEntity>? allFetchedVideos,
    List<VideoEntity>? displayedVideos,
    int? currentPage,
    bool? hasReachedMax,
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
      allFetchedVideos: allFetchedVideos ?? this.allFetchedVideos,
      displayedVideos: displayedVideos ?? this.displayedVideos,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      cefr: cefr ?? this.cefr,
      genre: genre ?? this.genre,
      exerciseType: exerciseType ?? this.exerciseType,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        trendingStatus,
        playlistStatus,
        trendingVideos,
        playlists,
        allFetchedVideos,
        displayedVideos,
        currentPage,
        hasReachedMax,
        searchQuery,
        cefr,
        genre,
        exerciseType,
        duration,
        errorMessage,
      ];
}
