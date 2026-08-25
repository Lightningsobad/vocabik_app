import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

enum SectionHeaderSize { large, medium, small }

class SectionHeader extends StatelessWidget {
  final String title;
  final String? iconAsset;
  final double? iconSize;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Color? actionTextColor;
  final bool isIconTrailing;
  final SectionHeaderSize size;

  const SectionHeader({
    super.key,
    required this.title,
    this.iconAsset,
    this.iconSize,
    this.actionText,
    this.onActionTap,
    this.actionTextColor,
    this.isIconTrailing = false,
    this.size = SectionHeaderSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    double fontSize;
    FontWeight fontWeight;
    Color color = colors.textPrimary;
    double defaultIconSize;
    double iconVerticalOffset;

    switch (size) {
      case SectionHeaderSize.large:
        fontSize = AppFontSize.xl5_5;
        fontWeight = FontWeight.w800;
        defaultIconSize = 35.0;
        iconVerticalOffset = -4.5;
        break;
      case SectionHeaderSize.medium:
        fontSize = AppFontSize.xl3;
        fontWeight = FontWeight.w900;
        defaultIconSize = 32.0;
        iconVerticalOffset = -2.0;
        break;
      case SectionHeaderSize.small:
        fontSize = AppFontSize.sm;
        fontWeight = FontWeight.w900;
        color = colors.textSecondary;
        defaultIconSize = 14.0;
        iconVerticalOffset = -1.5;
        break;
    }

    final effectiveIconSize = iconSize ?? defaultIconSize;

    final iconWidgetSpan = iconAsset != null
        ? WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(
                right: isIconTrailing ? 0 : 10.0,
                left: isIconTrailing ? 6.0 : 0,
              ),
              child: Transform.translate(
                offset: Offset(0, iconVerticalOffset),
                child: SvgPicture.asset(
                  iconAsset!,
                  width: effectiveIconSize,
                  height: effectiveIconSize,
                ),
              ),
            ),
          )
        : null;

    final textSpan = TextSpan(
      text: title,
      style: GoogleFonts.nunito(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: 1.15,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (!isIconTrailing && iconWidgetSpan != null) iconWidgetSpan,
                  textSpan,
                  if (isIconTrailing && iconWidgetSpan != null) iconWidgetSpan,
                ],
              ),
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: GoogleFonts.nunito(
                  color:
                      actionTextColor ?? Theme.of(context).colorScheme.primary,
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
