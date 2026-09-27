import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class CrashlyticsService {
  Future<void> init();
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  });
  Future<void> recordFlutterFatalError(FlutterErrorDetails details);
  Future<void> setUserId(String userId);
  Future<void> setCustomKey(String key, Object value);
  Future<void> log(String message);
  Future<void> setCrashlyticsCollectionEnabled(bool enabled);
}

class FirebaseCrashlyticsServiceImpl implements CrashlyticsService {
  final FirebaseCrashlytics? _providedCrashlytics;

  FirebaseCrashlyticsServiceImpl({FirebaseCrashlytics? crashlytics})
      : _providedCrashlytics = crashlytics;

  FirebaseCrashlytics? get _crashlytics {
    if (_providedCrashlytics != null) return _providedCrashlytics;
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseCrashlytics.instance;
      }
    } catch (e) {
      _logDebug('FirebaseCrashlytics not available: $e');
    }
    return null;
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint('[Crashlytics] $message');
    }
  }

  @override
  Future<void> init() async {
    try {
      // In debug mode, collection can be disabled to avoid spamming production stats,
      // while still logging to local console. In profile/release, collection is enabled.
      final shouldCollect = !kDebugMode;
      await _crashlytics?.setCrashlyticsCollectionEnabled(shouldCollect);
      _logDebug('Initialized with collectionEnabled: $shouldCollect');
    } catch (e) {
      _logDebug('init error: $e');
    }
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) async {
    _logDebug('recordError(fatal: $fatal, reason: $reason, error: $exception)');
    try {
      await _crashlytics?.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        fatal: fatal,
      );
    } catch (e) {
      _logDebug('recordError failed: $e');
    }
  }

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {
    _logDebug('recordFlutterFatalError: ${details.exceptionAsString()}');
    try {
      await _crashlytics?.recordFlutterFatalError(details);
    } catch (e) {
      _logDebug('recordFlutterFatalError failed: $e');
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    _logDebug('setUserId: $userId');
    try {
      await _crashlytics?.setUserIdentifier(userId);
    } catch (e) {
      _logDebug('setUserIdentifier failed: $e');
    }
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    _logDebug('setCustomKey: $key = $value');
    try {
      await _crashlytics?.setCustomKey(key, value);
    } catch (e) {
      _logDebug('setCustomKey failed: $e');
    }
  }

  @override
  Future<void> log(String message) async {
    _logDebug('log: $message');
    try {
      await _crashlytics?.log(message);
    } catch (e) {
      _logDebug('log failed: $e');
    }
  }

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    _logDebug('setCrashlyticsCollectionEnabled: $enabled');
    try {
      await _crashlytics?.setCrashlyticsCollectionEnabled(enabled);
    } catch (e) {
      _logDebug('setCrashlyticsCollectionEnabled failed: $e');
    }
  }
}
