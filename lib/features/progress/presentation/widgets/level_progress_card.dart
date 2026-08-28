import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_progress_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/progress_summary.dart';
import 'shimmer_block.dart';

class LevelProgressCard extends StatelessWidget {
  final bool isLoading;
  final ProgressLevel? level;

  const LevelProgressCard({super.key, this.isLoading = false, this.level});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final currentXp = level?.currentXpInLevel ?? 0;
    final maxXp = level?.xpRequiredForNextLevel ?? 500;
    final progress = level != null && level!.progressPct > 0
        ? (level!.progressPct / 100.0).clamp(0.0, 1.0)
        : (maxXp > 0 ? (currentXp / maxXp).clamp(0.0, 1.0) : 0.0);

    final title = level?.currentTitle ?? 'Fluent Challenger';
    final nextTitle = level?.nextTitle;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg2),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isLoading)
                const ShimmerBlock(width: 140, height: 22)
              else
                Text(
                  title,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.xl,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                  ),
                ),
              if (isLoading)
                const ShimmerBlock(width: 80, height: 16)
              else
                Text(
                  l10n.progressXpRatio(currentXp, maxXp),
                  style: AppTextStyles.custom(
                    color: colors.textSecondary,
                    fontSize: AppFontSize.mdt,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (isLoading)
            const ShimmerBlock(height: 8, borderRadius: 4.0)
          else
            AppProgressBar(
              progress: progress,
              height: 8.0,
              color: colors.levelProgressBar,
            ),
          const SizedBox(height: AppSpacing.sm),
          if (isLoading)
            const ShimmerBlock(width: 160, height: 16)
          else
            Text(
              nextTitle != null
                  ? l10n.progressNextLevel(nextTitle)
                  : l10n.progressMaxLevelReached,
              style: AppTextStyles.custom(
                color: colors.textSecondary,
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}
