import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/presentation/widgets/cards/course_tag_badge.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/entities/word_entity.dart';

class WordListCard extends StatelessWidget {
  final WordEntity word;

  const WordListCard({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final formattedDate = DateFormat('dd/MM/yyyy').format(word.savedAt);
    final sourceText = word.videoSourceTitle != null && word.videoSourceTitle!.isNotEmpty
        ? '${word.videoSourceTitle} • $formattedDate'
        : formattedDate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colors.borderSubtle,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Word + IPA + CEFR Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                word.word,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.xl,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              if (word.ipa.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    word.ipa,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.sm,
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else ...[
                const Spacer(),
              ],
              CourseTagBadge(
                text: word.cefrLevel,
                type: CourseTagType.level,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          // Row 2: Vietnamese Definition
          if (word.definitionVi.isNotEmpty) ...[
            Text(
              word.definitionVi,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],

          // Row 3: Example Sentence
          if (word.exampleSentence.isNotEmpty) ...[
            Text(
              '“${word.exampleSentence}”',
              style: AppTextStyles.custom(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Row 4: Source & Date
          Row(
            children: [
              Icon(
                Icons.movie_outlined,
                size: 14.0,
                color: colors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  sourceText,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.tnn,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
