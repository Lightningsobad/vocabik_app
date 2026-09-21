import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/services/notification/notification_router_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NotificationRouterHandler routerHandler;

  setUp(() {
    routerHandler = NotificationRouterHandler();
  });

  tearDown(() {
    routerHandler.dispose();
  });

  group('InAppChallengeEvent', () {
    test('parses friend_challenge map correctly', () {
      final data = {
        'type': 'friend_challenge',
        'challenge_id': 'ch_123',
        'video_id': 'vid_456',
        'video_title': 'Shape of You',
        'challenger_name': 'Alex',
        'challenger_score': '95',
        'target_route': '/exercise/vid_456?challenge_id=ch_123',
      };

      final event = InAppChallengeEvent.fromMap(data);

      expect(event.challengeId, 'ch_123');
      expect(event.videoId, 'vid_456');
      expect(event.videoTitle, 'Shape of You');
      expect(event.challengerName, 'Alex');
      expect(event.challengerScore, 95);
      expect(event.targetRoute, '/exercise/vid_456?challenge_id=ch_123');
    });

    test('falls back to accuracy_score when challenger_score is absent', () {
      final data = {
        'challenge_id': 'ch_789',
        'accuracy_score': '88',
        'video_id': 'vid_999',
      };

      final event = InAppChallengeEvent.fromMap(data);

      expect(event.challengerScore, 88);
      expect(event.targetRoute, '/exercise/vid_999');
    });
  });

  group('NotificationRouterHandler In-App Stream', () {
    test('emits InAppChallengeEvent on notifyInAppChallenge', () async {
      final data = {
        'type': 'friend_challenge',
        'challenge_id': 'ch_test',
        'challenger_name': 'Sarah',
        'video_id': 'vid_abc',
        'video_title': 'English Grammar Test',
        'challenger_score': '90',
        'target_route': '/exercise/vid_abc',
      };

      expectLater(
        routerHandler.onInAppChallenge,
        emits(isA<InAppChallengeEvent>()
            .having((e) => e.challengeId, 'challengeId', 'ch_test')
            .having((e) => e.challengerName, 'challengerName', 'Sarah')
            .having((e) => e.challengerScore, 'challengerScore', 90)),
      );

      routerHandler.notifyInAppChallenge(data);
    });
  });
}
