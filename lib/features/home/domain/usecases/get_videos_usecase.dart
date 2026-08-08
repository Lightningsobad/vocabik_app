import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/features/home/domain/entities/video_entity.dart';
import 'package:vocabik_app/features/home/domain/repositories/video_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetVideosUseCase {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<VideoEntity>>> call({
    required int page,
    required int pageSize,
  }) {
    return repository.getVideos(page: page, pageSize: pageSize);
  }
}
