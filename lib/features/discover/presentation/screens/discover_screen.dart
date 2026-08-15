import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_event.dart';
import 'package:vocabik_app/features/discover/presentation/bloc/discover_state.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_search_input.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'dart:async';

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
  int _selectedTimeIndex = 0;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  bool _isLoadingMore = false; // Guard: chặn scroll event gọi API nhiều lần

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
    if (_isLoadingMore) return;                         // Guard 1: đang chờ kết quả
    if (!_scrollController.hasClients) return;          // Guard 2: safety check
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 300) return; // Chưa đến cuối

    final state = context.read<DiscoverBloc>().state;
    if (state.status == DiscoverStatus.loading) return; // Guard 3: bloc đang loading
    if (state.hasReachedMax) return;                    // Guard 4: hết dữ liệu

    setState(() => _isLoadingMore = true);
    context.read<DiscoverBloc>().add(DiscoverVideosFetched());
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

    final levels = [l10n.discoverFilterAll, 'A1', 'A2', 'B1', 'B2', 'C1'];
    // Map CEFR values. Assuming API expects exactly 'A1', 'A2' etc, or empty/null for all
    final cefrValues = ['', 'A1', 'A2', 'B1', 'B2', 'C1'];

    final genres = [l10n.discoverFilterAll, 'Pop', 'Rap', 'Acoustic', 'Talk'];
    final genreValues = ['', 'Pop', 'Rap', 'Acoustic', 'Talk'];

    final times = [l10n.discoverFilterAll, l10n.discoverTimeUnder3, l10n.discoverTime3To7, l10n.discoverTimeOver7, l10n.discoverFilter7Days];
    final windowValues = ['', '', '', '', '7d']; // API `window` value
    final durationValues = ['', '<3', '3-7', '>7', '']; // Local filter values (backlog)

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DiscoverBloc>().add(DiscoverRefreshRequested());
        },
        // BlocListener: reset _isLoadingMore khi load more hoàn tất (C-1 + C-2)
        child: BlocListener<DiscoverBloc, DiscoverState>(
          listenWhen: (prev, curr) =>
              prev.status == DiscoverStatus.loading &&
              (curr.status == DiscoverStatus.success ||
                  curr.status == DiscoverStatus.failure),
          listener: (context, state) {
            if (_isLoadingMore) {
              setState(() => _isLoadingMore = false);
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header tĩnh: search + filters — KHÔNG rebuild khi bloc state thay đổi
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: DiscoverSearchInput(
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Filters
                    SharedSegmentedTabBar(
                      selectedIndex: _selectedLevelIndex,
                      onTabChanged: (index) {
                        setState(() => _selectedLevelIndex = index);
                        context.read<DiscoverBloc>().add(DiscoverFilterChanged(
                              cefr: cefrValues[index],
                            ));
                      },
                      tabs: levels,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SharedSegmentedTabBar(
                      selectedIndex: _selectedGenreIndex,
                      onTabChanged: (index) {
                        setState(() => _selectedGenreIndex = index);
                        context.read<DiscoverBloc>().add(DiscoverFilterChanged(
                              genre: genreValues[index],
                            ));
                      },
                      tabs: genres,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SharedSegmentedTabBar(
                      selectedIndex: _selectedTimeIndex,
                      onTabChanged: (index) {
                        setState(() => _selectedTimeIndex = index);
                        context.read<DiscoverBloc>().add(DiscoverFilterChanged(
                              window: windowValues[index],
                              duration: durationValues[index],
                            ));
                      },
                      tabs: times,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),

              // Phần content động: chỉ BlocBuilder này rebuild khi state thay đổi
              BlocBuilder<DiscoverBloc, DiscoverState>(
                buildWhen: (prev, curr) =>
                    prev.status != curr.status ||
                    prev.displayedVideos != curr.displayedVideos ||
                    prev.searchQuery != curr.searchQuery,
                builder: (context, state) {
                  // Trạng thái loading ban đầu (chưa có dữ liệu)
                  if (state.status == DiscoverStatus.initial ||
                      (state.status == DiscoverStatus.loading &&
                          state.displayedVideos.isEmpty)) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl4),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  // Trạng thái lỗi không có dữ liệu
                  if (state.status == DiscoverStatus.failure &&
                      state.displayedVideos.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl4),
                          child: Column(
                            children: [
                              Text(
                                l10n.discoverErrorLoad,
                                style: GoogleFonts.nunito(color: colors.textSecondary),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              BounceWrapper(
                                onTap: () {
                                  context
                                      .read<DiscoverBloc>()
                                      .add(DiscoverRefreshRequested());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.lg,
                                      vertical: AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: colors.primaryAccent,
                                    borderRadius:
                                        BorderRadius.circular(999.0),
                                  ),
                                  child: Text(
                                    l10n.discoverRetryButton,
                                    style: GoogleFonts.nunito(
                                        color: colors.onPrimaryAccent,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // Trạng thái có dữ liệu (success hoặc loading thêm trang)
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: Text(
                              state.searchQuery.isNotEmpty
                                  ? l10n.discoverSearchResultsWithQuery(
                                      state.displayedVideos.length,
                                      state.searchQuery)
                                  : l10n.discoverSearchResults(
                                      state.displayedVideos.length),
                              style: GoogleFonts.nunito(
                                color: colors.textSecondary,
                                fontSize: AppFontSize.md,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        if (state.displayedVideos.isEmpty)
                          SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.xl4),
                                child: Text(
                                  l10n.discoverEmptyResult,
                                  style: GoogleFonts.nunito(
                                      color: colors.textSecondary),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppSpacing.md,
                              mainAxisSpacing: AppSpacing.md,
                              childAspectRatio: 0.7,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return SharedCourseCard(
                                  video: state.displayedVideos[index],
                                  isLoading: false,
                                  width: double.infinity,
                                );
                              },
                              childCount: state.displayedVideos.length,
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: true,
                            ),
                          ),
                        if (state.status == DiscoverStatus.loading &&
                            state.displayedVideos.isNotEmpty)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.lg),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
                      ],
                    ),
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
