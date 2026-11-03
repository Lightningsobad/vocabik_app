import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/daily_challenge/data/models/daily_challenge_config_model.dart';

void main() {
  group('DailyChallengeConfigModel', () {
    test('extracts youtubeVideoId from thumbnailUrl when youtubeVideoId is not in JSON', () {
      final json = {
        'id': 'debd7e26-ff83-4938-937b-dc37c6ceb53f',
        'challengeDate': '2026-09-11',
        'videoSlug': '7f3aad2c-6e7b-407e-ad8e-521d7afc8d78',
        'videoTitle': 'Shadowing with Wednesday',
        'thumbnailUrl': 'https://i.ytimg.com/vi/aDJi1C5EJQo/maxresdefault.jpg',
        'category': 'entertainment',
        'cefrLevel': 'A2',
        'author': 'Васильченко',
        'durationSeconds': 27,
        'exerciseVersion': 'v1',
      };

      final model = DailyChallengeConfigModel.fromJson(json);

      expect(model.id, 'debd7e26-ff83-4938-937b-dc37c6ceb53f');
      expect(model.videoSlug, '7f3aad2c-6e7b-407e-ad8e-521d7afc8d78');
      expect(model.youtubeVideoId, 'aDJi1C5EJQo');
      expect(model.thumbnailUrl, 'https://i.ytimg.com/vi/aDJi1C5EJQo/maxresdefault.jpg');
    });

    test('prefers direct youtubeVideoId from JSON if present', () {
      final json = {
        'id': 'test-id',
        'challengeDate': '2026-09-11',
        'videoSlug': 'test-slug',
        'videoTitle': 'Test Title',
        'thumbnailUrl': 'https://i.ytimg.com/vi/oldId123456/maxresdefault.jpg',
        'youtubeVideoId': 'directId789',
        'exerciseVersion': 'v1',
      };

      final model = DailyChallengeConfigModel.fromJson(json);

      expect(model.youtubeVideoId, 'directId789');
    });

    test('handles standard response from daily-challenge/config', () {
      final responseJson = {
        'challengeConfigured': true,
        'config': {
          'id': 'debd7e26-ff83-4938-937b-dc37c6ceb53f',
          'challengeDate': '2026-09-11',
          'videoSlug': '7f3aad2c-6e7b-407e-ad8e-521d7afc8d78',
          'videoTitle': 'Shadowing with Wednesday',
          'thumbnailUrl': 'https://i.ytimg.com/vi/aDJi1C5EJQo/maxresdefault.jpg',
          'category': 'entertainment',
          'cefrLevel': 'A2',
          'author': 'Васильченко',
          'durationSeconds': 27,
          'exerciseVersion': 'v1',
          'createdAt': '2026-09-11T03:59:16.064Z',
        },
        'participantCount': 1,
        'resetAt': '2026-09-12T00:00:00.000Z',
        'userResult': null,
      };

      final responseModel = DailyChallengeResponseModel.fromJson(responseJson);

      expect(responseModel.challengeConfigured, isTrue);
      expect(responseModel.participantCount, 1);
      expect(responseModel.config?.youtubeVideoId, 'aDJi1C5EJQo');
    });
  });
}
