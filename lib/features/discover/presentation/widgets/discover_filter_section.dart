import 'package:flutter/material.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_filter_chip_row.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_search_input.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class DiscoverFilterSection extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final int selectedLevelIndex;
  final ValueChanged<int> onLevelIndexChanged;
  final int selectedGenreIndex;
  final ValueChanged<int> onGenreIndexChanged;
  final String selectedDuration;
  final ValueChanged<String> onDurationChanged;
  final String selectedExerciseType;
  final ValueChanged<String> onExerciseTypeChanged;

  const DiscoverFilterSection({
    super.key,
    required this.onSearchChanged,
    required this.selectedLevelIndex,
    required this.onLevelIndexChanged,
    required this.selectedGenreIndex,
    required this.onGenreIndexChanged,
    required this.selectedDuration,
    required this.onDurationChanged,
    required this.selectedExerciseType,
    required this.onExerciseTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final levels = [l10n.discoverFilterAll, 'A1', 'A2', 'B1', 'B2', 'C1'];

    final genres = [
      l10n.discoverFilterAll,
      l10n.genreMusic,
      l10n.genreVlog,
      l10n.genreNews,
      l10n.genreEducation,
      l10n.genreEntertainment,
      l10n.genreTedTalks,
      l10n.genreNewsEnglish,
      l10n.genreOther,
    ];

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg3),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
            ),
            child: DiscoverSearchInput(onChanged: onSearchChanged),
          ),
          const SizedBox(height: AppSpacing.lg),

          // CEFR Filters
          SharedSegmentedTabBar(
            selectedIndex: selectedLevelIndex,
            onTabChanged: onLevelIndexChanged,
            tabs: levels,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Genre Filters
          SharedSegmentedTabBar(
            selectedIndex: selectedGenreIndex,
            onTabChanged: onGenreIndexChanged,
            tabs: genres,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Duration & ExerciseType Row
          DiscoverFilterChipRow(
            selectedDuration: selectedDuration,
            selectedExerciseType: selectedExerciseType,
            onDurationChanged: onDurationChanged,
            onExerciseTypeChanged: onExerciseTypeChanged,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
