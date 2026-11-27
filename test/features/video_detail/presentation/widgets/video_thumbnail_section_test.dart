import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/video_detail/presentation/widgets/video_detail_skeleton.dart';
import 'package:vocabik_app/features/video_detail/presentation/widgets/video_thumbnail_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/presentation/utils/video_thumbnail_cache_manager.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

final Uint8List _kTestPngBytes = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(extensions: [AppColorsExtension.dark]),
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

VideoEntity _createVideo({
  String thumbnailUrl = 'https://i.ytimg.com/vi/V2eJrPzq1Rk/maxresdefault.jpg',
}) {
  return VideoEntity(
    id: 'vid-1',
    youtubeVideoId: 'V2eJrPzq1Rk',
    title: 'Sample Video',
    thumbnailUrl: thumbnailUrl,
    category: 'music',
    cefrLevel: 'B1',
    publishedAt: DateTime(2026, 1, 1),
    breakingBadge: false,
    durationSeconds: 180,
  );
}

void main() {
  testWidgets(
    'VideoThumbnailSection uses CachedNetworkImage without scale for maxresdefault.jpg',
    (tester) async {
      const url = 'https://i.ytimg.com/vi/V2eJrPzq1Rk/maxresdefault.jpg';
      await tester.pumpWidget(
        _wrapWithApp(
          VideoThumbnailSection(video: _createVideo(thumbnailUrl: url)),
        ),
      );
      await tester.pump();

      expect(find.byType(AppShimmer), findsNothing);
      expect(
        find.descendant(
          of: find.byType(ClipRRect),
          matching: find.byType(Transform),
        ),
        findsNothing,
      );

      final cachedImageFinder = find.byType(CachedNetworkImage);
      expect(cachedImageFinder, findsOneWidget);

      final cachedImage = tester.widget<CachedNetworkImage>(cachedImageFinder);
      expect(cachedImage.imageUrl, url);
      expect(
        cachedImage.cacheManager,
        same(VideoThumbnailCacheManager.instance),
      );
      expect(cachedImage.fit, BoxFit.cover);
      expect(cachedImage.memCacheWidth, 800);
      expect(cachedImage.memCacheHeight, isNull);
      expect(cachedImage.fadeInDuration, const Duration(milliseconds: 180));
      expect(cachedImage.fadeInCurve, Curves.easeOut);
      expect(cachedImage.imageBuilder, isNull);
      expect(cachedImage.placeholder, isNotNull);
      expect(cachedImage.errorWidget, isNotNull);

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.circular(25));

      final size = tester.getSize(find.byType(ClipRRect));
      expect(size.height, 215);
    },
  );

  for (final url in const [
    'https://i.ytimg.com/vi/V2eJrPzq1Rk/hqdefault.jpg',
    'https://i.ytimg.com/vi/V2eJrPzq1Rk/sddefault.jpg',
    'https://i.ytimg.com/vi/V2eJrPzq1Rk/default.jpg',
    'https://i.ytimg.com/vi/V2eJrPzq1Rk/hqdefault.jpg?sqp=-oaymwEm',
  ]) {
    testWidgets(
      'VideoThumbnailSection applies 1.34 scale via imageBuilder for $url',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithApp(
            VideoThumbnailSection(video: _createVideo(thumbnailUrl: url)),
          ),
        );
        await tester.pump();

        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        expect(cachedImage.imageBuilder, isNotNull);

        await tester.pumpWidget(
          _wrapWithApp(
            Builder(
              builder: (context) => cachedImage.imageBuilder!(
                context,
                MemoryImage(_kTestPngBytes),
              ),
            ),
          ),
        );
        await tester.pump();

        final transform = tester.widget<Transform>(
          find.ancestor(
            of: find.byType(Image),
            matching: find.byType(Transform),
          ),
        );
        expect(transform.transform.storage[0], closeTo(1.34, 0.001));
        expect(transform.transform.storage[5], closeTo(1.34, 0.001));

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, BoxFit.cover);
      },
    );
  }

  testWidgets(
    'VideoThumbnailSection falls back from maxresdefault.jpg error to hqdefault.jpg with scale 1.34 once',
    (tester) async {
      const maxResUrl =
          'https://i.ytimg.com/vi/V2eJrPzq1Rk/maxresdefault.jpg?sqp=abc';
      const expectedFallbackUrl =
          'https://i.ytimg.com/vi/V2eJrPzq1Rk/hqdefault.jpg?sqp=abc';

      await tester.pumpWidget(
        _wrapWithApp(
          VideoThumbnailSection(video: _createVideo(thumbnailUrl: maxResUrl)),
        ),
      );
      await tester.pump();

      var cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.imageUrl, maxResUrl);
      expect(cachedImage.imageBuilder, isNull);

      // Trigger first errorWidget (simulating 404 on maxresdefault.jpg).
      final context = tester.element(find.byType(CachedNetworkImage));
      cachedImage.errorWidget!(context, maxResUrl, Exception('404'));
      tester.binding.scheduleFrame();
      await tester.pump();
      await tester.pump();

      cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.imageUrl, expectedFallbackUrl);
      expect(cachedImage.imageBuilder, isNotNull);

      // Trigger second errorWidget on fallback URL -> must render error icon, not loop.
      final fallbackContext = tester.element(find.byType(CachedNetworkImage));
      final secondErrorWidget = cachedImage.errorWidget!(
        fallbackContext,
        expectedFallbackUrl,
        Exception('offline'),
      );
      await tester.pumpWidget(_wrapWithApp(secondErrorWidget));
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    },
  );

  testWidgets(
    'VideoThumbnailSection resets fallback state when video.thumbnailUrl changes',
    (tester) async {
      const firstMaxRes = 'https://i.ytimg.com/vi/video1/maxresdefault.jpg';
      const secondMaxRes = 'https://i.ytimg.com/vi/video2/maxresdefault.jpg';

      await tester.pumpWidget(
        _wrapWithApp(
          VideoThumbnailSection(video: _createVideo(thumbnailUrl: firstMaxRes)),
        ),
      );
      await tester.pump();

      final initialImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      initialImage.errorWidget!(
        tester.element(find.byType(CachedNetworkImage)),
        firstMaxRes,
        Exception('404'),
      );
      tester.binding.scheduleFrame();
      await tester.pump();
      await tester.pump();
      expect(
        tester
            .widget<CachedNetworkImage>(find.byType(CachedNetworkImage))
            .imageUrl,
        'https://i.ytimg.com/vi/video1/hqdefault.jpg',
      );

      await tester.pumpWidget(
        _wrapWithApp(
          VideoThumbnailSection(
            video: _createVideo(thumbnailUrl: secondMaxRes),
          ),
        ),
      );
      await tester.pump();

      final updatedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(updatedImage.imageUrl, secondMaxRes);
      expect(updatedImage.imageBuilder, isNull);
    },
  );

  testWidgets(
    'VideoThumbnailSection does not build CachedNetworkImage when thumbnailUrl is empty',
    (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          VideoThumbnailSection(video: _createVideo(thumbnailUrl: '')),
        ),
      );
      await tester.pump();

      expect(find.byType(CachedNetworkImage), findsNothing);
    },
  );

  testWidgets(
    'VideoDetailSkeleton matches VideoThumbnailSection height and borderRadius',
    (tester) async {
      await tester.pumpWidget(_wrapWithApp(const VideoDetailSkeleton()));
      await tester.pump();

      final containerFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration! as BoxDecoration;
          return decoration.borderRadius == BorderRadius.circular(25);
        }
        return false;
      });

      expect(containerFinder, findsOneWidget);
      final size = tester.getSize(containerFinder);
      expect(size.height, 215);
    },
  );
}
