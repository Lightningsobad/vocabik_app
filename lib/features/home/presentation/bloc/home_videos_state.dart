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

  const HomeVideosLoaded({
    required this.videos,
    required this.hasReachedMax,
    required this.currentPage,
    super.currentCefr,
  });

  HomeVideosLoaded copyWith({
    List<VideoEntity>? videos,
    bool? hasReachedMax,
    int? currentPage,
    String? currentCefr,
    bool clearCefr = false,
  }) {
    return HomeVideosLoaded(
      videos: videos ?? this.videos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentCefr: clearCefr ? null : (currentCefr ?? this.currentCefr),
    );
  }

  @override
  List<Object?> get props => [videos, hasReachedMax, currentPage, currentCefr];
}

class HomeVideosError extends HomeVideosState {
  final String message;

  const HomeVideosError(this.message, {super.currentCefr});

  @override
  List<Object?> get props => [message, currentCefr];
}
