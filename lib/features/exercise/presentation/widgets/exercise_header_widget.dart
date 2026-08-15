import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class ExerciseHeaderWidget extends StatelessWidget {
  final double progress;
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onClose;

  const ExerciseHeaderWidget({
    super.key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Progress Bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primaryAccent),
                backgroundColor: colors.tabUnselectedBackground,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Fraction Text
          Text(
            '$currentStep/$totalSteps',
            style: GoogleFonts.nunito(
              color: colors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 14),
          // Close Button
          GestureDetector(
            onTap: onClose ?? () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.tabUnselectedBackground,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
