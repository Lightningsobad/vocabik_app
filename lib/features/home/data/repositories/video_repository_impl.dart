import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/features/home/data/datasources/video_remote_data_source.dart';
import 'package:vocabik_app/features/home/domain/entities/video_entity.dart';
import 'package:vocabik_app/features/home/domain/repositories/video_repository.dart';

@LazySingleton(as: VideoRepository)
class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedResult<VideoEntity>>> getVideos({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await remoteDataSource.getVideos(
        page: page,
        pageSize: pageSize,
      );
      return right(response.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
