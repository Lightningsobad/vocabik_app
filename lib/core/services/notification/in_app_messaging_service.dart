import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/foundation.dart';

class InAppMessagingService {
  final FirebaseInAppMessaging? _instance;
  FirebaseInAppMessaging get _inAppMessaging =>
      _instance ?? FirebaseInAppMessaging.instance;

  InAppMessagingService([FirebaseInAppMessaging? inAppMessaging])
      : _instance = inAppMessaging;

  Future<void> init() async {
    if (_inAppMessaging == null) return;
    try {
      await _inAppMessaging.setAutomaticDataCollectionEnabled(true);
      await _inAppMessaging.setMessagesSuppressed(false);
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
