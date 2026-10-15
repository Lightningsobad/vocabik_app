import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/entities/badge_entity.dart';
import 'badge_card.dart';

class BadgeSectionWidget extends StatelessWidget {
  final String title;
  final List<BadgeEntity> badges;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double titleSpacing;
  final double titleFontSize;

  const BadgeSectionWidget({
    super.key,
    required this.title,
    required this.badges,
    this.childAspectRatio = 0.85,
    this.crossAxisSpacing = AppSpacing.md,
    this.mainAxisSpacing = AppSpacing.md,
    this.titleSpacing = AppSpacing.md,
    this.titleFontSize = AppFontSize.sm,
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.custom(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: titleSpacing),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            return BadgeCard(badge: badges[index]);
          },
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
