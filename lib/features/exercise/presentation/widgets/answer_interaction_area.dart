import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class AnswerInteractionArea extends StatelessWidget {
  const AnswerInteractionArea({super.key});

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
          orElse: () => ExerciseBlankEntity(blankIndex: currentBlankIndex, correctAnswer: ''),
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
                      final isOptionCorrect = checkResult != null &&
                          option.toLowerCase().trim() == correctAnswer.toLowerCase().trim();
                      final hasChecked = checkResult != null;
                      
                      Color bgColor;
                      Color borderColor;
                      Color textColor;
                      
                      if (!hasChecked) {
                        if (isSelected) {
                          bgColor = primaryColor.withValues(alpha: 0.2);
                          borderColor = primaryColor;
                          textColor = primaryColor;
                        } else {
                          bgColor = colors.optionCardBackground;
                          borderColor = colors.optionCardBorder;
                          textColor = colors.textPrimary;
                        }
                      } else {
                        if (isOptionCorrect) {
                          bgColor = colors.successBackground;
                          borderColor = colors.successBorder;
                          textColor = colors.success;
                        } else if (isSelected) {
                          bgColor = colors.danger.withValues(alpha: 0.25);
                          borderColor = colors.danger;
                          textColor = colors.danger;
                        } else {
                          bgColor = colors.optionCardBackground;
                          borderColor = colors.optionCardBorder;
                          textColor = colors.textSecondary;
                        }
                      }

                      return SizedBox(
                        width: itemWidth,
                        child: BounceWrapper(
                          onTap: () {
                            if (!hasChecked) {
                              context.read<ExerciseCubit>().selectAnswer(option);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor,
                              border: Border.all(
                                color: borderColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Center(
                              child: Text(
                                option,
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
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

              const SizedBox(height: 16),

              // Bottom Area: Hint Button (Before Answer) or Result & Continue Button (After Answer)
              if (checkResult == null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                    opacity: state.hintUsedForCurrentBlank ? 0.4 : 1.0,
                    child: BounceWrapper(
                      onTap: state.hintUsedForCurrentBlank
                          ? null
                          : () {
                              context.read<ExerciseCubit>().useHint();
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colors.optionCardBackground,
                          border: Border.all(
                            color: colors.optionCardBorder,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('💡 ', style: TextStyle(fontSize: 14)),
                            Text(
                              'Gợi ý',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFBBF24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              if (checkResult != null) ...[
                Text(
                  isCorrect 
                      ? 'Chính xác! 🎉' 
                      : 'Gần đúng — đáp án là "$correctAnswer".',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCorrect
                        ? colors.success
                        : colors.danger,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                BounceWrapper(
                  onTap: () {
                    context.read<ExerciseCubit>().nextBlank();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: Text(
                        l10n.exerciseContinue,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.onPrimaryAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
