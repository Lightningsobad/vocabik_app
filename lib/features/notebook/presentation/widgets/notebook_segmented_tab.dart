import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../cubit/notebook_state.dart';

class NotebookSegmentedTab extends StatelessWidget {
  final NotebookViewMode currentMode;
  final ValueChanged<NotebookViewMode> onModeChanged;

  const NotebookSegmentedTab({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: colors.tabUnselectedBackground,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: colors.tabUnselectedBorder,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabItem(
            label: l10n.tabList,
            emoji: '📄',
            isSelected: currentMode == NotebookViewMode.list,
            onTap: () => onModeChanged(NotebookViewMode.list),
          ),
          const SizedBox(width: AppSpacing.xs),
          _TabItem(
            label: l10n.tabFlashcard,
            emoji: '🎴',
            isSelected: currentMode == NotebookViewMode.flashcard,
            onTap: () => onModeChanged(NotebookViewMode.flashcard),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.sm,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? colors.onPrimaryAccent
                    : colors.tabUnselectedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
