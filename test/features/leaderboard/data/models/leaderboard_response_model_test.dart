import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/leaderboard/data/models/leaderboard_response_model.dart';

void main() {
  group('LeaderboardResponseModel.fromJson', () {
    test('correctly parses totalUsers from API response JSON', () {
      final json = {
        'period': 'last_week',
        'scope': 'global',
        'nextResetAt': '2026-09-07T00:00:00.000Z',
        'totalUsers': 2,
        'entries': [
          {
            'rank': 1,
            'userId': '48b5aa8f-3e4e-4e8d-a625-abbf098ea3ce',
            'displayName': 'quang pham',
            'avatarUrl': null,
            'xp': 71,
          },
          {
            'rank': 2,
            'userId': 'bcdd9bcb-40a6-4b68-8392-50fd2ee1977a',
            'displayName': 'quang 6789',
            'avatarUrl': null,
            'xp': 19,
          }
        ],
        'ownRank': null,
        'surrounding': null,
      };

      final model = LeaderboardResponseModel.fromJson(json);

      expect(model.period, 'last_week');
      expect(model.scope, 'global');
      expect(model.totalUsers, 2);
      expect(model.totalParticipants, 2);
      expect(model.entries.length, 2);
      expect(model.entries[0].displayName, 'quang pham');
      expect(model.entries[0].xp, 71);
      expect(model.ownRank, isNull);
    });

    test('correctly parses large totalUsers (e.g., 1234) and ownRank', () {
      final json = {
        'period': 'this_week',
        'scope': 'global',
        'nextResetAt': '2026-09-07T00:00:00.000Z',
        'totalUsers': 1234,
        'entries': [
          {
            'rank': 1,
            'userId': 'u1',
            'displayName': 'Minh Khôi',
            'xp': 1240,
          },
        ],
        'ownRank': {
          'rank': 47,
          'userId': 'me',
          'displayName': 'quang',
          'xp': 340,
        },
        'surrounding': null,
      };

      final model = LeaderboardResponseModel.fromJson(json, currentUserId: 'me');

      expect(model.totalUsers, 1234);
      expect(model.totalParticipants, 1234);
      expect(model.ownRank, isNotNull);
      expect(model.ownRank!.rank, 47);
      expect(model.ownRank!.xp, 340);
      expect(model.ownRank!.isCurrentUser, isTrue);
    });

    test('falls back to totalParticipants if totalUsers is not in json', () {
      final json = {
        'period': 'this_week',
        'scope': 'global',
        'totalParticipants': 88,
        'entries': [],
      };

      final model = LeaderboardResponseModel.fromJson(json);

      expect(model.totalUsers, 88);
      expect(model.totalParticipants, 88);
    });

    test('falls back to ownRank.totalUsers if root totalUsers is missing', () {
      final json = {
        'period': 'this_week',
        'scope': 'global',
        'ownRank': {
          'rank': 5,
          'userId': 'user-1',
          'displayName': 'quang',
          'xp': 100,
          'totalUsers': 500,
        },
        'entries': [],
      };

      final model = LeaderboardResponseModel.fromJson(json);

      expect(model.totalUsers, 500);
      expect(model.totalParticipants, 500);
    });

    test('detects ownRank from entries if root ownRank is null but currentUserId matches', () {
      final json = {
        'period': 'last_week',
        'scope': 'global',
        'totalUsers': 2,
        'entries': [
          {
            'rank': 1,
            'userId': '48b5aa8f-3e4e-4e8d-a625-abbf098ea3ce',
            'displayName': 'quang pham',
            'avatarUrl': null,
            'xp': 71,
          },
        ],
        'ownRank': null,
      };

      final model = LeaderboardResponseModel.fromJson(
        json,
        currentUserId: '48b5aa8f-3e4e-4e8d-a625-abbf098ea3ce',
      );

      expect(model.ownRank, isNotNull);
      expect(model.ownRank!.rank, 1);
      expect(model.ownRank!.displayName, 'quang pham');
      expect(model.ownRank!.isCurrentUser, isTrue);
    });
  });
}
