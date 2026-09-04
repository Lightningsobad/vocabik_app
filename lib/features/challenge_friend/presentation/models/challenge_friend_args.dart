import '../../../exercise/domain/entities/exercise_entity.dart';

class ChallengeFriendArgs {
  final ExerciseEntity exercise;
  final int durationMs;
  final int accuracyScore;
  final String videoTitle;
  final String artist;
  final String youtubeVideoId;

  const ChallengeFriendArgs({
    required this.exercise,
    required this.durationMs,
    required this.accuracyScore,
    required this.videoTitle,
    this.artist = '',
    this.youtubeVideoId = '',
  });
}
