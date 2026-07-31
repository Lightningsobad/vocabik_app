import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<ActionItemData> items = [
      ActionItemData(title: 'Achievements', emoji: '🏅', onTap: () {}),
      ActionItemData(title: 'Notebook', emoji: '📖', onTap: () {}),
      ActionItemData(title: 'Leaderboard', emoji: '🏆', onTap: () {}),
      ActionItemData(title: 'Classroom', emoji: '🎓', onTap: () {}),
      ActionItemData(title: 'Daily Challenge', emoji: '🔥', onTap: () {}),
      ActionItemData(title: 'Bot integration', emoji: '✈️', onTap: () {}),
    ];

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
              return SizedBox(
                width: itemWidth,
                height: 56.0, // Fixed height giống thiết kế
                child: _ActionGridItem(data: item),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _ActionGridItem extends StatelessWidget {
  final ActionItemData data;

  const _ActionGridItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: data.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft, // Đảm bảo nội dung căn giữa chiều dọc
          children: [
            Row(
              children: [
                Text(
                  data.emoji,
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    data.title,
                    style: GoogleFonts.inter( // Dùng font Inter
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (data.badgeCount > 0 || data.hasNotification)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: data.badgeCount > 0
                      ? Text(
                          data.badgeCount.toString(),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox(width: 4, height: 4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
