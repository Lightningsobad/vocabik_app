import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import '../widgets/video_detail_content_view.dart';
import '../widgets/video_detail_skeleton.dart';

class VideoDetailScreen extends StatelessWidget {
  final String videoId;

  const VideoDetailScreen({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VideoDetailCubit>()..loadVideoDetail(videoId),
      child: VideoDetailScreenView(videoId: videoId),
    );
  }
}

class VideoDetailScreenView extends StatelessWidget {
  final String videoId;

  const VideoDetailScreenView({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<VideoDetailCubit, VideoDetailState>(
        buildWhen: (previous, current) {
          if (previous is VideoDetailLoaded && current is VideoDetailLoaded) {
            final prevWithNewReactions = previous.copyWith(
              video: previous.video.copyWith(
                reactionCounts: current.video.reactionCounts,
              ),
              userReactions: current.userReactions,
            );
            return prevWithNewReactions != current;
          }
          return true;
        },
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
                      context.read<VideoDetailCubit>().loadVideoDetail(videoId);
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
            return VideoDetailContentView(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
