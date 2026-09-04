import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/challenge_friend/data/models/friend_model.dart';
import 'package:vocabik_app/features/challenge_friend/domain/entities/friend_entity.dart';

void main() {
  group('FriendModel', () {
    test('correctly parses friend JSON from API response', () {
      final json = {
        'userId': 'bcdd9bcb-40a6-4b68-8392-50fd2ee1977a',
        'displayName': 'quang 6789',
        'avatarUrl': null,
        'tier': 'free',
        'cefrLevel': 'A1',
        'lastActive': '2026-08-07T04:09:49.090Z',
        'friendedAt': '2026-08-27T14:22:07.156Z',
      };

      final model = FriendModel.fromJson(json);

      expect(model.userId, 'bcdd9bcb-40a6-4b68-8392-50fd2ee1977a');
      expect(model.displayName, 'quang 6789');
      expect(model.avatarUrl, isNull);
      expect(model.tier, 'free');
      expect(model.cefrLevel, 'A1');
      expect(model.lastActive, DateTime.parse('2026-08-07T04:09:49.090Z'));
      expect(model.friendedAt, DateTime.parse('2026-08-27T14:22:07.156Z'));
    });

    test('generates initials correctly for single and multi-word names', () {
      const friend1 = FriendEntity(
        userId: '1',
        displayName: 'Minh Khôi',
      );
      expect(friend1.initials, 'MK');

      const friend2 = FriendEntity(
        userId: '2',
        displayName: 'Thu Hà',
      );
      expect(friend2.initials, 'TH');

      const friend3 = FriendEntity(
        userId: '3',
        displayName: 'John',
      );
      expect(friend3.initials, 'JO');

      const friend4 = FriendEntity(
        userId: '4',
        displayName: 'Hải Đăng',
      );
      expect(friend4.initials, 'HĐ');
    });

    test('generates formattedStats correctly with XP and streak', () {
      const friendWithStats = FriendEntity(
        userId: '1',
        displayName: 'Minh Khôi',
        xp: 1240,
        streak: 4,
      );
      expect(friendWithStats.formattedStats, '⚡ 1240 XP · 🔥 4 days');

      const friendWithoutStats = FriendEntity(
        userId: '2',
        displayName: 'quang 6789',
        cefrLevel: 'A1',
        tier: 'free',
      );
      expect(friendWithoutStats.formattedStats, 'A1 · Free');
    });
  });
}
