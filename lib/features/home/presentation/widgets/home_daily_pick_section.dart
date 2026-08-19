import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_pick_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_pick_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_pick_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/daily_pick_card.dart';
import 'package:vocabik_app/features/home/presentation/widgets/daily_pick_card_shimmer.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class HomeDailyPickSection extends StatelessWidget {
  const HomeDailyPickSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            title: l10n.homeDailyPickTitle,
            iconAsset: 'assets/home_screen/sun.svg',
            size: SectionHeaderSize.large,
          ),
          BlocBuilder<HomeDailyPickBloc, HomeDailyPickState>(
            buildWhen: (prev, curr) {
              if (prev is HomeDailyPickLoaded && curr is HomeDailyPickLoaded) {
                return prev.dailyPick != curr.dailyPick;
              }
              return prev.runtimeType != curr.runtimeType;
            },
            builder: (context, state) {
              if (state is HomeDailyPickLoading || state is HomeDailyPickInitial) {
                return const DailyPickCardShimmer();
              }

              if (state is HomeDailyPickError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Container(
                    height: 140,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.homeVideosError,
                          style: TextStyle(color: colors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ElevatedButton(
                          onPressed: () => context
                              .read<HomeDailyPickBloc>()
                              .add(const FetchDailyPick()),
                          child: Text(l10n.homeRetry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is HomeDailyPickLoaded) {
                return DailyPickCard(dailyPick: state.dailyPick);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Center(
                  child: Text(
                    l10n.emptySectionText,
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
