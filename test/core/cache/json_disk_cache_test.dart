import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/core/cache/json_disk_cache.dart';

void main() {
  test('writes and reads JSON entry with timestamp, and clears by prefix', () async {
    SharedPreferences.setMockInitialValues({
      'unrelated_key': 'keep',
    });
    final prefs = await SharedPreferences.getInstance();
    final cache = JsonDiskCache(prefs);
    final now = DateTime(2026, 11, 26, 15, 0);

    await cache.write('${JsonDiskCache.homeKeyPrefix}daily_pick', {
      'title': 'Hello',
    }, now: now);

    final entry = cache.read('${JsonDiskCache.homeKeyPrefix}daily_pick');
    expect(entry, isNotNull);
    expect(entry!.cachedAt, now);
    expect((entry.data as Map<String, dynamic>)['title'], 'Hello');

    await JsonDiskCache.clearPrefixOn(prefs, JsonDiskCache.homeKeyPrefix);
    expect(cache.read('${JsonDiskCache.homeKeyPrefix}daily_pick'), isNull);
    expect(prefs.getString('unrelated_key'), 'keep');
  });

  test('removes corrupted JSON entry and returns null', () async {
    SharedPreferences.setMockInitialValues({
      '${JsonDiskCache.homeKeyPrefix}broken': '{not-valid-json',
    });
    final prefs = await SharedPreferences.getInstance();
    final cache = JsonDiskCache(prefs);

    expect(cache.read('${JsonDiskCache.homeKeyPrefix}broken'), isNull);
    expect(prefs.getString('${JsonDiskCache.homeKeyPrefix}broken'), isNull);
  });
}
