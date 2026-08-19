import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_video_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

class HomeTrendingSection extends StatelessWidget {
  const HomeTrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeTrendingBloc, HomeTrendingState>(
      buildWhen: (prev, curr) {
        if (prev is HomeTrendingLoaded && curr is HomeTrendingLoaded) {
          return prev.videos != curr.videos;
        }
        return prev.runtimeType != curr.runtimeType;
      },
      builder: (context, state) {
        final isLoading = state is HomeTrendingLoading || state is HomeTrendingInitial;
        final videos = state is HomeTrendingLoaded ? state.videos : const <VideoEntity>[];

        return HomeVideoSection(
          title: l10n.homeTrending,
          iconAsset: 'assets/home_screen/streak_icon.svg',
          actionText: l10n.homeViewAll,
          onActionTap: () {},
          isLoading: isLoading,
          videos: videos,
          emptyText: l10n.emptySectionText,
        );
      },
    );
  }
}
