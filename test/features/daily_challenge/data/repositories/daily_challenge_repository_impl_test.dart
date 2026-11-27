import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/core/cache/json_disk_cache.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/features/daily_challenge/data/datasources/daily_challenge_remote_data_source.dart';
import 'package:vocabik_app/features/daily_challenge/data/models/daily_challenge_config_model.dart';
import 'package:vocabik_app/features/daily_challenge/data/models/daily_challenge_leaderboard_model.dart';
import 'package:vocabik_app/features/daily_challenge/data/models/daily_challenge_streak_model.dart';
import 'package:vocabik_app/features/daily_challenge/data/repositories/daily_challenge_repository_impl.dart';

class _FakeDailyChallengeRemoteDataSource
    implements DailyChallengeRemoteDataSource {
  int getConfigCalls = 0;
  Object? errorToThrow;

  @override
  Future<DailyChallengeResponseModel> getConfig({
    CancelToken? cancelToken,
  }) async {
    getConfigCalls++;
    if (errorToThrow != null) throw errorToThrow!;
    return DailyChallengeResponseModel(
      challengeConfigured: true,
      participantCount: getConfigCalls * 10,
    );
  }

  @override
  Future<List<DailyChallengeLeaderboardItemModel>> getLeaderboard({
    required String date,
    CancelToken? cancelToken,
  }) async =>
      const [];

  @override
  Future<DailyChallengeStreakModel> getStreak({CancelToken? cancelToken}) async =>
      const DailyChallengeStreakModel(
        userId: 'u1',
        currentStreak: 0,
        longestStreak: 0,
      );

  @override
  Future<String> submitResult({
    required int scoreAccuracy,
    required int scoreTimeMs,
    CancelToken? cancelToken,
  }) async =>
      'ok';
}

void main() {
  test('persists config to disk, falls back when offline, and clears RAM + disk on logout', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final diskCache = JsonDiskCache(prefs);
    final remote = _FakeDailyChallengeRemoteDataSource();
    var now = DateTime(2026, 11, 26, 10, 0);

    final repo =
        DailyChallengeRepositoryImpl.withClock(remote, () => now, diskCache);
    final res1 = await repo.getConfig();
    expect(res1.getOrElse((_) => throw StateError('')).participantCount, 10);
    expect(remote.getConfigCalls, 1);

    // Cold start in new instance reads disk cache.
    final repo2 =
        DailyChallengeRepositoryImpl.withClock(remote, () => now, diskCache);
    expect(repo2.getCachedConfig()?.participantCount, 10);

    // Clear on logout clears both RAM and disk.
    await JsonDiskCache.clearPrefixOn(prefs, JsonDiskCache.homeKeyPrefix);
    expect(repo.getCachedConfig(), isNull);
    expect(repo2.getCachedConfig(), isNull);

    final res2 = await repo.getConfig();
    expect(res2.getOrElse((_) => throw StateError('')).participantCount, 20);
    expect(remote.getConfigCalls, 2);

    // Stale fallback vs forceRefresh.
    now = now.add(const Duration(minutes: 5));
    expect(repo.getCachedConfig(), isNull);
    remote.errorToThrow = NetworkException();
    expect((await repo.getConfig()).isRight(), isTrue);
    expect((await repo.getConfig(forceRefresh: true)).isLeft(), isTrue);
  });
}
