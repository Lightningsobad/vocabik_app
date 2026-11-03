import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_daily_challenge_bloc.dart';
import '../bloc/home_daily_challenge_state.dart';
import 'daily_challenge_banner.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDailyChallengeBloc, HomeDailyChallengeState>(
      builder: (context, state) {
        if (state is HomeDailyChallengeLoaded) {
          if (!state.response.challengeConfigured) {
            return const SizedBox.shrink();
          }
          return DailyChallengeBanner(
            response: state.response,
          );
        }

        if (state is HomeDailyChallengeLoading) {
          return const DailyChallengeBanner(
            response: null,
          );
        }

        return const DailyChallengeBanner(
          response: null,
        );
      },
    );
  }
}
