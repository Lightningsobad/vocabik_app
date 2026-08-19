import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_hint_button.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class TypeAnswerInteractionArea extends StatefulWidget {
  const TypeAnswerInteractionArea({super.key});

  @override
  State<TypeAnswerInteractionArea> createState() =>
      _TypeAnswerInteractionAreaState();
}

class _TypeAnswerInteractionAreaState extends State<TypeAnswerInteractionArea> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String? _errorMessage;
  int? _lastBlankIndex;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    final text = _controller.text.trim();
    final l10n = AppLocalizations.of(context)!;

    if (text.isEmpty) {
      setState(() {
        _errorMessage = l10n.exercisePleaseEnterAnswer;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    _focusNode.unfocus();
    context.read<ExerciseCubit>().selectAnswer(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = colors.primaryAccent;

    return BlocConsumer<ExerciseCubit, ExerciseState>(
      listenWhen: (previous, current) {
        if (previous is ExerciseLoaded && current is ExerciseLoaded) {
          return previous.currentBlankIndex != current.currentBlankIndex;
        }
        return false;
      },
      listener: (context, state) {
        if (state is ExerciseLoaded) {
          _controller.clear();
          setState(() {
            _errorMessage = null;
          });
        }
      },
      builder: (context, state) {
        if (state is! ExerciseLoaded) return const SizedBox.shrink();

        final currentBlankIndex = state.currentBlankIndex;

        // Reset controller when blank changes
        if (_lastBlankIndex != currentBlankIndex) {
          _lastBlankIndex = currentBlankIndex;
          final existingAnswer = state.selectedAnswers[currentBlankIndex];
          if (existingAnswer != null) {
            _controller.text = existingAnswer;
          } else {
            _controller.clear();
          }
          _errorMessage = null;
        }

        final checkResult = state.checkResults[currentBlankIndex];
        final isChecked = checkResult != null;
        final isCorrect = checkResult == true;

        final currentBlank = state.exercise.blanks.firstWhere(
          (b) => b.blankIndex == currentBlankIndex,
          orElse: () => ExerciseBlankEntity(
            blankIndex: currentBlankIndex,
            correctAnswer: '',
          ),
        );
        final correctAnswer = currentBlank.correctAnswer;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text Field for input
              AppTextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                readOnly: isChecked,
                hintText: l10n.exerciseTypeAnswerHint,
                errorText: _errorMessage,
                textInputAction: TextInputAction.done,
                onChanged: (val) {
                  if (_errorMessage != null && val.trim().isNotEmpty) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
                onSubmitted: (_) {
                  _focusNode.unfocus();
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Before submit: Row with Hint Button and Check Button
              if (!isChecked) ...[
                Row(
                  children: [
                    const ExerciseHintButton(),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: BounceWrapper(
                        onTap: () => _handleSubmit(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              l10n.exerciseCheck,
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colors.onPrimaryAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // After submit: Result message + Continue button
              if (isChecked) ...[
                Text(
                  isCorrect
                      ? l10n.exerciseCorrect
                      : l10n.exerciseAlmostCorrect(correctAnswer),
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? colors.success : colors.danger,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
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
