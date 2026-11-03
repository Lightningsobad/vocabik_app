import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ExerciseAnswerFeedback extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;

  const ExerciseAnswerFeedback({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
  });

  static String getRandomCorrectMessage(AppLocalizations l10n) {
    final messages = [
      l10n.exerciseCorrect,
      l10n.exerciseCorrectAwesome,
      l10n.exerciseCorrectSpotOn,
    ];
    return messages[Random().nextInt(messages.length)];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    if (isCorrect) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            getRandomCorrectMessage(l10n),
            style: AppTextStyles.custom(
              fontSize: AppFontSize.lg,
              fontWeight: FontWeight.w800,
              color: colors.success,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 6),
          SvgPicture.asset(
            'assets/exercise_screen/congratulation_icon.svg',
            width: 22,
            height: 22,
          ),
        ],
      );
    } else {
      return Text(
        l10n.exerciseAlmostCorrect(correctAnswer),
        style: AppTextStyles.custom(
          fontSize: AppFontSize.lg,
          fontWeight: FontWeight.w800,
          color: colors.danger,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}
