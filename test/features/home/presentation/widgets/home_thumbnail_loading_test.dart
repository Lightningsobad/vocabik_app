import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';
import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';
import 'package:vocabik_app/features/home/presentation/widgets/also_for_you_video_card.dart';
import 'package:vocabik_app/features/home/presentation/widgets/daily_pick_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/utils/video_thumbnail_cache_manager.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/presentation/widgets/cards/shared_course_card.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      extensions: [AppColorsExtension.dark],
    ),
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void _verifyCachedThumbnailImage(
  WidgetTester tester, {
  required int expectedMemCacheWidth,
}) {
  expect(find.byType(AppShimmer), findsNothing);

  final cachedImageFinder = find.byType(CachedNetworkImage);
  expect(cachedImageFinder, findsOneWidget);

  final cachedImage = tester.widget<CachedNetworkImage>(cachedImageFinder);
  expect(cachedImage.cacheManager, same(VideoThumbnailCacheManager.instance));
  expect(cachedImage.memCacheWidth, expectedMemCacheWidth);
  expect(cachedImage.memCacheHeight, isNull);
  expect(cachedImage.fadeInDuration, const Duration(milliseconds: 180));
  expect(cachedImage.fadeInCurve, Curves.easeOut);
  expect(cachedImage.placeholder, isNotNull);
  expect(cachedImage.errorWidget, isNotNull);
}

void main() {
  testWidgets(
    'DailyPickCard uses CachedNetworkImage with VideoThumbnailCacheManager and preserves aspect ratio',
    (tester) async {
      const dailyPick = DailyPickEntity(
        videoId: 'dp-1',
        title: 'Daily Pick Title',
        thumbnailUrl: 'https://example.com/daily-pick.jpg',
        cefrLevel: 'B1',
        playerUrl: 'https://example.com/player',
        artist: 'Artist',
        durationSeconds: 125,
        category: 'music',
        practiced: 42,
      );

      await tester.pumpWidget(
        _wrapWithApp(const DailyPickCard(dailyPick: dailyPick)),
      );
      await tester.pump();

      _verifyCachedThumbnailImage(tester, expectedMemCacheWidth: 800);
    },
  );

  testWidgets(
    'AlsoForYouVideoCard uses CachedNetworkImage with VideoThumbnailCacheManager and preserves aspect ratio',
    (tester) async {
      const slot = PersonalizedSlotEntity(
        position: 1,
        videoId: 'slot-1',
        title: 'Also For You Title',
        thumbnailUrl: 'https://example.com/also-for-you.jpg',
        youtubeVideoId: 'yt-1',
        cefrLevel: 'A2',
        durationSeconds: 95,
        category: 'tech',
      );

      await tester.pumpWidget(
        _wrapWithApp(const AlsoForYouVideoCard(slot: slot)),
      );
      await tester.pump();

      _verifyCachedThumbnailImage(tester, expectedMemCacheWidth: 220);
    },
  );

  testWidgets(
    'SharedCourseCard uses CachedNetworkImage with VideoThumbnailCacheManager and preserves aspect ratio',
    (tester) async {
      final video = VideoEntity(
        id: 'lib-1',
        youtubeVideoId: 'yt-lib-1',
        title: 'Library Video',
        thumbnailUrl: 'https://example.com/lib-thumb.jpg',
        category: 'tech',
        cefrLevel: 'B1',
        publishedAt: DateTime(2026, 1, 1),
        breakingBadge: false,
        durationSeconds: 125,
      );

      await tester.pumpWidget(
        _wrapWithApp(
          SizedBox(
            width: 180,
            height: 220,
            child: SharedCourseCard(video: video, width: 180),
          ),
        ),
      );
      await tester.pump();

      _verifyCachedThumbnailImage(tester, expectedMemCacheWidth: 500);
    },
  );
}
