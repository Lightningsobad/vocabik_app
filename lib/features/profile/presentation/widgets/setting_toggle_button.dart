import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class SettingToggleButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  final String? iconAsset;
  final String? prefixEmoji;
  final String? prefixText;
  final TextStyle? prefixTextStyle;
  final TextStyle? textStyle;
  final Widget? prefixWidget;
  final double iconSize;
  final Color? iconColor;

  const SettingToggleButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
    this.iconAsset,
    this.prefixEmoji,
    this.prefixText,
    this.prefixTextStyle,
    this.textStyle,
    this.prefixWidget,
    this.iconSize = AppSpacing.lg,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final primaryColor = colors.primaryAccent;
    final defaultTextColor = isActive ? primaryColor : colors.tabUnselectedText;

    final effectivePrefixStyle =
        (prefixTextStyle ??
                AppTextStyles.custom(
                  fontSize: AppFontSize.tn,
                  fontWeight: FontWeight.w900,
                ))
            .copyWith(color: prefixTextStyle?.color ?? defaultTextColor);

    final effectiveTextStyle =
        (textStyle ??
                AppTextStyles.custom(
                  fontSize: AppFontSize.mdt,
                  fontWeight: FontWeight.w700,
                ))
            .copyWith(color: textStyle?.color ?? defaultTextColor);

    return BounceWrapper(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg2,
          vertical: AppSpacing.sm2,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? primaryColor.withValues(alpha: 0.12)
              : colors.tabUnselectedBackground,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isActive ? primaryColor : colors.tabUnselectedBorder,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixWidget != null) ...[
              prefixWidget!,
              const SizedBox(width: AppSpacing.sm),
            ] else if (iconAsset != null) ...[
              SvgPicture.asset(
                iconAsset!,
                width: iconSize,
                height: iconSize,
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
              ),
              const SizedBox(width: AppSpacing.sm),
            ] else if (prefixEmoji != null) ...[
              Text(
                prefixEmoji!,
                style: prefixTextStyle ?? const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            if (prefixText != null) ...[
              Text(prefixText!, style: effectivePrefixStyle),
              const SizedBox(width: AppSpacing.tnn),
            ],
            Text(text, style: effectiveTextStyle),
          ],
        ),
      ),
    );
  }
}
