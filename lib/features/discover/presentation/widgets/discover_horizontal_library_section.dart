import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/utils/scroll_pagination_extension.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card_skeleton.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_empty_state.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class DiscoverHorizontalLibrarySection extends StatefulWidget {
  final String title;
  final bool isLoading;
  final bool isLoadingMore;
  final String? loadMoreError;
  final bool hasError;
  final List<VideoEntity> videos;
  final bool hasReachedMax;
  final String emptyText;
  final VoidCallback onLoadMore;
  final VoidCallback? onRetry;

  const DiscoverHorizontalLibrarySection({
    super.key,
    required this.title,
    required this.isLoading,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.hasError = false,
    required this.videos,
    required this.hasReachedMax,
    required this.emptyText,
    required this.onLoadMore,
    this.onRetry,
  });

  @override
  State<DiscoverHorizontalLibrarySection> createState() =>
      _DiscoverHorizontalLibrarySectionState();
}

class _DiscoverHorizontalLibrarySectionState
    extends State<DiscoverHorizontalLibrarySection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.isNearPrefetchThreshold &&
        !widget.hasReachedMax &&
        !widget.isLoading &&
        !widget.isLoadingMore &&
        widget.loadMoreError == null) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final trailingCount =
        widget.isLoadingMore ? 2 : (widget.loadMoreError != null ? 1 : 0);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            title: widget.title,
            size: SectionHeaderSize.medium,
            isLoading: widget.isLoading,
          ),
          if (widget.isLoading && widget.videos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SizedBox(
                height: 263,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) =>
                      const SharedCourseCardSkeleton(width: 282),
                ),
              ),
            )
          else if (widget.hasError && widget.videos.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
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
                      onPressed: widget.onRetry ?? widget.onLoadMore,
                      child: Text(l10n.homeRetry),
                    ),
                  ],
                ),
              ),
            )
          else if (widget.videos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SizedBox(
                height: 263,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  scrollCacheExtent: const ScrollCacheExtent.pixels(600),
                  itemCount: widget.videos.length + trailingCount,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    if (index >= widget.videos.length) {
                      if (widget.isLoadingMore) {
                        return const SharedCourseCardSkeleton(width: 282);
                      }
                      return Container(
                        width: 200,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.surfaceCard,
                          borderRadius: BorderRadius.circular(AppRadius.lg2),
                          border: Border.all(color: colors.borderSubtle),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 24,
                              color: colors.textSecondary,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              l10n.homeVideosError,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            TextButton(
                              onPressed: widget.onLoadMore,
                              child: Text(l10n.homeRetry),
                            ),
                          ],
                        ),
                      );
                    }
                    return SharedCourseCard(
                      video: widget.videos[index],
                      width: 282,
                    );
                  },
                ),
              ),
            )
          else
            SharedEmptyState(
              message: widget.emptyText,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
        ],
      ),
    );
  }
}
