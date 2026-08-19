import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/answer_interaction_area.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_header_widget.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_line_widget.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_video_player_widget.dart';
import 'package:vocabik_app/features/exercise/presentation/screens/result_screen.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/type_answer_interaction_area.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class ExerciseScreen extends StatelessWidget {
  final String videoId;
  final String cefrLevel;
  final String versionId;
  final String youtubeVideoId;
  final String videoTitle;
  final String exerciseType;

  const ExerciseScreen({
    super.key,
    required this.videoId,
    required this.cefrLevel,
    required this.versionId,
    required this.youtubeVideoId,
    this.videoTitle = '',
    this.exerciseType = 'Multiple choice',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExerciseCubit>()
        ..loadExercise(
          videoId: videoId,
          cefrLevel: cefrLevel,
          versionId: versionId,
        ),
      child: ExerciseScreenView(
        videoId: videoId,
        versionId: versionId,
        youtubeVideoId: youtubeVideoId,
        videoTitle: videoTitle,
        cefrLevel: cefrLevel,
        exerciseType: exerciseType,
      ),
    );
  }
}

class ExerciseScreenView extends StatefulWidget {
  final String videoId;
  final String versionId;
  final String youtubeVideoId;
  final String videoTitle;
  final String cefrLevel;
  final String exerciseType;

  const ExerciseScreenView({
    super.key,
    required this.videoId,
    required this.versionId,
    required this.youtubeVideoId,
    required this.videoTitle,
    required this.cefrLevel,
    this.exerciseType = 'Multiple choice',
  });

  @override
  State<ExerciseScreenView> createState() => _ExerciseScreenViewState();
}

class _ExerciseScreenViewState extends State<ExerciseScreenView> {
  late YoutubePlayerController _youtubeController;
  StreamSubscription<YoutubeVideoState>? _videoStateSubscription;
  bool _isQuestionVisible = false;
  DateTime _startTime = DateTime.now();

  void _handlePracticeAgain() {
    setState(() {
      _startTime = DateTime.now();
      _isQuestionVisible = false;
    });
    _youtubeController.seekTo(seconds: 0);
    _youtubeController.playVideo();
    context.read<ExerciseCubit>().loadExercise(
      videoId: widget.videoId,
      cefrLevel: widget.cefrLevel,
      versionId: widget.versionId,
    );
  }

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    
    // Safely extract ID in case a full URL was passed
    final safeVideoId = YoutubePlayerController.convertUrlToId(widget.youtubeVideoId) ?? widget.youtubeVideoId;
    
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: safeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: false,
        enableCaption: false,
        mute: false,
        pointerEvents: PointerEvents.none,
      ),
    );

    _videoStateSubscription = _youtubeController.videoStateStream.listen((videoState) {
      if (!mounted) return;
      final state = context.read<ExerciseCubit>().state;
      if (state is ExerciseLoaded && !state.isFinished) {
        final currentPosition = videoState.position.inMilliseconds;
        final activeLine = state.activeLine;
        
        // Pause when the video reaches the END of the active sentence
        if (currentPosition >= activeLine.endMs) {
          _youtubeController.pauseVideo();
          if (!_isQuestionVisible) {
            setState(() {
              _isQuestionVisible = true;
            });
          }
        } else if (currentPosition < activeLine.endMs && _isQuestionVisible) {
          // If user seeks backward before the active sentence end
          setState(() {
            _isQuestionVisible = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _videoStateSubscription?.cancel();
    _youtubeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocConsumer<ExerciseCubit, ExerciseState>(
          listenWhen: (previous, current) {
            if (previous is ExerciseLoaded && current is ExerciseLoaded) {
              return previous.currentBlankIndex != current.currentBlankIndex;
            }
            return false;
          },
          listener: (context, state) async {
            if (state is ExerciseLoaded && !state.isFinished) {
              if (mounted) {
                setState(() {
                  _isQuestionVisible = false;
                });
              }
              try {
                final playerState = await _youtubeController.playerState;
                if (!mounted) return;
                if (playerState != PlayerState.playing) {
                  _youtubeController.playVideo();
                }
              } catch (_) {}
            }
          },
          builder: (context, state) {
            if (state is ExerciseInitial || state is ExerciseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExerciseError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colors.danger,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: GoogleFonts.nunito(
                        color: colors.textPrimary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primaryAccent,
                        foregroundColor: colors.onPrimaryAccent,
                      ),
                      child: Text(l10n.homeRetry),
                    ),
                  ],
                ),
              );
            } else if (state is ExerciseLoaded) {
              if (state.isFinished) {
                return ResultScreen(
                  exercise: state.exercise,
                  selectedAnswers: state.selectedAnswers,
                  checkResults: state.checkResults,
                  durationMs: DateTime.now().difference(_startTime).inMilliseconds,
                  onPracticeAgain: _handlePracticeAgain,
                );
              }

              return Column(
                children: [
                  ExerciseHeaderWidget(
                    progress: state.progress,
                    currentStep: state.currentStep,
                    totalSteps: state.totalSteps,
                  ),

                  // Video Player with custom controls overlay
                  ExerciseVideoPlayerWidget(
                    controller: _youtubeController,
                    videoTitle: widget.videoTitle,
                    cefrLevel: widget.cefrLevel,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Lower Area: Either "Playing video..." placeholder OR Question & Options
                  Expanded(
                    child: !_isQuestionVisible
                        ? Center(
                            child: Text(
                              l10n.exercisePlayingVideo,
                              style: GoogleFonts.nunito(
                                color: colors.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: AppSpacing.md),
                                // Sentence with blank
                                ExerciseLineWidget(line: state.activeLine),
                                const SizedBox(height: AppSpacing.tn),
                                // Translation button
                                Center(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      // TODO: Show translation
                                    },
                                    icon: Icon(Icons.language, size: 18, color: colors.primaryAccent),
                                    label: Text(
                                      l10n.viewVietnameseTranslation,
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: colors.primaryAccent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.tn),
                                // Interaction Area: Type the answer OR Multiple Choice
                                if (widget.exerciseType == 'Type the answer')
                                  const TypeAnswerInteractionArea()
                                else
                                  const AnswerInteractionArea(),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
