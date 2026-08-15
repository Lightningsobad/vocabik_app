import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/domain/repositories/exercise_repository.dart';

@injectable
class GetExerciseUseCase {
  final ExerciseRepository repository;

  GetExerciseUseCase(this.repository);

  Future<Either<Failure, ExerciseEntity>> call(GetExerciseParams params) async {
    return repository.getExercise(
      videoId: params.videoId,
      cefrLevel: params.cefrLevel,
      versionId: params.versionId,
      cancelToken: params.cancelToken,
    );
  }
}

class GetExerciseParams {
  final String videoId;
  final String cefrLevel;
  final String versionId;
  final CancelToken? cancelToken;

  GetExerciseParams({
    required this.videoId,
    required this.cefrLevel,
    required this.versionId,
    this.cancelToken,
  });
}
