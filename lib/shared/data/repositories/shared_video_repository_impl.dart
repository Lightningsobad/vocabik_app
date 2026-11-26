import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/cache/json_disk_cache.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/core/network/dio_cancel_token.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_local_data_source.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_remote_data_source.dart';
import 'package:vocabik_app/shared/data/models/video_model.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';

class _CacheEntry<T> {
  final T data;
  final DateTime cachedAt;

  const _CacheEntry(this.data, this.cachedAt);
}

class _InFlightVideoRequest {
  final int pageSize;
  final Future<Either<Failure, PaginatedResult<VideoEntity>>> future;

  const _InFlightVideoRequest(this.pageSize, this.future);
}

@LazySingleton(as: SharedVideoRepository)
class SharedVideoRepositoryImpl implements SharedVideoRepository {
  final SharedVideoRemoteDataSource remoteDataSource;
  final SharedVideoLocalDataSource? localDataSource;
  final JsonDiskCache? _diskCache;
  final DateTime Function() _now;

  static const Duration _cacheTtl = Duration(minutes: 3);
  static const Duration _categoriesCacheTtl = Duration(minutes: 10);
  static const String _videosDiskPrefix = '${JsonDiskCache.homeKeyPrefix}videos_';
  static const String _trendingDiskPrefix =
      '${JsonDiskCache.homeKeyPrefix}trending_';

  final Map<String, _CacheEntry<PaginatedResult<VideoEntity>>> _pageCache = {};
  final Map<String, _CacheEntry<List<VideoEntity>>> _trendingCache = {};
  final Map<String, _InFlightVideoRequest> _inFlightPage1 = {};
  List<VideoCategoryEntity>? _cachedCategories;
  DateTime? _categoriesCachedAt;

  @factoryMethod
  SharedVideoRepositoryImpl({
    required this.remoteDataSource,
    required JsonDiskCache diskCache,
    this.localDataSource,
    // ignore: prefer_initializing_formals
  })  : _diskCache = diskCache,
        _now = DateTime.now {
    JsonDiskCache.registerHomeMemoryClearer(_clearMemoryCache);
  }

  @visibleForTesting
  SharedVideoRepositoryImpl.withClock(
    this.remoteDataSource,
    this._now, {
    JsonDiskCache? diskCache,
    this.localDataSource,
    // ignore: prefer_initializing_formals
  }) : _diskCache = diskCache {
    JsonDiskCache.registerHomeMemoryClearer(_clearMemoryCache);
  }

  void _clearMemoryCache() {
    _pageCache.clear();
    _trendingCache.clear();
  }

  String? _normalizeFilter(String? value) {
    if (value == null || value.isEmpty || value.toLowerCase() == 'all') {
      return null;
    }
    return value.toLowerCase();
  }

  String _cefrKey(String? normalizedCefr) => normalizedCefr ?? 'all';

  PaginatedResult<VideoEntity> _slicePage(
    PaginatedResult<VideoEntity> data,
    int pageSize,
  ) {
    if (data.pageSize == pageSize || data.items.length <= pageSize) {
      return data;
    }
    return PaginatedResult<VideoEntity>(
      items: data.items.take(pageSize).toList(),
      page: data.page,
      pageSize: pageSize,
      totalItems: data.totalItems,
      totalPages: pageSize > 0
          ? math.max(1, (data.totalItems / pageSize).ceil())
          : data.totalPages,
    );
  }

  _CacheEntry<PaginatedResult<VideoEntity>>? _getOrLoadPageCache(
    String cefrKey,
  ) {
    final mem = _pageCache[cefrKey];
    if (mem != null) return mem;

    final disk = _diskCache?.read('$_videosDiskPrefix$cefrKey');
    if (disk?.data is! Map<String, dynamic>) return null;
    try {
      final entity = PaginatedVideoResponseModel.fromJson(
        disk!.data as Map<String, dynamic>,
      ).toEntity();
      final entry = _CacheEntry(entity, disk.cachedAt);
      _pageCache[cefrKey] = entry;
      return entry;
    } catch (_) {
      return null;
    }
  }

