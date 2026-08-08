import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/discover/presentation/models/discover_mock_data.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_search_input.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/playlist_card.dart';
import 'package:vocabik_app/features/home/presentation/models/home_mock_data.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _searchQuery = '';
  int _selectedLevelIndex = 0;
  int _selectedGenreIndex = 0;
  int _selectedTimeIndex = 0;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading for shimmer effect
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  bool get _isSearchingOrFiltering {
    return _searchQuery.isNotEmpty || 
           _selectedLevelIndex != 0 || 
           _selectedGenreIndex != 0 || 
           _selectedTimeIndex != 0;
  }

  List<MockCourseModel> _getFilteredCourses(List<String> levels, List<String> genres) {
    var courses = DiscoverMockData.allCourses;
    
    // Remove duplicates since we concatenated them
    final uniqueCourses = <String, MockCourseModel>{};
    for (var c in courses) {
      uniqueCourses[c.title] = c;
    }
    courses = uniqueCourses.values.toList();

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      courses = courses.where((c) {
        return c.title.toLowerCase().contains(query) || 
               c.subtitle.toLowerCase().contains(query);
      }).toList();
    }

    if (_selectedLevelIndex > 0) {
      final level = levels[_selectedLevelIndex];
      courses = courses.where((c) => c.level == level).toList();
    }

    if (_selectedGenreIndex > 0) {
      final genre = genres[_selectedGenreIndex];
      courses = courses.where((c) => c.category == genre).toList();
    }
    
    // Time filter logic omitted for simplicity in mock, 
    // but in real app would parse 'MM:SS' and compare.

    return courses;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final levels = [l10n.discoverFilterAll, 'A1', 'A2', 'B1', 'B2', 'C1'];
    final genres = [l10n.discoverFilterAll, 'Pop', 'Rap', 'Acoustic', 'Talk'];
    final times = [l10n.discoverTimeUnder3, l10n.discoverTime3To7, l10n.discoverTimeOver7, 'MC'];

    final filteredCourses = _getFilteredCourses(levels, genres);

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            _isLoading = false;
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              
              // 1. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: DiscoverSearchInput(
                  initialValue: _searchQuery,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // 2. Filters
              SharedSegmentedTabBar(
                selectedIndex: _selectedLevelIndex,
                onTabChanged: (index) {
                  setState(() => _selectedLevelIndex = index);
                },
                tabs: levels,
              ),
              const SizedBox(height: AppSpacing.sm),
              SharedSegmentedTabBar(
                selectedIndex: _selectedGenreIndex,
                onTabChanged: (index) {
                  setState(() => _selectedGenreIndex = index);
                },
                tabs: genres,
              ),
              const SizedBox(height: AppSpacing.sm),
              SharedSegmentedTabBar(
                selectedIndex: _selectedTimeIndex,
                onTabChanged: (index) {
                  setState(() => _selectedTimeIndex = index);
                },
                tabs: times,
              ),
              
              const SizedBox(height: AppSpacing.lg),

              // Content Area
              if (_isSearchingOrFiltering)
                _buildSearchResults(colors, l10n, filteredCourses)
              else
                _buildDefaultContent(l10n),
                
              const SizedBox(height: 80), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(AppColorsExtension colors, AppLocalizations l10n, List<MockCourseModel> courses) {
    final resultText = _searchQuery.isNotEmpty 
        ? l10n.discoverSearchResultsWithQuery(courses.length, _searchQuery)
        : l10n.discoverSearchResults(courses.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              resultText,
              style: GoogleFonts.nunito(
                color: colors.textSecondary,
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (courses.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl4),
                child: Text(
                  'No results found',
                  style: GoogleFonts.nunito(color: colors.textSecondary),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.7, // Matching home screen library aspect ratio
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return SharedCourseCard(
                  video: courses[index].toEntity(),
                  isLoading: _isLoading,
                  width: double.infinity,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trending Section
        SectionHeader(
          title: l10n.discoverTrendingTitle,
          size: SectionHeaderSize.medium,
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: DiscoverMockData.trendingCourses.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              return SharedCourseCard(
                video: DiscoverMockData.trendingCourses[index].toEntity(),
                isLoading: _isLoading,
              );
            },
          ),
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Pop B1 Category Section (Demo)
        const SectionHeader(
          title: 'Pop · B1',
          size: SectionHeaderSize.medium,
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: DiscoverMockData.categoryCourses.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              return SharedCourseCard(
                video: DiscoverMockData.categoryCourses[index].toEntity(),
                isLoading: _isLoading,
              );
            },
          ),
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Playlists
        SectionHeader(
          title: l10n.discoverPlaylistTitle,
          size: SectionHeaderSize.medium,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: DiscoverMockData.playlists.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            return PlaylistCard(
              playlist: DiscoverMockData.playlists[index],
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}
