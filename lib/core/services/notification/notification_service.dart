import 'package:flutter/foundation.dart';
import 'fcm_service.dart';
import 'in_app_messaging_service.dart';
import 'local_notification_service.dart';
import 'notification_router_handler.dart';

class NotificationService {
  final FcmService fcmService;
  final LocalNotificationService localNotificationService;
  final InAppMessagingService inAppMessagingService;
  final NotificationRouterHandler routerHandler;

  bool _isInitialized = false;

  NotificationService({
    required this.fcmService,
    required this.localNotificationService,
    required this.inAppMessagingService,
    required this.routerHandler,
  });

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      debugPrint('[NotificationService] Initializing notification subsystem...');

      // 1. Initialize local notifications
      await localNotificationService.init();

      // 2. Initialize in-app messaging
      await inAppMessagingService.init();

      // 3. Initialize Firebase Cloud Messaging
      await fcmService.init();

      _isInitialized = true;
      debugPrint('[NotificationService] Notification subsystem initialized successfully');
    } catch (e) {
      debugPrint('[NotificationService] Error initializing notification service: $e');
    }
  }

  /// Subscribe to daily pick and daily challenge updates
  Future<void> subscribeDailyReminders() async {
    await fcmService.subscribeToTopic('daily_reminders');
  }

  /// Unsubscribe from daily updates (e.g. on logout or user settings)
  Future<void> unsubscribeDailyReminders() async {
    await fcmService.unsubscribeFromTopic('daily_reminders');
  }
}
