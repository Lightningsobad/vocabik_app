import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_bloc.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_event.dart';
import 'package:vocabik_app/features/home/presentation/bloc/home_videos_state.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_footer.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/features/home/presentation/widgets/today_progress_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeVideosBloc>()..add(const FetchVideos()),
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
    if (_isBottom) {
      final state = context.read<HomeVideosBloc>().state;
      if (state is HomeVideosLoaded && !state.hasReachedMax) {
        context.read<HomeVideosBloc>().add(const FetchVideos());
      } else if (state is HomeVideosInitial || state is HomeVideosError) {
        context.read<HomeVideosBloc>().add(const FetchVideos());
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
    
    final List<String> tags = [
      l10n.homeAll,
      'A1',
      'A2',
      'B1',
      'B2',
      'C1',
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeVideosBloc>().add(const RefreshVideos());
        },
        child: BlocBuilder<HomeVideosBloc, HomeVideosState>(
          builder: (context, state) {
            final isLoading = state is HomeVideosInitial || state is HomeVideosLoading;
            final hasError = state is HomeVideosError;
            final videos = state is HomeVideosLoaded ? state.videos : [];
            final hasReachedMax = state is HomeVideosLoaded ? state.hasReachedMax : true;
            final isEmpty = videos.isEmpty && !isLoading && !hasError;

            if (hasError && videos.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Icon(Icons.error_outline, size: 48, color: colors.textSecondary),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.homeVideosError,
                        style: TextStyle(color: colors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () => context.read<HomeVideosBloc>().add(const FetchVideos()),
                        child: Text(l10n.homeRetry),
                      ),
                    ],
                  ),
                ),
              );
            }

            return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                
                // 1. Daily Pick
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: l10n.homeDailyPickTitle,
                    size: SectionHeaderSize.large,
                  ),
                ),
                SliverToBoxAdapter(
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : videos.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                              child: SharedCourseCard(
                                video: videos.first,
                                width: double.infinity,
                              ),
                            )
                          : _EmptySection(text: l10n.emptySectionText),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                
                // 2. Recommended
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: l10n.homeRecommendedTitle,
                    size: SectionHeaderSize.small,
                  ),
                ),
                SliverToBoxAdapter(child: _EmptySection(text: l10n.emptySectionText)),
                
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                
                // 3. Today Progress
                const SliverToBoxAdapter(
                  child: TodayProgressCard(
                    completedLessons: 2,
                    totalLessons: 5,
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                
                // 4. Tag Filters
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<int>(
                    valueListenable: _selectedTabIndex,
                    builder: (context, index, child) {
                      return SharedSegmentedTabBar(
                        selectedIndex: index,
                        onTabChanged: (newIndex) {
                          _selectedTabIndex.value = newIndex;
                        },
                        tabs: tags,
                      );
                    },
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                
                // 5. Trending
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: l10n.homeTrending,
                    actionText: l10n.homeViewAll,
                    onActionTap: () {},
                    size: SectionHeaderSize.medium,
                  ),
                ),
                SliverToBoxAdapter(child: _EmptySection(text: l10n.emptySectionText)),
                
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                
                // 6. Recently Added
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: l10n.homeRecentlyAdded,
                    size: SectionHeaderSize.medium,
                  ),
                ),
                SliverToBoxAdapter(child: _EmptySection(text: l10n.emptySectionText)),
                
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                
                // 7. Library
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: l10n.homeLibrary,
                    size: SectionHeaderSize.medium,
                  ),
                ),
                
                if (isEmpty)
                  SliverToBoxAdapter(child: _EmptySection(text: l10n.homeVideosEmpty))
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return SharedCourseCard(
                            video: videos[index],
                            width: double.infinity,
                          );
                        },
                        childCount: videos.length,
                      ),
                    ),
                  ),
                
                if (state is HomeVideosLoaded && !hasReachedMax)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                
                // 8. Footer
                const SliverToBoxAdapter(child: HomeFooter()),
                
                // 9. Padding bottom for FAB
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String text;

  const _EmptySection({required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: colors.textSecondary),
        ),
      ),
    );
  }
}
