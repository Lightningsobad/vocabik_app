import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoThumbnailCacheManager {
  VideoThumbnailCacheManager._();

  static const String _key = 'vocabik_video_thumbnails';

  static final CacheManager _defaultInstance = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 300,
    ),
  );

  @visibleForTesting
  static BaseCacheManager? debugOverride;

  static BaseCacheManager get instance => debugOverride ?? _defaultInstance;
}
