import 'package:vocabik_app/shared/presentation/widgets/notifications/app_snack_bar.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/core/services/audio_feedback_service.dart';
import 'package:vocabik_app/features/challenge_friend/presentation/models/challenge_friend_args.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/celebration_confetti_overlay.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/result_action_buttons.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/result_gamification_cards.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/result_stats_section.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/result_wrong_answers.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/score_card_share_section.dart';
import 'package:vocabik_app/features/main_shell/presentation/cubit/main_shell_cubit.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/gamification/cubit/gamification_global_cubit.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class ResultScreen extends StatelessWidget {
  final ExerciseEntity exercise;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> checkResults;
  final int durationMs;
  final String youtubeVideoId;
  final String videoTitle;
  final String exerciseType;
  final bool isDailyChallenge;
  final VoidCallback? onPracticeAgain;

  const ResultScreen({
    super.key,
    required this.exercise,
    required this.selectedAnswers,
    required this.checkResults,
    required this.durationMs,
    this.youtubeVideoId = '',
    this.videoTitle = '',
    this.exerciseType = 'Multiple choice',
    this.isDailyChallenge = false,
    this.onPracticeAgain,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ResultCubit>()
        ..initialize(
          exercise: exercise,
          selectedAnswers: selectedAnswers,
          checkResults: checkResults,
          durationMs: durationMs,
          isDailyChallenge: isDailyChallenge,
        ),
      child: ResultScreenView(
        exercise: exercise,
        durationMs: durationMs,
        youtubeVideoId: youtubeVideoId,
        videoTitle: videoTitle,
        exerciseType: exerciseType,
        isDailyChallenge: isDailyChallenge,
        onPracticeAgain: onPracticeAgain,
      ),
    );
  }
}

class ResultScreenView extends StatefulWidget {
  final ExerciseEntity exercise;
  final int durationMs;
  final String youtubeVideoId;
  final String videoTitle;
  final String exerciseType;
  final bool isDailyChallenge;
  final VoidCallback? onPracticeAgain;

  const ResultScreenView({
    super.key,
    required this.exercise,
    required this.durationMs,
    this.youtubeVideoId = '',
    this.videoTitle = '',
    this.exerciseType = 'Multiple choice',
    this.isDailyChallenge = false,
    this.onPracticeAgain,
  });

  @override
  State<ResultScreenView> createState() => _ResultScreenViewState();
}

class _ResultScreenViewState extends State<ResultScreenView> {
  bool _hasPlayedCompletionAudio = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<ResultCubit>().state;
    if (!state.isCalculating && state.summary != null && !_hasPlayedCompletionAudio) {
      _hasPlayedCompletionAudio = true;
      getIt<AudioFeedbackService>().playCompletionFeedback();
    }
  }

  @override
  void dispose() {
    getIt<AudioFeedbackService>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final streak = context.select(
      (GamificationGlobalCubit cubit) => cubit.state.streak,
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocConsumer<ResultCubit, ResultState>(
        listenWhen: (previous, current) {
          return previous.progressStatus != current.progressStatus ||
              previous.isCalculating != current.isCalculating ||
              previous.summary != current.summary;
        },
        listener: (context, state) {
          if (state.progressStatus == ProgressSubmitStatus.success) {
            context.read<MainShellCubit>().loadSummary();
          }

          if (state.progressStatus == ProgressSubmitStatus.error) {
            AppSnackBar.showError(
              context,
              state.progressErrorMessage ??
                  l10n.resultProgressSaveError,
              action: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  if (state.summary != null) {
                    context.read<ResultCubit>().submitProgress(
                      exercise: widget.exercise,
                      summary: state.summary!,
                    );
                  }
                },
                child: Text(
                  l10n.resultProgressRetry,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.bold,
                    color: colors.danger,
                  ),
                ),
              ),
            );
          }

          if (!state.isCalculating && state.summary != null && !_hasPlayedCompletionAudio) {
            _hasPlayedCompletionAudio = true;
            getIt<AudioFeedbackService>().playCompletionFeedback();
          }
        },
        builder: (context, state) {
          final isCalculating = state.isCalculating || state.summary == null;
          final shouldPlayConfetti =
              !state.isCalculating && (state.summary?.accuracyScore ?? 0) >= 80;

          return Stack(
            children: [
              if (isCalculating)
                const Center(child: CircularProgressIndicator())
              else
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.sm),

                        // 1. Result Score Stats Section
                        ResultStatsSection(summary: state.summary!),

                        // 2. XP, Streak, Badge Cards
                        ResultGamificationCards(
                          cefrLevel: widget.exercise.cefrLevel,
                          dayStreak: streak,
                        ),

                        // 3. What went wrong section
                        ResultWrongAnswers(
                          wrongAnswers: state.summary!.wrongAnswers,
                        ),

                        // 4. Score Card and Share section
                        ScoreCardShareSection(
                          status: state.scoreCardStatus,
                          imageUrl: state.scoreCardImageUrl,
                          videoId: widget.exercise.videoId,
                          videoTitle: widget.videoTitle,
                          accuracyScore: state.summary?.accuracyScore ?? 0,
                          onRetry: () {
                            context.read<ResultCubit>().generateScoreCard(
                              videoId: widget.exercise.videoId,
                              cefrLevel: widget.exercise.cefrLevel,
                              accuracyScore: state.summary!.accuracyScore,
                            );
                          },
                          onChallengeFriend: () {
                            if (state.summary != null) {
                              context.pushToChallengeFriend(
                                ChallengeFriendArgs(
                                  exercise: widget.exercise,
                                  durationMs: widget.durationMs,
                                  accuracyScore: state.summary!.accuracyScore,
                                  videoTitle: widget.videoTitle,
                                  youtubeVideoId: widget.youtubeVideoId,
                                ),
                              );
                            }
                          },
                        ),

                        // 5. Navigation Action Buttons
                        ResultActionButtons(
                          exercise: widget.exercise,
                          youtubeVideoId: widget.youtubeVideoId,
                          videoTitle: widget.videoTitle,
                          exerciseType: widget.exerciseType,
                          isDailyChallenge: widget.isDailyChallenge,
                          onPracticeAgain: widget.onPracticeAgain,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),

              // Confetti Overlay: Star particles falling rapidly and evenly across the top
              CelebrationConfettiOverlay(
                shouldPlay: shouldPlayConfetti,
              ),
            ],
          );
        },
      ),
    );
  }
}
