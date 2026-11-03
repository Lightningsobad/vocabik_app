import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../domain/entities/daily_challenge_streak_entity.dart';

class DailyChallengeStreakCard extends StatelessWidget {
  final DailyChallengeStreakEntity? streak;
  final bool isLoading;

  const DailyChallengeStreakCard({
    super.key,
    required this.streak,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    if (isLoading && streak == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: AppShimmer(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    final currentStreak = streak?.currentStreak ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg2,
      ),
      decoration: BoxDecoration(
        color: colors.streakCardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg2),
        border: Border.all(color: colors.streakCardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/daily_challenge_screen/streak_icon.svg',
            width: 22,
            height: 22,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              currentStreak > 0
                  ? l10n.dailyChallengeStreakDays(currentStreak)
                  : l10n.dailyChallengeStreakKeep,
              style: AppTextStyles.custom(
                color: colors.textPrimary,
                fontSize: AppFontSize.lg,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
