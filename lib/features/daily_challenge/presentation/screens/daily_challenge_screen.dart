import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/core/routes/app_router.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import '../../domain/entities/daily_challenge_config_entity.dart';
import '../bloc/daily_challenge_bloc.dart';
import '../bloc/daily_challenge_event.dart';
import '../bloc/daily_challenge_state.dart';
import '../widgets/daily_challenge_header.dart';
import '../widgets/daily_challenge_join_button.dart';
import '../widgets/daily_challenge_leaderboard.dart';
import '../widgets/daily_challenge_skeleton.dart';
import '../widgets/daily_challenge_streak_card.dart';
import '../widgets/daily_challenge_video_card.dart';

class DailyChallengeScreen extends StatelessWidget {
  final DailyChallengeResponseEntity? initialConfig;

  const DailyChallengeScreen({super.key, this.initialConfig});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DailyChallengeBloc>()
            ..add(LoadDailyChallenge(initialConfig: initialConfig)),
      child: const _DailyChallengeView(),
    );
  }
}

class _DailyChallengeView extends StatelessWidget {
  const _DailyChallengeView();

  void _onJoinNow(
    BuildContext context,
    DailyChallengeResponseEntity? configResponse,
  ) {
    final config = configResponse?.config;
    if (config == null) return;

    // Navigate to exercise screen with challenge video info
    context.pushToExercise(
      videoId: config.videoSlug,
      videoTitle: config.videoTitle,
      cefrLevel: config.cefrLevel.isNotEmpty ? config.cefrLevel : 'B2',
      versionId: config.exerciseVersion.isNotEmpty
          ? config.exerciseVersion
          : 'v1',
      youtubeVideoId: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<DailyChallengeBloc, DailyChallengeState>(
        builder: (context, state) {
          if (state is DailyChallengeLoading && state.cachedConfig == null) {
            return const DailyChallengeSkeleton();
          }


          if (state is DailyChallengeError && state.cachedConfig == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: AppTextStyles.custom(
                        color: colors.textSecondary,
                        fontSize: AppFontSize.md,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DailyChallengeBloc>().add(
                          const RefreshDailyChallenge(),
                        );
                      },
                      child: Text(l10n?.homeRetry ?? 'Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          DailyChallengeResponseEntity? configResponse;
          if (state is DailyChallengeLoaded) {
            configResponse = state.configResponse;
          } else if (state is DailyChallengeLoading) {
            configResponse = state.cachedConfig;
          } else if (state is DailyChallengeError) {
            configResponse = state.cachedConfig;
          }

          final config = configResponse?.config;
          final leaderboard = state is DailyChallengeLoaded
              ? state.leaderboard
              : [];
          final streak = state is DailyChallengeLoaded ? state.streak : null;
          final isScreenLoading = state is DailyChallengeLoading;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DailyChallengeBloc>().add(
                const RefreshDailyChallenge(),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg2),

                  // 1. Header (Title, Trophy, Timer)
                  DailyChallengeHeader(resetAt: configResponse?.resetAt),
                  const SizedBox(height: AppSpacing.lg),

                  // 2. Video Card
                  DailyChallengeVideoCard(
                    config: config,
                    participantCount: configResponse?.participantCount ?? 0,
                  ),
                  const SizedBox(height: AppSpacing.lg2),

                  // 3. Join Button
                  DailyChallengeJoinButton(
                    onTap: () => _onJoinNow(context, configResponse),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 4. Leaderboard Section
                  DailyChallengeLeaderboard(
                    leaderboard: leaderboard.cast(),
                    isLoading: isScreenLoading,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // 5. Streak Card
                  DailyChallengeStreakCard(
                    streak: streak,
                    isLoading: isScreenLoading,
                  ),

                  // 6. Padding bottom for Floating action / Bottom Nav
                  const SizedBox(height: AppSpacing.xl9),
                ],
              ),
            ),
          );

        },
      ),
    );
  }
}
