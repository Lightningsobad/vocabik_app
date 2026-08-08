import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/features/home/domain/entities/video_entity.dart';

abstract class VideoRepository {
  Future<Either<Failure, PaginatedResult<VideoEntity>>> getVideos({
    required int page,
    required int pageSize,
  });
}
