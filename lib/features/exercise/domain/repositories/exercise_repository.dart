import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';
import 'package:vocabik_app/features/exercise/domain/entities/translation_entity.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, ExerciseEntity>> getExercise({
    required String videoId,
    required String cefrLevel,
    required String versionId,
    AppCancelToken? cancelToken,
  });

  Future<Either<Failure, List<TranslationEntity>>> getVideoTranslations({
    required String videoId,
    String lang = 'vi',
    String language = 'vi',
    AppCancelToken? cancelToken,
  });

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
  });
}

