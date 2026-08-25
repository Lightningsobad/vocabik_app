import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/enums/exercise_type.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ResultActionButtons extends StatelessWidget {
  final ExerciseEntity exercise;
  final String youtubeVideoId;
  final String videoTitle;
  final String exerciseType;
  final VoidCallback? onPracticeAgain;

  const ResultActionButtons({
    super.key,
    required this.exercise,
    this.youtubeVideoId = '',
    this.videoTitle = '',
    this.exerciseType = 'Multiple choice',
    this.onPracticeAgain,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Next suggested exercise button
        PrimaryButton(
          text: l10n.resultNextSuggestedExercise,
          variant: PrimaryButtonVariant.secondary,
          backgroundColor: colors.surfaceCard,
          textStyle: AppTextStyles.custom(
            fontSize: AppFontSize.lg,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
          onPressed: () {
            context.go('/home');
          },
        ),
        const SizedBox(height: AppSpacing.sm),

        // Practice again button
        PrimaryButton(
          text: l10n.resultPracticeAgain,
          variant: PrimaryButtonVariant.secondary,
          backgroundColor: colors.surfaceCard,
          textStyle: AppTextStyles.custom(
            fontSize: AppFontSize.lg,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
          onPressed: () {
            if (onPracticeAgain != null) {
              onPracticeAgain!();
            } else {
              context.pushReplacementToExercise(
                videoId: exercise.videoId,
                cefrLevel: exercise.cefrLevel,
                versionId: exercise.versionId,
                youtubeVideoId: youtubeVideoId,
                videoTitle: videoTitle,
                exerciseType: ExerciseType.fromString(exerciseType),
              );
            }
          },
        ),
        const SizedBox(height: AppSpacing.tn),

        // Back to library text button
        TextButton(
          onPressed: () {
            context.go('/home');
          },
          child: Text(
            l10n.resultBackToLibrary,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.mdt,
              fontWeight: FontWeight.bold,
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
