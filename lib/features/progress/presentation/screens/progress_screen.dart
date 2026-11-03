import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import '../../../../core/di/injection.dart';
import 'package:vocabik_app/features/main_shell/presentation/cubit/main_shell_cubit.dart';
import '../cubit/progress_cubit.dart';
import '../widgets/stats_grid_view.dart';
import '../widgets/streak_calendar_card.dart';
import '../widgets/level_progress_card.dart';
import '../widgets/weekly_xp_card.dart';
import '../widgets/areas_to_improve_card.dart';
import '../widgets/learning_history_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BlocProvider(
      create: (context) => getIt<ProgressCubit>()..loadProgressData(),
      child: Scaffold(
        backgroundColor: colors.background,
        body: const _ProgressScreenContent(),
      ),
    );
  }
}

class _ProgressScreenContent extends StatelessWidget {
  const _ProgressScreenContent();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final shellState = context.watch<MainShellCubit>().state;
    final progressState = context.watch<ProgressCubit>().state;

    final hasFatalError = (shellState.errorMessage != null && shellState.summary == null) ||
        (progressState is ProgressError && shellState.summary == null);

    if (hasFatalError) {
      final errorMessage = shellState.errorMessage ??
          (progressState is ProgressError ? progressState.message : l10n.homeRetry);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () {
                context.read<MainShellCubit>().loadSummary();
                context.read<ProgressCubit>().loadProgressData();
              },
              child: Text(l10n.homeRetry),
            ),
          ],
        ),
      );
    }

    final isSummaryLoading = shellState.isLoading || shellState.summary == null;
    final isProgressLoading =
        progressState is ProgressInitial || progressState is ProgressLoading;

    final summary = shellState.summary;
    final history = progressState is ProgressLoaded ? progressState.history : null;
    final errorInsights =
        progressState is ProgressLoaded ? progressState.errorInsights : null;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          context.read<MainShellCubit>().loadSummary(),
          context.read<ProgressCubit>().loadProgressData(),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.tn),
            // Header Title
            Text(
              l10n.progressYourProgress,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.xl5_5,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg1),

            // Action buttons: Achievements & Leaderboard
            Row(
              children: [
                Expanded(
                  child: _NavigationCard(
                    iconAsset: 'assets/progress_screen/medal_icon.svg',
                    title: l10n.progressAchievements,
                    onTap: () => context.push('/progress/achievements'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _NavigationCard(
                    iconAsset: 'assets/progress_screen/trophy.svg',
                    title: l10n.progressLeaderboard,
                    onTap: () => context.push('/progress/leaderboard'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg1),

            // Stats Grid (Streak, XP, Exercises, Accuracy)
            StatsGridView(isLoading: isSummaryLoading, summary: summary),
            const SizedBox(height: AppSpacing.xl2),

            // 30-Day Streak Heatmap
            StreakCalendarCard(
              isLoading: isSummaryLoading,
              streak: summary?.streak,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Level / Current Title Progress
            LevelProgressCard(isLoading: isSummaryLoading, level: summary?.level),
            const SizedBox(height: AppSpacing.lg),

            // Weekly XP Bar Chart
            WeeklyXpCard(isLoading: isSummaryLoading, weeklyXp: summary?.weeklyXp),
            const SizedBox(height: AppSpacing.lg),

            // Areas to Improve (Weak points)
            AreasToImproveCard(
              isLoading: isProgressLoading,
              errorInsights: errorInsights,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Learning History List
            LearningHistoryCard(isLoading: isProgressLoading, history: history),
            const SizedBox(height: AppSpacing.xl2),
          ],
        ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final String iconAsset;
  final String title;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.iconAsset,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg2),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconAsset, width: 18, height: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
