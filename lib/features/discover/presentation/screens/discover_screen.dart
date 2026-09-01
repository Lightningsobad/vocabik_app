import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_event.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_state.dart';
import 'package:vocabik_app/features/discover/presentation/utils/discover_l10n_extension.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_error_state.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_filter_section.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_horizontal_library_section.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_playlist_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_video_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DiscoverBloc>()..add(DiscoverVideosFetched()),
      child: const DiscoverScreenView(),
    );
  }
}

class DiscoverScreenView extends StatefulWidget {
  const DiscoverScreenView({super.key});

  @override
  State<DiscoverScreenView> createState() => _DiscoverScreenViewState();
}

class _DiscoverScreenViewState extends State<DiscoverScreenView> {
  int _selectedLevelIndex = 0;
  int _selectedGenreIndex = 0;
  String _selectedDuration = '';
  String _selectedExerciseType = '';
  Timer? _debounce;

  static const List<String> _cefrValues = ['', 'A1', 'A2', 'B1', 'B2', 'C1'];
  static const List<String> _genreValues = [
    '',
    'music',
    'vlog',
    'news',
    'education',
    'entertainment',
    'ted_talks',
    'news_english',
    'other',
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<DiscoverBloc>().add(DiscoverSearchQueryChanged(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DiscoverBloc>().add(DiscoverRefreshRequested());
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Filter Section (Search Bar + Tabs + Chips)
            DiscoverFilterSection(
              onSearchChanged: _onSearchChanged,
              selectedLevelIndex: _selectedLevelIndex,
              onLevelIndexChanged: (index) {
                setState(() => _selectedLevelIndex = index);
                context.read<DiscoverBloc>().add(
                  DiscoverFilterChanged(cefr: _cefrValues[index]),
                );
              },
              selectedGenreIndex: _selectedGenreIndex,
              onGenreIndexChanged: (index) {
                setState(() => _selectedGenreIndex = index);
                context.read<DiscoverBloc>().add(
                  DiscoverFilterChanged(genre: _genreValues[index]),
                );
              },
              selectedDuration: _selectedDuration,
              onDurationChanged: (duration) {
                setState(() => _selectedDuration = duration);
                context.read<DiscoverBloc>().add(
                  DiscoverFilterChanged(duration: _selectedDuration),
                );
              },
              selectedExerciseType: _selectedExerciseType,
              onExerciseTypeChanged: (type) {
                setState(() => _selectedExerciseType = type);
                context.read<DiscoverBloc>().add(
                  DiscoverFilterChanged(exerciseType: _selectedExerciseType),
                );
              },
            ),

            // 2. Content Sections (Trending + Library) or Error State
            BlocBuilder<DiscoverBloc, DiscoverState>(
              builder: (context, state) {
                // Error State
                if (state.status == DiscoverStatus.failure &&
                    state.displayedVideos.isEmpty &&
                    state.trendingVideos.isEmpty &&
                    state.playlists.isEmpty) {
                  return DiscoverErrorState(
                    onRetry: () {
                      context.read<DiscoverBloc>().add(
                        DiscoverRefreshRequested(),
                      );
                    },
                  );
                }

                final libraryTitle = l10n.getDiscoverLibraryTitle(
                  genre: state.genre,
                  cefr: state.cefr,
                );

                final isTrendingLoading =
                    state.trendingStatus == DiscoverStatus.loading ||
                    state.trendingStatus == DiscoverStatus.initial;
                final isLibraryLoading =
                    state.status == DiscoverStatus.loading ||
                    state.status == DiscoverStatus.initial;
                final isPlaylistLoading =
                    state.playlistStatus == DiscoverStatus.loading ||
                    state.playlistStatus == DiscoverStatus.initial;

                return SliverMainAxisGroup(
                  slivers: [
                    // 1. Trending Section
                    HomeVideoSection(
                      title: l10n.discoverTrendingTitle,
                      iconAsset: 'assets/home_screen/streak_icon.svg',
                      isLoading: isTrendingLoading,
                      videos: state.trendingVideos,
                      emptyText: l10n.emptyVideos,
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.lg),
                    ),

                    // 2. Library Section (Horizontal List with dynamic title and pagination)
                    DiscoverHorizontalLibrarySection(
                      title: libraryTitle,
                      isLoading: isLibraryLoading,
                      videos: state.displayedVideos,
                      hasReachedMax: state.hasReachedMax,
                      emptyText: l10n.emptyVideos,
                      onLoadMore: () {
                        context.read<DiscoverBloc>().add(
                          DiscoverVideosFetched(),
                        );
                      },
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.lg),
                    ),

                    // 3. Curated Playlists Section
                    DiscoverPlaylistSection(
                      title: l10n.discoverPlaylistTitle,
                      isLoading: isPlaylistLoading,
                      playlists: state.playlists,
                      onPlaylistTap: (playlist) {
                        context.push('/discover/playlist/${playlist.slug}');
                      },
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
