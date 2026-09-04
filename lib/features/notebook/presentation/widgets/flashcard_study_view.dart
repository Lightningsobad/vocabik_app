import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../cubit/notebook_cubit.dart';
import '../cubit/notebook_state.dart';
import 'flashcard_action_buttons.dart';
import 'flashcard_flip_card.dart';

class FlashcardStudyView extends StatelessWidget {
  final NotebookState state;
  final NotebookCubit cubit;

  const FlashcardStudyView({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    if (state.totalFlashcards == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            state.searchQuery.isNotEmpty
                ? l10n.noSearchResults
                : l10n.emptyNotebook,
            textAlign: TextAlign.center,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.md,
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (state.isFlashcardFinished) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 48.0),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.reviewFinishedTitle,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.xl,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.reviewFinishedDesc,
                textAlign: TextAlign.center,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              BounceWrapper(
                onTap: cubit.restartFlashcards,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryAccent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    l10n.reviewAgain,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w800,
                      color: colors.onPrimaryAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentWord = state.currentFlashcard;
    if (currentWord == null) return const SizedBox.shrink();

    final currentIndexDisplay = state.currentFlashcardIndex + 1;
    final totalDisplay = state.totalFlashcards;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          // Progress text: 3 / 247
          Text(
            '$currentIndexDisplay / $totalDisplay',
            style: AppTextStyles.custom(
              fontSize: AppFontSize.md,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 3D Flip Card
          FlashcardFlipCard(
            key: ValueKey(currentWord.id),
            word: currentWord,
            isFlipped: state.isCardFlipped,
            onFlip: cubit.flipCard,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Action Buttons
          FlashcardActionButtons(
            isLoading: state.isUpdatingStatus,
            onReviewAgain: () => cubit.answerFlashcard(true),
            onGotIt: () => cubit.answerFlashcard(false),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
