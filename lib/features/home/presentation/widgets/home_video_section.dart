import 'package:flutter/material.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_empty_state.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class HomeVideoSection extends StatelessWidget {
  final String title;
  final String iconAsset;
  final bool isIconTrailing;
  final String? actionText;
  final VoidCallback? onActionTap;
  final bool isLoading;
  final List<VideoEntity> videos;
  final String emptyText;

  const HomeVideoSection({
    super.key,
    required this.title,
    required this.iconAsset,
    this.isIconTrailing = true,
    this.actionText,
    this.onActionTap,
    required this.isLoading,
    required this.videos,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            title: title,
            iconAsset: iconAsset,
            isIconTrailing: isIconTrailing,
            actionText: actionText,
            onActionTap: onActionTap,
            size: SectionHeaderSize.medium,
          ),
          if (isLoading)
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
          else if (videos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SizedBox(
                height: 263,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    return SharedCourseCard(video: videos[index], width: 282);
                  },
                ),
              ),
            )
          else
            SharedEmptyState(
              message: emptyText,
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
