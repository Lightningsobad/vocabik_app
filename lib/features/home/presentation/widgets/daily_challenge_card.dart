import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

import '../bloc/home_daily_challenge_bloc.dart';
import '../bloc/home_daily_challenge_event.dart';
import '../bloc/home_daily_challenge_state.dart';
import 'daily_challenge_banner.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeDailyChallengeBloc, HomeDailyChallengeState>(
      builder: (context, state) {
        if (state is HomeDailyChallengeLoaded) {
          if (!state.response.challengeConfigured) {
            return const SizedBox.shrink();
          }
          return DailyChallengeBanner(response: state.response);
        }

        if (state is HomeDailyChallengeError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homeVideosError,
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: () => context
                        .read<HomeDailyChallengeBloc>()
                        .add(const FetchHomeDailyChallenge()),
                    child: Text(l10n.homeRetry),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AppShimmer(
            child: Container(
              height: 76,
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
          ),
        );
      },
    );
  }
}
