import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/shared/presentation/widgets/icon_action_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class ActionItemData {
  final String title;
  final String iconAsset;
  final double iconSize;
  final VoidCallback onTap;
  final int badgeCount;
  final bool hasNotification;
  static const double defaultIconSize = AppSpacing.lg;

  ActionItemData({
    required this.title,
    required this.iconAsset,
    this.iconSize = defaultIconSize,
    required this.onTap,
    this.badgeCount = 0,
    this.hasNotification = false,
  });
}

class ProfileActionGrid extends StatelessWidget {
  const ProfileActionGrid({super.key});

  List<ActionItemData> _getItems(BuildContext context, AppLocalizations l10n) =>
      [
        ActionItemData(
          title: l10n.actionAchievements,
          iconAsset: 'assets/profile_screen/medal_icon.svg',
          onTap: () {
            context.push('/profile/achievements');
          },
        ),
        ActionItemData(
          title: l10n.actionNotebook,
          iconAsset: 'assets/profile_screen/notebook_icon.svg',
          onTap: () {
            context.push('/profile/notebook');
          },
        ),
        ActionItemData(
          title: l10n.actionLeaderboard,
          iconAsset: 'assets/profile_screen/trophy.svg',
          onTap: () {
            context.push('/profile/leaderboard');
          },
        ),
        ActionItemData(
          title: l10n.actionDailyChallenge,
          iconAsset: 'assets/profile_screen/streak_icon.svg',
          onTap: () {
            context.push('/profile/daily-challenge');
          },
        ),
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
                constraints: const BoxConstraints(minHeight: AppSpacing.xl5_5),
                child: IconActionCard(
                  title: item.title,
                  iconAsset: item.iconAsset,
                  iconSize: item.iconSize,
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
