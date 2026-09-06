import 'package:flutter/material.dart';
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
        // Review again (Danger red outline)
        Expanded(
          child: BounceWrapper(
            onTap: isLoading ? null : onReviewAgain,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                  const Text('👎', style: TextStyle(fontSize: 16.0)),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    l10n.reviewAgain,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w800,
                      color: colors.danger,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // Got it (Success green outline)
        Expanded(
          child: BounceWrapper(
            onTap: isLoading ? null : onGotIt,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                  const Text('👍', style: TextStyle(fontSize: 16.0)),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    l10n.gotIt,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w800,
                      color: colors.success,
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
