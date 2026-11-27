import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/cache/json_disk_cache.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/daily_challenge_config_entity.dart';
import '../../domain/entities/daily_challenge_leaderboard_entity.dart';
import '../../domain/entities/daily_challenge_streak_entity.dart';
import '../../domain/repositories/daily_challenge_repository.dart';
import '../datasources/daily_challenge_remote_data_source.dart';
import '../models/daily_challenge_config_model.dart';

class _CachedDailyChallenge {
  final DailyChallengeResponseEntity data;
  final DateTime cachedAt;

  const _CachedDailyChallenge(this.data, this.cachedAt);
}

@LazySingleton(as: DailyChallengeRepository)
class DailyChallengeRepositoryImpl implements DailyChallengeRepository {
  final DailyChallengeRemoteDataSource _remoteDataSource;
  final JsonDiskCache? _diskCache;
  final DateTime Function() _now;

  static const Duration _cacheTtl = Duration(minutes: 3);
  static const String _configDiskKey =
      '${JsonDiskCache.homeKeyPrefix}daily_challenge_config';

  _CachedDailyChallenge? _configCache;

  @factoryMethod
  DailyChallengeRepositoryImpl(
    this._remoteDataSource,
    JsonDiskCache diskCache,
  )   : _diskCache = diskCache,
        _now = DateTime.now {
    JsonDiskCache.registerHomeMemoryClearer(_clearMemoryCache);
  }

  @visibleForTesting
  DailyChallengeRepositoryImpl.withClock(
    this._remoteDataSource,
    this._now, [
    this._diskCache,
  ]) {
    JsonDiskCache.registerHomeMemoryClearer(_clearMemoryCache);
  }

  void _clearMemoryCache() {
    _configCache = null;
  }

  _CachedDailyChallenge? _getOrLoadConfig() {
    if (_configCache != null) return _configCache;
    final disk = _diskCache?.read(_configDiskKey);
    if (disk?.data is! Map<String, dynamic>) return null;
    try {
      final model = DailyChallengeResponseModel.fromJson(
        disk!.data as Map<String, dynamic>,
      );
      _configCache = _CachedDailyChallenge(model, disk.cachedAt);
      return _configCache;
    } catch (_) {
      return null;
    }
  }

  @override
  DailyChallengeResponseEntity? getCachedConfig() {
    final cached = _getOrLoadConfig();
    if (cached == null || _now().difference(cached.cachedAt) >= _cacheTtl) {
      return null;
    }
    return cached.data;
  }

  @override
  Future<Either<Failure, DailyChallengeResponseEntity>> getConfig({
    bool forceRefresh = false,
  }) async {
    final cached = _getOrLoadConfig();
    if (!forceRefresh &&
        cached != null &&
        _now().difference(cached.cachedAt) < _cacheTtl) {
      return Right(cached.data);
    }

    try {
      final result = await _remoteDataSource.getConfig();
      final now = _now();
      _configCache = _CachedDailyChallenge(result, now);
      await _diskCache?.write(_configDiskKey, result.toJson(), now: now);
      return Right(result);
    } on NetworkException {
      if (!forceRefresh && cached != null) return Right(cached.data);
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      if (!forceRefresh && cached != null) return Right(cached.data);
      return Left(ServerFailure(e.message));
    } catch (e) {
      if (!forceRefresh && cached != null) return Right(cached.data);
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
