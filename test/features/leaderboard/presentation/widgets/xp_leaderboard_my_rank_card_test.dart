import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/leaderboard/data/models/leaderboard_entry_model.dart';
import 'package:vocabik_app/features/leaderboard/presentation/widgets/xp_leaderboard_my_rank_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

Widget _buildTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('XpLeaderboardMyRankCard', () {
    testWidgets('renders rank, totalParticipants formatted with comma, and XP',
        (tester) async {
      const entry = LeaderboardEntryModel(
        rank: 47,
        userId: 'u47',
        displayName: 'Test User',
        xp: 340,
        isCurrentUser: true,
      );

      await tester.pumpWidget(
        _buildTestWidget(
          const XpLeaderboardMyRankCard(
            ownRank: entry,
            totalParticipants: 1234,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('#47'), findsOneWidget);
      expect(find.text('/ 1,234'), findsOneWidget);
      expect(find.text('340 XP'), findsOneWidget);
    });

    testWidgets('renders unranked state with totalParticipants when ownRank is null',
        (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          const XpLeaderboardMyRankCard(
            ownRank: null,
            totalParticipants: 2,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('#--'), findsOneWidget);
      expect(find.text('/ 2'), findsOneWidget);
      expect(find.text('0 XP'), findsOneWidget);
    });

    testWidgets('returns SizedBox.shrink when both ownRank and totalParticipants are absent',
        (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          const XpLeaderboardMyRankCard(
            ownRank: null,
            totalParticipants: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('#--'), findsNothing);
      expect(find.textContaining('XP'), findsNothing);
    });
  });
}
