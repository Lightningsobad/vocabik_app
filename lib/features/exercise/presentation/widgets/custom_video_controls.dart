import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
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
  Timer? _hideTimer;
  bool _showControls = true;
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
    _startHideTimer();

    _videoStateSubscription = widget.controller.videoStateStream.listen((
      videoState,
    ) async {
      if (!mounted) return;

      final posMs = videoState.position.inMilliseconds;
      try {
        final playerState = await widget.controller.playerState;
        if (!mounted) return;

        final isPlaying = playerState == PlayerState.playing;

        setState(() {
          _currentPositionMs = posMs;
          _isPlaying = isPlaying;
          if (posMs > _maxPositionMs) {
            _maxPositionMs = posMs;
          }
        });

        if (!isPlaying) {
          _cancelHideTimer();
          if (!_showControls) {
            setState(() {
              _showControls = true;
            });
          }
        }
      } catch (_) {}
    });

    _fetchDuration();
  }

  Future<void> _fetchDuration() async {
    try {
      final durSeconds = await widget.controller.duration;
      if (mounted && durSeconds > 0) {
        setState(() {
          _totalDurationMs = (durSeconds * 1000).round();
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _videoStateSubscription?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _cancelHideTimer() {
    _hideTimer?.cancel();
  }

  void _onUserInteraction() {
    setState(() {
      _showControls = true;
    });
    if (_isPlaying) {
      _startHideTimer();
    }
  }

  void _togglePlayPause() async {
    _onUserInteraction();
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
    _onUserInteraction();
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
    _onUserInteraction();
    const speeds = [0.75, 1.0, 1.25, 1.5];
    final currentIndex = speeds.indexOf(_playbackRate);
    final nextSpeed = speeds[(currentIndex + 1) % speeds.length];
    setState(() {
      _playbackRate = nextSpeed;
    });
    widget.controller.setPlaybackRate(nextSpeed);
  }

  void _handleSeek(double progressFraction) {
    _onUserInteraction();
    if (_totalDurationMs <= 0) return;

    final targetMs = (progressFraction * _totalDurationMs).round();
    // Only allow rewind or seek up to the furthest reached position
    final clampedMs = min(targetMs, _maxPositionMs);
    widget.controller.seekTo(seconds: clampedMs / 1000.0, allowSeekAhead: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseLoaded) {
          // Fallback total duration from lines if video duration is not loaded yet
          if (_totalDurationMs <= 0 && state.exercise.lines.isNotEmpty) {
            _totalDurationMs = state.exercise.lines.last.endMs;
          }
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_showControls && _isPlaying) {
              setState(() {
                _showControls = false;
              });
              _cancelHideTimer();
            } else {
              _onUserInteraction();
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Top / Center Fading Controls (Play/Pause Button)
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !_showControls,
                      child: Center(
                        child: BounceWrapper(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Controls: Seekbar (Always Visible) & Info Row (Fading)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Seek Bar with stop dots (Always Visible)
                      ExerciseCustomSeekBar(
                        currentPositionMs: _currentPositionMs,
                        totalDurationMs: _totalDurationMs,
                        exerciseState: state is ExerciseLoaded ? state : null,
                        onSeek: _handleSeek,
                      ),

                      const SizedBox(height: 6),

                      // Bottom Info Bar (Fading: Title, Volume, Speed)
                      AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: IgnorePointer(
                          ignoring: !_showControls,
                          child: Row(
                            children: [
                              // Mute/Unmute Button
                              GestureDetector(
                                onTap: _toggleMute,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isMuted
                                        ? Icons.volume_off_rounded
                                        : Icons.volume_up_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Video Title & Level
                              Expanded(
                                child: Text(
                                  widget.videoTitle.isNotEmpty
                                      ? '${widget.videoTitle} • ${widget.cefrLevel}'
                                      : widget.cefrLevel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.custom(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: AppFontSize.sm,
                                    fontWeight: FontWeight.w700,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Playback Speed Button
                              GestureDetector(
                                onTap: _cycleSpeed,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '${_playbackRate == 1.0 ? '1' : _playbackRate}x',
                                    style: AppTextStyles.custom(
                                      color: Colors.white,
                                      fontSize: AppFontSize.tnn,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
