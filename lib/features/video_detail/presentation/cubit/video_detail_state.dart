import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/video_detail/domain/entities/video_progress_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/enums/exercise_type.dart';

abstract class VideoDetailState extends Equatable {
  const VideoDetailState();

  @override
  List<Object?> get props => [];
}

class VideoDetailInitial extends VideoDetailState {}

class VideoDetailLoading extends VideoDetailState {}

class VideoDetailLoaded extends VideoDetailState {
  final VideoEntity video;
  final ExerciseType selectedExerciseType;
  final String selectedVersion; // e.g. "v1", "v2"
  final int blanksCount;
  final VideoProgressEntity? latestProgress;
  final Set<String> userReactions;

  const VideoDetailLoaded({
    required this.video,
    required this.selectedExerciseType,
    required this.selectedVersion,
    this.blanksCount = 0,
    this.latestProgress,
    this.userReactions = const {},
  });

  VideoDetailLoaded copyWith({
    VideoEntity? video,
    ExerciseType? selectedExerciseType,
    String? selectedVersion,
    int? blanksCount,
    VideoProgressEntity? latestProgress,
    Set<String>? userReactions,
    bool clearProgress = false,
  }) {
    return VideoDetailLoaded(
      video: video ?? this.video,
      selectedExerciseType: selectedExerciseType ?? this.selectedExerciseType,
      selectedVersion: selectedVersion ?? this.selectedVersion,
      blanksCount: blanksCount ?? this.blanksCount,
      latestProgress:
          clearProgress ? null : (latestProgress ?? this.latestProgress),
      userReactions: userReactions ?? this.userReactions,
    );
  }

  @override
  List<Object?> get props => [
        video,
        selectedExerciseType,
        selectedVersion,
        blanksCount,
        latestProgress,
        userReactions,
      ];
}

class VideoDetailError extends VideoDetailState {
  final String message;

  const VideoDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
