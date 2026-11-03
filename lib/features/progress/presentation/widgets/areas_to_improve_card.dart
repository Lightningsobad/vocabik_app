import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/progress_error_insights.dart';
import 'shimmer_block.dart';

class AreasToImproveCard extends StatelessWidget {
  final bool isLoading;
  final ProgressErrorInsights? errorInsights;
  final VoidCallback? onPractice;

  const AreasToImproveCard({
    super.key,
    this.isLoading = false,
    this.errorInsights,
    this.onPractice,
  });

  Color _getBarColor(int accuracy, AppColorsExtension colors) {
    if (accuracy < 50) {
      return colors.danger;
    } else if (accuracy < 70) {
      return AppColors.streak;
    } else {
      return colors.primaryAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final categories = errorInsights?.categories ?? [];
    final practiceTarget = categories.isNotEmpty
        ? categories.first.category
        : 'Grammar';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.progressAreasToImprove,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.lg2,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading) ...[
            const ShimmerBlock(height: 20),
            const SizedBox(height: 12),
            const ShimmerBlock(height: 20),
            const SizedBox(height: 12),
            const ShimmerBlock(height: 20),
          ] else if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                l10n.progressNoAreasToImprove,
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: 13,
                ),
              ),
            )
          else ...[
            ...categories.map((cat) {
              final barColor = _getBarColor(cat.accuracyPct, colors);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 105,
                      child: Text(
                        cat.category,
                        style: AppTextStyles.custom(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: (cat.accuracyPct / 100.0).clamp(0.0, 1.0),
                          backgroundColor: colors.streakCellInactive,
                          valueColor: AlwaysStoppedAnimation<Color>(barColor),
                          minHeight: 6.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 42,
                      child: Text(
                        '${cat.accuracyPct}%',
                        textAlign: TextAlign.end,
                        style: AppTextStyles.custom(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            InkWell(
              onTap: onPractice,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: colors.primaryAccent.withValues(alpha: 0.35),
                  ),
                  color: colors.accentCardBackground,
                ),
                child: Text(
                  l10n.progressPracticeTarget(practiceTarget),
                  style: AppTextStyles.custom(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryAccent,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
