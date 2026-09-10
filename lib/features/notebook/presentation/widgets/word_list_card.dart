import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import '../../../../shared/presentation/widgets/cards/course_tag_badge.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../domain/entities/word_entity.dart';

class WordListCard extends StatelessWidget {
  final WordEntity word;

  const WordListCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final formattedDate = DateFormat('dd/MM/yyyy').format(word.savedAt);
    final hasVideoTitle =
        word.videoSourceTitle != null &&
        word.videoSourceTitle!.trim().isNotEmpty;
    final sourceText = hasVideoTitle
        ? '${word.videoSourceTitle!.trim()} · $formattedDate'
        : formattedDate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.borderSubtle, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Word + IPA + CEFR Badge inline
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              Text(
                word.word,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.xl,
                  fontWeight: FontWeight.w900,
                  color: colors.textPrimary,
                ),
              ),
              if (word.ipa.isNotEmpty)
                Text(
                  word.ipa,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.lg,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (word.cefrLevel.isNotEmpty)
                CourseTagBadge(text: word.cefrLevel, type: CourseTagType.level),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Row 2: Vietnamese Definition
          if (word.definitionVi.isNotEmpty) ...[
            Text(
              word.definitionVi,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm2),
          ],

          // Row 3: Example Sentence
          if (word.exampleSentence.isNotEmpty) ...[
            Text(
              '“${word.exampleSentence}”',
              style: AppTextStyles.custom(
                fontSize: AppFontSize.mdt,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Row 4: Source (Song/Video Title) & Date
          Row(
            children: [
              SvgPicture.asset(
                'assets/notebook_screen/video_icon.svg',
                width: 14.0,
                height: 14.0,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  sourceText,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.sm,
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
