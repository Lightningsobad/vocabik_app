import 'package:equatable/equatable.dart';

class BlankAnswerRequest extends Equatable {
  final int blankIndex;
  final bool isCorrect;

  const BlankAnswerRequest({
    required this.blankIndex,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'blank_index': blankIndex,
      'is_correct': isCorrect,
    };
  }

  @override
  List<Object?> get props => [blankIndex, isCorrect];
}

class ProgressRequest extends Equatable {
  final String videoId;
  final String cefrLevel;
  final String versionId;
  final String completedAt;
  final int accuracyScore;
  final int timeTakenSeconds;
  final List<String> correctAnswers;
  final List<BlankAnswerRequest> blankAnswers;

  const ProgressRequest({
    required this.videoId,
    required this.cefrLevel,
    required this.versionId,
    required this.completedAt,
    required this.accuracyScore,
    required this.timeTakenSeconds,
    required this.correctAnswers,
    required this.blankAnswers,
  });

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'cefr_level': cefrLevel,
      'version_id': versionId,
      'completed_at': completedAt,
      'accuracy_score': accuracyScore,
      'time_taken_seconds': timeTakenSeconds,
      'correct_answers': correctAnswers,
      'blank_answers': blankAnswers.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        videoId,
        cefrLevel,
        versionId,
        completedAt,
        accuracyScore,
        timeTakenSeconds,
        correctAnswers,
        blankAnswers,
      ];
}
