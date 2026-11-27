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
  test('DailyPick caches per calendar day, PersonalizedSlots always fetches when online, and both clear on logout', () async {
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

    // Same calendar day: DailyPick hits cache, PersonalizedSlots always fetches fresh.
    now = now.add(const Duration(minutes: 2));
    await repo.getDailyPick();
    final slots2 = await repo.getPersonalizedSlots();
    expect(remote.dailyPickCalls, 1);
    expect(remote.personalizedCalls, 2);
    expect(slots2.getOrElse((_) => throw StateError('')).single.videoId, 'slot-2');

    // New repository instance (cold start) on same day: DailyPick reads from disk without remote call.
    final repo2 = HomeRepositoryImpl.withClock(remote, () => now, diskCache);
    expect(repo2.getCachedDailyPick()?.videoId, 'dp-1');

    // Next calendar day: DailyPick cache expires; getCachedDailyPick returns null and getDailyPick fetches remote.
    now = DateTime(2026, 11, 27, 8, 0);
    expect(repo.getCachedDailyPick(), isNull);
    expect(repo2.getCachedDailyPick(), isNull);
    final dpNextDay = await repo.getDailyPick();
    expect(dpNextDay.getOrElse((_) => throw StateError('')).videoId, 'dp-2');
    expect(remote.dailyPickCalls, 2);

    // Simulate logout: clears both disk and RAM caches across registered repos.
    await JsonDiskCache.clearPrefixOn(prefs, JsonDiskCache.homeKeyPrefix);
    expect(repo.getCachedDailyPick(), isNull);
    expect(repo2.getCachedDailyPick(), isNull);

    // Offline after logout: PersonalizedSlots must not leak User A's RAM or disk cache.
    remote.errorToThrow = ServerException('Offline');
    expect((await repo.getPersonalizedSlots()).isLeft(), isTrue);
    expect((await repo2.getPersonalizedSlots()).isLeft(), isTrue);
    remote.errorToThrow = null;

    // After logout on same day, must fetch fresh from remote (not stale User A RAM).
    final dpAfterLogout = await repo.getDailyPick();
    expect(dpAfterLogout.getOrElse((_) => throw StateError('')).videoId, 'dp-3');
    expect(remote.dailyPickCalls, 3);
  });

  test('falls back to stale cache when remote fails unless forceRefresh is true', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final diskCache = JsonDiskCache(prefs);
    final remote = _FakeHomeRemoteDataSource();
    var now = DateTime(2026, 11, 26, 10, 0);

    final repo = HomeRepositoryImpl.withClock(remote, () => now, diskCache);
    await repo.getDailyPick();
    await repo.getPersonalizedSlots();

    now = DateTime(2026, 11, 27, 8, 0);
    remote.errorToThrow = ServerException('Offline');

    final staleDp = await repo.getDailyPick();
    expect(staleDp.isRight(), isTrue);

    final forcedDp = await repo.getDailyPick(forceRefresh: true);
    expect(forcedDp.isLeft(), isTrue);

    final staleSlots = await repo.getPersonalizedSlots();
    expect(staleSlots.isRight(), isTrue);

    final forcedSlots = await repo.getPersonalizedSlots(forceRefresh: true);
    expect(forcedSlots.isLeft(), isTrue);
  });
}
