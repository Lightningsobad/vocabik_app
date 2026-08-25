import 'package:flutter/material.dart';
import 'package:vocabik_app/core/utils/string_extensions.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

enum CourseTagType { level, category, newTag, completed, dailyPick }

class CourseTagBadge extends StatelessWidget {
  final String text;
  final CourseTagType type;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Border? border;
  final IconData? icon;
  final Widget? leadingIcon;
  final double? iconSize;
  final Color? iconColor;
  final double iconSpacing;

  const CourseTagBadge({
    super.key,
    required this.text,
    this.type = CourseTagType.level,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.backgroundColor,
    this.border,
    this.icon,
    this.leadingIcon,
    this.iconSize,
    this.iconColor,
    this.iconSpacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    Color defaultBg;
    Color textColor;
    IconData? defaultIcon;
    Border? defaultBorder;

    switch (type) {
      case CourseTagType.level:
        textColor = colors.tagLevelText;
        final cleanLevel = text.trim().toUpperCase();
        if (cleanLevel.startsWith('A')) {
          defaultBg = colors.tagLevelA;
        } else if (cleanLevel == 'B1') {
          defaultBg = colors.tagLevelB1;
        } else if (cleanLevel == 'B2') {
          defaultBg = colors.tagLevelB2;
        } else if (cleanLevel == 'C1') {
          defaultBg = colors.tagLevelC1;
        } else {
          defaultBg = colors.tagLevelA;
        }
        break;
      case CourseTagType.category:
        defaultBg = colors.tabUnselectedBackground;
        textColor = colors.textSecondary;
        defaultBorder = Border.all(color: colors.borderSubtle, width: 1);
        break;
      case CourseTagType.newTag:
        defaultBg = colors.tagNewBackground;
        textColor = colors.tagNewText;
        break;
      case CourseTagType.completed:
        defaultBg = colors.tagNewBackground;
        textColor = colors.tagNewText;
        defaultIcon = Icons.check;
        break;
      case CourseTagType.dailyPick:
        defaultBg = Colors.black.withValues(alpha: 0.4);
        textColor = Colors.white;
        break;
    }

    String displayText = text;
    if (type == CourseTagType.category && text.isNotEmpty) {
      displayText = text.capitalize();
    }

    final isCompactCircle = type == CourseTagType.completed && text.isEmpty;

    final effectiveIcon = icon ?? defaultIcon;
    final effectiveTextColor = textStyle?.color ?? textColor;
    final effectiveIconColor = iconColor ?? effectiveTextColor;
    final effectiveIconSize = iconSize ?? 14.0;

    Widget? leading;
    if (leadingIcon != null) {
      leading = leadingIcon;
    } else if (effectiveIcon != null) {
      leading = Icon(
        effectiveIcon,
        size: effectiveIconSize,
        color: effectiveIconColor,
      );
    }

    return Container(
      padding:
          padding ??
          (isCompactCircle
              ? const EdgeInsets.all(5.0)
              : const EdgeInsets.symmetric(
                  horizontal: AppSpacing.tnn,
                  vertical: AppSpacing.xs,
                )),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.full),
        border: border ?? defaultBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (type == CourseTagType.dailyPick) ...[
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
          if (leading != null) ...[
            leading,
            if (displayText.isNotEmpty) SizedBox(width: iconSpacing),
          ],
          if (displayText.isNotEmpty)
            Flexible(
              child: Text(
                displayText,
                style:
                    textStyle ??
                    AppTextStyles.custom(
                      fontSize: AppFontSize.tnn,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
