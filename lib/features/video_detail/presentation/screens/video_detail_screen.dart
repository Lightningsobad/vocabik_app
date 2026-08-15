import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/course_tag_badge.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

import '../widgets/video_detail_skeleton.dart';
// Widgets that we will create next
import '../widgets/video_thumbnail_section.dart';
import '../widgets/exercise_config_section.dart';
import '../widgets/version_selector.dart';
import '../widgets/reaction_stats_section.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.videoDetailBack,
          style: GoogleFonts.nunito(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
      ),
      body: BlocBuilder<VideoDetailCubit, VideoDetailState>(
        builder: (context, state) {
          if (state is VideoDetailInitial || state is VideoDetailLoading) {
            return const VideoDetailSkeleton();
          } else if (state is VideoDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: GoogleFonts.nunito(color: colors.textPrimary, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final id = (context.read<VideoDetailCubit>().state as dynamic).video?.id;
                      if (id != null) {
                        context.read<VideoDetailCubit>().loadVideoDetail(id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(l10n.homeRetry),
                  )
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
                  VideoThumbnailSection(video: video),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Row(
                      children: [
                        CourseTagBadge(text: video.cefrLevel),
                        const SizedBox(width: AppSpacing.sm),
                        CourseTagBadge(text: video.category, type: CourseTagType.category),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      video.title,
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: colors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (video.artist != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        video.artist!,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  const ExerciseConfigSection(),
                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      l10n.videoDetailVersion,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const VersionSelector(),
                  const SizedBox(height: AppSpacing.xl),
                  const ReactionStatsSection(),
                  const SizedBox(height: AppSpacing.xl2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: BounceWrapper(
                      onTap: () {
                        context.push('/exercise/${video.id}?cefr_level=${video.cefrLevel}&version_id=v1&youtube_video_id=${video.youtubeVideoId}&video_title=${Uri.encodeComponent(video.title)}');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            l10n.videoDetailStartPractice,
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
