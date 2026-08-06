import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

enum SectionHeaderSize { large, medium, small }

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final SectionHeaderSize size;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.size = SectionHeaderSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    double fontSize;
    FontWeight fontWeight;
    Color color = colors.textPrimary;

    switch (size) {
      case SectionHeaderSize.large:
        fontSize = AppFontSize.xl5;
        fontWeight = FontWeight.w900;
        break;
      case SectionHeaderSize.medium:
        fontSize = AppFontSize.xl3;
        fontWeight = FontWeight.w900;
        break;
      case SectionHeaderSize.small:
        fontSize = AppFontSize.sm;
        fontWeight = FontWeight.w800;
        color = colors.textSecondary;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.nunito(
                color: color,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: GoogleFonts.nunito(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: AppFontSize.md,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
