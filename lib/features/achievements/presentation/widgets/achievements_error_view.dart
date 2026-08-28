import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';

class AchievementsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AchievementsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl5,
        horizontal: AppSpacing.lg,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: AppSpacing.xl5, color: colors.danger),
            const SizedBox(height: AppSpacing.md),
            Text(
              message.isNotEmpty ? message : l10n.authGenericError,
              textAlign: TextAlign.center,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.mdt,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            BounceWrapper(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg2,
                  vertical: AppSpacing.sm2,
                ),
                decoration: BoxDecoration(
                  color: colors.tabUnselectedBackground,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: colors.tabUnselectedBorder),
                ),
                child: Text(
                  l10n.homeRetry,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
