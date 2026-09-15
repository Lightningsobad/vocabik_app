import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/daily_challenge_config_entity.dart';
import '../../domain/entities/daily_challenge_leaderboard_entity.dart';
import '../../domain/entities/daily_challenge_streak_entity.dart';
import '../../domain/repositories/daily_challenge_repository.dart';
import '../datasources/daily_challenge_remote_data_source.dart';

@LazySingleton(as: DailyChallengeRepository)
class DailyChallengeRepositoryImpl implements DailyChallengeRepository {
  final DailyChallengeRemoteDataSource _remoteDataSource;

  DailyChallengeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DailyChallengeResponseEntity>> getConfig() async {
    try {
      final result = await _remoteDataSource.getConfig();
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
  Future<Either<Failure, List<DailyChallengeLeaderboardItemEntity>>>
      getLeaderboard(String date) async {
    try {
      final result = await _remoteDataSource.getLeaderboard(date: date);
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
  Future<Either<Failure, DailyChallengeStreakEntity>> getStreak() async {
    try {
      final result = await _remoteDataSource.getStreak();
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
  Future<Either<Failure, String>> submitResult({
    required int scoreAccuracy,
    required int scoreTimeMs,
  }) async {
    try {
      final result = await _remoteDataSource.submitResult(
        scoreAccuracy: scoreAccuracy,
        scoreTimeMs: scoreTimeMs,
      );
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
