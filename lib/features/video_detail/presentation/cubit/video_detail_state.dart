import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/home/domain/entities/video_entity.dart';

abstract class VideoDetailState extends Equatable {
  const VideoDetailState();

  @override
  List<Object?> get props => [];
}

class VideoDetailInitial extends VideoDetailState {}

class VideoDetailLoading extends VideoDetailState {}

class VideoDetailLoaded extends VideoDetailState {
  final VideoEntity video;
  final String selectedExerciseType; // e.g. "Multiple choice" or "Type the answer"
  final String selectedVersion; // e.g. "v1", "v2"

  const VideoDetailLoaded({
    required this.video,
    required this.selectedExerciseType,
    required this.selectedVersion,
  });

  VideoDetailLoaded copyWith({
    VideoEntity? video,
    String? selectedExerciseType,
    String? selectedVersion,
  }) {
    return VideoDetailLoaded(
      video: video ?? this.video,
      selectedExerciseType: selectedExerciseType ?? this.selectedExerciseType,
      selectedVersion: selectedVersion ?? this.selectedVersion,
    );
  }

  @override
  List<Object?> get props => [video, selectedExerciseType, selectedVersion];
}

class VideoDetailError extends VideoDetailState {
  final String message;

  const VideoDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
