import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/core/services/share_service.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/course_tag_badge.dart';
import 'package:vocabik_app/shared/presentation/widgets/dialogs/report_content_dialog.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import 'exercise_config_section.dart';
import 'progress_history_card.dart';
import 'reaction_stats_section.dart';
import 'version_selector.dart';
import 'video_thumbnail_section.dart';

class VideoDetailContentView extends StatelessWidget {
  final VideoDetailLoaded state;

  const VideoDetailContentView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final video = state.video;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Custom Back Button & Report Video row matching design
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BounceWrapper(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 16,
                          color: colors.tabUnselectedText,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.videoDetailBack,
                          style: AppTextStyles.custom(
                            color: colors.tabUnselectedText,
                            fontSize: AppFontSize.lg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BounceWrapper(
                  onTap: () {
                    ReportContentDialog.show(
                      context,
                      targetId: video.id,
                      targetTitle: video.title,
                      targetType: 'video',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 16,
                          color: colors.tabUnselectedText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.reportVideoOption,
                          style: AppTextStyles.custom(
                            color: colors.tabUnselectedText,
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Thumbnail
          VideoThumbnailSection(video: video),
          const SizedBox(height: 16),
          // Badges: CEFR Level, Category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CourseTagBadge(
                  text: video.cefrLevel,
                  textStyle: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    color: colors.tagLevelText,
                    fontWeight: FontWeight.w900,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.tnn,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                CourseTagBadge(
                  text: video.category,
                  type: CourseTagType.category,
                  textStyle: AppTextStyles.custom(
                    fontSize: AppFontSize.md,
                    color: colors.tabUnselectedText,
                    fontWeight: FontWeight.w700,
                  ),
                  backgroundColor: colors.tagCategoryBackground,
                  border: Border.all(color: colors.tagCategoryBorder, width: 1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm2,
                    vertical: AppSpacing.xs,
                  ),
                  leadingIcon: Image.asset(
                    'assets/home_screen/music_icon.png',
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                  ),
                ),
                if (video.durationSeconds > 0) ...[
                  const SizedBox(width: AppSpacing.sm2),
                  Image.asset(
                    'assets/home_screen/timer_icon.png',
                    width: 14,
                    height: 14,
                    alignment: Alignment.center,
                  ),
                  const SizedBox(width: AppSpacing.tnn),
                  Text(
                    video.formattedDuration,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.md,
                      color: colors.videoDurationText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              video.title,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.xl6,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
          ),
          // Artist
          if (video.artist != null && video.artist!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                video.artist!,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.lg2,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg2),
          // Exercise Config (Cards + Segmented Toggle)
          const ExerciseConfigSection(),
          const SizedBox(height: AppSpacing.lg2),
          // Versions header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              l10n.videoDetailVersion,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w900,
                color: colors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.mdt),
          const VersionSelector(),
          const SizedBox(height: AppSpacing.lg),
          // Reaction stats
          const ReactionStatsSection(),
          const SizedBox(height: AppSpacing.xl),
          // Progress history card (if user has previous attempts)
          if (state.latestProgress != null) ...[
            ProgressHistoryCard(progress: state.latestProgress!),
            const SizedBox(height: AppSpacing.xl1),
          ],
          // Main CTA button ("Bắt đầu luyện →")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: PrimaryButton(
              text: l10n.videoDetailStartPractice,
              textStyle: AppTextStyles.custom(
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.w700,
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg3),
              onPressed: () {
                context.pushVideoToExercise(
                  video: video,
                  versionId: state.selectedVersion,
                  exerciseType: state.selectedExerciseType,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Secondary Share button ("🔗 Chia sẻ bài này")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: PrimaryButton(
              text: l10n.videoDetailShareThis,
              variant: PrimaryButtonVariant.secondary,
              textColor: colors.shareText,
              textStyle: AppTextStyles.custom(
                fontSize: AppFontSize.lg,
                fontWeight: FontWeight.w700,
                color: colors.shareText,
              ),
              leadingIcon: SvgPicture.asset(
                'assets/video_detail/share_icon.svg',
                width: 16,
                height: 16,
              ),
              border: Border.all(color: colors.optionCardBorder),
              onPressed: () {
                final shareUrl = getIt<ShareService>().getLessonUrl(video.id);
                final message = l10n.shareLessonMessage(video.title, shareUrl);
                final box = context.findRenderObject() as RenderBox?;
                final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;
                getIt<ShareService>().shareLesson(
                  videoId: video.id,
                  message: message,
                  sharePositionOrigin: origin,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
