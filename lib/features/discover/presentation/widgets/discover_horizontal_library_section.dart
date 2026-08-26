import 'package:flutter/material.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_empty_state.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class DiscoverHorizontalLibrarySection extends StatefulWidget {
  final String title;
  final bool isLoading;
  final List<VideoEntity> videos;
  final bool hasReachedMax;
  final String emptyText;
  final VoidCallback onLoadMore;

  const DiscoverHorizontalLibrarySection({
    super.key,
    required this.title,
    required this.isLoading,
    required this.videos,
    required this.hasReachedMax,
    required this.emptyText,
    required this.onLoadMore,
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
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll - 200 &&
        !widget.hasReachedMax &&
        !widget.isLoading) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

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
          if (widget.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SizedBox(
                height: 267,
                child: AppShimmer(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: AppSpacing.lg),
                    itemBuilder: (context, index) => Container(
                      width: 282,
                      decoration: BoxDecoration(
                        color: colors.surfaceCard,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                  ),
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
                  itemCount:
                      widget.videos.length + (widget.hasReachedMax ? 0 : 1),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    if (index >= widget.videos.length) {
                      return Container(
                        width: 80,
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
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
