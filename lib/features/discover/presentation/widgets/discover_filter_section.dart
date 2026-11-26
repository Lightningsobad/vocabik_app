import 'package:flutter/material.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_filter_chip_row.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_search_input.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class DiscoverFilterSection extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final int selectedLevelIndex;
  final ValueChanged<int> onLevelIndexChanged;
  final List<VideoCategoryEntity> categories;
  final String selectedGenre;
  final ValueChanged<String> onGenreChanged;
  final String selectedDuration;
  final ValueChanged<String> onDurationChanged;
  final String selectedExerciseType;
  final ValueChanged<String> onExerciseTypeChanged;

  const DiscoverFilterSection({
    super.key,
    required this.onSearchChanged,
    required this.selectedLevelIndex,
    required this.onLevelIndexChanged,
    required this.categories,
    required this.selectedGenre,
    required this.onGenreChanged,
    required this.selectedDuration,
    required this.onDurationChanged,
    required this.selectedExerciseType,
    required this.onExerciseTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    final levels = [l10n.discoverFilterAll, 'A1', 'A2', 'B1', 'B2', 'C1'];

    final genres = <String>[
      l10n.discoverFilterAll,
      ...categories.map((c) => c.localizedShortLabel(languageCode)),
    ];
    final selectedGenreIndex = selectedGenre.isEmpty
        ? 0
        : categories.indexWhere((c) => c.slug == selectedGenre) + 1;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg3),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
            selectedIndex: selectedGenreIndex < 0 ? 0 : selectedGenreIndex,
            onTabChanged: (index) {
              if (index <= 0 || index - 1 >= categories.length) {
                onGenreChanged('');
              } else {
                onGenreChanged(categories[index - 1].slug);
              }
            },
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
