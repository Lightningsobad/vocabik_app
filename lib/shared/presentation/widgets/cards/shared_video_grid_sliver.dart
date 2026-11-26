import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card_skeleton.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_empty_state.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

/// Reusable 2-column video grid sliver with initial shimmer skeletons,
/// localized error state, empty state, and inline load-more skeleton/retry.
class SharedVideoGridSliver extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final List<VideoEntity> videos;
  final bool isLoadingMore;
  final String? loadMoreError;
  final String emptyText;
  final VoidCallback onRetry;
  final VoidCallback onLoadMoreRetry;

  const SharedVideoGridSliver({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.videos,
    required this.isLoadingMore,
    required this.loadMoreError,
    required this.emptyText,
    required this.onRetry,
    required this.onLoadMoreRetry,
  });

  static const SliverGridDelegate _gridDelegate =
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: AppSpacing.md2,
    mainAxisSpacing: AppSpacing.md2,
    childAspectRatio: 0.85,
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    if (isLoading && videos.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        sliver: SliverGrid(
          gridDelegate: _gridDelegate,
          delegate: SliverChildBuilderDelegate(
            (context, index) => const SharedCourseCardSkeleton(),
            childCount: 4,
          ),
        ),
      );
    }

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
                onPressed: onRetry,
                child: Text(l10n.homeRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (videos.isEmpty) {
      return SliverToBoxAdapter(
        child: SharedEmptyState(
          message: emptyText,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverGrid(
            gridDelegate: _gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= videos.length) {
                  return const SharedCourseCardSkeleton();
                }
                final video = videos[index];
                return SharedCourseCard(
                  key: ValueKey(video.id),
                  video: video,
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
                    onPressed: onLoadMoreRetry,
                    child: Text(l10n.homeRetry),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
