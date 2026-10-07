import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'local_notification_service.dart';
import 'notification_router_handler.dart';

/// Top-level background message handler required by Firebase Messaging
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint(
      '[FCM Background Handler] Received message: ${message.messageId}, data: ${message.data}');
}

class FcmService {
  final FirebaseMessaging? _messagingInstance;
  final LocalNotificationService _localNotificationService;
  final NotificationRouterHandler _routerHandler;

  FirebaseMessaging? get _messaging {
    if (_messagingInstance != null) return _messagingInstance;
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseMessaging.instance;
      }
    } catch (_) {}
    return null;
  }

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  // Stream controller for exposing token updates
  final _tokenController = StreamController<String>.broadcast();
  Stream<String> get onTokenRefresh => _tokenController.stream;

  String? _fcmToken;
  String? get currentToken => _fcmToken;

  FcmService(
    this._localNotificationService,
    this._routerHandler, [
    FirebaseMessaging? messaging,
  ]) : _messagingInstance = messaging;

  Future<void> init() async {
    final messaging = _messaging;
    if (messaging == null) {
      debugPrint('[FcmService] Firebase not initialized. Skipping FCM init.');
      return;
    }

    // 1. Request permission
    await requestPermission();

    // 2. Configure foreground notification presentation options (iOS)
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. Get initial FCM token
    try {
      _fcmToken = await messaging.getToken();
      if (_fcmToken != null) {
        if (kDebugMode) {
          try {
            await Clipboard.setData(ClipboardData(text: _fcmToken!));
          } catch (_) {}
        }
        debugPrint('\n\n================================================================');
        debugPrint('🔥 [VOCABIK FCM REGISTRATION TOKEN] 🔥');
        debugPrint('$_fcmToken');
        debugPrint('📋 (Đã tự động copy token vào Clipboard của bạn, có thể dán trực tiếp!)');
        debugPrint('================================================================\n\n');
      } else {
        debugPrint('\n⚠️ [FcmService] FCM Token trả về null. Kiểm tra Google Play Services trên thiết bị.\n');
      }
    } catch (e) {
      debugPrint('\n❌ [FcmService] Lỗi khi lấy FCM Token: $e\n');
    }

    // 4. Listen for token refresh
    _onTokenRefreshSubscription = messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      _tokenController.add(token);
      debugPrint('\n================================================================');
      debugPrint('🔥 [VOCABIK FCM TOKEN REFRESHED] 🔥: $token');
      debugPrint('================================================================\n');
    });

    // 5. Setup message listeners
    _setupMessageListeners();

    // 6. Check if app was opened by tapping a notification from terminated state
    await _checkInitialMessage();

    debugPrint('[FcmService] Initialized successfully');
  }

  Future<NotificationSettings?> requestPermission() async {
    final messaging = _messaging;
    if (messaging == null) return null;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        '[FcmService] User permission status: ${settings.authorizationStatus}');
    return settings;
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging?.subscribeToTopic(topic);
      debugPrint('[FcmService] Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('[FcmService] Error subscribing to topic $topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging?.unsubscribeFromTopic(topic);
      debugPrint('[FcmService] Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('[FcmService] Error unsubscribing from topic $topic: $e');
    }
  }

  void _setupMessageListeners() {
    if (_messaging == null) return;

    // A. Foreground message listener
    _onMessageSubscription = FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
          '[FcmService] Foreground message received: ${message.notification?.title}, data: ${message.data}');

      final data = message.data;
      final type = data['type']?.toString();

      if (type == 'friend_challenge') {
        // Notify in-app banner for active user
        _routerHandler.notifyInAppChallenge(data);

        // Also display local notification banner
        _localNotificationService.showNotification(
          id: message.messageId.hashCode,
          title: message.notification?.title ?? '⚔️ Lời thách đấu mới!',
          body: message.notification?.body ?? 'Bạn bè vừa thách đấu bạn!',
          data: data,
          channelId: LocalNotificationService.challengesChannelId,
        );
      } else {
        // Daily challenge or general notifications
        final notification = message.notification;
        if (notification != null) {
          _localNotificationService.showNotification(
            id: message.messageId.hashCode,
            title: notification.title,
            body: notification.body,
            data: data,
            channelId: LocalNotificationService.dailyChannelId,
          );
        }
      }
    });

    // B. Background notification tap listener (when app in background)
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('[FcmService] Notification opened from background: ${message.data}');
      _routerHandler.handleData(message.data);
    });
  }

  Future<void> _checkInitialMessage() async {
    try {
      final initialMessage = await _messaging?.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
            '[FcmService] App opened from terminated state via notification: ${initialMessage.data}');
        // Delay slightly to let initial router and auth initialize
        Future.delayed(const Duration(milliseconds: 500), () {
          _routerHandler.handleData(initialMessage.data);
        });
      }
    } catch (e) {
      debugPrint('[FcmService] Error getting initial message: $e');
    }
  }

  void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _onTokenRefreshSubscription?.cancel();
    _tokenController.close();
  }
}
