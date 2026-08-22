import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/video_detail/domain/repositories/video_detail_repository.dart';

@injectable
class GetVideoExerciseBlanksUseCase {
  final VideoDetailRepository repository;

  GetVideoExerciseBlanksUseCase(this.repository);

  Future<Either<Failure, int>> call(String videoId) async {
    return repository.getExerciseBlanksCount(videoId);
  }
}
