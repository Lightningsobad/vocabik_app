import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/enums/exercise_type.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class VideoThumbnailSection extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback? onTap;

  const VideoThumbnailSection({
    super.key,
    required this.video,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: BounceWrapper(
        onTap: onTap ??
            () {
              final detailState = context.read<VideoDetailCubit>().state;
              final selectedType = (detailState is VideoDetailLoaded)
                  ? detailState.selectedExerciseType
                  : ExerciseType.multipleChoice;
              final selectedVersion = (detailState is VideoDetailLoaded)
                  ? detailState.selectedVersion
                  : 'v1';
              context.pushVideoToExercise(
                video: video,
                versionId: selectedVersion,
                exerciseType: selectedType,
              );
            },
        child: Container(
          width: double.infinity,
          height: 215,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colors.surfaceCard,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Background Thumbnail
                if (video.thumbnailUrl.isNotEmpty)
                  Transform.scale(
                    scale: 1.34,
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 800,
                      cacheHeight: 430,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: colors.surfaceCard,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: colors.surfaceCard,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(color: colors.surfaceCard),

                // 2. Gradient Overlay for readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 1.0],
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),

                // 3. Center Play Button with Glow
                Center(
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 34,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
