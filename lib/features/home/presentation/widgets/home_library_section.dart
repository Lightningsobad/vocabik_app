import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card_skeleton.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_empty_state.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class HomeLibrarySection extends StatelessWidget {
  const HomeLibrarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return SliverMainAxisGroup(
      slivers: [
        // 1. Header (isolated rebuild via BlocSelector for video count)
        SliverToBoxAdapter(
          child: BlocSelector<HomeVideosBloc, HomeVideosState, int>(
            selector: (state) {
              if (state is HomeVideosLoaded) {
                return state.totalItems;
              }
              return 0;
            },
            builder: (context, count) {
              return SectionHeader(
                title: l10n.homeLibrary,
                actionText: count > 0 ? '$count videos' : null,
                actionTextColor: colors.textSecondary,
                size: SectionHeaderSize.medium,
              );
            },
          ),
        ),

        // 2. Content (Loading / Error / Empty / Grid)
        BlocBuilder<HomeVideosBloc, HomeVideosState>(
          builder: (context, state) {
            final isLoading =
                state is HomeVideosInitial || state is HomeVideosLoading;
            final hasError = state is HomeVideosError;
            final videos = state is HomeVideosLoaded
                ? state.videos
                : const <VideoEntity>[];
            final isLoadingMore =
                state is HomeVideosLoaded && state.isLoadingMore;
            final loadMoreError =
                state is HomeVideosLoaded ? state.loadMoreError : null;
            final isEmpty = videos.isEmpty && !isLoading && !hasError;

            const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md2,
              mainAxisSpacing: AppSpacing.md2,
              childAspectRatio: 0.85,
            );

            // Loading Placeholder (Initial load)
            if (isLoading && videos.isEmpty) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverGrid(
                  gridDelegate: gridDelegate,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const SharedCourseCardSkeleton(),
                    childCount: 4,
                  ),
                ),
              );
            }

            // Error state (localized to library)
            if (hasError && videos.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.homeVideosError,
                        style: TextStyle(color: colors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeVideosBloc>().add(
                            const FetchVideos(),
                          );
                        },
                        child: Text(l10n.homeRetry),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Empty state
            if (isEmpty) {
              return SliverToBoxAdapter(
                child: SharedEmptyState(
                  message: l10n.emptyVideos,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              );
            }

            // Loaded list
            return SliverMainAxisGroup(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: gridDelegate,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= videos.length) {
                          return const SharedCourseCardSkeleton();
                        }
                        return SharedCourseCard(
                          video: videos[index],
                          width: double.infinity,
                        );
                      },
                      childCount: videos.length + (isLoadingMore ? 2 : 0),
                    ),
                  ),
                ),
                if (loadMoreError != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 18,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              l10n.homeVideosError,
                              style: TextStyle(color: colors.textSecondary),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          TextButton(
                            onPressed: () {
                              context.read<HomeVideosBloc>().add(
                                const FetchVideos(),
                              );
                            },
                            child: Text(l10n.homeRetry),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
