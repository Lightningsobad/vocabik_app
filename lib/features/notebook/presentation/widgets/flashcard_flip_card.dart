import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/cards/course_tag_badge.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/entities/word_entity.dart';

class FlashcardFlipCard extends StatelessWidget {
  final WordEntity word;
  final bool isFlipped;
  final VoidCallback onFlip;

  const FlashcardFlipCard({
    super.key,
    required this.word,
    required this.isFlipped,
    required this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return BounceWrapper(
      onTap: onFlip,
      scaleFactor: 0.98,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(begin: 0.0, end: isFlipped ? 1.0 : 0.0),
        builder: (context, value, child) {
          final isBack = value >= 0.5;
          final angle = value * pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 280.0),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: colors.borderSubtle,
                  width: 1.5,
                ),
              ),
              child: isBack
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: _buildBackContent(context, colors, l10n),
                    )
                  : _buildFrontContent(context, colors, l10n),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontContent(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          word.word,
          textAlign: TextAlign.center,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.xl6,
            fontWeight: FontWeight.w900,
            color: colors.textPrimary,
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.tapToFlip,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.replay_rounded,
              size: 16.0,
              color: colors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackContent(
    BuildContext context,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              word.word,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.lg,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            if (word.ipa.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                word.ipa,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
            ],
            const SizedBox(width: AppSpacing.sm),
            CourseTagBadge(
              text: word.cefrLevel,
              type: CourseTagType.level,
            ),
          ],
        ),
        const Spacer(),
        if (word.definitionVi.isNotEmpty) ...[
          Text(
            word.definitionVi,
            textAlign: TextAlign.center,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.xl,
              fontWeight: FontWeight.w800,
              color: colors.primaryAccent,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (word.exampleSentence.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              '“${word.exampleSentence}”',
              textAlign: TextAlign.center,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.tapToFlip,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.replay_rounded,
              size: 16.0,
              color: colors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }
}
