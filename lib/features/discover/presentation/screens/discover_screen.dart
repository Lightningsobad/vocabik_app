import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/presentation/utils/scroll_pagination_extension.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_video_grid_sliver.dart';
import 'package:vocabik_app/shared/presentation/widgets/notifications/app_snack_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
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
  final ScrollController _scrollController = ScrollController();
  int _selectedLevelIndex = 0;
  String _selectedDuration = '';
  String _selectedExerciseType = '';
  Timer? _debounce;

  static const List<String> _cefrValues = ['', 'A1', 'A2', 'B1', 'B2', 'C1'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.isNearPrefetchThreshold) return;
    final state = context.read<DiscoverBloc>().state;
    if (state.searchQuery.isNotEmpty &&
        state.status == DiscoverStatus.success &&
        !state.hasReachedMax &&
        !state.isLoadingMore &&
        state.loadMoreError == null) {
      context.read<DiscoverBloc>().add(DiscoverVideosFetched());
    }
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
      body: BlocListener<DiscoverBloc, DiscoverState>(
        listenWhen: (previous, current) =>
            current.refreshError != null &&
            previous.refreshErrorId != current.refreshErrorId,
        listener: (context, state) {
          AppSnackBar.showError(
            context,
            l10n.homeVideosError,
            action: TextButton(
              onPressed: () {
                if (!mounted) return;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                context.read<DiscoverBloc>().add(
                  const DiscoverRefreshRequested(),
                );
              },
              child: Text(l10n.discoverRetryButton),
            ),
          );
        },
        child: RefreshIndicator(
          onRefresh: () async {
            final completer = Completer<void>();
            context.read<DiscoverBloc>().add(
              DiscoverRefreshRequested(completer: completer),
            );
            await completer.future;
          },
          child: CustomScrollView(
            controller: _scrollController,
            scrollCacheExtent: const ScrollCacheExtent.pixels(600),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Filter Section (Search Bar + Tabs + Chips)
              BlocSelector<
                DiscoverBloc,
                DiscoverState,
                ({List<VideoCategoryEntity> categories, String genre})
              >(
                selector: (state) =>
                    (categories: state.categories, genre: state.genre),
                builder: (context, filterData) {
                  return DiscoverFilterSection(
                    onSearchChanged: _onSearchChanged,
                    selectedLevelIndex: _selectedLevelIndex,
                    onLevelIndexChanged: (index) {
                      setState(() => _selectedLevelIndex = index);
                      context.read<DiscoverBloc>().add(
                        DiscoverFilterChanged(cefr: _cefrValues[index]),
                      );
                    },
                    categories: filterData.categories,
                    selectedGenre: filterData.genre,
                    onGenreChanged: (genreSlug) {
                      context.read<DiscoverBloc>().add(
                        DiscoverFilterChanged(genre: genreSlug),
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
                        DiscoverFilterChanged(
                          exerciseType: _selectedExerciseType,
                        ),
                      );
                    },
                  );
                },
              ),

              // 2. Search Mode (count + 2-column grid) or Browse Mode
              BlocBuilder<DiscoverBloc, DiscoverState>(
                builder: (context, state) {
                  final isLibraryLoading =
                      state.status == DiscoverStatus.loading ||
                      state.status == DiscoverStatus.initial;

                  if (state.searchQuery.isNotEmpty) {
                    return SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _SearchResultCountHeader(
                            totalCount: state.totalItems,
                            query: state.searchQuery,
                            isHidden:
                                (isLibraryLoading ||
                                    state.status == DiscoverStatus.failure) &&
                                state.displayedVideos.isEmpty,
                          ),
                        ),
                        SharedVideoGridSliver(
                          isLoading: isLibraryLoading,
                          hasError: state.status == DiscoverStatus.failure,
                          videos: state.displayedVideos,
                          isLoadingMore: state.isLoadingMore,
                          loadMoreError: state.loadMoreError,
                          emptyText: l10n.discoverEmptyResult,
                          onRetry: () {
                            context.read<DiscoverBloc>().add(
                              DiscoverVideosFetched(),
                            );
                          },
                          onLoadMoreRetry: () {
                            context.read<DiscoverBloc>().add(
                              DiscoverVideosFetched(),
                            );
                          },
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
                      ],
                    );
                  }

                  // Browse Mode Error State
                  if (state.status == DiscoverStatus.failure &&
                      state.displayedVideos.isEmpty &&
                      state.trendingVideos.isEmpty &&
                      state.playlists.isEmpty) {
                    return DiscoverErrorState(
                      onRetry: () {
                        context.read<DiscoverBloc>().add(
                          const DiscoverRefreshRequested(),
                        );
                      },
                    );
                  }

                  final languageCode = Localizations.localeOf(
                    context,
                  ).languageCode;
                  String? selectedGenreLabel;
                  if (state.genre.isNotEmpty) {
                    for (final category in state.categories) {
                      if (category.slug == state.genre) {
                        selectedGenreLabel = category.localizedShortLabel(
                          languageCode,
                        );
                        break;
                      }
                    }
                  }

                  final libraryTitle = l10n.getDiscoverLibraryTitle(
                    genre: state.genre,
                    cefr: state.cefr,
                    genreLabel: selectedGenreLabel,
                  );

                  final isTrendingLoading =
                      state.trendingStatus == DiscoverStatus.loading ||
                      state.trendingStatus == DiscoverStatus.initial;
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
                        isLoadingMore: state.isLoadingMore,
                        loadMoreError: state.loadMoreError,
                        hasError: state.status == DiscoverStatus.failure,
                        videos: state.displayedVideos,
                        hasReachedMax: state.hasReachedMax,
                        emptyText: l10n.emptyVideos,
                        onLoadMore: () {
                          context.read<DiscoverBloc>().add(
                            DiscoverVideosFetched(),
                          );
                        },
                        onRetry: () {
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

                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultCountHeader extends StatelessWidget {
  final int totalCount;
  final String query;
  final bool isHidden;

  const _SearchResultCountHeader({
    required this.totalCount,
    required this.query,
    required this.isHidden,
  });

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return const SizedBox(height: AppSpacing.md);
    }

    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    final fullText = l10n.discoverSearchResultsWithQuery(totalCount, query);
    final countStr = '$totalCount';
    final countIndex = fullText.indexOf(countStr);

    final baseStyle = TextStyle(
      fontSize: AppFontSize.md,
      color: colors.textSecondary,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: countIndex == -1
          ? Text(fullText, style: baseStyle)
          : Text.rich(
              TextSpan(
                style: baseStyle,
                children: [
                  TextSpan(text: fullText.substring(0, countIndex)),
                  TextSpan(
                    text: countStr,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: fullText.substring(countIndex + countStr.length),
                  ),
                ],
              ),
            ),
    );
  }
}
