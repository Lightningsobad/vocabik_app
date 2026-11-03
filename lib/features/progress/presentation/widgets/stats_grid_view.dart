import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import '../../domain/entities/progress_summary.dart';
import 'stat_card_widget.dart';

class StatsGridView extends StatelessWidget {
  final bool isLoading;
  final ProgressSummary? summary;

  const StatsGridView({super.key, this.isLoading = false, this.summary});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final format = NumberFormat.decimalPattern();

    final streakValue = summary?.streak.currentStreak.toString() ?? '0';
    final xpValue = format.format(summary?.level.totalXp ?? 0);
    final exercisesDoneStr = summary?.stats.exercisesCompleted != null
        ? format.format(summary!.stats.exercisesCompleted)
        : '0';
    final accuracyStr = summary?.stats.accuracyPct != null
        ? '${summary!.stats.accuracyPct}%'
        : '--';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.27,
      children: [
        StatCardWidget(
          title: l10n.progressDayStreak,
          value: streakValue,
          iconAsset: 'assets/progress_screen/streak_icon.svg',
          iconBgColor: colors.streakCardBackground,
          iconBorderColor: colors.streakCardBorder,
          isLoading: isLoading,
        ),
        StatCardWidget(
          title: l10n.progressXP,
          value: xpValue,
          iconAsset: 'assets/progress_screen/xp_icon.svg',
          iconBgColor: colors.xpCardBackground,
          iconBorderColor: colors.xpCardBorder,
          isLoading: isLoading,
        ),
        StatCardWidget(
          title: l10n.progressExercisesDone,
          value: exercisesDoneStr,
          iconAsset: 'assets/progress_screen/book_icon.svg',
          iconBgColor: colors.accentCardBackground,
          iconBorderColor: colors.accentCardBorder,
          isLoading: isLoading,
        ),
        StatCardWidget(
          title: l10n.progressAccuracy,
          value: accuracyStr,
          iconAsset: 'assets/progress_screen/accuracy_icon.svg',
          iconBgColor: colors.successBackground,
          iconBorderColor: colors.successBorder,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
