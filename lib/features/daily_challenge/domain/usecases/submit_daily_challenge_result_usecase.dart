import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/daily_challenge_repository.dart';

@lazySingleton
class SubmitDailyChallengeResultUseCase {
  final DailyChallengeRepository _repository;

  SubmitDailyChallengeResultUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required int scoreAccuracy,
    required int scoreTimeMs,
  }) async {
    return await _repository.submitResult(
      scoreAccuracy: scoreAccuracy,
      scoreTimeMs: scoreTimeMs,
    );
  }
}
