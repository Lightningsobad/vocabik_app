import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_router_handler.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationRouterHandler _routerHandler;
  bool _isInitialized = false;

  static const String dailyChannelId = 'channel_daily';
  static const String dailyChannelName = 'Daily Reminders';
  static const String dailyChannelDesc =
      'Notifications for Daily Pick and Daily Challenge';

  static const String challengesChannelId = 'channel_challenges';
  static const String challengesChannelName = 'Friend Challenges';
  static const String challengesChannelDesc =
      'Notifications when friends challenge you in Vocabik';

  LocalNotificationService(this._routerHandler)
      : _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );

    await _createNotificationChannels();

    _isInitialized = true;
    debugPrint('[LocalNotificationService] Initialized successfully');
  }

  void _onSelectNotification(NotificationResponse response) {
    debugPrint(
        '[LocalNotificationService] Notification tapped: ${response.payload}');
    _routerHandler.handlePayloadString(response.payload);
  }

  Future<void> _createNotificationChannels() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      const dailyChannel = AndroidNotificationChannel(
        dailyChannelId,
        dailyChannelName,
        description: dailyChannelDesc,
        importance: Importance.defaultImportance,
      );

      const challengesChannel = AndroidNotificationChannel(
        challengesChannelId,
        challengesChannelName,
        description: challengesChannelDesc,
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
      );

      await androidPlugin.createNotificationChannel(dailyChannel);
      await androidPlugin.createNotificationChannel(challengesChannel);
      debugPrint('[LocalNotificationService] Notification channels created');
    }
  }

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    Map<String, dynamic>? data,
    String? channelId,
  }) async {
    final targetChannelId = channelId ?? dailyChannelId;
    final isChallenge = targetChannelId == challengesChannelId;

    final androidDetails = AndroidNotificationDetails(
      targetChannelId,
      isChallenge ? challengesChannelName : dailyChannelName,
      channelDescription: isChallenge ? challengesChannelDesc : dailyChannelDesc,
      importance: isChallenge ? Importance.max : Importance.defaultImportance,
      priority: isChallenge ? Priority.high : Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payloadString = data != null ? jsonEncode(data) : null;

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payloadString,
    );
  }
}
