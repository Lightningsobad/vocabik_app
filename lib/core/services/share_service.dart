import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

@lazySingleton
class ShareService {
  final Dio _dio;
  final SharePlatform _sharePlatform;

  ShareService(
    this._dio, {
    @factoryMethod SharePlatform? sharePlatform,
  }) : _sharePlatform = sharePlatform ?? SharePlatform.instance;

  static const String baseUrl = 'https://vocabik.com';

  String getLessonUrl(String videoId) => '$baseUrl/videos/$videoId';

  Future<void> copyLessonLink(String videoId) async {
    await Clipboard.setData(ClipboardData(text: getLessonUrl(videoId)));
  }

  Future<void> shareLesson({
    required String videoId,
    required String message,
    Rect? sharePositionOrigin,
  }) async {
    await _sharePlatform.share(
      ShareParams(
        text: message,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  /// Shares score card image via native share sheet, falls back to text on failure.
  Future<bool> shareScoreCardImage({
    required String? imageUrl,
    required String videoId,
    required String message,
    Rect? sharePositionOrigin,
  }) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await _dio.get<List<int>>(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = response.data;
        if (bytes != null && bytes.isNotEmpty) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/vocabik_score_card_$videoId.png');
          await file.writeAsBytes(bytes, flush: true);
          final xFile = XFile(file.path, mimeType: 'image/png');
          await _sharePlatform.share(
            ShareParams(
              files: [xFile],
              text: message,
              sharePositionOrigin: sharePositionOrigin,
            ),
          );
          return true;
        }
      } catch (_) {
        // shortcut: fallback to text on image download failure, upgrade to user retry prompt if needed
      }
    }

    await _sharePlatform.share(
      ShareParams(
        text: message,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
    return false;
  }
}
