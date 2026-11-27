import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_cubit.dart';
import 'package:vocabik_app/features/video_detail/presentation/cubit/video_detail_state.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/enums/exercise_type.dart';
import 'package:vocabik_app/shared/presentation/utils/video_thumbnail_cache_manager.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class VideoThumbnailSection extends StatefulWidget {
  static const double _letterboxCropScale = 1.34;
  static const String _maxResSuffix = '/maxresdefault.jpg';

  final VideoEntity video;
  final VoidCallback? onTap;

  const VideoThumbnailSection({super.key, required this.video, this.onTap});

  static bool _needsLetterboxCrop(String url) {
    final path = (Uri.tryParse(url)?.path ?? url).toLowerCase();
    return path.endsWith('/hqdefault.jpg') ||
        path.endsWith('/sddefault.jpg') ||
        path.endsWith('/default.jpg');
  }

  static String? _resolveHqFallbackUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.path.toLowerCase().endsWith(_maxResSuffix)) {
      return null;
    }
    final newPath =
        '${uri.path.substring(0, uri.path.length - _maxResSuffix.length)}/hqdefault.jpg';
    return uri.replace(path: newPath).toString();
  }

  @override
  State<VideoThumbnailSection> createState() => _VideoThumbnailSectionState();
}

class _VideoThumbnailSectionState extends State<VideoThumbnailSection> {
  bool _useFallbackUrl = false;

  @override
  void didUpdateWidget(covariant VideoThumbnailSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.thumbnailUrl != widget.video.thumbnailUrl) {
      _useFallbackUrl = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final fallbackUrl = VideoThumbnailSection._resolveHqFallbackUrl(
      widget.video.thumbnailUrl,
    );
    final effectiveUrl = (_useFallbackUrl && fallbackUrl != null)
        ? fallbackUrl
        : widget.video.thumbnailUrl;
    final needsScale = VideoThumbnailSection._needsLetterboxCrop(effectiveUrl);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: BounceWrapper(
        onTap:
            widget.onTap ??
            () {
              final detailState = context.read<VideoDetailCubit>().state;
              final selectedType = (detailState is VideoDetailLoaded)
                  ? detailState.selectedExerciseType
                  : ExerciseType.multipleChoice;
              final selectedVersion = (detailState is VideoDetailLoaded)
                  ? detailState.selectedVersion
                  : 'v1';
              context.pushVideoToExercise(
                video: widget.video,
                versionId: selectedVersion,
                exerciseType: selectedType,
              );
            },
        child: Container(
          width: double.infinity,
          height: 215,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
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
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Background Thumbnail
                if (effectiveUrl.isNotEmpty)
                  ColoredBox(
                    color: colors.surfaceCard,
                    child: CachedNetworkImage(
                      key: ValueKey(effectiveUrl),
                      imageUrl: effectiveUrl,
                      cacheManager: VideoThumbnailCacheManager.instance,
                      fit: BoxFit.cover,
                      memCacheWidth: 800,
                      fadeInDuration: const Duration(milliseconds: 180),
                      fadeInCurve: Curves.easeOut,
                      imageBuilder: needsScale
                          ? (context, imageProvider) => Transform.scale(
                              scale: VideoThumbnailSection._letterboxCropScale,
                              child: Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            )
                          : null,
                      placeholder: (context, url) =>
                          ColoredBox(color: colors.surfaceCard),
                      errorWidget: (context, url, error) {
                        if (!_useFallbackUrl && fallbackUrl != null) {
                          final failedUrl = widget.video.thumbnailUrl;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted &&
                                !_useFallbackUrl &&
                                widget.video.thumbnailUrl == failedUrl) {
                              setState(() => _useFallbackUrl = true);
                            }
                          });
                          return ColoredBox(color: colors.surfaceCard);
                        }
                        return Container(
                          color: colors.surfaceCard,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: colors.textSecondary,
                            ),
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
                    width: 74,
                    height: 74,
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
                      size: 44,
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
