import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

import '../../domain/entities/leaderboard_response_entity.dart';
import '../cubit/xp_leaderboard_cubit.dart';
import '../cubit/xp_leaderboard_state.dart';
import '../widgets/xp_leaderboard_filters.dart';
import '../widgets/xp_leaderboard_header.dart';
import '../widgets/xp_leaderboard_list.dart';
import '../widgets/xp_leaderboard_my_rank_card.dart';

class XpLeaderboardScreen extends StatelessWidget {
  const XpLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<XpLeaderboardCubit>()..loadLeaderboard(),
      child: const _XpLeaderboardView(),
    );
  }
}

class _XpLeaderboardView extends StatelessWidget {
  const _XpLeaderboardView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<XpLeaderboardCubit, XpLeaderboardState>(
        builder: (context, state) {
          if (state is XpLeaderboardError && state.cachedData == null) {
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
                        context.read<XpLeaderboardCubit>().loadLeaderboard(
                              isRefresh: true,
                            );
                      },
                      child: Text(l10n?.homeRetry ?? 'Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          LeaderboardResponseEntity? data;
          String selectedPeriod = 'this_week';
          String selectedScope = 'global';
          bool isLoading = false;

          if (state is XpLeaderboardLoaded) {
            data = state.data;
            selectedPeriod = state.selectedPeriod;
            selectedScope = state.selectedScope;
          } else if (state is XpLeaderboardLoading) {
            data = state.cachedData;
            selectedPeriod = state.selectedPeriod;
            selectedScope = state.selectedScope;
            isLoading = true;
          } else if (state is XpLeaderboardError) {
            data = state.cachedData;
            selectedPeriod = state.selectedPeriod;
            selectedScope = state.selectedScope;
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<XpLeaderboardCubit>().loadLeaderboard(
                    isRefresh: true,
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // 1. Header (Title & Countdown timer)
                  XpLeaderboardHeader(nextResetAt: data?.nextResetAt),
                  const SizedBox(height: AppSpacing.lg),

                  // 2. Filters (Period & Scope)
                  XpLeaderboardFilters(
                    selectedPeriod: selectedPeriod,
                    selectedScope: selectedScope,
                    onPeriodChanged: (newPeriod) {
                      context.read<XpLeaderboardCubit>().loadLeaderboard(
                            period: newPeriod,
                          );
                    },
                    onScopeChanged: (newScope) {
                      context.read<XpLeaderboardCubit>().loadLeaderboard(
                            scope: newScope,
                          );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg2),

                  // 3. My Rank Card
                  if (data?.ownRank != null) ...[
                    XpLeaderboardMyRankCard(
                      ownRank: data?.ownRank,
                      totalParticipants: data?.totalParticipants,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // 4. Leaderboard Entries and Surrounding List
                  XpLeaderboardList(
                    entries: data?.entries ?? [],
                    surrounding: data?.surrounding,
                    isLoading: isLoading && data == null,
                  ),

                  // 5. Bottom spacing for Bottom Nav Bar
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
