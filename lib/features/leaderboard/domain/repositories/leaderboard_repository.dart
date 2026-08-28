import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import '../entities/leaderboard_response_entity.dart';

abstract class LeaderboardRepository {
  Future<Either<Failure, LeaderboardResponseEntity>> getLeaderboard({
    required String period,
    required String scope,
  });
}
