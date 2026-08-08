import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/home/domain/entities/video_entity.dart';
import 'package:vocabik_app/features/video_detail/domain/repositories/video_detail_repository.dart';

@injectable
class GetVideoDetailUseCase {
  final VideoDetailRepository repository;

  GetVideoDetailUseCase(this.repository);

  Future<Either<Failure, VideoEntity>> call(String params) async {
    return repository.getVideoDetail(params);
  }
}
