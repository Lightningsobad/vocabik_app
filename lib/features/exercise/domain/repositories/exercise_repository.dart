import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/core/errors/failures.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, ExerciseEntity>> getExercise({
    required String videoId,
    required String cefrLevel,
    required String versionId,
    CancelToken? cancelToken,
  });
}
