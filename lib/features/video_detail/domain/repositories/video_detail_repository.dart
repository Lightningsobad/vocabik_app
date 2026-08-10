import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

abstract class VideoDetailRepository {
  Future<Either<Failure, VideoEntity>> getVideoDetail(String id);
}
