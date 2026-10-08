import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_custom_seek_bar.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';

class CustomVideoControls extends StatefulWidget {
  final YoutubePlayerController controller;
  final String videoTitle;
  final String cefrLevel;

  const CustomVideoControls({
    super.key,
    required this.controller,
    required this.videoTitle,
    required this.cefrLevel,
  });

  @override
  State<CustomVideoControls> createState() => _CustomVideoControlsState();
}

class _CustomVideoControlsState extends State<CustomVideoControls> {
  bool _isPlaying = true;
  bool _isMuted = false;
  double _playbackRate = 1.0;
  int _currentPositionMs = 0;
  int _totalDurationMs = 0;
  int _maxPositionMs = 0;

  StreamSubscription<YoutubeVideoState>? _videoStateSubscription;

  @override
  void initState() {
    super.initState();

    _videoStateSubscription = widget.controller.videoStateStream.listen((
      videoState,
    ) async {
      if (!mounted) return;

      final posMs = videoState.position.inMilliseconds;
      try {
        final playerState = await widget.controller.playerState;
        if (!mounted) return;

        final isPlaying = playerState == PlayerState.playing;

        // Continuously refresh duration when available
        if (_totalDurationMs <= 0) {
          _fetchDuration();
        }

        setState(() {
          _currentPositionMs = posMs;
          _isPlaying = isPlaying;
          if (posMs > _maxPositionMs) {
            _maxPositionMs = posMs;
          }
        });
      } catch (_) {}
    });

    _fetchDuration();
  }

  Future<void> _fetchDuration() async {
    try {
      final durSeconds = await widget.controller.duration;
      if (mounted && durSeconds > 0) {
        final newDurationMs = (durSeconds * 1000).round();
        if (newDurationMs != _totalDurationMs) {
          setState(() {
            _totalDurationMs = newDurationMs;
          });
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _videoStateSubscription?.cancel();
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      final playerState = await widget.controller.playerState;
      if (playerState == PlayerState.playing) {
        widget.controller.pauseVideo();
      } else {
        widget.controller.playVideo();
      }
    } catch (_) {}
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    if (_isMuted) {
      widget.controller.mute();
    } else {
      widget.controller.unMute();
    }
  }

  void _cycleSpeed() {
    const speeds = [0.75, 1.0, 1.25, 1.5];
    final currentIndex = speeds.indexOf(_playbackRate);
    final nextSpeed = speeds[(currentIndex + 1) % speeds.length];
    setState(() {
      _playbackRate = nextSpeed;
    });
    widget.controller.setPlaybackRate(nextSpeed);
  }

  void _handleSeek(double progressFraction, int effectiveDurationMs) {
    if (effectiveDurationMs <= 0) return;

    final targetMs = (progressFraction * effectiveDurationMs).round();
    final clampedMs = min(targetMs, _maxPositionMs);
    widget.controller.seekTo(seconds: clampedMs / 1000.0, allowSeekAhead: true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        int effectiveDurationMs = _totalDurationMs;
        if (effectiveDurationMs <= 0 && state is ExerciseLoaded) {
          if (state.exercise.lines.isNotEmpty) {
            effectiveDurationMs = state.exercise.lines.last.endMs;
          } else if (state.exercise.blankPositions.isNotEmpty) {
            effectiveDurationMs = state.exercise.blankPositions.last.endMs;
          }
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Seek bar with blank stop dots
              ExerciseCustomSeekBar(
                currentPositionMs: _currentPositionMs,
                totalDurationMs: effectiveDurationMs,
                exerciseState: state is ExerciseLoaded ? state : null,
                onSeek: (progress) => _handleSeek(progress, effectiveDurationMs),
              ),

              const SizedBox(height: AppSpacing.xs),

              // 2. Control Row: Play/Pause, Mute, Video Title & CEFR level, Speed
              Row(
                children: [
                  // Play/Pause button
                  BounceWrapper(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.primaryAccent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: colors.primaryAccent,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  // Mute / Unmute
                  GestureDetector(
                    onTap: _toggleMute,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.tabUnselectedBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isMuted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        color: colors.textSecondary,
                        size: 16,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  // Video Title & Level
                  Expanded(
                    child: Text(
                      widget.videoTitle.isNotEmpty
                          ? '${widget.videoTitle} • ${widget.cefrLevel}'
                          : widget.cefrLevel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.custom(
                        color: colors.textSecondary,
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  // Playback Speed Button
                  GestureDetector(
                    onTap: _cycleSpeed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.tabUnselectedBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: colors.borderSubtle,
                        ),
                      ),
                      child: Text(
                        '${_playbackRate == 1.0 ? '1' : _playbackRate}x',
                        style: AppTextStyles.custom(
                          color: colors.textPrimary,
                          fontSize: AppFontSize.tnn,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
