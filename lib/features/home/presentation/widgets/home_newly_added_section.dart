import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_video_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

class HomeNewlyAddedSection extends StatelessWidget {
  const HomeNewlyAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeNewlyBloc, HomeNewlyState>(
      buildWhen: (prev, curr) {
        if (prev is HomeNewlyLoaded && curr is HomeNewlyLoaded) {
          return prev.videos != curr.videos;
        }
        return prev.runtimeType != curr.runtimeType;
      },
      builder: (context, state) {
        final isLoading = state is HomeNewlyLoading || state is HomeNewlyInitial;
        final videos = state is HomeNewlyLoaded ? state.videos : const <VideoEntity>[];

        return HomeVideoSection(
          title: l10n.homeRecentlyAdded,
          iconAsset: 'assets/home_screen/newly_icon.svg',
          isLoading: isLoading,
          videos: videos,
          emptyText: l10n.emptySectionText,
        );
      },
    );
  }
}
