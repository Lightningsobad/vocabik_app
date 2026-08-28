import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/badge_entity.dart';
import '../repositories/badge_repository.dart';

@lazySingleton
class GetBadgesUseCase {
  final BadgeRepository _repository;

  GetBadgesUseCase(this._repository);

  Future<Either<Failure, List<BadgeEntity>>> call() {
    return _repository.getBadges();
  }
}
