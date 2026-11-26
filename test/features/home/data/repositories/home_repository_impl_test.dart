import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/core/cache/json_disk_cache.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:vocabik_app/features/home/data/models/daily_pick_model.dart';
import 'package:vocabik_app/features/home/data/models/personalized_slot_model.dart';
import 'package:vocabik_app/features/home/data/repositories/home_repository_impl.dart';

class _FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  int dailyPickCalls = 0;
  int personalizedCalls = 0;
  Object? errorToThrow;

  @override
  Future<DailyPickModel> getDailyPick() async {
    dailyPickCalls++;
    if (errorToThrow != null) throw errorToThrow!;
    return DailyPickModel(
      videoId: 'dp-$dailyPickCalls',
      title: 'Pick $dailyPickCalls',
      thumbnailUrl: 'https://example.com/dp.jpg',
      cefrLevel: 'B1',
      playerUrl: 'https://example.com/player',
    );
  }

  @override
  Future<List<PersonalizedSlotModel>> getPersonalizedSlots() async {
    personalizedCalls++;
    if (errorToThrow != null) throw errorToThrow!;
    return [
      PersonalizedSlotModel(
        position: 1,
        videoId: 'slot-$personalizedCalls',
        title: 'Slot $personalizedCalls',
        thumbnailUrl: 'https://example.com/slot.jpg',
        youtubeVideoId: 'yt-1',
        cefrLevel: 'A2',
      ),
    ];
  }
}

void main() {
  test('persists DailyPick and PersonalizedSlots to disk, respects TTL, and clears both RAM and disk on logout', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final diskCache = JsonDiskCache(prefs);
    final remote = _FakeHomeRemoteDataSource();
    var now = DateTime(2026, 11, 26, 10, 0);

    final repo = HomeRepositoryImpl.withClock(remote, () => now, diskCache);
    final dp1 = await repo.getDailyPick();
    final slots1 = await repo.getPersonalizedSlots();
    expect(dp1.isRight(), isTrue);
    expect(slots1.isRight(), isTrue);
    expect(remote.dailyPickCalls, 1);
    expect(remote.personalizedCalls, 1);

    // Within TTL: hits RAM cache.
    now = now.add(const Duration(minutes: 2));
    await repo.getDailyPick();
    await repo.getPersonalizedSlots();
    expect(remote.dailyPickCalls, 1);
    expect(remote.personalizedCalls, 1);

    // New repository instance (cold start): reads from disk without remote call.
    final repo2 = HomeRepositoryImpl.withClock(remote, () => now, diskCache);
    expect(repo2.getCachedDailyPick()?.videoId, 'dp-1');
    expect(repo2.getCachedPersonalizedSlots()?.single.videoId, 'slot-1');

    // Simulate logout: clears both disk and RAM caches across registered repos.
    await JsonDiskCache.clearPrefixOn(prefs, JsonDiskCache.homeKeyPrefix);
    expect(repo.getCachedDailyPick(), isNull);
    expect(repo.getCachedPersonalizedSlots(), isNull);
    expect(repo2.getCachedDailyPick(), isNull);

    // After logout within TTL window, must fetch fresh from remote (not stale User A RAM).
    final dp2 = await repo.getDailyPick();
    expect(dp2.getOrElse((_) => throw StateError('')).videoId, 'dp-2');
    expect(remote.dailyPickCalls, 2);
  });

  test('falls back to stale cache when remote fails unless forceRefresh is true', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final diskCache = JsonDiskCache(prefs);
    final remote = _FakeHomeRemoteDataSource();
    var now = DateTime(2026, 11, 26, 10, 0);

    final repo = HomeRepositoryImpl.withClock(remote, () => now, diskCache);
    await repo.getDailyPick();

    now = now.add(const Duration(minutes: 5));
    remote.errorToThrow = ServerException('Offline');

    final stale = await repo.getDailyPick();
    expect(stale.isRight(), isTrue);

    final forced = await repo.getDailyPick(forceRefresh: true);
    expect(forced.isLeft(), isTrue);
  });
}
