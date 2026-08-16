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
  final PrimaryButtonVariant variant;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.textColor,
    this.variant = PrimaryButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDisabled = isLoading || onPressed == null;

    final Color bgColor;
    final Border? border;
    final Color defaultTextColor;

    if (variant == PrimaryButtonVariant.secondary) {
      bgColor = Colors.transparent;
      border = Border.all(
        color: isDisabled ? colors.borderSubtle.withValues(alpha: 0.5) : colors.borderSubtle,
        width: 1.5,
      );
      defaultTextColor = isDisabled ? colors.textSecondary : colors.textPrimary;
    } else {
      bgColor = isDisabled
          ? colors.primaryAccent.withValues(alpha: 0.6)
          : colors.primaryAccent;
      border = null;
      defaultTextColor = colors.onPrimaryAccent;
    }

    final effectiveTextColor = textColor ?? defaultTextColor;

    return BounceWrapper(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md2),
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
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
            : Text(
                text,
                style: GoogleFonts.nunito(
                  color: effectiveTextColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }
}
