import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class SegmentedToggleOption<T> {
  final T value;
  final String label;
  final Widget? icon;

  const SegmentedToggleOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

class SegmentedToggle<T> extends StatelessWidget {
  final T selectedValue;
  final List<SegmentedToggleOption<T>> options;
  final ValueChanged<T> onChanged;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? itemPadding;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadiusGeometry? itemBorderRadius;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final List<BoxShadow>? activeBoxShadow;
  final bool isExpanded;

  const SegmentedToggle({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.padding,
    this.itemPadding,
    this.borderRadius,
    this.itemBorderRadius,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.activeBoxShadow,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    final defaultItemBorderRadius =
        itemBorderRadius ?? BorderRadius.circular(AppRadius.full);

    final activeColor = activeBackgroundColor ?? colors.surfaceCard;
    final inactiveColor = activeColor.withValues(alpha: 0);

    final items = options.map((option) {
      final isSelected = option.value == selectedValue;

      Widget itemWidget = BounceWrapper(
        onTap: () => onChanged(option.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding:
              itemPadding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : inactiveColor,
            borderRadius: defaultItemBorderRadius,
            boxShadow: isSelected ? (activeBoxShadow ?? const []) : const [],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (option.icon != null) ...[
                option.icon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                option.label,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.mdt,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  color: isSelected
                      ? (activeTextColor ?? colors.textPrimary)
                      : (inactiveTextColor ?? colors.textSecondary),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );

      if (isExpanded) {
        return Expanded(child: itemWidget);
      }
      return itemWidget;
    }).toList();

    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.tn),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.inputBackground,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        children: items,
      ),
    );
  }
}
