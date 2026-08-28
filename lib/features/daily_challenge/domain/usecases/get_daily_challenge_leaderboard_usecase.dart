import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/daily_challenge_leaderboard_entity.dart';
import '../repositories/daily_challenge_repository.dart';

@lazySingleton
class GetDailyChallengeLeaderboardUseCase {
  final DailyChallengeRepository _repository;

  GetDailyChallengeLeaderboardUseCase(this._repository);

  Future<Either<Failure, List<DailyChallengeLeaderboardItemEntity>>> call(
    String date,
  ) async {
    return await _repository.getLeaderboard(date);
  }
}
