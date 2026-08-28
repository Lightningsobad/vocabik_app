import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/progress_summary.dart';
import 'shimmer_block.dart';

class WeeklyXpCard extends StatelessWidget {
  final bool isLoading;
  final List<WeeklyXpItem>? weeklyXp;

  const WeeklyXpCard({super.key, this.isLoading = false, this.weeklyXp});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final items = weeklyXp ?? const [];
    final maxXp = items.fold<int>(1, (maxVal, item) => max(maxVal, item.xp));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl1,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg2),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.progressWeeklyXP,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.lg2,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (isLoading)
            const ShimmerBlock(height: 130, borderRadius: 8.0)
          else
            SizedBox(
              height: 130,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: items.map((item) {
                  final heightFactor = maxXp > 0
                      ? (item.xp / maxXp).clamp(0.08, 1.0)
                      : 0.08;
                  const maxBarHeight = 72.0;
                  final barHeight = maxBarHeight * heightFactor;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 18,
                          child: item.xp > 0
                              ? Text(
                                  '${item.xp}',
                                  style: AppTextStyles.custom(
                                    fontSize: AppFontSize.sm,
                                    fontWeight: FontWeight.w900,
                                    color: colors.weeklyXpBarStart,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: barHeight,
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg1,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                colors.weeklyXpBarStart, // Chân cột
                                colors.weeklyXpBarEnd, // Đỉnh cột
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(AppRadius.sm2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 18,
                          child: Text(
                            item.label,
                            style: AppTextStyles.custom(
                              fontSize: AppFontSize.sm,
                              fontWeight: FontWeight.w700,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
