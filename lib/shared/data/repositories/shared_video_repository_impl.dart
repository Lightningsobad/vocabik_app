import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/shared/data/datasources/shared_video_remote_data_source.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';

@LazySingleton(as: SharedVideoRepository)
class SharedVideoRepositoryImpl implements SharedVideoRepository {
  final SharedVideoRemoteDataSource remoteDataSource;

  // In-memory cache for the first page of default videos
  PaginatedResult<VideoEntity>? _defaultCachedVideos;
  bool _isRefreshing = false; // Guard: chỉ một background refresh chạy tại một thời điểm

  SharedVideoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedResult<VideoEntity>>> getVideos({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
    String? duration,
    String? exerciseType,
  }) async {
    final isDefaultQuery = page == 1 &&
        (cefr == null || cefr.isEmpty || cefr.toLowerCase() == 'all') &&
        (genre == null || genre.isEmpty || genre.toLowerCase() == 'all') &&
        (window == null || window.isEmpty) &&
        (duration == null || duration.isEmpty) &&
        (exerciseType == null || exerciseType.isEmpty);

    // Return cache immediately if available and it's a default query
    if (isDefaultQuery && _defaultCachedVideos != null) {
      // Trigger background refresh optionally if needed, but returning cache for now
      _fetchAndCacheDefault(page, pageSize); // Async fire-and-forget
      return right(_defaultCachedVideos!);
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

      if (isDefaultQuery) {
        _defaultCachedVideos = entity;
      }

      return right(entity);
    } on ServerException catch (e) {
      // If we have cache and server fails on default query, we could fallback to cache
      if (isDefaultQuery && _defaultCachedVideos != null) {
        return right(_defaultCachedVideos!);
      }
      return left(ServerFailure(e.message));
    } catch (e) {
      if (isDefaultQuery && _defaultCachedVideos != null) {
        return right(_defaultCachedVideos!);
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

  Future<void> _fetchAndCacheDefault(int page, int pageSize) async {
    if (_isRefreshing) return; // Chặn concurrent refresh để tránh race condition
    _isRefreshing = true;
    try {
      final response = await remoteDataSource.getVideos(
        page: page,
        pageSize: pageSize,
      );
      _defaultCachedVideos = response.toEntity();
    } catch (_) {
      // Ignore errors for background refresh
    } finally {
      _isRefreshing = false; // Luôn reset dù thành công hay thất bại
    }
  }
}
