import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_answer_feedback.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_hint_button.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/inputs/app_text_field.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

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
          final existingAnswer = state.selectedAnswers[state.currentBlankIndex];
          _controller.text = existingAnswer ?? '';
          setState(() {
            _errorMessage = null;
          });
        }
      },
      builder: (context, state) {
        if (state is! ExerciseLoaded) return const SizedBox.shrink();

        final currentBlankIndex = state.currentBlankIndex;
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

        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? AppSpacing.sm : AppSpacing.md,
            vertical: isLandscape ? 2 : AppSpacing.sm,
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
                  _handleSubmit(context);
                },
              ),

              SizedBox(height: isLandscape ? AppSpacing.sm : AppSpacing.lg),

              // Before submit: Row with Hint Button and Check Button
              if (!isChecked) ...[
                Row(
                  children: [
                    const ExerciseHintButton(),
                    SizedBox(width: isLandscape ? AppSpacing.sm : AppSpacing.md),
                    Expanded(
                      child: BounceWrapper(
                        onTap: () => _handleSubmit(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: isLandscape ? 10 : 14,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              l10n.exerciseCheck,
                              style: AppTextStyles.custom(
                                fontSize: isLandscape
                                    ? AppFontSize.md
                                    : AppFontSize.lg,
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
                ExerciseAnswerFeedback(
                  isCorrect: isCorrect,
                  correctAnswer: correctAnswer,
                ),
                SizedBox(height: isLandscape ? AppSpacing.sm : AppSpacing.md),
                PrimaryButton(
                  text: l10n.exerciseContinue,
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
