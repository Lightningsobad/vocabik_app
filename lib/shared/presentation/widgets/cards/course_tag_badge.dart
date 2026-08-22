import 'package:flutter/material.dart';
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

  const CourseTagBadge({
    super.key,
    required this.text,
    this.type = CourseTagType.level,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    Color backgroundColor;
    Color textColor;
    IconData? icon;
    Border? border;

    switch (type) {
      case CourseTagType.level:
        textColor = colors.tagLevelText;
        final cleanLevel = text.trim().toUpperCase();
        if (cleanLevel.startsWith('A')) {
          backgroundColor = colors.tagLevelA;
        } else if (cleanLevel == 'B1') {
          backgroundColor = colors.tagLevelB1;
        } else if (cleanLevel == 'B2') {
          backgroundColor = colors.tagLevelB2;
        } else if (cleanLevel == 'C1') {
          backgroundColor = colors.tagLevelC1;
        } else {
          backgroundColor = colors.tagLevelA;
        }
        break;
      case CourseTagType.category:
        backgroundColor = colors.tabUnselectedBackground;
        textColor = colors.textSecondary;
        border = Border.all(color: colors.borderSubtle, width: 1);
        break;
      case CourseTagType.newTag:
        backgroundColor = colors.tagNewBackground;
        textColor = colors.tagNewText;
        break;
      case CourseTagType.completed:
        backgroundColor = colors.tagNewBackground;
        textColor = colors.tagNewText;
        icon = Icons.check;
        break;
      case CourseTagType.dailyPick:
        backgroundColor = Colors.black.withValues(alpha: 0.4);
        textColor = Colors.white;
        break;
    }

    final isCompactCircle = type == CourseTagType.completed && text.isEmpty;

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
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.full),
        border: border,
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
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            if (text.isNotEmpty) const SizedBox(width: 4),
          ],
          if (text.isNotEmpty)
            Flexible(
              child: Text(
                text,
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