  _CacheEntry<List<VideoEntity>>? _getOrLoadTrendingCache(String cefrKey) {
    final mem = _trendingCache[cefrKey];
    if (mem != null) return mem;

    final disk = _diskCache?.read('$_trendingDiskPrefix$cefrKey');
    if (disk?.data is! List<dynamic>) return null;
    try {
      final entities = (disk!.data as List<dynamic>)
          .map(
            (item) =>
                VideoModel.fromJson(item as Map<String, dynamic>).toEntity(),
          )
          .toList();
      final entry = _CacheEntry(entities, disk.cachedAt);
      _trendingCache[cefrKey] = entry;
      return entry;
    } catch (_) {
      return null;
    }
  }

  @override
  PaginatedResult<VideoEntity>? getCachedVideos({
    required int pageSize,
    String? cefr,
  }) {
    final cefrKey = _cefrKey(_normalizeFilter(cefr));
    final cached = _getOrLoadPageCache(cefrKey);
    if (cached == null) return null;
    return _slicePage(cached.data, pageSize);
  }

  @override
  List<VideoEntity>? getCachedTrendingVideos({String? cefr}) {
    final cefrKey = _cefrKey(_normalizeFilter(cefr));
    return _getOrLoadTrendingCache(cefrKey)?.data;
  }

  @override
  Future<Either<Failure, PaginatedResult<VideoEntity>>> getVideos({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? exerciseType,
    String? searchQuery,
    bool forceRefresh = false,
    AppCancelToken? cancelToken,
  }) async {
    final normalizedCefr = _normalizeFilter(cefr);
    final isSearch = searchQuery != null && searchQuery.trim().isNotEmpty;
    final isCacheable = page == 1 &&
        !isSearch &&
        _normalizeFilter(genre) == null &&
        (window == null || window.isEmpty) &&
        (duration == null || duration.isEmpty) &&
        (exerciseType == null || exerciseType.isEmpty);
    final cefrKey = _cefrKey(normalizedCefr);
    final cached = isCacheable ? _getOrLoadPageCache(cefrKey) : null;

    if (!forceRefresh &&
        cached != null &&
        cached.data.pageSize >= pageSize &&
        _now().difference(cached.cachedAt) < _cacheTtl) {
      return right(_slicePage(cached.data, pageSize));
    }

    if (isCacheable) {
      final flightKey = '$cefrKey|$forceRefresh';
      final inFlight = _inFlightPage1[flightKey] ??
          (!forceRefresh ? _inFlightPage1['$cefrKey|true'] : null);
      if (inFlight != null && inFlight.pageSize >= pageSize) {
        final sharedResult = await inFlight.future;
        return sharedResult.map((data) => _slicePage(data, pageSize));
      }

      final future = _fetchPage1AndCache(
        cefrKey: cefrKey,
        page: page,
        pageSize: pageSize,
        cefr: cefr,
        genre: genre,
        window: window,
        duration: duration,
        exerciseType: exerciseType,
        searchQuery: searchQuery,
        cancelToken: cancelToken,
        forceRefresh: forceRefresh,
        staleFallback: cached,
      );
      _inFlightPage1[flightKey] = _InFlightVideoRequest(pageSize, future);
      try {
        return await future;
      } finally {
        if (identical(_inFlightPage1[flightKey]?.future, future)) {
          _inFlightPage1.remove(flightKey);
        }
      }
    }

    return _fetchVideosUncached(
      page: page,
      pageSize: pageSize,
      cefr: cefr,
      genre: genre,
      window: window,
      duration: duration,
      exerciseType: exerciseType,
      searchQuery: searchQuery,
      cancelToken: cancelToken,
    );
  }

