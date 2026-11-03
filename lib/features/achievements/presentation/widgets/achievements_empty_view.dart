import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';

class AchievementsEmptyView extends StatelessWidget {
  const AchievementsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl7,
        horizontal: AppSpacing.lg,
      ),
      child: Center(
        child: Text(
          l10n.achievementsEmpty,
          textAlign: TextAlign.center,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.mdt,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
