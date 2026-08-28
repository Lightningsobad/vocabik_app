import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import 'shimmer_block.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String iconAsset;
  final Color iconBgColor;
  final Color iconBorderColor;
  final bool isLoading;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.iconAsset,
    required this.iconBgColor,
    required this.iconBorderColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg2),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(iconAsset, width: 22, height: 22),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (isLoading)
            const ShimmerBlock(height: 28, width: 60)
          else
            Text(
              value,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.xl6,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.mdt,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
