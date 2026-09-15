import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ResultGamificationCards extends StatelessWidget {
  final String cefrLevel;
  final int xpEarned;
  final int dayStreak;

  const ResultGamificationCards({
    super.key,
    required this.cefrLevel,
    this.xpEarned = 20,
    this.dayStreak = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // XP & Streak Row
        Row(
          children: [
            // XP Card
            _GamificationMetricCard(
              backgroundColor: colors.xpCardBackground,
              borderColor: colors.xpCardBorder,
              topWidget: Text(
                '+$xpEarned',
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.xl5,
                  fontWeight: FontWeight.w900,
                  color: colors.primaryAccent,
                ),
              ),
              bottomWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/home_screen/xp_icon.svg',
                    width: 14,
                    height: 14,
                  ),
                  const SizedBox(width: AppSpacing.tn),
                  Flexible(
                    child: Text(
                      l10n.resultXpEarned,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Streak Card
            _GamificationMetricCard(
              backgroundColor: colors.streakCardBackground,
              borderColor: colors.streakCardBorder,
              topWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/home_screen/streak_icon.svg',
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: AppSpacing.tnn),
                  Text(
                    '$dayStreak',
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.xl5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.streak,
                    ),
                  ),
                ],
              ),
              bottomWidget: Text(
                l10n.resultDayStreak,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm3),

        // New Badge Card
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md2,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: colors.badgeCardBackground,
            borderRadius: BorderRadius.circular(AppRadius.lg2),
            border: Border.all(color: colors.badgeCardBorder, width: 1.5),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/result_screen/medal_icon.svg',
                width: 36,
                height: 36,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.resultNewBadge(cefrLevel.toUpperCase()),
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.lg,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.resultCompletedFirstExercise(
                        cefrLevel.toUpperCase(),
                      ),
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _GamificationMetricCard extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Widget topWidget;
  final Widget bottomWidget;

  const _GamificationMetricCard({
    required this.backgroundColor,
    required this.borderColor,
    required this.topWidget,
    required this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md3,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.lg2),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          children: [
            topWidget,
            const SizedBox(height: AppSpacing.tn),
            bottomWidget,
          ],
        ),
      ),
    );
  }
}
