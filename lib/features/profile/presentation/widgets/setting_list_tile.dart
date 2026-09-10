import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class SettingListTile extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Widget trailing;
  final VoidCallback? onTap;
  final String? prefixEmoji;
  final String? prefixAsset;
  final TextStyle? prefixTextStyle;
  final Widget? prefixWidget;
  final double iconSize;
  final Color? iconColor;

  const SettingListTile({
    super.key,
    required this.title,
    required this.trailing,
    this.titleStyle,
    this.onTap,
    this.prefixEmoji,
    this.prefixAsset,
    this.prefixTextStyle,
    this.prefixWidget,
    this.iconSize = 20.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    Widget content = Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg3,
      ),
      child: Row(
        children: [
          if (prefixWidget != null) ...[
            prefixWidget!,
            const SizedBox(width: AppSpacing.md),
          ] else if (prefixAsset != null) ...[
            SvgPicture.asset(
              prefixAsset!,
              width: iconSize,
              height: iconSize,
              colorFilter: iconColor != null
                  ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
          ] else if (prefixEmoji != null) ...[
            Text(
              prefixEmoji!,
              style: prefixTextStyle ?? const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Text(
              title,
              style: titleStyle ??
                  AppTextStyles.custom(
                    fontSize: AppFontSize.lg2,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          trailing,
        ],
      ),
    );


    if (onTap != null) {
      return BounceWrapper(onTap: onTap!, child: content);
    }

    return content;
  }
}
