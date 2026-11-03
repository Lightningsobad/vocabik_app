import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/badge_entity.dart';
import '../../domain/repositories/badge_repository.dart';
import '../datasources/badge_remote_data_source.dart';

@LazySingleton(as: BadgeRepository)
class BadgeRepositoryImpl implements BadgeRepository {
  final BadgeRemoteDataSource _remoteDataSource;

  BadgeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<BadgeEntity>>> getBadges({String? category}) async {
    try {
      final result = await _remoteDataSource.getBadges(category: category);
      return Right(result);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
