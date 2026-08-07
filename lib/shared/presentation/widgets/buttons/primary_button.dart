import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return BounceWrapper(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: (isLoading || onPressed == null)
              ? Theme.of(context).primaryColor.withValues(alpha: 0.6)
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.nunito(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary, // White text on primary button
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }
}
