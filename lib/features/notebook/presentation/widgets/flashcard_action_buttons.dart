import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';

class FlashcardActionButtons extends StatelessWidget {
  final VoidCallback onReviewAgain;
  final VoidCallback onGotIt;
  final bool isLoading;

  const FlashcardActionButtons({
    super.key,
    required this.onReviewAgain,
    required this.onGotIt,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Review again (dislike icon)
        Expanded(
          child: BounceWrapper(
            onTap: isLoading ? null : onReviewAgain,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: colors.danger,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/notebook_screen/dislike_icon.svg',
                    width: 20.0,
                    height: 20.0,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      l10n.reviewAgain,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w800,
                        color: colors.danger,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // Got it (like icon)
        Expanded(
          child: BounceWrapper(
            onTap: isLoading ? null : onGotIt,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: colors.success,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/notebook_screen/like_icon.png',
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      l10n.gotIt,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w800,
                        color: colors.success,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