  Future<Either<Failure, PaginatedResult<VideoEntity>>> _fetchPage1AndCache({
    required String cefrKey,
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? exerciseType,
    String? searchQuery,
    AppCancelToken? cancelToken,
    required bool forceRefresh,
    required _CacheEntry<PaginatedResult<VideoEntity>>? staleFallback,
  }) async {
    try {
      final response = await remoteDataSource.getVideos(
        page: page,
        pageSize: pageSize,
        cefr: cefr,
        genre: genre,
        window: window,
        duration: duration,
        exerciseType: exerciseType,
        searchQuery: searchQuery,
        cancelToken: cancelToken.toDio(),
      );
      final entity = response.toEntity();
      final existing = _pageCache[cefrKey];
      final now = _now();
      if (existing == null ||
          pageSize >= existing.data.pageSize ||
          now.difference(existing.cachedAt) >= _cacheTtl ||
          forceRefresh) {
        _pageCache[cefrKey] = _CacheEntry(entity, now);
        await _diskCache?.write(
          '$_videosDiskPrefix$cefrKey',
          response.toJson(),
          now: now,
        );
      }
      return right(entity);
    } on RequestCancelledException {
      return left(const CancelledFailure());
    } on ServerException catch (e) {
      if (!forceRefresh && staleFallback != null) {
        return right(_slicePage(staleFallback.data, pageSize));
      }
      return left(ServerFailure(e.message));
    } catch (e) {
      if (!forceRefresh && staleFallback != null) {
        return right(_slicePage(staleFallback.data, pageSize));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, PaginatedResult<VideoEntity>>> _fetchVideosUncached({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? exerciseType,
    String? searchQuery,
    AppCancelToken? cancelToken,
  }) async {
    try {
      final response = await remoteDataSource.getVideos(
        page: page,
        pageSize: pageSize,
        cefr: cefr,
        genre: genre,
        window: window,
        duration: duration,
        exerciseType: exerciseType,
        searchQuery: searchQuery,
        cancelToken: cancelToken.toDio(),
      );
      return right(response.toEntity());
    } on RequestCancelledException {
      return left(const CancelledFailure());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
    bool forceRefresh = false,
  }) async {
    final normalizedCefr = _normalizeFilter(cefr);
    final isCacheable = _normalizeFilter(genre) == null &&
        (duration == null || duration.isEmpty) &&
        (exerciseType == null || exerciseType.isEmpty);
    final cefrKey = _cefrKey(normalizedCefr);
    final cached = isCacheable ? _getOrLoadTrendingCache(cefrKey) : null;

    if (!forceRefresh &&
        cached != null &&
        _now().difference(cached.cachedAt) < _cacheTtl) {
      return right(cached.data);
    }

    try {
      final response = await remoteDataSource.getTrendingVideos(
        cefr: cefr,
        genre: genre,
        duration: duration,
        exerciseType: exerciseType,
      );
      final entities = response.map((model) => model.toEntity()).toList();
      if (isCacheable) {
        final now = _now();
        _trendingCache[cefrKey] = _CacheEntry(entities, now);
        await _diskCache?.write(
          '$_trendingDiskPrefix$cefrKey',
          response.map((m) => m.toJson()).toList(),
          now: now,
        );
      }
      return right(entities);
    } on ServerException catch (e) {
      if (!forceRefresh && cached != null) {
        return right(cached.data);
      }
      return left(ServerFailure(e.message));
    } catch (e) {
      if (!forceRefresh && cached != null) {
        return right(cached.data);
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  List<VideoCategoryEntity> getCachedCategories() {
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }
    final diskModels = localDataSource?.getCachedCategories();
    if (diskModels != null && diskModels.isNotEmpty) {
      final entities = diskModels.map((m) => m.toEntity()).toList();
      _cachedCategories = entities;
      _categoriesCachedAt ??= localDataSource?.getCategoriesCachedAt();
      return entities;
    }
    return const [];
  }

  @override
  Future<Either<Failure, List<VideoCategoryEntity>>> getCategories({
    bool forceRefresh = false,
  }) async {
    final cached = _cachedCategories ??
        localDataSource
            ?.getCachedCategories()
            ?.map((m) => m.toEntity())
            .toList();
    final cachedAt =
        _categoriesCachedAt ?? localDataSource?.getCategoriesCachedAt();
    if (cached != null) {
      _cachedCategories = cached;
      _categoriesCachedAt ??= cachedAt;
    }

    if (!forceRefresh &&
        cached != null &&
        cachedAt != null &&
        _now().difference(cachedAt) < _categoriesCacheTtl) {
      return right(cached);
    }

    try {
      final response = await remoteDataSource.getCategories();
      final entities = response.map((model) => model.toEntity()).toList();
      final fetchedAt = _now();
      _cachedCategories = entities;
      _categoriesCachedAt = fetchedAt;
      try {
        await localDataSource?.saveCategories(response, fetchedAt);
      } catch (_) {
        // Best-effort local persistence; keep fresh remote data in RAM.
      }
      return right(entities);
    } on ServerException catch (e) {
      if (!forceRefresh && cached != null) {
        return right(cached);
      }
      return left(ServerFailure(e.message));
    } catch (e) {
      if (!forceRefresh && cached != null) {
        return right(cached);
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
