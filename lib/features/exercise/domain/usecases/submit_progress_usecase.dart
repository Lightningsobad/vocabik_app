import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_result_summary.dart';
import 'package:vocabik_app/features/exercise/domain/repositories/exercise_repository.dart';

@injectable
class SubmitProgressUseCase {
  final ExerciseRepository repository;

  SubmitProgressUseCase(this.repository);

  Future<Either<Failure, void>> call(SubmitProgressParams params) async {
    return repository.submitProgress(
      videoId: params.videoId,
      cefrLevel: params.cefrLevel,
      versionId: params.versionId,
      completedAt: params.completedAt,
      accuracyScore: params.accuracyScore,
      timeTakenSeconds: params.timeTakenSeconds,
      correctAnswers: params.correctAnswers,
      blankAnswers: params.blankAnswers,
      cancelToken: params.cancelToken,
    );
  }
}

class SubmitProgressParams {
  final String videoId;
  final String cefrLevel;
  final String versionId;
  final String completedAt;
  final int accuracyScore;
  final int timeTakenSeconds;
  final List<String> correctAnswers;
  final List<BlankAnswerEntity> blankAnswers;
  final AppCancelToken? cancelToken;

  SubmitProgressParams({
    required this.videoId,
    required this.cefrLevel,
    required this.versionId,
    required this.completedAt,
    required this.accuracyScore,
    required this.timeTakenSeconds,
    required this.correctAnswers,
    required this.blankAnswers,
    this.cancelToken,
  });
}

