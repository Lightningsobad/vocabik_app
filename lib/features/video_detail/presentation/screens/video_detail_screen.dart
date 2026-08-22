import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/course_tag_badge.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import '../widgets/exercise_config_section.dart';
import '../widgets/progress_history_card.dart';
import '../widgets/reaction_stats_section.dart';
import '../widgets/version_selector.dart';
import '../widgets/video_detail_skeleton.dart';
import '../widgets/video_thumbnail_section.dart';

class VideoDetailScreen extends StatelessWidget {
  final String videoId;

  const VideoDetailScreen({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VideoDetailCubit>()..loadVideoDetail(videoId),
      child: const VideoDetailScreenView(),
    );
  }
}

class VideoDetailScreenView extends StatelessWidget {
  const VideoDetailScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<VideoDetailCubit, VideoDetailState>(
        builder: (context, state) {
          if (state is VideoDetailInitial || state is VideoDetailLoading) {
            return const VideoDetailSkeleton();
          } else if (state is VideoDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: AppTextStyles.custom(
                      color: colors.textPrimary,
                      fontSize: AppFontSize.lg,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final id =
                          (context.read<VideoDetailCubit>().state as dynamic)
                              .video
                              ?.id;
                      if (id != null) {
                        context.read<VideoDetailCubit>().loadVideoDetail(id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(l10n.homeRetry),
                  ),
                ],
              ),
            );
          } else if (state is VideoDetailLoaded) {
            final video = state.video;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Custom Back Button row matching design
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: BounceWrapper(
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
                  ),
                  const SizedBox(height: 12),
                  // Thumbnail
                  VideoThumbnailSection(video: video),
                  const SizedBox(height: 16),
                  // Badges: CEFR Level, Category
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        CourseTagBadge(
                          text: video.cefrLevel,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm2,
                            vertical: AppSpacing.tnn,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        CourseTagBadge(
                          text: video.category,
                          type: CourseTagType.category,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Text(
                        video.artist!,
                        style: AppTextStyles.custom(
                          fontSize: 16,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
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
                  const SizedBox(height: 10),
                  const VersionSelector(),
                  const SizedBox(height: 20),
                  // Reaction stats
                  const ReactionStatsSection(),
                  const SizedBox(height: 20),
                  // Progress history card (if user has previous attempts)
                  if (state.latestProgress != null) ...[
                    ProgressHistoryCard(progress: state.latestProgress!),
                    const SizedBox(height: 16),
                  ],
                  // Main CTA button ("Bắt đầu luyện →")
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: PrimaryButton(
                      text: l10n.videoDetailStartPractice,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: PrimaryButton(
                      text: l10n.videoDetailShareThis,
                      variant: PrimaryButtonVariant.secondary,
                      textColor: colors.shareText,

                      leadingIcon: SvgPicture.asset(
                        'assets/video_detail/share_icon.svg',
                        width: 16,
                        height: 16,
                      ),
                      onPressed: () {
                        // Share logic will be integrated later
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
