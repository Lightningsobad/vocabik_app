import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/core/network/dio_cancel_token.dart';
import 'package:vocabik_app/features/exercise/data/datasources/exercise_remote_datasource.dart';
import 'package:vocabik_app/features/exercise/data/models/progress_request.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';
import 'package:vocabik_app/features/exercise/domain/repositories/exercise_repository.dart';

import 'package:vocabik_app/features/exercise/domain/entities/translation_entity.dart';

@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ExerciseEntity>> getExercise({
    required String videoId,
    required String cefrLevel,
    required String versionId,
    AppCancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.getExercise(
        videoId: videoId,
        cefrLevel: cefrLevel,
        versionId: versionId,
        cancelToken: cancelToken.toDio(),
      );
      return Right(model.toEntity());
    } on RequestCancelledException {
      return const Left(CancelledFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TranslationEntity>>> getVideoTranslations({
    required String videoId,
    String lang = 'vi',
    String language = 'vi',
    AppCancelToken? cancelToken,
  }) async {
    try {
      final models = await remoteDataSource.getVideoTranslations(
        videoId: videoId,
        lang: lang,
        language: language,
        cancelToken: cancelToken.toDio(),
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on RequestCancelledException {
      return const Left(CancelledFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitProgress({
    required String videoId,
    required String cefrLevel,
    required String versionId,
    required String completedAt,
    required int accuracyScore,
    required int timeTakenSeconds,
    required List<String> correctAnswers,
    required List<BlankAnswerEntity> blankAnswers,
    AppCancelToken? cancelToken,
  }) async {
    try {
      final request = ProgressRequest(
        videoId: videoId,
        cefrLevel: cefrLevel,
        versionId: versionId,
        completedAt: completedAt,
        accuracyScore: accuracyScore,
        timeTakenSeconds: timeTakenSeconds,
        correctAnswers: correctAnswers,
        blankAnswers: blankAnswers
            .map((b) => BlankAnswerRequest(
                  blankIndex: b.blankIndex,
                  isCorrect: b.isCorrect,
                ))
            .toList(),
      );

      await remoteDataSource.submitProgress(
        request: request,
        cancelToken: cancelToken.toDio(),
      );
      return const Right(null);
    } on RequestCancelledException {
      return const Left(CancelledFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

