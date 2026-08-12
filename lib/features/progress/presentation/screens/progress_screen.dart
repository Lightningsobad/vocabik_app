import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

import '../../../../core/di/injection.dart';
import '../cubit/progress_cubit.dart';
import '../widgets/stats_grid_view.dart';
import '../widgets/streak_calendar_card.dart';
import '../widgets/level_progress_card.dart';
import '../widgets/empty_state_card.dart';

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
    
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        if (state is ProgressError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, style: TextStyle(color: colors.textSecondary)),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () => context.read<ProgressCubit>().loadProgressData(),
                  child: Text(AppLocalizations.of(context)!.homeRetry),
                ),
              ],
            ),
          );
        }
        
        final isLoading = state is ProgressInitial || state is ProgressLoading;
        final summary = state is ProgressLoaded ? state.summary : null;

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ProgressCubit>().loadProgressData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.progressYourProgress,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                
                StatsGridView(isLoading: isLoading, gamification: summary?.gamification),
                const SizedBox(height: AppSpacing.md),
                
                StreakCalendarCard(isLoading: isLoading, gamification: summary?.gamification, dailyStreak: summary?.dailyStreak),
                const SizedBox(height: AppSpacing.md),
                
                LevelProgressCard(isLoading: isLoading, gamification: summary?.gamification),
                const SizedBox(height: AppSpacing.md),
                
                EmptyStateCard(title: AppLocalizations.of(context)!.progressWeeklyXP),
                const SizedBox(height: AppSpacing.md),
                
                EmptyStateCard(title: AppLocalizations.of(context)!.progressAreasToImprove),
                const SizedBox(height: AppSpacing.md),
                
                EmptyStateCard(title: AppLocalizations.of(context)!.progressLearningHistory),
                const SizedBox(height: AppSpacing.xl2),
              ],
            ),
          ),
        );
      },
    );
  }
}
