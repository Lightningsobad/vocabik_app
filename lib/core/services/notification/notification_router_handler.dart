import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../routes/app_router.dart';

/// Class encapsulating an incoming challenge event for In-App Banner presentation
class InAppChallengeEvent {
  final String challengeId;
  final String challengerName;
  final String? challengerAvatar;
  final String videoId;
  final String videoTitle;
  final int challengerScore;
  final String targetRoute;

  const InAppChallengeEvent({
    required this.challengeId,
    required this.challengerName,
    this.challengerAvatar,
    required this.videoId,
    required this.videoTitle,
    required this.challengerScore,
    required this.targetRoute,
  });

  factory InAppChallengeEvent.fromMap(Map<String, dynamic> data) {
    final score = int.tryParse(data['challenger_score']?.toString() ?? '') ??
        int.tryParse(data['accuracy_score']?.toString() ?? '') ??
        0;

    final videoId = data['video_id']?.toString() ?? '';
    final videoTitle = data['video_title']?.toString() ?? 'Challenge';
    final targetRoute = data['target_route']?.toString() ??
        (videoId.isNotEmpty ? '/exercise/$videoId' : '/home');

    return InAppChallengeEvent(
      challengeId: data['challenge_id']?.toString() ?? '',
      challengerName: data['challenger_name']?.toString() ?? 'A friend',
      challengerAvatar: data['challenger_avatar']?.toString(),
      videoId: videoId,
      videoTitle: videoTitle,
      challengerScore: score,
      targetRoute: targetRoute,
    );
  }
}

class NotificationRouterHandler {
  // Broadcast stream for in-app challenge events (e.g. when app is in foreground)
  final _inAppChallengeController =
      StreamController<InAppChallengeEvent>.broadcast();
  Stream<InAppChallengeEvent> get onInAppChallenge =>
      _inAppChallengeController.stream;

  void handleData(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    final targetRoute = data['target_route']?.toString();

    if (kDebugMode) {
      debugPrint('[NotificationRouterHandler] Handling payload (type: $type)');
    }

    if (targetRoute != null && targetRoute.isNotEmpty) {
      _navigateTo(targetRoute);
      return;
    }

    // Fallback based on type
    switch (type) {
      case 'daily_challenge':
        _navigateTo('/home/daily-challenge');
        break;
      case 'daily_pick':
        _navigateTo('/home');
        break;
      case 'friend_challenge':
        final videoId = data['video_id']?.toString();
        if (videoId != null && videoId.isNotEmpty) {
          _navigateTo('/exercise/$videoId');
        } else {
          _navigateTo('/home');
        }
        break;
      default:
        if (kDebugMode) {
          debugPrint('[NotificationRouterHandler] Unknown notification type: $type');
        }
        break;
    }
  }

  void handlePayloadString(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final data = jsonDecode(payload);
      if (data is Map<String, dynamic>) {
        handleData(data);
      } else if (data is Map) {
        handleData(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationRouterHandler] Error parsing payload string: $e');
      }
      if (payload.startsWith('/')) {
        _navigateTo(payload);
      }
    }
  }

  void notifyInAppChallenge(Map<String, dynamic> data) {
    try {
      final event = InAppChallengeEvent.fromMap(data);
      _inAppChallengeController.add(event);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationRouterHandler] Error notifying in-app challenge: $e');
      }
    }
  }

  void _navigateTo(String route) {
    try {
      if (kDebugMode) {
        debugPrint('[NotificationRouterHandler] Navigating to: $route');
      }
      appRouter.push(route);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationRouterHandler] Push failed, trying go: $e');
      }
      try {
        appRouter.go(route);
      } catch (e2) {
        if (kDebugMode) {
          debugPrint('[NotificationRouterHandler] Go navigation error: $e2');
        }
      }
    }
  }

  void dispose() {
    _inAppChallengeController.close();
  }
}
