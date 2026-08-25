import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

abstract class SharedVideoRepository {
  Future<Either<Failure, PaginatedResult<VideoEntity>>> getVideos({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
  });

  Future<Either<Failure, List<VideoEntity>>> getTrendingVideos({String? cefr});
}
