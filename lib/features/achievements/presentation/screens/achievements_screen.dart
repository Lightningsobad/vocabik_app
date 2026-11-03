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

class _AchievementFilterCategory {
  final String? key;
  final String Function(AppLocalizations l10n) getTitle;

  const _AchievementFilterCategory({
    required this.key,
    required this.getTitle,
  });
}

const List<_AchievementFilterCategory> _categories = [
  _AchievementFilterCategory(
    key: null,
    getTitle: _getAllTitle,
  ),
  _AchievementFilterCategory(
    key: 'exercise',
    getTitle: _getExerciseTitle,
  ),
  _AchievementFilterCategory(
    key: 'streak',
    getTitle: _getStreakTitle,
  ),
  _AchievementFilterCategory(
    key: 'proficiency',
    getTitle: _getProficiencyTitle,
  ),
  _AchievementFilterCategory(
    key: 'diversity',
    getTitle: _getDiversityTitle,
  ),
  _AchievementFilterCategory(
    key: 'vocabulary',
    getTitle: _getVocabularyTitle,
  ),
  _AchievementFilterCategory(
    key: 'speed',
    getTitle: _getSpeedTitle,
  ),
  _AchievementFilterCategory(
    key: 'general',
    getTitle: _getGeneralTitle,
  ),
];

String _getAllTitle(AppLocalizations l10n) => l10n.achievementsFilterAll;
String _getExerciseTitle(AppLocalizations l10n) => l10n.achievementsFilterExercise;
String _getStreakTitle(AppLocalizations l10n) => l10n.achievementsFilterStreak;
String _getProficiencyTitle(AppLocalizations l10n) => l10n.achievementsFilterProficiency;
String _getDiversityTitle(AppLocalizations l10n) => l10n.achievementsFilterDiversity;
String _getVocabularyTitle(AppLocalizations l10n) => l10n.achievementsFilterVocabulary;
String _getSpeedTitle(AppLocalizations l10n) => l10n.achievementsFilterSpeed;
String _getGeneralTitle(AppLocalizations l10n) => l10n.achievementsFilterGeneral;

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

  void _onTabChanged(int index) {
    if (_selectedFilterIndex == index) return;
    setState(() {
      _selectedFilterIndex = index;
    });
    final category = _categories[index].key;
    context.read<AchievementsCubit>().selectCategory(category);
  }

  void _onRefresh() {
    final category = _categories[_selectedFilterIndex].key;
    context.read<AchievementsCubit>().fetchBadges(category: category);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final filterTabs = _categories.map((c) => c.getTitle(l10n)).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        top: false,
        child: BlocBuilder<AchievementsCubit, AchievementsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async => _onRefresh(),
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
                      onTabChanged: _onTabChanged,
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
        onRetry: _onRefresh,
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
