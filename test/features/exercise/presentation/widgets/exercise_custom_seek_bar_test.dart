import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_custom_seek_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

void main() {
  Widget buildTestWidget({
    required ThemeData theme,
    required int currentPositionMs,
    required int totalDurationMs,
    ExerciseLoaded? exerciseState,
    ValueChanged<double>? onSeek,
  }) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            child: ExerciseCustomSeekBar(
              currentPositionMs: currentPositionMs,
              totalDurationMs: totalDurationMs,
              exerciseState: exerciseState,
              onSeek: onSeek ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  ExerciseLoaded createTestExerciseState() {
    const blank0 = ExerciseBlankEntity(
      blankIndex: 0,
      correctAnswer: 'test',
    );
    const blank1 = ExerciseBlankEntity(
      blankIndex: 1,
      correctAnswer: 'world',
    );

    const exercise = ExerciseEntity(
      status: 'active',
      videoId: 'vid1',
      cefrLevel: 'B1',
      versionId: 'v1',
      strategy: 'default',
      isCanonical: true,
      blankPositions: [
        ExerciseBlankPositionEntity(startMs: 0, endMs: 5000, blankIndex: 0),
        ExerciseBlankPositionEntity(startMs: 5000, endMs: 10000, blankIndex: 1),
      ],
      blanks: [blank0, blank1],
      answerOptions: {},
      createdAt: '2026-01-01',
      lines: [],
    );

    return ExerciseLoaded(
      exercise: exercise,
      currentBlankIndex: 1,
      checkResults: const {0: true}, // blank 0 is answered correctly
      blankEndMsMap: const {0: 5000, 1: 10000},
    );
  }

  group('ExerciseCustomSeekBar Theme and Color rendering', () {
    testWidgets('renders seek bar using theme tokens in Light Theme', (tester) async {
      final state = createTestExerciseState();

      await tester.pumpWidget(
        buildTestWidget(
          theme: AppTheme.lightTheme,
          currentPositionMs: 5000,
          totalDurationMs: 10000,
          exerciseState: state,
        ),
      );

      final lightColors = AppColorsExtension.light;

      // Find containers
      final containerWidgets = tester.widgetList<Container>(find.byType(Container)).toList();

      // Find background track Container (height 4, decoration with track color)
      final trackContainer = containerWidgets.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == lightColors.videoSeekBarTrack,
      );
      expect((trackContainer.decoration as BoxDecoration).color, equals(lightColors.videoSeekBarTrack));
      expect((trackContainer.decoration as BoxDecoration).color, isNot(equals(Colors.white)));

      // Find played progress Container (decoration with videoSeekBarProgress)
      final progressContainer = containerWidgets.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == lightColors.videoSeekBarProgress,
      );
      expect((progressContainer.decoration as BoxDecoration).color, equals(lightColors.videoSeekBarProgress));
      expect((progressContainer.decoration as BoxDecoration).color, equals(lightColors.primaryAccent));
    });

    testWidgets('renders seek bar using theme tokens in Dark Theme', (tester) async {
      final state = createTestExerciseState();

      await tester.pumpWidget(
        buildTestWidget(
          theme: AppTheme.darkTheme,
          currentPositionMs: 5000,
          totalDurationMs: 10000,
          exerciseState: state,
        ),
      );

      final darkColors = AppColorsExtension.dark;

      final containerWidgets = tester.widgetList<Container>(find.byType(Container)).toList();

      final trackContainer = containerWidgets.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == darkColors.videoSeekBarTrack,
      );
      expect((trackContainer.decoration as BoxDecoration).color, equals(darkColors.videoSeekBarTrack));

      final progressContainer = containerWidgets.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == darkColors.videoSeekBarProgress,
      );
      expect((progressContainer.decoration as BoxDecoration).color, equals(darkColors.videoSeekBarProgress));
      expect((progressContainer.decoration as BoxDecoration).color, equals(darkColors.primaryAccent));
    });

    testWidgets('triggers onSeek callback with clamped fraction on drag', (tester) async {
      double? seekedFraction;

      await tester.pumpWidget(
        buildTestWidget(
          theme: AppTheme.lightTheme,
          currentPositionMs: 2500,
          totalDurationMs: 10000,
          onSeek: (fraction) => seekedFraction = fraction,
        ),
      );

      final gestureFinder = find.byType(GestureDetector);
      expect(gestureFinder, findsOneWidget);

      await tester.tap(gestureFinder);
      expect(seekedFraction, isNotNull);
      expect(seekedFraction!, inInclusiveRange(0.0, 1.0));
    });
  });
}
