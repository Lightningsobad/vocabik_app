import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_calculation_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('calculateExerciseResultSummary', () {
    test('computes accuracy score and wrong answer details accurately in isolate', () async {
      const exercise = ExerciseEntity(
        status: 'ready',
        videoId: 'vid-123',
        cefrLevel: 'B2',
        versionId: 'v1',
        strategy: 'standard',
        isCanonical: true,
        blankPositions: [
          ExerciseBlankPositionEntity(startMs: 0, endMs: 1000, blankIndex: 1),
          ExerciseBlankPositionEntity(startMs: 1000, endMs: 2000, blankIndex: 2),
        ],
        blanks: [
          ExerciseBlankEntity(blankIndex: 1, correctAnswer: 'world'),
          ExerciseBlankEntity(blankIndex: 2, correctAnswer: 'hello'),
        ],
        answerOptions: {},
        createdAt: '2026-08-19',
        lines: [
          ExerciseLineEntity(
            lineIndex: 1,
            startMs: 0,
            endMs: 1000,
            sentenceIndex: 1,
            tokens: [
              ExerciseTokenEntity(text: 'Hello', isBlank: false),
              ExerciseTokenEntity(isBlank: true, blankIndex: 1),
            ],
          ),
          ExerciseLineEntity(
            lineIndex: 2,
            startMs: 1000,
            endMs: 2000,
            sentenceIndex: 2,
            tokens: [
              ExerciseTokenEntity(isBlank: true, blankIndex: 2),
              ExerciseTokenEntity(text: 'there', isBlank: false),
            ],
          ),
        ],
      );

      final params = ResultCalculationParams(
        exercise: exercise,
        selectedAnswers: const {1: 'world', 2: 'wrong'},
        checkResults: const {1: true, 2: false},
        durationMs: 125000,
      );

      final summary = await calculateExerciseResultSummary(params);

      expect(summary.totalQuestions, 2);
      expect(summary.correctCount, 1);
      expect(summary.wrongCount, 1);
      expect(summary.accuracyScore, 50);
      expect(summary.duration.inSeconds, 125);
      expect(summary.wrongAnswers.length, 1);
      expect(summary.wrongAnswers.first.blankStep, 2);
      expect(summary.wrongAnswers.first.correctWord, 'hello');
      expect(summary.wrongAnswers.first.afterText, 'there');
    });
  });
}
