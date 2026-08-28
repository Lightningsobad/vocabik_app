import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/daily_challenge_config_entity.dart';
import '../entities/daily_challenge_leaderboard_entity.dart';
import '../entities/daily_challenge_streak_entity.dart';

abstract class DailyChallengeRepository {
  Future<Either<Failure, DailyChallengeResponseEntity>> getConfig();
  Future<Either<Failure, List<DailyChallengeLeaderboardItemEntity>>>
      getLeaderboard(String date);
  Future<Either<Failure, DailyChallengeStreakEntity>> getStreak();
}
