import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_answer_feedback.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import 'exercise_hint_button.dart';

class AnswerInteractionArea extends StatelessWidget {
  const AnswerInteractionArea({super.key});

  ({Color bgColor, Color borderColor, Color textColor}) _resolveOptionColors({
    required bool hasChecked,
    required bool isSelected,
    required bool isOptionCorrect,
    required AppColorsExtension colors,
    required Color primaryColor,
  }) {
    if (!hasChecked) {
      if (isSelected) {
        return (
          bgColor: primaryColor.withValues(alpha: 0.2),
          borderColor: primaryColor,
          textColor: primaryColor,
        );
      } else {
        return (
          bgColor: colors.tabUnselectedBackground,
          borderColor: colors.optionCardBorder,
          textColor: colors.textPrimary,
        );
      }
    } else {
      if (isOptionCorrect) {
        return (
          bgColor: colors.successBackground,
          borderColor: colors.successBorder,
          textColor: colors.success,
        );
      } else if (isSelected) {
        return (
          bgColor: colors.danger.withValues(alpha: 0.25),
          borderColor: colors.danger,
          textColor: colors.danger,
        );
      } else {
        return (
          bgColor: colors.optionCardBackground,
          borderColor: colors.optionCardBorder,
          textColor: colors.textSecondary,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = colors.primaryAccent;

    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        if (state is! ExerciseLoaded) return const SizedBox.shrink();

        final currentBlankIndex = state.currentBlankIndex;
        final selectedAnswer = state.selectedAnswers[currentBlankIndex];
        final checkResult = state.checkResults[currentBlankIndex];

        final isCorrect = checkResult == true;

        final currentBlank = state.exercise.blanks.firstWhere(
          (b) => b.blankIndex == currentBlankIndex,
          orElse: () => ExerciseBlankEntity(
            blankIndex: currentBlankIndex,
            correctAnswer: '',
          ),
        );
        final correctAnswer = currentBlank.correctAnswer;

        // Get options for current blank
        final options =
            state.exercise.answerOptions[currentBlankIndex.toString()] ?? [];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Options Grid (2x2)
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: options.map((option) {
                      final isSelected = selectedAnswer == option;
                      final isOptionCorrect =
                          checkResult != null &&
                          option.toLowerCase().trim() ==
                              correctAnswer.toLowerCase().trim();
                      final hasChecked = checkResult != null;

                      final optionColors = _resolveOptionColors(
                        hasChecked: hasChecked,
                        isSelected: isSelected,
                        isOptionCorrect: isOptionCorrect,
                        colors: colors,
                        primaryColor: primaryColor,
                      );

                      return SizedBox(
                        width: itemWidth,
                        child: BounceWrapper(
                          onTap: () {
                            if (!hasChecked) {
                              context.read<ExerciseCubit>().selectAnswer(
                                option,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: optionColors.bgColor,
                              border: Border.all(
                                color: optionColors.borderColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.xl2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                option,
                                style: AppTextStyles.custom(
                                  fontSize: AppFontSize.lg2,
                                  fontWeight: FontWeight.w700,
                                  color: optionColors.textColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              // Bottom Area: Hint Button (Before Answer) or Result & Continue Button (After Answer)
              if (checkResult == null)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: ExerciseHintButton(),
                ),

              if (checkResult != null) ...[
                ExerciseAnswerFeedback(
                  isCorrect: isCorrect,
                  correctAnswer: correctAnswer,
                ),
                const SizedBox(height: AppSpacing.lg3),
                PrimaryButton(
                  text: l10n.exerciseContinue,
                  textStyle: AppTextStyles.custom(
                    fontSize: AppFontSize.lg2,
                    fontWeight: FontWeight.w700,
                  ),
                  onPressed: () {
                    context.read<ExerciseCubit>().nextBlank();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

