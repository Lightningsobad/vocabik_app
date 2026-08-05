import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/shared/presentation/widgets/icon_action_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

class ActionItemData {
  final String title;
  final String emoji;
  final VoidCallback onTap;
  final int badgeCount;
  final bool hasNotification;

  ActionItemData({
    required this.title,
    required this.emoji,
    required this.onTap,
    this.badgeCount = 0,
    this.hasNotification = false,
  });
}

class ProfileActionGrid extends StatelessWidget {
  const ProfileActionGrid({super.key});

  List<ActionItemData> _getItems(BuildContext context, AppLocalizations l10n) => [
    ActionItemData(title: l10n.actionAchievements, emoji: '🏅', onTap: () {}),
    ActionItemData(title: l10n.actionNotebook, emoji: '📖', onTap: () {}),
    ActionItemData(title: l10n.actionLeaderboard, emoji: '🏆', onTap: () {}),
    ActionItemData(title: l10n.actionClassroom, emoji: '🎓', onTap: () {}),
    ActionItemData(title: l10n.actionDailyChallenge, emoji: '🔥', onTap: () {}),
    ActionItemData(title: l10n.actionBotIntegration, emoji: '✈️', onTap: () {
      context.push('/profile/integration');
    }),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _getItems(context, l10n);
    
    return Padding(
      // Chỉ giữ padding ngang
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Tính toán width cho 2 cột với khoảng cách ở giữa là 12.0
          final itemWidth = (constraints.maxWidth - 12.0) / 2;
          
          return Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: items.map((item) {
              return Container(
                width: itemWidth,
                constraints: const BoxConstraints(minHeight: 56.0),
                child: IconActionCard(
                  title: item.title,
                  emoji: item.emoji,
                  onTap: item.onTap,
                  badgeCount: item.badgeCount,
                  hasNotification: item.hasNotification,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
