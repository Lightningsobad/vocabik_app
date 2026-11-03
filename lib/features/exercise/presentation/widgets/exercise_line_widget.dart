import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ExerciseLineWidget extends StatelessWidget {
  final ExerciseLineEntity line;

  const ExerciseLineWidget({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLandscape ? AppSpacing.sm : AppSpacing.md,
      ),
      child: Wrap(
        spacing: 4.0,
        runSpacing: isLandscape ? 2.0 : 4.0,
        alignment: WrapAlignment.center, // Center the text horizontally
        crossAxisAlignment: WrapCrossAlignment.center,
        children: line.tokens.map((token) {
          if (token.isBlank && token.blankIndex != null) {
            return BlankTokenWidget(
              blankIndex: token.blankIndex!,
              originalText: token.text ?? '',
            );
          }
          return Text(
            token.text ?? '',
            style: AppTextStyles.custom(
              fontSize: isLandscape ? AppFontSize.lg : AppFontSize.xl,
              color: Theme.of(
                context,
              ).extension<AppColorsExtension>()!.textPrimary,
              height: 1.4,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BlankTokenWidget extends StatelessWidget {
  final int blankIndex;
  final String originalText;

  const BlankTokenWidget({
    super.key,
    required this.blankIndex,
    required this.originalText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExerciseCubit, ExerciseState, ExerciseLoaded?>(
      selector: (state) {
        if (state is ExerciseLoaded) {
          return state;
        }
        return null;
      },
      builder: (context, state) {
        if (state == null) return const SizedBox.shrink();

        final colors = Theme.of(context).extension<AppColorsExtension>()!;
        final primaryColor = colors.primaryAccent;

        final isCurrent = state.currentBlankIndex == blankIndex;
        final selectedAnswer = state.selectedAnswers[blankIndex];
        final checkResult = state.checkResults[blankIndex];

        final isCorrect = checkResult == true;
        final isIncorrect = checkResult == false;

        final blank = state.exercise.blanks.firstWhere(
          (b) => b.blankIndex == blankIndex,
          orElse: () =>
              ExerciseBlankEntity(blankIndex: blankIndex, correctAnswer: ''),
        );
        final correctAnswer = blank.correctAnswer;

        String displayText = '________';
        Color textColor = colors.textSecondary;
        Color borderColor = colors.borderSubtle;
        Color backgroundColor = Colors.transparent;

        if (selectedAnswer != null) {
          displayText = selectedAnswer;
          textColor = colors.textPrimary;
          if (isCurrent) {
            borderColor = primaryColor;
          }
        }

        if (isCurrent && selectedAnswer == null) {
          borderColor = primaryColor;
          textColor = primaryColor;
        }

        if (isCorrect) {
          displayText = correctAnswer.isNotEmpty
              ? correctAnswer
              : (selectedAnswer ?? '________');
          textColor = colors.success;
          borderColor = colors.successBorder;
          backgroundColor = colors.successBackground;
        } else if (isIncorrect) {
          displayText = correctAnswer.isNotEmpty
              ? correctAnswer
              : (selectedAnswer ?? '________');
          textColor = colors.danger;
          borderColor = colors.danger;
          backgroundColor = colors.dangerSoft;
        }

        // If hint is used for current blank
        if (isCurrent &&
            state.hintUsedForCurrentBlank &&
            selectedAnswer == null) {
          if (correctAnswer.isNotEmpty) {
            displayText = '${correctAnswer[0]}_______';
          }
        }

        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        return GestureDetector(
          onTap: () {
            if (!isCorrect && state.currentBlankIndex != blankIndex) {
              // Optionally allow skipping around
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? 12 : 16,
              vertical: isLandscape ? 2 : 4,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Text(
              displayText,
              style: AppTextStyles.custom(
                fontSize: isLandscape ? AppFontSize.lg : AppFontSize.xl,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
