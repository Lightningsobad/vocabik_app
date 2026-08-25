import 'package:flutter/material.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class ResultWrongAnswers extends StatelessWidget {
  final List<WrongAnswerDetail> wrongAnswers;

  const ResultWrongAnswers({super.key, required this.wrongAnswers});

  @override
  Widget build(BuildContext context) {
    if (wrongAnswers.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.resultWhatWentWrong,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.lg2,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...wrongAnswers.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSubtle, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blank ${item.blankStep}',
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.tn),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.lg,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      height: 1.4,
                    ),
                    children: [
                      if (item.beforeText.isNotEmpty)
                        TextSpan(text: '${item.beforeText} '),
                      TextSpan(
                        text: item.correctWord,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.lg,
                          fontWeight: FontWeight.w800,
                          color: colors.success,
                        ),
                      ),
                      if (item.afterText.isNotEmpty)
                        TextSpan(text: ' ${item.afterText}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
