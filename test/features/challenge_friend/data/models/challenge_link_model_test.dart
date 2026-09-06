import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/challenge_friend/data/models/challenge_link_request_model.dart';
import 'package:vocabik_app/features/challenge_friend/data/models/challenge_link_response_model.dart';

void main() {
  group('ChallengeLink Models', () {
    test('ChallengeLinkRequestModel converts to JSON accurately', () {
      const request = ChallengeLinkRequestModel(
        videoSlug: 'shape-of-you',
        exerciseVersion: 'v1',
        challengerScoreAccuracy: 85,
        challengerScoreTimeMs: 120000,
      );

      final json = request.toJson();
      expect(json['videoSlug'], 'shape-of-you');
      expect(json['exerciseVersion'], 'v1');
      expect(json['challengerScoreAccuracy'], 85);
      expect(json['challengerScoreTimeMs'], 120000);
    });

    test('ChallengeLinkResponseModel parses response JSON accurately', () {
      final json = {
        'uuid': 'c1a9941f-9f3c-4538-a100-8a34f8b3f95c',
        'url': 'https://vocabik.com/challenge/c1a9941f-9f3c-4538-a100-8a34f8b3f95c',
        'expiresAt': '2026-10-04T02:42:11.773Z',
      };

      final response = ChallengeLinkResponseModel.fromJson(json);
      expect(response.uuid, 'c1a9941f-9f3c-4538-a100-8a34f8b3f95c');
      expect(
        response.url,
        'https://vocabik.com/challenge/c1a9941f-9f3c-4538-a100-8a34f8b3f95c',
      );
      expect(response.expiresAt, DateTime.parse('2026-10-04T02:42:11.773Z'));
    });
  });
}
