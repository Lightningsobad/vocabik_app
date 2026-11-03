import 'package:equatable/equatable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

abstract class HomeTrendingState extends Equatable {
  final String? currentCefr;

  const HomeTrendingState({this.currentCefr});

  @override
  List<Object?> get props => [currentCefr];
}

class HomeTrendingInitial extends HomeTrendingState {
  const HomeTrendingInitial({super.currentCefr});
}

class HomeTrendingLoading extends HomeTrendingState {
  const HomeTrendingLoading({super.currentCefr});
}

class HomeTrendingLoaded extends HomeTrendingState {
  final List<VideoEntity> videos;

  const HomeTrendingLoaded({
    required this.videos,
    super.currentCefr,
  });

  HomeTrendingLoaded copyWith({
    List<VideoEntity>? videos,
    String? currentCefr,
    bool clearCefr = false,
  }) {
    return HomeTrendingLoaded(
      videos: videos ?? this.videos,
      currentCefr: clearCefr ? null : (currentCefr ?? this.currentCefr),
    );
  }

  @override
  List<Object?> get props => [videos, currentCefr];
}

class HomeTrendingError extends HomeTrendingState {
  final String message;

  const HomeTrendingError(this.message, {super.currentCefr});

  @override
  List<Object?> get props => [message, currentCefr];
}
