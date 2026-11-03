import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/daily_challenge/presentation/widgets/daily_challenge_header.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

Widget _buildTestWidget({required Widget child, Locale locale = const Locale('en')}) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('DailyChallengeHeader', () {
    testWidgets('renders title, trophy and timer without overflow on 360dp width',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final futureReset = DateTime.now().add(const Duration(hours: 10, minutes: 2, seconds: 9));

      await tester.pumpWidget(
        _buildTestWidget(
          child: DailyChallengeHeader(resetAt: futureReset),
        ),
      );
      await tester.pump();

      expect(find.text('Daily Challenge'), findsOneWidget);
      expect(find.byType(DailyChallengeHeader), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders title, trophy and timer without overflow on compact 320dp width',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final futureReset = DateTime.now().add(const Duration(hours: 10, minutes: 2, seconds: 9));

      await tester.pumpWidget(
        _buildTestWidget(
          child: DailyChallengeHeader(resetAt: futureReset),
        ),
      );
      await tester.pump();

      expect(find.text('Daily Challenge'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders gracefully when resetAt is null', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          child: const DailyChallengeHeader(resetAt: null),
        ),
      );
      await tester.pump();

      expect(find.text('Daily Challenge'), findsOneWidget);
      expect(find.text('00:00:00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
