import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/custom_video_controls.dart';

class ExerciseVideoPlayerWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final String videoTitle;
  final String cefrLevel;
  final bool isLandscape;

  const ExerciseVideoPlayerWidget({
    super.key,
    required this.controller,
    required this.videoTitle,
    required this.cefrLevel,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isLandscape ? 12 : 0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 200,
              minHeight: 200,
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ColoredBox(
                color: Colors.black,
                child: YoutubePlayer(
                  key: const ValueKey('exercise_youtube_player'),
                  controller: controller,
                  aspectRatio: 16 / 9,
                  autoFullScreen: false,
                  enableFullScreenOnVerticalDrag: false,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        CustomVideoControls(
          controller: controller,
          videoTitle: videoTitle,
          cefrLevel: cefrLevel,
        ),
      ],
    );
  }
}
