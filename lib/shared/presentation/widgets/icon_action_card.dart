import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class IconActionCard extends StatelessWidget {
  final String title;
  final String? iconAsset;
  final String? emoji;
  final double iconSize;
  final VoidCallback onTap;
  final int badgeCount;
  final bool hasNotification;

  const IconActionCard({
    super.key,
    required this.title,
    this.iconAsset,
    this.emoji,
    this.iconSize = AppSpacing.lg2,
    required this.onTap,
    this.badgeCount = 0,
    this.hasNotification = false,
  }) : assert(
          iconAsset != null || emoji != null,
          'Either iconAsset or emoji must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: colors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          alignment:
              Alignment.centerLeft, // Đảm bảo nội dung căn giữa chiều dọc
          children: [
            Row(
              children: [
                if (iconAsset != null)
                  SvgPicture.asset(
                    iconAsset!,
                    width: iconSize,
                    height: iconSize,
                  )
                else if (emoji != null)
                  Text(emoji!, style: TextStyle(fontSize: iconSize - 2)),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.custom(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: AppFontSize.md,
                    ),
                    maxLines: null, // Allow wrapping if text scales up
                  ),
                ),
              ],
            ),
            if (badgeCount > 0 || hasNotification)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: badgeCount > 0
                      ? Text(
                          badgeCount.toString(),
                          style: AppTextStyles.custom(
                            color: Theme.of(context).colorScheme.onError,
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
