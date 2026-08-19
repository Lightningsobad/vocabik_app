import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';

enum ScoreCardStatus { initial, loading, success, error, offline }

class ResultState extends Equatable {
  final bool isCalculating;
  final ExerciseResultSummary? summary;
  final ScoreCardStatus scoreCardStatus;
  final String? scoreCardImageUrl;
  final String? errorMessage;

  const ResultState({
    this.isCalculating = true,
    this.summary,
    this.scoreCardStatus = ScoreCardStatus.initial,
    this.scoreCardImageUrl,
    this.errorMessage,
  });

  ResultState copyWith({
    bool? isCalculating,
    ExerciseResultSummary? summary,
    ScoreCardStatus? scoreCardStatus,
    String? scoreCardImageUrl,
    String? errorMessage,
  }) {
    return ResultState(
      isCalculating: isCalculating ?? this.isCalculating,
      summary: summary ?? this.summary,
      scoreCardStatus: scoreCardStatus ?? this.scoreCardStatus,
      scoreCardImageUrl: scoreCardImageUrl ?? this.scoreCardImageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isCalculating,
        summary,
        scoreCardStatus,
        scoreCardImageUrl,
        errorMessage,
      ];
}
