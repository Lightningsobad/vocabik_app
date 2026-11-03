import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DiscoverFilterChipRow extends StatelessWidget {
  final String selectedDuration;
  final String selectedExerciseType;
  final ValueChanged<String> onDurationChanged;
  final ValueChanged<String> onExerciseTypeChanged;

  const DiscoverFilterChipRow({
    super.key,
    required this.selectedDuration,
    required this.selectedExerciseType,
    required this.onDurationChanged,
    required this.onExerciseTypeChanged,
  });

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorsExtension colors,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 9.0),
      child: BounceWrapper(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(
            minHeight: 39.0,
            minWidth: 42.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 5.0,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primaryAccent
                : colors.tabUnselectedBackground,
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              color: isSelected
                  ? colors.primaryAccent
                  : colors.tabUnselectedBorder,
              width: 1.0,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.custom(
              fontSize: AppFontSize.md,
              color: isSelected
                  ? colors.onPrimaryAccent
                  : colors.tabUnselectedText,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Duration Filters
          _buildFilterChip(
            label: l10n.discoverTimeUnder3,
            isSelected: selectedDuration == 'short',
            onTap: () {
              onDurationChanged(selectedDuration == 'short' ? '' : 'short');
            },
            colors: colors,
          ),
          _buildFilterChip(
            label: l10n.discoverTime3To7,
            isSelected: selectedDuration == 'medium',
            onTap: () {
              onDurationChanged(selectedDuration == 'medium' ? '' : 'medium');
            },
            colors: colors,
          ),
          _buildFilterChip(
            label: l10n.discoverTimeOver7,
            isSelected: selectedDuration == 'long',
            onTap: () {
              onDurationChanged(selectedDuration == 'long' ? '' : 'long');
            },
            colors: colors,
          ),

          // Spacing between duration group and exerciseType group
          const SizedBox(width: AppSpacing.xl),

          // Exercise Type Filters
          _buildFilterChip(
            label: l10n.exerciseTypeMc,
            isSelected: selectedExerciseType == 'MC',
            onTap: () {
              onExerciseTypeChanged(selectedExerciseType == 'MC' ? '' : 'MC');
            },
            colors: colors,
          ),
          _buildFilterChip(
            label: l10n.exerciseTypeFreeText,
            isSelected: selectedExerciseType == 'FREE_TEXT',
            onTap: () {
              onExerciseTypeChanged(
                selectedExerciseType == 'FREE_TEXT' ? '' : 'FREE_TEXT',
              );
            },
            colors: colors,
          ),
          _buildFilterChip(
            label: l10n.exerciseTypeSentenceReorder,
            isSelected: selectedExerciseType == 'SENTENCE_REORDER',
            onTap: () {
              onExerciseTypeChanged(
                selectedExerciseType == 'SENTENCE_REORDER'
                    ? ''
                    : 'SENTENCE_REORDER',
              );
            },
            colors: colors,
          ),
        ],
      ),
    );
  }
}
