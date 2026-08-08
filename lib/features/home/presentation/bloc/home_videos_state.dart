import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/home/domain/entities/video_entity.dart';

abstract class HomeVideosState extends Equatable {
  const HomeVideosState();
  
  @override
  List<Object> get props => [];
}

class HomeVideosInitial extends HomeVideosState {}

class HomeVideosLoading extends HomeVideosState {}

class HomeVideosLoaded extends HomeVideosState {
  final List<VideoEntity> videos;
  final bool hasReachedMax;
  final int currentPage;

  const HomeVideosLoaded({
    required this.videos,
    required this.hasReachedMax,
    required this.currentPage,
  });

  HomeVideosLoaded copyWith({
    List<VideoEntity>? videos,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return HomeVideosLoaded(
      videos: videos ?? this.videos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [videos, hasReachedMax, currentPage];
}

class HomeVideosError extends HomeVideosState {
  final String message;

  const HomeVideosError(this.message);

  @override
  List<Object> get props => [message];
}
