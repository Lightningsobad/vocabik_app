import 'package:equatable/equatable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

abstract class HomeTrendingState extends Equatable {
  const HomeTrendingState();

  @override
  List<Object?> get props => [];
}

class HomeTrendingInitial extends HomeTrendingState {}

class HomeTrendingLoading extends HomeTrendingState {}

class HomeTrendingLoaded extends HomeTrendingState {
  final List<VideoEntity> videos;

  const HomeTrendingLoaded({
    required this.videos,
  });

  @override
  List<Object?> get props => [videos];
}

class HomeTrendingError extends HomeTrendingState {
  final String message;

  const HomeTrendingError(this.message);

  @override
  List<Object?> get props => [message];
}
