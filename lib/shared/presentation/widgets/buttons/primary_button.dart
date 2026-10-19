import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

enum PrimaryButtonVariant { primary, secondary }

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? textColor;
  final Color? backgroundColor;
  final PrimaryButtonVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final BoxBorder? border;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.textColor,
    this.backgroundColor,
    this.variant = PrimaryButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.textStyle,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDisabled = isLoading || onPressed == null;

    final Color bgColor;
    final BoxBorder? defaultBorder;
    final Color defaultTextColor;

    if (variant == PrimaryButtonVariant.secondary) {
      bgColor = backgroundColor ?? Colors.transparent;
      defaultBorder = Border.all(
        color: isDisabled ? colors.borderSubtle.withValues(alpha: 0.5) : colors.borderSubtle,
        width: 1.5,
      );
      defaultTextColor = isDisabled ? colors.textSecondary : colors.textPrimary;
    } else {
      bgColor = isDisabled
          ? (backgroundColor ?? colors.primaryAccent).withValues(alpha: 0.6)
          : (backgroundColor ?? colors.primaryAccent);
      defaultBorder = null;
      defaultTextColor = colors.onPrimaryAccent;
    }

    final effectiveBorder = border ?? defaultBorder;

    final effectiveTextColor = textColor ?? defaultTextColor;
    final effectiveTextStyle = (textStyle ??
            GoogleFonts.nunito(
              fontSize: 18.0,
              fontWeight: FontWeight.w900,
            ))
        .copyWith(
      color: textStyle?.color ?? effectiveTextColor,
    );

    return BounceWrapper(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.md2),
        decoration: BoxDecoration(
          color: bgColor,
          border: effectiveBorder,
          borderRadius: BorderRadius.circular(999.0), // Bo góc dạng viên thuốc (Pill shape)
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: effectiveTextColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: effectiveTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    trailingIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
