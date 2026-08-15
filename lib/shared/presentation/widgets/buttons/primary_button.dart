import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BounceWrapper(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: (isLoading || onPressed == null)
              ? colors.primaryAccent.withValues(alpha: 0.6)
              : colors.primaryAccent,
          borderRadius: BorderRadius.circular(999.0), // Bo góc dạng viên thuốc (Pill shape)
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: textColor ?? colors.onPrimaryAccent,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.nunito(
                  color: textColor ?? colors.onPrimaryAccent,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }
}
