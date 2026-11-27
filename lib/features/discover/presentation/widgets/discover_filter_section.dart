import 'package:flutter/material.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_filter_chip_row.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_search_input.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DiscoverFilterSection extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final int selectedLevelIndex;
  final ValueChanged<int> onLevelIndexChanged;
  final List<VideoCategoryEntity> categories;
  final bool isCategoriesLoading;
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
    this.isCategoriesLoading = false,
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.centerLeft,
              children: [
                ...previousChildren,
                ?currentChild,
              ],
            ),
            child: categories.isEmpty && isCategoriesLoading
                ? _GenreChipsShimmerRow(
                    key: const ValueKey('genre_chips_loading'),
                    allLabel: l10n.discoverFilterAll,
                  )
                : SharedSegmentedTabBar(
                    key: const ValueKey('genre_chips_loaded'),
                    selectedIndex:
                        selectedGenreIndex < 0 ? 0 : selectedGenreIndex,
                    onTabChanged: (index) {
                      if (index <= 0 || index - 1 >= categories.length) {
                        onGenreChanged('');
                      } else {
                        onGenreChanged(categories[index - 1].slug);
                      }
                    },
                    tabs: genres,
                  ),
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

class _GenreChipsShimmerRow extends StatelessWidget {
  final String allLabel;

  const _GenreChipsShimmerRow({super.key, required this.allLabel});

  static const List<double> _shimmerWidths = [76.0, 96.0, 84.0, 108.0, 88.0];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 42.0, minWidth: 42.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 5.0,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryAccent,
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(color: colors.primaryAccent, width: 1.0),
            ),
            child: Text(
              allLabel,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                color: colors.onPrimaryAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 9.0),
          AppShimmer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _shimmerWidths
                  .map(
                    (width) => Padding(
                      padding: const EdgeInsets.only(right: 9.0),
                      child: Container(
                        width: width,
                        height: 42.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
