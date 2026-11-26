import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_video_grid_sliver.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class HomeLibrarySection extends StatelessWidget {
  const HomeLibrarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return SliverMainAxisGroup(
      slivers: [
        // 1. Header (isolated rebuild via BlocSelector for video count)
        SliverToBoxAdapter(
          child: BlocSelector<HomeVideosBloc, HomeVideosState, int>(
            selector: (state) {
              if (state is HomeVideosLoaded) {
                return state.totalItems;
              }
              return 0;
            },
            builder: (context, count) {
              return SectionHeader(
                title: l10n.homeLibrary,
                actionText: count > 0 ? '$count videos' : null,
                actionTextColor: colors.textSecondary,
                size: SectionHeaderSize.medium,
              );
            },
          ),
        ),

        // 2. Content (Loading / Error / Empty / Grid)
        BlocBuilder<HomeVideosBloc, HomeVideosState>(
          builder: (context, state) {
            final isLoading =
                state is HomeVideosInitial || state is HomeVideosLoading;
            final hasError = state is HomeVideosError;
            final videos = state is HomeVideosLoaded
                ? state.videos
                : const <VideoEntity>[];
            final isLoadingMore =
                state is HomeVideosLoaded && state.isLoadingMore;
            final loadMoreError = state is HomeVideosLoaded
                ? state.loadMoreError
                : null;

            return SharedVideoGridSliver(
              isLoading: isLoading,
              hasError: hasError,
              videos: videos,
              isLoadingMore: isLoadingMore,
              loadMoreError: loadMoreError,
              emptyText: l10n.emptyVideos,
              onRetry: () {
                context.read<HomeVideosBloc>().add(const FetchVideos());
              },
              onLoadMoreRetry: () {
                context.read<HomeVideosBloc>().add(const FetchVideos());
              },
            );
          },
        ),
      ],
    );
  }
}
