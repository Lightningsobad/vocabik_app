import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/exercise/data/models/exercise_model.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';

void main() {
  group('ExerciseModel and Token JSON Deserialization', () {
    test('deserializes tokens with snake_case is_blank and blank_index', () {
      final json = {
        'text': 'hello',
        'is_blank': true,
        'blank_index': 3,
      };

      final model = ExerciseTokenModel.fromJson(json);
      expect(model.text, 'hello');
      expect(model.isBlank, true);
      expect(model.blankIndex, 3);
    });

    test('deserializes tokens with camelCase isBlank and blankIndex', () {
      final json = {
        'text': 'world',
        'isBlank': true,
        'blankIndex': 5,
      };

      final model = ExerciseTokenModel.fromJson(json);
      expect(model.text, 'world');
      expect(model.isBlank, true);
      expect(model.blankIndex, 5);
    });

    test('deserializes ExerciseBlankPositionModel with camelCase and snake_case', () {
      final snakeJson = {
        'start_ms': 1000,
        'end_ms': 3000,
        'blank_index': 1,
      };
      final camelJson = {
        'startMs': 2000,
        'endMs': 4000,
        'blankIndex': 2,
      };

      final snakeModel = ExerciseBlankPositionModel.fromJson(snakeJson);
      final camelModel = ExerciseBlankPositionModel.fromJson(camelJson);

      expect(snakeModel.startMs, 1000);
      expect(snakeModel.endMs, 3000);
      expect(snakeModel.blankIndex, 1);

      expect(camelModel.startMs, 2000);
      expect(camelModel.endMs, 4000);
      expect(camelModel.blankIndex, 2);
    });
  });

  group('ExerciseLoaded mapping logic', () {
    test('maps blank to correct line endMs when tokens contain blankIndex', () {
      const exercise = ExerciseEntity(
        status: 'ready',
        videoId: 'v1',
        cefrLevel: 'B1',
        versionId: 'v1',
        strategy: 'standard',
        isCanonical: true,
        blankPositions: [],
        blanks: [
          ExerciseBlankEntity(blankIndex: 1, correctAnswer: 'one'),
          ExerciseBlankEntity(blankIndex: 2, correctAnswer: 'two'),
        ],
        answerOptions: {},
        createdAt: '2026-09-14',
        lines: [
          ExerciseLineEntity(
            lineIndex: 0,
            startMs: 0,
            endMs: 2500,
            sentenceIndex: 0,
            tokens: [
              ExerciseTokenEntity(isBlank: true, blankIndex: 1),
            ],
          ),
          ExerciseLineEntity(
            lineIndex: 1,
            startMs: 3000,
            endMs: 6500,
            sentenceIndex: 1,
            tokens: [
              ExerciseTokenEntity(isBlank: true, blankIndex: 2),
            ],
          ),
        ],
      );

      final state = ExerciseLoaded(exercise: exercise);

      expect(state.blankEndMsMap[1], 2500);
      expect(state.blankEndMsMap[2], 6500);
      expect(state.stopPointMs, [2500, 6500]);
      expect(state.activeLineMap[1]?.lineIndex, 0);
      expect(state.activeLineMap[2]?.lineIndex, 1);
    });

    test('falls back to blankPositions when tokens do not specify blankIndex', () {
      const exercise = ExerciseEntity(
        status: 'ready',
        videoId: 'v1',
        cefrLevel: 'B1',
        versionId: 'v1',
        strategy: 'standard',
        isCanonical: true,
        blankPositions: [
          ExerciseBlankPositionEntity(blankIndex: 1, startMs: 500, endMs: 2000),
          ExerciseBlankPositionEntity(blankIndex: 2, startMs: 3500, endMs: 5500),
        ],
        blanks: [
          ExerciseBlankEntity(blankIndex: 1, correctAnswer: 'apple'),
          ExerciseBlankEntity(blankIndex: 2, correctAnswer: 'banana'),
        ],
        answerOptions: {},
        createdAt: '2026-09-14',
        lines: [
          ExerciseLineEntity(
            lineIndex: 0,
            startMs: 0,
            endMs: 2500,
            sentenceIndex: 0,
            tokens: [
              ExerciseTokenEntity(text: 'I eat an apple', isBlank: false),
            ],
          ),
          ExerciseLineEntity(
            lineIndex: 1,
            startMs: 3000,
            endMs: 6000,
            sentenceIndex: 1,
            tokens: [
              ExerciseTokenEntity(text: 'He eats a banana', isBlank: false),
            ],
          ),
        ],
      );

      final state = ExerciseLoaded(exercise: exercise);

      expect(state.blankEndMsMap[1], 2500);
      expect(state.blankEndMsMap[2], 6000);
      expect(state.stopPointMs, [2500, 6000]);
      expect(state.activeLineMap[1]?.lineIndex, 0);
      expect(state.activeLineMap[2]?.lineIndex, 1);
    });

    test('handles multiple blanks in the same sentence correctly', () {
      const exercise = ExerciseEntity(
        status: 'ready',
        videoId: 'v1',
        cefrLevel: 'B1',
        versionId: 'v1',
        strategy: 'standard',
        isCanonical: true,
        blankPositions: [],
        blanks: [
          ExerciseBlankEntity(blankIndex: 1, correctAnswer: 'cat'),
          ExerciseBlankEntity(blankIndex: 2, correctAnswer: 'mat'),
        ],
        answerOptions: {},
        createdAt: '2026-09-14',
        lines: [
          ExerciseLineEntity(
            lineIndex: 0,
            startMs: 0,
            endMs: 4000,
            sentenceIndex: 0,
            tokens: [
              ExerciseTokenEntity(text: 'The', isBlank: false),
              ExerciseTokenEntity(isBlank: true, blankIndex: 1),
              ExerciseTokenEntity(text: 'sat on the', isBlank: false),
              ExerciseTokenEntity(isBlank: true, blankIndex: 2),
            ],
          ),
        ],
      );

      final state = ExerciseLoaded(exercise: exercise);

      expect(state.blankEndMsMap[1], 4000);
      expect(state.blankEndMsMap[2], 4000);
      expect(state.activeLineMap[1], state.activeLineMap[2]);
    });
  });
}
