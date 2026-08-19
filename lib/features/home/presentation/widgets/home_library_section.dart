import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
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
                return state.videos.length;
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
          buildWhen: (prev, curr) {
            if (prev is HomeVideosLoaded && curr is HomeVideosLoaded) {
              return prev.videos.length != curr.videos.length ||
                  prev.hasReachedMax != curr.hasReachedMax;
            }
            return prev.runtimeType != curr.runtimeType;
          },
          builder: (context, state) {
            final isLoading =
                state is HomeVideosInitial || state is HomeVideosLoading;
            final hasError = state is HomeVideosError;
            final videos = state is HomeVideosLoaded ? state.videos : [];
            final hasReachedMax =
                state is HomeVideosLoaded ? state.hasReachedMax : true;
            final isEmpty = videos.isEmpty && !isLoading && !hasError;

            // Loading Placeholder (Initial load)
            if (isLoading && videos.isEmpty) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: AppShimmer(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md2,
                        mainAxisSpacing: AppSpacing.md2,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                          color: colors.surfaceCard,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                      ),
                    ),
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
                          context
                              .read<HomeVideosBloc>()
                              .add(const FetchVideos());
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Center(
                    child: Text(
                      l10n.homeVideosEmpty,
                      style: TextStyle(color: colors.textSecondary),
                    ),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.md2,
                      mainAxisSpacing: AppSpacing.md2,
                      childAspectRatio: 0.9,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return SharedCourseCard(
                          video: videos[index],
                          width: double.infinity,
                        );
                      },
                      childCount: videos.length,
                    ),
                  ),
                ),
                if (state is HomeVideosLoaded && !hasReachedMax)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(child: CircularProgressIndicator()),
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
