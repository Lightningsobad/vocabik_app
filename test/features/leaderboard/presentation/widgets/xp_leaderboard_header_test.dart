import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/leaderboard/presentation/widgets/xp_leaderboard_header.dart';
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
  group('XpLeaderboardHeader', () {
    testWidgets('renders title and countdown without overflow on narrow 360dp width',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final futureReset = DateTime.now().add(const Duration(hours: 10, minutes: 5)).toIso8601String();

      await tester.pumpWidget(
        _buildTestWidget(
          child: XpLeaderboardHeader(nextResetAt: futureReset),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('XP Leaderboard'), findsOneWidget);
      expect(find.text('Resets in: 10 hours'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders in Vietnamese without overflow on narrow 360dp width',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final futureReset = DateTime.now().add(const Duration(hours: 10, minutes: 5)).toIso8601String();

      await tester.pumpWidget(
        _buildTestWidget(
          locale: const Locale('vi'),
          child: XpLeaderboardHeader(nextResetAt: futureReset),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bảng xếp hạng XP'), findsOneWidget);
      expect(find.text('Làm mới sau: 10 giờ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders gracefully when nextResetAt is null', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          child: const XpLeaderboardHeader(nextResetAt: null),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('XP Leaderboard'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
