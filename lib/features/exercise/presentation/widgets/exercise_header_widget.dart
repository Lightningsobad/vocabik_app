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
  final VoidCallback? onReport;
  final bool isLandscape;

  const ExerciseHeaderWidget({
    super.key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
    this.onClose,
    this.onReport,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: isLandscape ? 6 : AppSpacing.md2,
      ),
      child: Row(
        children: [
          // Progress Bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: isLandscape ? 4 : 6,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primaryAccent),
                backgroundColor: colors.tabUnselectedBackground,
              ),
            ),
          ),
          SizedBox(width: isLandscape ? AppSpacing.sm : AppSpacing.md2),
          // Fraction Text
          Text(
            '$currentStep/$totalSteps',
            style: AppTextStyles.custom(
              color: colors.textSecondary,
              fontSize: isLandscape ? AppFontSize.sm : AppFontSize.md,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: isLandscape ? AppSpacing.sm : AppSpacing.md2),
          // Optional Report Button
          if (onReport != null) ...[
            GestureDetector(
              onTap: onReport,
              child: Container(
                padding: EdgeInsets.all(isLandscape ? 5 : 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.tabUnselectedBackground,
                ),
                child: Icon(
                  Icons.flag_outlined,
                  size: isLandscape ? 18 : 22,
                  color: colors.textSecondary,
                ),
              ),
            ),
            SizedBox(width: isLandscape ? AppSpacing.sm : AppSpacing.md2),
          ],
          // Close Button
          GestureDetector(
            onTap: onClose ?? () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(isLandscape ? 5 : 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.tabUnselectedBackground,
              ),
              child: Icon(
                Icons.close_rounded,
                size: isLandscape ? 18 : 22,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
