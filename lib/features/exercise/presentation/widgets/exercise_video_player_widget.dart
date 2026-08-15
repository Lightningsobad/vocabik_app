import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/custom_video_controls.dart';

class ExerciseVideoPlayerWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final String videoTitle;
  final String cefrLevel;

  const ExerciseVideoPlayerWidget({
    super.key,
    required this.controller,
    required this.videoTitle,
    required this.cefrLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220, // Default height for 16:9 aspect ratio roughly
      color: Colors.black,
      child: YoutubePlayer(
        controller: controller,
        aspectRatio: 16 / 9,
        controlsBuilder: (context, isFullscreen) {
          return CustomVideoControls(
            controller: controller,
            videoTitle: videoTitle,
            cefrLevel: cefrLevel,
          );
        },
      ),
    );
  }
}
