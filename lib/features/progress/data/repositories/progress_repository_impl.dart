import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/gamification.dart';
import '../../domain/entities/daily_streak.dart';
import '../../domain/repositories/progress_repository.dart';
import '../data_sources/progress_remote_data_source.dart';

@LazySingleton(as: ProgressRepository)
class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource _remoteDataSource;

  ProgressRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Gamification>> getGamificationMe() async {
    try {
      final result = await _remoteDataSource.getGamificationMe();
      return Right(result);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DailyStreak>> getDailyChallengeStreak() async {
    try {
      final result = await _remoteDataSource.getDailyChallengeStreak();
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
