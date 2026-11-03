import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/daily_challenge_config_entity.dart';
import '../repositories/daily_challenge_repository.dart';

@lazySingleton
class GetDailyChallengeConfigUseCase {
  final DailyChallengeRepository _repository;

  GetDailyChallengeConfigUseCase(this._repository);

  Future<Either<Failure, DailyChallengeResponseEntity>> call() async {
    return await _repository.getConfig();
  }
}
