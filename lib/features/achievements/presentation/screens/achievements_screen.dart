import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/shared_segmented_tab_bar.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../cubit/achievements_cubit.dart';
import '../cubit/achievements_state.dart';
import '../widgets/achievements_empty_view.dart';
import '../widgets/achievements_error_view.dart';
import '../widgets/badge_section_widget.dart';
import '../widgets/badge_skeleton_grid.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AchievementsCubit>()..fetchBadges(),
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatefulWidget {
  const _AchievementsView();

  @override
  State<_AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<_AchievementsView> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final filterTabs = [
      l10n.achievementsFilterAll,
      l10n.achievementsFilterMilestones,
      l10n.achievementsFilterStreak,
      l10n.achievementsFilterGenre,
      l10n.achievementsFilterVocabulary,
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        top: false,
        child: BlocBuilder<AchievementsCubit, AchievementsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<AchievementsCubit>().fetchBadges(),
              color: colors.primaryAccent,
              backgroundColor: colors.surfaceCard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: AppSpacing.xl3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(
                        l10n.achievementsYourAchievements,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.xl5_5,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.tn),

                    // Subtitle: Unlocked badges count
                    if (state is AchievementsLoaded &&
                        state.badges.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Text(
                          l10n.achievementsBadgesUnlocked(
                            state.unlockedCount,
                            state.totalCount,
                          ),
                          style: AppTextStyles.custom(
                            fontSize: AppFontSize.lg2,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ] else ...[
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Filter chips using SharedSegmentedTabBar
                    SharedSegmentedTabBar(
                      tabs: filterTabs,
                      selectedIndex: _selectedFilterIndex,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Content Section based on Cubit State
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: _buildBodyContent(context, state, l10n),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    AchievementsState state,
    AppLocalizations l10n,
  ) {
    if (state is AchievementsLoading || state is AchievementsInitial) {
      return const Column(
        children: [
          BadgeSkeletonGrid(itemCount: 6),
          SizedBox(height: AppSpacing.xl),
        ],
      );
    }

    if (state is AchievementsError) {
      return AchievementsErrorView(
        message: state.message,
        onRetry: () => context.read<AchievementsCubit>().fetchBadges(),
      );
    }

    if (state is AchievementsLoaded) {
      if (state.badges.isEmpty) {
        return const AchievementsEmptyView();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadgeSectionWidget(
            title: l10n.achievementsUnlockedHeader,
            badges: state.unlockedBadges,
          ),
          BadgeSectionWidget(
            title: l10n.achievementsLockedHeader,
            badges: state.lockedBadges,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
