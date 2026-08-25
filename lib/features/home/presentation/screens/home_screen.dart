import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_pick_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_daily_pick_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_newly_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_personalized_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_trending_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/daily_challenge_card.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_daily_pick_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_footer.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_library_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_newly_added_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_recommended_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_trending_section.dart';
import 'package:vocabik_app/features/home/presentation/widgets/today_progress_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/enums/cefr_level.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<HomeVideosBloc>()..add(const FetchVideos()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<HomeDailyPickBloc>()..add(const FetchDailyPick()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<HomePersonalizedBloc>()
                ..add(const FetchPersonalizedSlots()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<HomeTrendingBloc>()..add(const FetchTrendingVideos()),
        ),
        BlocProvider(
          create: (_) => getIt<HomeNewlyBloc>()..add(const FetchNewlyVideos()),
        ),
      ],
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  final ValueNotifier<int> _selectedTabIndex = ValueNotifier<int>(0);
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedTabIndex.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_isBottom) {
      final state = context.read<HomeVideosBloc>().state;
      if (state is HomeVideosLoaded && !state.hasReachedMax) {
        _isFetchingMore = true;
        context.read<HomeVideosBloc>().add(const FetchVideos());
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _isFetchingMore = false;
          }
        });
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final List<String> tags =
        CefrLevel.values.map((level) => level.getLocalizedName(l10n)).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeVideosBloc>().add(const RefreshVideos());
          context.read<HomeDailyPickBloc>().add(const RefreshDailyPick());
          context.read<HomePersonalizedBloc>().add(
            const RefreshPersonalizedSlots(),
          );
          context.read<HomeTrendingBloc>().add(const RefreshTrendingVideos());
          context.read<HomeNewlyBloc>().add(const RefreshNewlyVideos());
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sm2),
            ),

            // 1. Daily Pick Section
            const HomeDailyPickSection(),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sm),
            ),

            // 2. Recommended / Also For You Section
            const HomeRecommendedSection(),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sm),
            ),

            // 3. Today Progress Card
            const SliverToBoxAdapter(
              child: TodayProgressCard(
                completedLessons: 2,
                totalLessons: 5,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),

            // 4. Tag Filters
            SliverToBoxAdapter(
              child: ValueListenableBuilder<int>(
                valueListenable: _selectedTabIndex,
                builder: (context, index, child) {
                  return SharedSegmentedTabBar(
                    selectedIndex: index,
                    onTabChanged: (newIndex) {
                      _selectedTabIndex.value = newIndex;
                      final cefrLevel = CefrLevel.fromIndex(newIndex);
                      context.read<HomeVideosBloc>().add(
                            ChangeCefrFilter(cefrLevel.code),
                          );
                      context.read<HomeTrendingBloc>().add(
                            ChangeTrendingCefrFilter(cefrLevel.code),
                          );
                    },
                    tabs: tags,
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),

            // 5. Daily Challenge
            const SliverToBoxAdapter(child: DailyChallengeCard()),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),

            // 6. Trending Section
            const HomeTrendingSection(),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),

            // 7. Recently Added (Newly added) Section
            const HomeNewlyAddedSection(),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),

            // 8. Library Section (Grid of all videos)
            const HomeLibrarySection(),

            // 9. Footer
            const SliverToBoxAdapter(child: HomeFooter()),

            // 10. Padding bottom for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
