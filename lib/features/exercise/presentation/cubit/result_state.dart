import 'package:equatable/equatable.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';

enum ScoreCardStatus { initial, loading, success, error, offline }
enum ProgressSubmitStatus { initial, loading, success, error }

class ResultState extends Equatable {
  final bool isCalculating;
  final ExerciseResultSummary? summary;
  final ScoreCardStatus scoreCardStatus;
  final String? scoreCardImageUrl;
  final String? errorMessage;
  final ProgressSubmitStatus progressStatus;
  final String? progressErrorMessage;

  const ResultState({
    this.isCalculating = true,
    this.summary,
    this.scoreCardStatus = ScoreCardStatus.initial,
    this.scoreCardImageUrl,
    this.errorMessage,
    this.progressStatus = ProgressSubmitStatus.initial,
    this.progressErrorMessage,
  });

  ResultState copyWith({
    bool? isCalculating,
    ExerciseResultSummary? summary,
    ScoreCardStatus? scoreCardStatus,
    String? scoreCardImageUrl,
    String? errorMessage,
    ProgressSubmitStatus? progressStatus,
    String? progressErrorMessage,
  }) {
    return ResultState(
      isCalculating: isCalculating ?? this.isCalculating,
      summary: summary ?? this.summary,
      scoreCardStatus: scoreCardStatus ?? this.scoreCardStatus,
      scoreCardImageUrl: scoreCardImageUrl ?? this.scoreCardImageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      progressStatus: progressStatus ?? this.progressStatus,
      progressErrorMessage: progressErrorMessage ?? this.progressErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isCalculating,
        summary,
        scoreCardStatus,
        scoreCardImageUrl,
        errorMessage,
        progressStatus,
        progressErrorMessage,
      ];
}
