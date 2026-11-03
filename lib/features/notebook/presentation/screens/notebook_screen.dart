import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../cubit/notebook_cubit.dart';
import '../cubit/notebook_state.dart';
import '../widgets/flashcard_study_view.dart';
import '../widgets/notebook_search_bar.dart';
import '../widgets/notebook_segmented_tab.dart';
import '../widgets/word_list_card.dart';

class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<NotebookCubit>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<NotebookCubit, NotebookState>(
          builder: (context, state) {
            final wordsCount = state.totalCount > 0
                ? state.totalCount
                : state.words.length;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Notebook + count
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        l10n.notebookTitle,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.xl5_5,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm2),
                      Text(
                        l10n.wordsCount(wordsCount),
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.md,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Search Bar
                  NotebookSearchBar(
                    initialValue: state.searchQuery,
                    onChanged: (query) => cubit.searchWords(query),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Segmented Tabs: List / Flashcard
                  NotebookSegmentedTab(
                    currentMode: state.viewMode,
                    onModeChanged: (mode) => cubit.changeViewMode(mode),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Content Area
                  Expanded(
                    child: _buildBody(context, state, cubit, colors, l10n),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotebookState state,
    NotebookCubit cubit,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    if (state.status == NotebookStatus.loading && state.words.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == NotebookStatus.error && state.words.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48.0,
                color: colors.danger,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                state.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              BounceWrapper(
                onTap: cubit.fetchWords,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryAccent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Retry',
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w700,
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

    if (state.viewMode == NotebookViewMode.flashcard) {
      return FlashcardStudyView(state: state, cubit: cubit);
    }

    // List mode
    final displayList = state.searchQuery.isNotEmpty
        ? state.filteredWords
        : state.words;

    if (displayList.isEmpty) {
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

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      // Add bottom padding so cards are not covered by bottom nav bar
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: 88.0 + MediaQuery.paddingOf(context).bottom,
      ),
      itemCount: displayList.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final word = displayList[index];
        return WordListCard(word: word);
      },
    );
  }
}
