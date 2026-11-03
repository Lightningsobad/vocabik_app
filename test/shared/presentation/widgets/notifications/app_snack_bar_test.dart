import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/shared/presentation/widgets/notifications/app_snack_bar.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

Widget _buildTestApp({required Widget child, bool isDark = false}) {
  return MaterialApp(
    theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
    home: Scaffold(
      body: Builder(
        builder: (context) => child,
      ),
    ),
  );
}

void main() {
  group('AppSnackBar', () {
    testWidgets('renders floating SnackBar with transparent background and zero elevation',
        (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: ElevatedButton(
            onPressed: () {
              // We need a context inside Scaffold
            },
            child: const Text('Show'),
          ),
        ),
      );

      final BuildContext context = tester.element(find.byType(ElevatedButton));
      AppSnackBar.showSuccess(context, 'Success message', title: 'Great!');
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 300)); // Complete animation

      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final SnackBar snackBar = tester.widget(snackBarFinder);
      expect(snackBar.behavior, SnackBarBehavior.floating);
      expect(snackBar.backgroundColor, Colors.transparent);
      expect(snackBar.elevation, 0);
      expect(snackBar.dismissDirection, DismissDirection.horizontal);
      expect(snackBar.margin, const EdgeInsets.symmetric(horizontal: 16, vertical: 12));

      expect(find.text('Great!'), findsOneWidget);
      expect(find.text('Success message'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });

    testWidgets('shows error snackbar with correct icon and optional action',
        (tester) async {
      bool actionPressed = false;

      await tester.pumpWidget(
        _buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                AppSnackBar.showError(
                  context,
                  'Something went wrong',
                  action: TextButton(
                    onPressed: () => actionPressed = true,
                    child: const Text('Retry'),
                  ),
                );
              },
              child: const Text('Trigger Error'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger Error'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(actionPressed, isTrue);
    });

    testWidgets('shows warning and info snackbars with corresponding icons',
        (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: Builder(
            builder: (context) => Column(
              children: [
                ElevatedButton(
                  onPressed: () => AppSnackBar.showWarning(context, 'Warning note'),
                  child: const Text('Warning'),
                ),
                ElevatedButton(
                  onPressed: () => AppSnackBar.showInfo(context, 'Info note'),
                  child: const Text('Info'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Warning'));
      await tester.pumpAndSettle();
      expect(find.text('Warning note'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      // Triggering Info should clear warning first (clearSnackBars)
      await tester.tap(find.text('Info'));
      await tester.pumpAndSettle();
      expect(find.text('Warning note'), findsNothing);
      expect(find.text('Info note'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });

    testWidgets('close button dismisses snackbar immediately', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AppSnackBar.showSuccess(context, 'Dismiss me'),
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();
      expect(find.text('Dismiss me'), findsOneWidget);

      final closeBtnFinder = find.byKey(const Key('app_snack_bar_close_button'));
      expect(closeBtnFinder, findsOneWidget);
      await tester.tap(closeBtnFinder);
      await tester.pumpAndSettle();

      expect(find.text('Dismiss me'), findsNothing);
    });
  });
}
