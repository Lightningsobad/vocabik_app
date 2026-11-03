import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/daily_challenge_streak_entity.dart';
import '../repositories/daily_challenge_repository.dart';

@lazySingleton
class GetDailyChallengeStreakUseCase {
  final DailyChallengeRepository _repository;

  GetDailyChallengeStreakUseCase(this._repository);

  Future<Either<Failure, DailyChallengeStreakEntity>> call() async {
    return await _repository.getStreak();
  }
}
