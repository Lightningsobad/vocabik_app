import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/video_detail/domain/entities/video_progress_entity.dart';
import 'package:vocabik_app/features/video_detail/domain/repositories/video_detail_repository.dart';

@injectable
class GetLatestVideoProgressUseCase {
  final VideoDetailRepository repository;

  GetLatestVideoProgressUseCase(this.repository);

  Future<Either<Failure, VideoProgressEntity?>> call(String videoId) async {
    return repository.getLatestProgress(videoId);
  }
}
