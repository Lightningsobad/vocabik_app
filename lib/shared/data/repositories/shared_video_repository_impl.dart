import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/core/network/dio_cancel_token.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_local_data_source.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_remote_data_source.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';

class _CachedVideoPage {
  final PaginatedResult<VideoEntity> data;
  final DateTime cachedAt;

  const _CachedVideoPage(this.data, this.cachedAt);
}

@LazySingleton(as: SharedVideoRepository)
class SharedVideoRepositoryImpl implements SharedVideoRepository {
  final SharedVideoRemoteDataSource remoteDataSource;
  final SharedVideoLocalDataSource? localDataSource;
  final DateTime Function() _now;

  static const Duration _cacheTtl = Duration(minutes: 3);
  static const Duration _categoriesCacheTtl = Duration(minutes: 10);
  final Map<String, _CachedVideoPage> _pageCache = {};
  List<VideoCategoryEntity>? _cachedCategories;
  DateTime? _categoriesCachedAt;

  @factoryMethod
  SharedVideoRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  }) : _now = DateTime.now;

  @visibleForTesting
  SharedVideoRepositoryImpl.withClock(
    this.remoteDataSource,
    this._now, {
    this.localDataSource,
  });

  String? _normalizeFilter(String? value) {
    if (value == null || value.isEmpty || value.toLowerCase() == 'all') {
      return null;
    }
    return value.toLowerCase();
  }

  String _cacheKey(int pageSize, String? normalizedCefr) =>
      '$pageSize|${normalizedCefr ?? 'all'}';

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
    final cacheKey = _cacheKey(pageSize, normalizedCefr);
    final cached = isCacheable ? _pageCache[cacheKey] : null;

    if (!forceRefresh &&
        cached != null &&
        _now().difference(cached.cachedAt) < _cacheTtl) {
      return right(cached.data);
    }

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

      if (isCacheable) {
        _pageCache[cacheKey] = _CachedVideoPage(entity, _now());
      }

      return right(entity);
    } on RequestCancelledException {
      return left(const CancelledFailure());
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
  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
  }) async {
    try {
      final response = await remoteDataSource.getTrendingVideos(
        cefr: cefr,
        genre: genre,
        duration: duration,
        exerciseType: exerciseType,
      );
      final entities = response.map((model) => model.toEntity()).toList();
      return right(entities);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
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
