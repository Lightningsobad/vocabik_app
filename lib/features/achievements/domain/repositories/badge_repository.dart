import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/badge_entity.dart';

abstract class BadgeRepository {
  Future<Either<Failure, List<BadgeEntity>>> getBadges();
}
