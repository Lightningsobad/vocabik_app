import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/progress_summary.dart';
import 'shimmer_block.dart';

class StreakCalendarCard extends StatelessWidget {
  final bool isLoading;
  final ProgressStreak? streak;

  const StreakCalendarCard({super.key, this.isLoading = false, this.streak});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

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
              Text(
                l10n.progress30DayStreak,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.lg2,
                  fontWeight: FontWeight.w900,
                  color: colors.textPrimary,
                ),
              ),
              if (isLoading)
                const ShimmerBlock(width: 110, height: 18)
              else
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/progress_screen/freeze_icon.svg',
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      l10n.progressStreakFreezeCount(streak?.freezeCount ?? 0),
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w800,
                        color: colors.premiumBackground,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (isLoading)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 15,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1.0,
              ),
              itemCount: 30,
              itemBuilder: (context, index) =>
                  const ShimmerBlock(width: 18, height: 18, borderRadius: 5.0),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 15,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1.0,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                final days = streak?.heatmap30Days ?? List.filled(30, false);
                final isActive = index < days.length ? days[index] : false;
                return Container(
                  decoration: BoxDecoration(
                    color: isActive
                        ? colors.streakCellActive
                        : colors.streakCellInactive,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
