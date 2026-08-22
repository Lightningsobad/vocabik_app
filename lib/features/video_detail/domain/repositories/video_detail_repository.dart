import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/video_detail/domain/entities/video_progress_entity.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

abstract class VideoDetailRepository {
  Future<Either<Failure, VideoEntity>> getVideoDetail(String id);
  Future<Either<Failure, int>> getExerciseBlanksCount(String videoId);
  Future<Either<Failure, VideoProgressEntity?>> getLatestProgress(String videoTitle);
}
