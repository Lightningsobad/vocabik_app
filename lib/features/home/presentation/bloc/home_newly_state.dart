import 'package:equatable/equatable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

abstract class HomeNewlyState extends Equatable {
  const HomeNewlyState();

  @override
  List<Object?> get props => [];
}

class HomeNewlyInitial extends HomeNewlyState {}

class HomeNewlyLoading extends HomeNewlyState {}

class HomeNewlyLoaded extends HomeNewlyState {
  final List<VideoEntity> videos;

  const HomeNewlyLoaded({
    required this.videos,
  });

  @override
  List<Object?> get props => [videos];
}

class HomeNewlyError extends HomeNewlyState {
  final String message;

  const HomeNewlyError(this.message);

  @override
  List<Object?> get props => [message];
}
