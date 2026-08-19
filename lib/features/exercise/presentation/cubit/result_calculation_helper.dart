import 'package:flutter/foundation.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';

class ResultCalculationParams {
  final ExerciseEntity exercise;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> checkResults;
  final int durationMs;

  const ResultCalculationParams({
    required this.exercise,
    required this.selectedAnswers,
    required this.checkResults,
    required this.durationMs,
  });
}

Future<ExerciseResultSummary> calculateExerciseResultSummary(
  ResultCalculationParams params,
) async {
  return await compute(_computeSummary, params);
}

ExerciseResultSummary _computeSummary(ResultCalculationParams params) {
  final exercise = params.exercise;
  final checkResults = params.checkResults;
  final selectedAnswers = params.selectedAnswers;

  int correctCount = 0;
  int wrongCount = 0;
  final List<WrongAnswerDetail> wrongAnswers = [];

  for (int i = 0; i < exercise.blanks.length; i++) {
    final blank = exercise.blanks[i];
    final blankIndex = blank.blankIndex;
    final isCorrect = checkResults[blankIndex] ?? false;

    if (isCorrect) {
      correctCount++;
    } else {
      wrongCount++;

      // Find the sentence line containing this blank
      final line = exercise.lines.firstWhere(
        (l) => l.tokens.any((t) => t.blankIndex == blankIndex),
        orElse: () => exercise.lines.isNotEmpty
            ? exercise.lines.first
            : const ExerciseLineEntity(
                lineIndex: 0,
                startMs: 0,
                endMs: 0,
                sentenceIndex: 0,
                tokens: [],
              ),
      );

      final beforeTokens = <String>[];
      final afterTokens = <String>[];
      bool foundBlank = false;

      for (final token in line.tokens) {
        if (token.blankIndex == blankIndex) {
          foundBlank = true;
        } else if (!foundBlank) {
          if (token.text != null && token.text!.isNotEmpty) {
            beforeTokens.add(token.text!);
          }
        } else {
          if (token.text != null && token.text!.isNotEmpty) {
            afterTokens.add(token.text!);
          }
        }
      }

      wrongAnswers.add(
        WrongAnswerDetail(
          blankIndex: blankIndex,
          blankStep: i + 1,
          beforeText: beforeTokens.join(' ').trim(),
          correctWord: blank.correctAnswer,
          afterText: afterTokens.join(' ').trim(),
          userAnswer: selectedAnswers[blankIndex],
        ),
      );
    }
  }

  final total = exercise.blanks.length;
  final accuracy = total > 0 ? ((correctCount / total) * 100).round() : 0;

  return ExerciseResultSummary(
    totalQuestions: total,
    correctCount: correctCount,
    wrongCount: wrongCount,
    accuracyScore: accuracy,
    duration: Duration(milliseconds: params.durationMs),
    wrongAnswers: wrongAnswers,
  );
}
