import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
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
      padding: const EdgeInsets.all(AppSpacing.tnn),
      decoration: BoxDecoration(
        color: colors.inputBackground,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabItem(
            label: l10n.tabList,
            iconPath: 'assets/notebook_screen/list_icon.svg',
            isSelected: currentMode == NotebookViewMode.list,
            onTap: () => onModeChanged(NotebookViewMode.list),
          ),
          const SizedBox(width: AppSpacing.xs),
          _TabItem(
            label: l10n.tabFlashcard,
            iconPath: 'assets/notebook_screen/flash_card_icon.svg',
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
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedBgColor = isDark ? const Color(0xFF222238) : Colors.white;

    return BounceWrapper(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(iconPath, width: 18.0, height: 18.0),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w800,
                color: isSelected ? colors.textPrimary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
