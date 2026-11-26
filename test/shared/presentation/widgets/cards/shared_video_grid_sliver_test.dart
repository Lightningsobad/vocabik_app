import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card_skeleton.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_video_grid_sliver.dart';
import 'package:vocabik_app/shared/presentation/widgets/shared_empty_state.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

void main() {
  Widget wrapSliver(Widget sliver) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      theme: ThemeData.dark().copyWith(
        extensions: [AppColorsExtension.dark],
      ),
      home: Scaffold(
        body: CustomScrollView(
          slivers: [sliver],
        ),
      ),
    );
  }

  final sampleVideo = VideoEntity(
    id: 'v1',
    youtubeVideoId: 'yt1',
    title: 'NASA Mars Rover',
    thumbnailUrl: 'https://i.ytimg.com/vi/7Gni54puoIg/maxresdefault.jpg',
    category: 'news',
    cefrLevel: 'B2',
    publishedAt: DateTime(2025, 1, 1),
    breakingBadge: false,
  );

  testWidgets('renders 4 skeletons during initial loading', (tester) async {
    await tester.pumpWidget(
      wrapSliver(
        SharedVideoGridSliver(
          isLoading: true,
          hasError: false,
          videos: const [],
          isLoadingMore: false,
          loadMoreError: null,
          emptyText: 'No results found',
          onRetry: () {},
          onLoadMoreRetry: () {},
        ),
      ),
    );

    expect(find.byType(SharedCourseCardSkeleton), findsNWidgets(4));
  });

  testWidgets('renders empty state when loaded list is empty', (tester) async {
    await tester.pumpWidget(
      wrapSliver(
        SharedVideoGridSliver(
          isLoading: false,
          hasError: false,
          videos: const [],
          isLoadingMore: false,
          loadMoreError: null,
          emptyText: 'No results found',
          onRetry: () {},
          onLoadMoreRetry: () {},
        ),
      ),
    );

    expect(find.byType(SharedEmptyState), findsOneWidget);
    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('renders cards, trailing skeletons, and inline loadMoreError retry', (tester) async {
    var loadMoreRetried = false;

    await tester.pumpWidget(
      wrapSliver(
        SharedVideoGridSliver(
          isLoading: false,
          hasError: false,
          videos: [sampleVideo],
          isLoadingMore: true,
          loadMoreError: 'Network error',
          emptyText: 'No results found',
          onRetry: () {},
          onLoadMoreRetry: () => loadMoreRetried = true,
        ),
      ),
    );

    expect(find.byType(SharedCourseCard), findsOneWidget);
    expect(find.byType(SharedCourseCardSkeleton), findsNWidgets(2));

    await tester.scrollUntilVisible(find.text('Retry'), 200);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    expect(loadMoreRetried, isTrue);
  });
}
