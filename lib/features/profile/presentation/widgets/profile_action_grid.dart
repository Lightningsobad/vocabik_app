import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/presentation/widgets/icon_action_card.dart';

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

  static final List<ActionItemData> _items = [
    ActionItemData(title: 'Achievements', emoji: '🏅', onTap: () {}),
    ActionItemData(title: 'Notebook', emoji: '📖', onTap: () {}),
    ActionItemData(title: 'Leaderboard', emoji: '🏆', onTap: () {}),
    ActionItemData(title: 'Classroom', emoji: '🎓', onTap: () {}),
    ActionItemData(title: 'Daily Challenge', emoji: '🔥', onTap: () {}),
    ActionItemData(title: 'Bot integration', emoji: '✈️', onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
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
            children: _items.map((item) {
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
