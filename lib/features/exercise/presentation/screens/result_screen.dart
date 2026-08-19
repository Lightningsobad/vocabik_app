import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/result_state.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/result_gamification_cards.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/result_stats_section.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/result_wrong_answers.dart';
import 'package:vocabik_app/features/exercise/presentation/widgets/score_card_share_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class ResultScreen extends StatelessWidget {
  final ExerciseEntity exercise;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> checkResults;
  final int durationMs;
  final VoidCallback? onPracticeAgain;

  const ResultScreen({
    super.key,
    required this.exercise,
    required this.selectedAnswers,
    required this.checkResults,
    required this.durationMs,
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
        ),
      child: ResultScreenView(
        exercise: exercise,
        onPracticeAgain: onPracticeAgain,
      ),
    );
  }
}

class ResultScreenView extends StatefulWidget {
  final ExerciseEntity exercise;
  final VoidCallback? onPracticeAgain;

  const ResultScreenView({
    super.key,
    required this.exercise,
    this.onPracticeAgain,
  });

  @override
  State<ResultScreenView> createState() => _ResultScreenViewState();
}

class _ResultScreenViewState extends State<ResultScreenView> {
  late ConfettiController _confettiController;
  bool _confettiPlayed = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Path _drawStar(Size size) {
    // 5-pointed star path generator
    final path = Path();
    final double max = min(size.width, size.height);
    final double half = max / 2;
    final double innerRadius = half * 0.4;
    final double outerRadius = half;
    final double angle = pi / 5;

    for (int i = 0; i < 10; i++) {
      final double r = i.isEven ? outerRadius : innerRadius;
      final double x = half + r * sin(i * angle);
      final double y = half - r * cos(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          SafeArea(
            child: BlocConsumer<ResultCubit, ResultState>(
              listener: (context, state) {
                if (!state.isCalculating &&
                    state.summary != null &&
                    !_confettiPlayed) {
                  if (state.summary!.accuracyScore >= 80) {
                    _confettiPlayed = true;
                    _confettiController.play();
                  }
                }
              },
              builder: (context, state) {
                if (state.isCalculating || state.summary == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final summary = state.summary!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.sm),

                      // 1. Result Score Stats Section
                      ResultStatsSection(summary: summary),

                      // 2. XP, Streak, Badge Cards
                      ResultGamificationCards(
                        cefrLevel: widget.exercise.cefrLevel,
                      ),

                      // 3. What went wrong section
                      ResultWrongAnswers(wrongAnswers: summary.wrongAnswers),

                      // 4. Score Card and Share section
                      ScoreCardShareSection(
                        status: state.scoreCardStatus,
                        imageUrl: state.scoreCardImageUrl,
                        onRetry: () {
                          context.read<ResultCubit>().generateScoreCard(
                            videoId: widget.exercise.videoId,
                            cefrLevel: widget.exercise.cefrLevel,
                            accuracyScore: summary.accuracyScore,
                          );
                        },
                      ),

                      // 5. Navigation Action Buttons
                      // Next suggested exercise button
                      ElevatedButton(
                        onPressed: () {
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E2038),
                          foregroundColor: colors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: const Color(0xFF2C3050),
                              width: 1.5,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.resultNextSuggestedExercise,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Practice again button
                      OutlinedButton(
                        onPressed: () {
                          if (widget.onPracticeAgain != null) {
                            widget.onPracticeAgain!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: colors.surfaceCard,
                          foregroundColor: colors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(
                            color: colors.borderSubtle,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          l10n.resultPracticeAgain,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.tn),

                      // Back to library text button
                      TextButton(
                        onPressed: () {
                          context.go('/home');
                        },
                        child: Text(
                          l10n.resultBackToLibrary,
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                );
              },
            ),
          ),

          // Confetti Overlay: Star particles falling rapidly and evenly across the top
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Downward
              blastDirectionality: BlastDirectionality.directional,
              maxBlastForce: 25,
              minBlastForce: 12,
              emissionFrequency: 0.08,
              numberOfParticles: 25,
              gravity: 0.4, // Fast falling speed
              createParticlePath: _drawStar,
              colors: const [
                Color(0xFFFFD700), // Gold
                Color(0xFF00E5CC), // Cyan
                Color(0xFFFF4081), // Pink
                Color(0xFF7C4DFF), // Purple
                Color(0xFFFF9100), // Orange
              ],
            ),
          ),
        ],
      ),
    );
  }
}
