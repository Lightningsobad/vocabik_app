import 'package:flutter/material.dart';
import 'package:vocabik_app/features/home/presentation/models/home_mock_data.dart';
import 'package:vocabik_app/features/home/presentation/widgets/daily_challenge_banner.dart';
import 'package:vocabik_app/features/home/presentation/widgets/daily_pick_card.dart';
import 'package:vocabik_app/features/home/presentation/widgets/home_footer.dart';
import 'package:vocabik_app/features/home/presentation/widgets/horizontal_course_card.dart';
import 'package:vocabik_app/features/home/presentation/widgets/section_header.dart';
import 'package:vocabik_app/features/home/presentation/widgets/today_progress_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

import 'package:vocabik_app/shared/presentation/widgets/shared_segmented_tab_bar.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading for shimmer effect
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;
    
    // Tag Filters for SegmentedTabBar
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // 1. Daily Pick
            SectionHeader(
              title: l10n.homeDailyPickTitle,
              size: SectionHeaderSize.large,
            ),
            DailyPickCard(
              course: mockDailyPick.first,
              isLoading: _isLoading,
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // 2. Recommended
            SectionHeader(
              title: l10n.homeRecommendedTitle,
              size: SectionHeaderSize.small,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: mockRecommended.map((course) {
                  return HorizontalCourseCard(course: course);
                }).toList(),
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // 3. Today Progress
            const TodayProgressCard(
              completedLessons: 2,
              totalLessons: 5,
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // 4. Tag Filters
            SharedSegmentedTabBar(
              selectedIndex: _selectedTabIndex,
              onTabChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              tabs: tags,
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // 5. Daily Challenge
            DailyChallengeBanner(
              title: mockTrending.first.title,
              subtitle: l10n.homeChallengeParticipants('1,247'),
              timeLeft: '08:42',
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // 6. Trending
            SectionHeader(
              title: l10n.homeTrending,
              actionText: l10n.homeViewAll,
              onActionTap: () {},
              size: SectionHeaderSize.medium,
            ),
            SizedBox(
              height: 280,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                scrollDirection: Axis.horizontal,
                itemCount: mockTrending.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  return SharedCourseCard(
                    course: mockTrending[index],
                    isLoading: _isLoading,
                  );
                },
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // 7. Recently Added
            SectionHeader(
              title: l10n.homeRecentlyAdded,
              size: SectionHeaderSize.medium,
            ),
            SizedBox(
              height: 280,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                scrollDirection: Axis.horizontal,
                itemCount: mockRecentlyAdded.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  return SharedCourseCard(
                    course: mockRecentlyAdded[index],
                    isLoading: _isLoading,
                  );
                },
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // 8. Library
            SectionHeader(
              title: l10n.homeLibrary,
              size: SectionHeaderSize.medium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.7, // Adjust this ratio to fit content
                ),
                itemCount: _isLoading ? 6 : mockLibrary.length.clamp(0, 12), // Max 12
                itemBuilder: (context, index) {
                  return SharedCourseCard(
                    course: _isLoading ? mockLibrary.first : mockLibrary[index],
                    isLoading: _isLoading,
                    width: double.infinity, // Let grid determine width
                  );
                },
              ),
            ),
            
            // 9. Footer
            const HomeFooter(),
            
            // 10. Padding bottom for FAB
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
