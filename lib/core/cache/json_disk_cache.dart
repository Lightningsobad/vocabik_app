import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachedJsonEntry {
  final Object? data;
  final DateTime cachedAt;

  const CachedJsonEntry({
    required this.data,
    required this.cachedAt,
  });
}

/// Lightweight persistent JSON cache backed by [SharedPreferences] for small
/// Home feed payloads (page-1 snapshots).
@lazySingleton
class JsonDiskCache {
  static const String homeKeyPrefix = 'home_cache_';
  static final Set<VoidCallback> _homeMemoryClearers = {};

  final SharedPreferences _prefs;

  JsonDiskCache(this._prefs);

  static void registerHomeMemoryClearer(VoidCallback clearer) {
    _homeMemoryClearers.add(clearer);
  }

  CachedJsonEntry? read(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final ts = (decoded['cachedAt'] as num?)?.toInt();
      if (ts == null) {
        unawaited(_prefs.remove(key));
        return null;
      }
      return CachedJsonEntry(
        data: decoded['data'],
        cachedAt: DateTime.fromMillisecondsSinceEpoch(ts),
      );
    } catch (_) {
      unawaited(_prefs.remove(key));
      return null;
    }
  }

  Future<void> write(String key, Object? data, {DateTime? now}) async {
    final payload = jsonEncode({
      'cachedAt': (now ?? DateTime.now()).millisecondsSinceEpoch,
      'data': data,
    });
    await _prefs.setString(key, payload);
  }

  static Future<void> clearPrefixOn(
    SharedPreferences prefs,
    String prefix,
  ) async {
    if (prefix == homeKeyPrefix) {
      for (final clearer in _homeMemoryClearers.toList()) {
        clearer();
      }
    }
    final keys = prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
