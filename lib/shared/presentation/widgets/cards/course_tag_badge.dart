import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

enum CourseTagType { level, category, newTag, completed, dailyPick }

class CourseTagBadge extends StatelessWidget {
  final String text;
  final CourseTagType type;

  const CourseTagBadge({
    super.key,
    required this.text,
    this.type = CourseTagType.level,
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
        backgroundColor = Theme.of(context).colorScheme.primary;
        textColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case CourseTagType.category:
        backgroundColor = colors.surfaceCard.withValues(alpha: 0.5);
        textColor = colors.textSecondary;
        border = Border.all(color: colors.borderSubtle, width: 0.5);
        break;
      case CourseTagType.newTag:
        backgroundColor = const Color(0xFF10B981); // Green
        textColor = Colors.white;
        break;
      case CourseTagType.completed:
        backgroundColor = const Color(0xFF10B981); // Green
        textColor = Colors.white;
        icon = Icons.check;
        break;
      case CourseTagType.dailyPick:
        backgroundColor = Colors.black.withValues(alpha: 0.2);
        textColor = Colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.tn,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
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
                style: GoogleFonts.nunito(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
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
