import 'package:equatable/equatable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

enum DiscoverStatus { initial, loading, success, failure }

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  final List<VideoEntity> allFetchedVideos; // Original list from API
  final List<VideoEntity> displayedVideos; // Filtered list
  final int currentPage;
  final bool hasReachedMax;
  final String searchQuery;
  final String cefr;
  final String genre;
  final String window;
  final String duration;
  final String errorMessage;

  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.allFetchedVideos = const [],
    this.displayedVideos = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.searchQuery = '',
    this.cefr = '',
    this.genre = '',
    this.window = '',
    this.duration = '',
    this.errorMessage = '',
  });

  DiscoverState copyWith({
    DiscoverStatus? status,
    List<VideoEntity>? allFetchedVideos,
    List<VideoEntity>? displayedVideos,
    int? currentPage,
    bool? hasReachedMax,
    String? searchQuery,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? errorMessage,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      allFetchedVideos: allFetchedVideos ?? this.allFetchedVideos,
      displayedVideos: displayedVideos ?? this.displayedVideos,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      cefr: cefr ?? this.cefr,
      genre: genre ?? this.genre,
      window: window ?? this.window,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        allFetchedVideos,
        displayedVideos,
        currentPage,
        hasReachedMax,
        searchQuery,
        cefr,
        genre,
        window,
        duration,
        errorMessage,
      ];
}
