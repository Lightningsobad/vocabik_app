import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_remote_data_source.dart';
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
  final DateTime Function() _now;

  static const Duration _cacheTtl = Duration(minutes: 3);
  final Map<String, _CachedVideoPage> _pageCache = {};

  @factoryMethod
  SharedVideoRepositoryImpl({required this.remoteDataSource})
      : _now = DateTime.now;

  @visibleForTesting
  SharedVideoRepositoryImpl.withClock(
    this.remoteDataSource,
    this._now,
  );

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
    bool forceRefresh = false,
  }) async {
    final normalizedCefr = _normalizeFilter(cefr);
    final isCacheable = page == 1 &&
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
      );

      final entity = response.toEntity();

      if (isCacheable) {
        _pageCache[cacheKey] = _CachedVideoPage(entity, _now());
      }

      return right(entity);
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
}
