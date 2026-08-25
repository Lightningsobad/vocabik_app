import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';

class ExerciseResultArgs {
  final ExerciseEntity exercise;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> checkResults;
  final int durationMs;
  final String youtubeVideoId;
  final String videoTitle;
  final String exerciseType;

  const ExerciseResultArgs({
    required this.exercise,
    required this.selectedAnswers,
    required this.checkResults,
    required this.durationMs,
    this.youtubeVideoId = '',
    this.videoTitle = '',
    this.exerciseType = 'Multiple choice',
  });
}
