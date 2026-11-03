import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';

@injectable
class GetTrendingVideosUseCase {
  final SharedVideoRepository repository;

  GetTrendingVideosUseCase(this.repository);

  Future<Either<Failure, List<VideoEntity>>> call({
    String? cefr,
    String? genre,
    String? duration,
    String? exerciseType,
  }) {
    return repository.getTrendingVideos(
      cefr: cefr,
      genre: genre,
      duration: duration,
      exerciseType: exerciseType,
    );
  }
}
