import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/utils/number_format_utils.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import 'course_tag_badge.dart';

class SharedCourseCard extends StatelessWidget {
  final VideoEntity video;
  final bool isLoading;
  final double width;

  const SharedCourseCard({
    super.key,
    required this.video,
    this.isLoading = false,
    this.width = AppSpacing.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      );
    }

    return BounceWrapper(
      onTap: () {
        final location = GoRouterState.of(context).matchedLocation;
        final prefix = location.startsWith('/discover') ? '/discover' : '/home';
        context.push('$prefix/video/${video.id}');
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg2),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.lg2),
                    topRight: Radius.circular(AppRadius.lg2),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.lg),
                        topRight: Radius.circular(AppRadius.lg),
                      ),
                      child: SizedBox.expand(
                        child: Transform.scale(
                          scale: 1.34,
                          child: Image.network(
                            video.thumbnailUrl,
                            fit: BoxFit.cover,
                            cacheWidth: 500,
                            cacheHeight: 310,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: colors.surfaceCard,
                                  child: Icon(
                                    Icons.broken_image,
                                    color: colors.textSecondary,
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const AppShimmer(
                                child: ColoredBox(color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      right: AppSpacing.xl4,
                      child: Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: [
                          CourseTagBadge(text: video.cefrLevel),
                          if (video.isNew)
                            CourseTagBadge(
                              text: l10n.homeNewTag,
                              type: CourseTagType.newTag,
                            ),
                        ],
                      ),
                    ),
                    if (video.durationSeconds > 0)
                      Positioned(
                        bottom: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.tnn,
                            vertical: AppSpacing.tn,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(AppRadius.tn),
                          ),
                          child: Text(
                            _formatDuration(video.durationSeconds),
                            style: AppTextStyles.custom(
                              color: Colors.white,
                              fontSize: AppFontSize.tnn,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    video.title,
                    style: AppTextStyles.custom(
                      color: colors.textPrimary,
                      fontSize: AppFontSize.lg2,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (video.artist != null && video.artist!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.tnn),
                    Text(
                      video.artist!,
                      style: AppTextStyles.custom(
                        color: colors.practicedText,
                        fontSize: AppFontSize.mdt,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CourseTagBadge(
                          text: video.category,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.tn,
                          ),
                          textStyle: AppTextStyles.custom(
                            color: colors.tabUnselectedText,
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w700,
                          ),
                          type: CourseTagType.category,
                        ),
                      ),
                      if (video.practiced >= 0)
                        Text(
                          l10n.homePracticed(
                            NumberFormatUtils.formatCompact(video.practiced),
                          ),
                          style: AppTextStyles.custom(
                            color: colors.practicedText,
                            fontSize: AppFontSize.md,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.tn),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
