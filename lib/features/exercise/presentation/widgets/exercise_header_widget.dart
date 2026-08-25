import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md2,
      ),
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
          const SizedBox(width: AppSpacing.md2),
          // Fraction Text
          Text(
            '$currentStep/$totalSteps',
            style: AppTextStyles.custom(
              color: colors.textSecondary,
              fontSize: AppFontSize.md,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.md2),
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
                size: 22,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
