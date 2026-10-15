import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/achievements/domain/entities/badge_entity.dart';
import 'package:vocabik_app/features/achievements/presentation/widgets/badge_section_widget.dart';
import 'package:vocabik_app/features/achievements/presentation/widgets/badge_skeleton_grid.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

Widget _buildTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(
        child: child,
      ),
    ),
  );
}

void main() {
  group('BadgeSectionWidget & BadgeSkeletonGrid', () {
    final badges = [
      BadgeEntity(
        code: 'first_exercise',
        displayName: 'First Exercise',
        description: 'Completed your very first exercise.',
        category: 'exercise',
        locked: false,
        awardedAt: DateTime(2026, 8, 18),
      ),
      const BadgeEntity(
        code: 'seven_day_streak',
        displayName: '7-Day Streak',
        description: 'Keep your streak for 7 consecutive days.',
        category: 'streak',
        locked: true,
        progress: BadgeProgressEntity(current: 3, target: 7),
      ),
      const BadgeEntity(
        code: 'vocabulary_hunter',
        displayName: 'Vocabulary Hunter',
        description: 'Learn 100 new vocabulary words in topics.',
        category: 'vocabulary',
        locked: true,
      ),
    ];

    testWidgets('renders badges with default aspect ratio without overflow on 360 width',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        _buildTestWidget(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BadgeSectionWidget(
              title: 'UNLOCKED',
              badges: badges,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('First Exercise'), findsOneWidget);
      expect(find.text('7-Day Streak'), findsOneWidget);
      expect(find.text('Vocabulary Hunter'), findsOneWidget);
    });

    testWidgets('renders badges with default aspect ratio without overflow on 320 width',
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        _buildTestWidget(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BadgeSectionWidget(
              title: 'UNLOCKED',
              badges: badges,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('First Exercise'), findsOneWidget);
      expect(find.text('7-Day Streak'), findsOneWidget);
    });

    testWidgets('renders BadgeSkeletonGrid without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        _buildTestWidget(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: BadgeSkeletonGrid(itemCount: 6),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BadgeSkeletonGrid), findsOneWidget);
    });
  });
}
