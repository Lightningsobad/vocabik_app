import 'package:equatable/equatable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

abstract class HomeVideosState extends Equatable {
  final String? currentCefr;

  const HomeVideosState({this.currentCefr});
  
  @override
  List<Object?> get props => [currentCefr];
}

class HomeVideosInitial extends HomeVideosState {
  const HomeVideosInitial({super.currentCefr});
}

class HomeVideosLoading extends HomeVideosState {
  const HomeVideosLoading({super.currentCefr});
}

class HomeVideosLoaded extends HomeVideosState {
  final List<VideoEntity> videos;
  final bool hasReachedMax;
  final int currentPage;
  final int totalItems;
  final bool isLoadingMore;
  final String? loadMoreError;
  final String? refreshError;
  final int refreshErrorId;

  const HomeVideosLoaded({
    required this.videos,
    required this.hasReachedMax,
    required this.currentPage,
    this.totalItems = 0,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.refreshError,
    this.refreshErrorId = 0,
    super.currentCefr,
  });

  HomeVideosLoaded copyWith({
    List<VideoEntity>? videos,
    bool? hasReachedMax,
    int? currentPage,
    int? totalItems,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
    String? refreshError,
    int? refreshErrorId,
    String? currentCefr,
    bool clearCefr = false,
  }) {
    return HomeVideosLoaded(
      videos: videos ?? this.videos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
      refreshError: refreshError ?? this.refreshError,
      refreshErrorId: refreshErrorId ?? this.refreshErrorId,
      currentCefr: clearCefr ? null : (currentCefr ?? this.currentCefr),
    );
  }

  @override
  List<Object?> get props => [
        videos,
        hasReachedMax,
        currentPage,
        totalItems,
        isLoadingMore,
        loadMoreError,
        refreshError,
        refreshErrorId,
        currentCefr,
      ];
}

class HomeVideosError extends HomeVideosState {
  final String message;

  const HomeVideosError(this.message, {super.currentCefr});

  @override
  List<Object?> get props => [message, currentCefr];
}
