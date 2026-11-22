import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_horizontal_library_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card_skeleton.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

Widget _buildTestWidget({
  required bool isLoading,
  bool isLoadingMore = false,
  String? loadMoreError,
  bool hasError = false,
  required List<VideoEntity> videos,
  bool hasReachedMax = false,
  VoidCallback? onLoadMore,
  VoidCallback? onRetry,
}) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      extensions: [AppColorsExtension.dark],
    ),
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: CustomScrollView(
        slivers: [
          DiscoverHorizontalLibrarySection(
            title: 'Library',
            isLoading: isLoading,
            isLoadingMore: isLoadingMore,
            loadMoreError: loadMoreError,
            hasError: hasError,
            videos: videos,
            hasReachedMax: hasReachedMax,
            emptyText: 'No videos',
            onLoadMore: onLoadMore ?? () {},
            onRetry: onRetry,
          ),
        ],
      ),
    ),
  );
}

void main() {
  final sampleVideo = VideoEntity(
    id: '1',
    youtubeVideoId: 'yt1',
    title: 'Sample Video',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    category: 'tech',
    cefrLevel: 'B1',
    publishedAt: DateTime(2025, 1, 1),
    breakingBadge: false,
  );

  testWidgets(
    'initial loading renders 3 SharedCourseCardSkeleton cards without CircularProgressIndicator',
    (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          isLoading: true,
          videos: const [],
        ),
      );
      await tester.pump();

      expect(find.byType(SharedCourseCardSkeleton), findsNWidgets(3));
      expect(find.byType(AppShimmer), findsNWidgets(4)); // 1 header + 3 cards
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  testWidgets(
    'isLoadingMore renders 2 trailing SharedCourseCardSkeleton cards without CircularProgressIndicator',
    (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          isLoading: false,
          isLoadingMore: true,
          videos: [sampleVideo],
          hasReachedMax: false,
        ),
      );
      await tester.pump();

      expect(find.byType(SharedCourseCard), findsOneWidget);
      expect(find.byType(SharedCourseCardSkeleton), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  testWidgets(
    'loadMoreError keeps loaded cards visible and tapping retry triggers onLoadMore',
    (tester) async {
      var retryCount = 0;

      await tester.pumpWidget(
        _buildTestWidget(
          isLoading: false,
          loadMoreError: 'Network error',
          videos: [sampleVideo],
          hasReachedMax: false,
          onLoadMore: () => retryCount++,
        ),
      );
      await tester.pump();

      expect(find.byType(SharedCourseCard), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(retryCount, equals(1));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  testWidgets(
    'localized initial error state renders retry button and triggers onRetry',
    (tester) async {
      var retryCount = 0;

      await tester.pumpWidget(
        _buildTestWidget(
          isLoading: false,
          hasError: true,
          videos: const [],
          onRetry: () => retryCount++,
        ),
      );
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(retryCount, equals(1));
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  testWidgets(
    'horizontal scroll near end triggers onLoadMore and suppresses when loadMoreError is set',
    (tester) async {
      final videos = List.generate(
        6,
        (i) => VideoEntity(
          id: '$i',
          youtubeVideoId: 'yt$i',
          title: 'Video $i',
          thumbnailUrl: 'https://example.com/$i.jpg',
          category: 'tech',
          cefrLevel: 'B1',
          publishedAt: DateTime(2025, 1, 1 + i),
          breakingBadge: false,
        ),
      );
      var loadMoreCalls = 0;

      await tester.pumpWidget(
        _buildTestWidget(
          isLoading: false,
          videos: videos,
          hasReachedMax: false,
          onLoadMore: () => loadMoreCalls++,
        ),
      );
      await tester.pump();

      await tester.drag(find.byType(ListView), const Offset(-800, 0));
      await tester.pump();
      expect(loadMoreCalls, greaterThan(0));

      final callsBeforeError = loadMoreCalls;
      await tester.pumpWidget(
        _buildTestWidget(
          isLoading: false,
          loadMoreError: 'Network error',
          videos: videos,
          hasReachedMax: false,
          onLoadMore: () => loadMoreCalls++,
        ),
      );
      await tester.pump();

      await tester.drag(find.byType(ListView), const Offset(-300, 0));
      await tester.pump();
      expect(loadMoreCalls, equals(callsBeforeError));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );
}
