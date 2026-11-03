import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/also_for_you_shimmer.dart';
import 'package:vocabik_app/features/home/presentation/widgets/also_for_you_video_card.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class HomeRecommendedSection extends StatelessWidget {
  const HomeRecommendedSection({super.key});

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
            title: l10n.homeRecommendedTitle,
            size: SectionHeaderSize.small,
          ),
          BlocBuilder<HomePersonalizedBloc, HomePersonalizedState>(
            buildWhen: (prev, curr) {
              if (prev is HomePersonalizedLoaded &&
                  curr is HomePersonalizedLoaded) {
                return prev.slots != curr.slots;
              }
              return prev.runtimeType != curr.runtimeType;
            },
            builder: (context, state) {
              if (state is HomePersonalizedLoading ||
                  state is HomePersonalizedInitial) {
                return const AlsoForYouShimmer();
              }

              if (state is HomePersonalizedError) {
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
              }

              if (state is HomePersonalizedLoaded) {
                if (state.slots.isEmpty) {
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
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: state.slots
                        .map(
                          (slot) => AlsoForYouVideoCard(
                            key: ValueKey(slot.videoId),
                            slot: slot,
                          ),
                        )
                        .toList(),
                  ),
                );
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
