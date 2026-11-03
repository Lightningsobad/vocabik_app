import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_header_widget.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: child),
    );
  }

  group('ExerciseHeaderWidget Layout', () {
    testWidgets('renders properly in portrait mode', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const ExerciseHeaderWidget(
            progress: 0.5,
            currentStep: 5,
            totalSteps: 10,
            isLandscape: false,
          ),
        ),
      );

      expect(find.text('5/10'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      final linearProgress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(linearProgress.minHeight, 6);
    });

    testWidgets('renders compact styling in landscape mode without error', (tester) async {
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        wrapWithTheme(
          const ExerciseHeaderWidget(
            progress: 0.8,
            currentStep: 8,
            totalSteps: 10,
            isLandscape: true,
          ),
        ),
      );

      expect(find.text('8/10'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      final linearProgress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(linearProgress.minHeight, 4);
    });
  });
}
