import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/foundation.dart';

class InAppMessagingService {
  final FirebaseInAppMessaging? _instance;
  FirebaseInAppMessaging? get _inAppMessaging {
    if (_instance != null) return _instance;
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseInAppMessaging.instance;
      }
    } catch (_) {}
    return null;
  }

  InAppMessagingService([FirebaseInAppMessaging? inAppMessaging])
      : _instance = inAppMessaging;

  Future<void> init() async {
    final inApp = _inAppMessaging;
    if (inApp == null) return;
    try {
      await inApp.setAutomaticDataCollectionEnabled(true);
      await inApp.setMessagesSuppressed(false);
      debugPrint('[InAppMessagingService] Initialized successfully');
    } catch (e) {
      debugPrint('[InAppMessagingService] Init error: $e');
    }
  }

  /// Temporarily suppress In-App messages (e.g. while user is in active exercise)
  Future<void> suppressMessages(bool suppress) async {
    try {
      await _inAppMessaging?.setMessagesSuppressed(suppress);
      debugPrint('[InAppMessagingService] Messages suppressed: $suppress');
    } catch (e) {
      debugPrint('[InAppMessagingService] Error setting messages suppressed: $e');
    }
  }

  /// Programmatically trigger an In-App message by event name
  Future<void> triggerEvent(String eventName) async {
    try {
      await _inAppMessaging?.triggerEvent(eventName);
      debugPrint('[InAppMessagingService] Triggered event: $eventName');
    } catch (e) {
      debugPrint('[InAppMessagingService] Error triggering event $eventName: $e');
    }
  }
}
