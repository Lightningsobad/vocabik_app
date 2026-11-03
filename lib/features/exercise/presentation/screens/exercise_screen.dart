import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/core/services/audio_feedback_service.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/answer_interaction_area.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_header_widget.dart';
import 'package:vocabik_app/shared/presentation/widgets/dialogs/report_content_dialog.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_line_widget.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/exercise_video_player_widget.dart';
import 'package:vocabik_app/features/exercise/presentation/models/exercise_result_args.dart';
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
  final bool isDailyChallenge;

  const ExerciseScreen({
    super.key,
    required this.videoId,
    required this.cefrLevel,
    required this.versionId,
    required this.youtubeVideoId,
    this.videoTitle = '',
    this.exerciseType = 'Multiple choice',
    this.isDailyChallenge = false,
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
        isDailyChallenge: isDailyChallenge,
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
  final bool isDailyChallenge;

  const ExerciseScreenView({
    super.key,
    required this.videoId,
    required this.versionId,
    required this.youtubeVideoId,
    required this.videoTitle,
    required this.cefrLevel,
    this.exerciseType = 'Multiple choice',
    this.isDailyChallenge = false,
  });

  @override
  State<ExerciseScreenView> createState() => _ExerciseScreenViewState();
}

class _ExerciseScreenViewState extends State<ExerciseScreenView> {
  late YoutubePlayerController _youtubeController;
  final GlobalKey _videoPlayerKey = GlobalKey();
  StreamSubscription<YoutubeVideoState>? _videoStateSubscription;
  bool _isQuestionVisible = false;
  bool _isNavigatingToResult = false;
  DateTime _startTime = DateTime.now();
  int _currentPositionMs = 0;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Safely extract ID in case a full URL was passed
    final safeVideoId =
        YoutubePlayerController.convertUrlToId(widget.youtubeVideoId) ??
        widget.youtubeVideoId;

    if (safeVideoId.isEmpty) {
      _isQuestionVisible = true;
    }

    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: safeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        enableCaption: false,
        mute: false,
        origin: 'https://com.snapsofts.vocabik.yt',
        pointerEvents: PointerEvents.initial,
      ),
    );

    _videoStateSubscription = _youtubeController.videoStateStream.listen(
      _onVideoStateChanged,
    );
  }

  void _handleReport() {
    _youtubeController.pauseVideo();
    ReportContentDialog.show(
      context,
      targetId: widget.videoId,
      targetTitle: widget.videoTitle,
      targetType: 'video',
    );
  }

  void _onVideoStateChanged(YoutubeVideoState videoState) {
    if (!mounted) return;
    final posMs = videoState.position.inMilliseconds;
    _currentPositionMs = posMs;

    final state = context.read<ExerciseCubit>().state;
    if (state is! ExerciseLoaded || state.isFinished) return;

    final activeLine = state.activeLine;

    if (activeLine.endMs > 0) {
      // Pause when the video reaches the END of the active sentence
      if (posMs >= activeLine.endMs) {
        _youtubeController.pauseVideo();
        if (!_isQuestionVisible) {
          setState(() {
            _isQuestionVisible = true;
          });
        }
      } else if (posMs < activeLine.endMs && _isQuestionVisible) {
        // If user seeks backward before the active sentence end and question is not yet answered
        if (!state.checkResults.containsKey(state.currentBlankIndex)) {
          setState(() {
            _isQuestionVisible = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _videoStateSubscription?.cancel();
    _youtubeController.close();
    if (!_isNavigatingToResult) {
      getIt<AudioFeedbackService>().stop();
    }
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
              final prevChecked = previous.checkResults.containsKey(previous.currentBlankIndex);
              final currChecked = current.checkResults.containsKey(current.currentBlankIndex);
              final hasNewCheckResult = !prevChecked && currChecked;
              final hasBlankChange = previous.currentBlankIndex != current.currentBlankIndex;
              final hasFinishedChange = previous.isFinished != current.isFinished;
              return hasNewCheckResult || hasBlankChange || hasFinishedChange;
            }
            return false;
          },
          listener: (context, state) async {
            if (state is ExerciseLoaded) {
              if (state.isFinished) {
                _isNavigatingToResult = true;
                final durationMs = DateTime.now()
                    .difference(_startTime)
                    .inMilliseconds;
                context.goToExerciseResult(
                  ExerciseResultArgs(
                    exercise: state.exercise,
                    selectedAnswers: state.selectedAnswers,
                    checkResults: state.checkResults,
                    durationMs: durationMs,
                    youtubeVideoId: widget.youtubeVideoId,
                    videoTitle: widget.videoTitle,
                    exerciseType: widget.exerciseType,
                    isDailyChallenge: widget.isDailyChallenge,
                  ),
                );
                return;
              }

              final isCorrect = state.checkResults[state.currentBlankIndex];
              if (isCorrect != null && _isQuestionVisible) {
                if (isCorrect) {
                  getIt<AudioFeedbackService>().playCorrectFeedback();
                } else {
                  getIt<AudioFeedbackService>().playIncorrectFeedback();
                }
              }

              if (state.checkResults[state.currentBlankIndex] == null) {
                final activeLine = state.activeLine;
                // If the next sentence is ahead in the video, hide question and play
                if (activeLine.endMs > 0 && _currentPositionMs < activeLine.endMs - 300) {
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
                } else {
                  // Video is already at or past the end of the sentence (e.g. multiple blanks in the same sentence)
                  // Keep question visible and ensure video is smoothly paused
                  if (mounted && !_isQuestionVisible) {
                    setState(() {
                      _isQuestionVisible = true;
                    });
                  }
                  try {
                    _youtubeController.pauseVideo();
                  } catch (_) {}
                }
              }
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
                    Icon(Icons.error_outline, size: 48, color: colors.danger),
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
                return const Center(child: CircularProgressIndicator());
              }

              final isLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;
              final isKeyboardOpen =
                  MediaQuery.of(context).viewInsets.bottom > 0;

              if (isLandscape) {
                return Column(
                  children: [
                    // Hide compact header when keyboard opens in landscape to maximize vertical room
                    if (!isKeyboardOpen)
                      ExerciseHeaderWidget(
                        progress: state.progress,
                        currentStep: state.currentStep,
                        totalSteps: state.totalSteps,
                        onReport: _handleReport,
                        isLandscape: true,
                      ),

                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left Pane: Video Player (~50% flex for YouTube minimum viewport compliance)
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.md,
                                0,
                                AppSpacing.sm,
                                AppSpacing.sm,
                              ),
                              child: Center(
                                child: ExerciseVideoPlayerWidget(
                                  key: _videoPlayerKey,
                                  controller: _youtubeController,
                                  videoTitle: widget.videoTitle,
                                  cefrLevel: widget.cefrLevel,
                                  isLandscape: true,
                                ),
                              ),
                            ),
                          ),

                          // Right Pane: Interactive Exercise Area (~50% flex)
                          Expanded(
                            flex: 1,
                            child: !_isQuestionVisible
                                ? Center(
                                    child: Text(
                                      l10n.exercisePlayingVideo,
                                      style: AppTextStyles.custom(
                                        color: colors.textSecondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.xs,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Sentence with blank
                                        ExerciseLineWidget(
                                          line: state.activeLine,
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        // Translation button
                                        Center(
                                          child: TextButton.icon(
                                            onPressed: () {
                                              context
                                                  .read<ExerciseCubit>()
                                                  .toggleTranslation();
                                            },
                                            icon: SvgPicture.asset(
                                              'assets/exercise_screen/global.svg',
                                              width: 18,
                                              height: 18,
                                              colorFilter: ColorFilter.mode(
                                                colors.primaryAccent,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            label: Text(
                                              state.isTranslationVisible
                                                  ? l10n.hideVietnameseTranslation
                                                  : l10n.viewVietnameseTranslation,
                                              style: AppTextStyles.custom(
                                                fontWeight: FontWeight.w800,
                                                fontSize: AppFontSize.md,
                                                color: colors.primaryAccent,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (state.isTranslationVisible &&
                                            state.translations[state
                                                    .activeLine.lineIndex] !=
                                                null &&
                                            state
                                                .translations[state
                                                    .activeLine.lineIndex]!
                                                .isNotEmpty) ...[
                                          const SizedBox(
                                            height: AppSpacing.xs,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.md,
                                            ),
                                            child: Text(
                                              state.translations[
                                                  state.activeLine.lineIndex]!,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.custom(
                                                color: colors.textSecondary,
                                                fontSize: AppFontSize.sm,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: AppSpacing.xs,
                                          ),
                                        ] else
                                          const SizedBox(
                                            height: AppSpacing.tn,
                                          ),

                                        // Interaction Area: Type the answer OR Multiple Choice
                                        if (widget.exerciseType ==
                                            'Type the answer')
                                          const TypeAnswerInteractionArea()
                                        else
                                          const AnswerInteractionArea(),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              // Portrait Layout
              return Column(
                children: [
                  ExerciseHeaderWidget(
                    progress: state.progress,
                    currentStep: state.currentStep,
                    totalSteps: state.totalSteps,
                    onReport: _handleReport,
                  ),

                  // Video Player with custom controls overlay
                  ExerciseVideoPlayerWidget(
                    key: _videoPlayerKey,
                    controller: _youtubeController,
                    videoTitle: widget.videoTitle,
                    cefrLevel: widget.cefrLevel,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Lower Area: Either "Playing video..." placeholder OR Question & Options
                  Expanded(
                    child: !_isQuestionVisible
                        ? Center(
                            child: Text(
                              l10n.exercisePlayingVideo,
                              style: AppTextStyles.custom(
                                color: colors.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: AppSpacing.md),
                                // Sentence with blank
                                ExerciseLineWidget(line: state.activeLine),
                                const SizedBox(height: AppSpacing.sm2),
                                // Translation button
                                Center(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      context
                                          .read<ExerciseCubit>()
                                          .toggleTranslation();
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/exercise_screen/global.svg',
                                      width: 20,
                                      height: 20,
                                      colorFilter: ColorFilter.mode(
                                        colors.primaryAccent,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    label: Text(
                                      state.isTranslationVisible
                                          ? l10n.hideVietnameseTranslation
                                          : l10n.viewVietnameseTranslation,
                                      style: AppTextStyles.custom(
                                        fontWeight: FontWeight.w800,
                                        fontSize: AppFontSize.lg,
                                        color: colors.primaryAccent,
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.isTranslationVisible &&
                                    state.translations[state.activeLine.lineIndex] !=
                                        null &&
                                    state.translations[state.activeLine.lineIndex]!
                                        .isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                    ),
                                    child: Text(
                                      state.translations[
                                          state.activeLine.lineIndex]!,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.custom(
                                        color: colors.textSecondary,
                                        fontSize: AppFontSize.mdt,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm2),
                                ] else
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
