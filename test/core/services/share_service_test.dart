// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:vocabik_app/core/services/share_service.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final Directory tempDir;
  FakePathProviderPlatform(this.tempDir);

  @override
  Future<String?> getTemporaryPath() async => tempDir.path;
}

class FakeSharePlatform extends Fake
    with MockPlatformInterfaceMixin
    implements SharePlatform {
  String? lastSharedText;
  List<XFile>? lastSharedFiles;
  Rect? lastSharePositionOrigin;

  @override
  Future<ShareResult> share(ShareParams params) async {
    lastSharedText = params.text;
    lastSharedFiles = params.files;
    lastSharePositionOrigin = params.sharePositionOrigin;
    return const ShareResult('success', ShareResultStatus.success);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late ShareService shareService;
  late FakeSharePlatform fakeShare;
  late Directory tempDir;

  setUp(() async {
    dio = Dio();
    fakeShare = FakeSharePlatform();
    shareService = ShareService(dio, sharePlatform: fakeShare);

    tempDir = await Directory.systemTemp.createTemp('share_service_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('ShareService', () {
    test('getLessonUrl formats correctly', () {
      expect(
        shareService.getLessonUrl('video-123'),
        'https://vocabik.com/videos/video-123',
      );
    });

    test('copyLessonLink copies link to Clipboard', () async {
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        log.add(call);
        return null;
      });

      await shareService.copyLessonLink('video-123');

      expect(
        log.any((call) =>
            call.method == 'Clipboard.setData' &&
            call.arguments['text'] == 'https://vocabik.com/videos/video-123'),
        isTrue,
      );
    });

    test('shareLesson delegates to SharePlatform.share with message', () async {
      await shareService.shareLesson(
        videoId: 'v1',
        message: 'Learn English: https://vocabik.com/videos/v1',
      );

      expect(fakeShare.lastSharedText, 'Learn English: https://vocabik.com/videos/v1');
      expect(fakeShare.lastSharedFiles, isNull);
    });

    test('shareScoreCardImage falls back to text share when imageUrl is null', () async {
      final result = await shareService.shareScoreCardImage(
        imageUrl: null,
        videoId: 'v1',
        message: 'Score 100%: https://vocabik.com/videos/v1',
      );

      expect(result, isFalse);
      expect(fakeShare.lastSharedText, 'Score 100%: https://vocabik.com/videos/v1');
      expect(fakeShare.lastSharedFiles, isNull);
    });

    test('shareScoreCardImage downloads image and shares file via share', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [1, 2, 3, 4], // Fake PNG bytes
              ),
            );
          },
        ),
      );

      final result = await shareService.shareScoreCardImage(
        imageUrl: 'https://api.vocabik.com/public/score-cards/1/image',
        videoId: 'v1',
        message: 'Score 100%: https://vocabik.com/videos/v1',
      );

      expect(result, isTrue);
      expect(fakeShare.lastSharedFiles, isNotNull);
      expect(fakeShare.lastSharedFiles!.length, 1);
      expect(fakeShare.lastSharedFiles!.first.path, contains('vocabik_score_card_v1.png'));
      expect(fakeShare.lastSharedText, 'Score 100%: https://vocabik.com/videos/v1');
    });

    test('shareScoreCardImage falls back to text share when download fails', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
              ),
            );
          },
        ),
      );

      final result = await shareService.shareScoreCardImage(
        imageUrl: 'https://api.vocabik.com/public/score-cards/1/image',
        videoId: 'v1',
        message: 'Score 100%: https://vocabik.com/videos/v1',
      );

      expect(result, isFalse);
      expect(fakeShare.lastSharedText, 'Score 100%: https://vocabik.com/videos/v1');
      expect(fakeShare.lastSharedFiles, isNull);
    });
  });
}
