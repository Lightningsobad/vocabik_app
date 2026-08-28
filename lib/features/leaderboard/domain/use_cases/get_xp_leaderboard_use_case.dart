import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import '../entities/leaderboard_response_entity.dart';
import '../repositories/leaderboard_repository.dart';

@lazySingleton
class GetXpLeaderboardUseCase {
  final LeaderboardRepository _repository;

  GetXpLeaderboardUseCase(this._repository);

  Future<Either<Failure, LeaderboardResponseEntity>> call({
    required String period,
    required String scope,
  }) {
    return _repository.getLeaderboard(period: period, scope: scope);
  }
}
