import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/moderation/data/models/block_user_response_model.dart';
import 'package:vocabik_app/features/moderation/data/models/blocked_user_model.dart';
import 'package:vocabik_app/features/moderation/data/models/report_request_model.dart';
import 'package:vocabik_app/features/moderation/data/models/report_response_model.dart';

void main() {
  group('ReportRequestModel', () {
    test('toJson with details', () {
      const model = ReportRequestModel(
        targetType: 'user',
        targetId: 'user-123',
        reason: 'harassment',
        details: 'Offensive language',
      );

      final json = model.toJson();

      expect(json, {
        'targetType': 'user',
        'targetId': 'user-123',
        'reason': 'harassment',
        'details': 'Offensive language',
      });
    });

    test('toJson without details', () {
      const model = ReportRequestModel(
        targetType: 'user',
        targetId: 'user-123',
        reason: 'spam',
      );

      final json = model.toJson();

      expect(json, {
        'targetType': 'user',
        'targetId': 'user-123',
        'reason': 'spam',
      });
      expect(json.containsKey('details'), false);
    });
  });

  group('ReportResponseModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'success': true,
        'reportId': 'rep-abc',
        'message': 'Report received',
      };

      final model = ReportResponseModel.fromJson(json);

      expect(model.success, true);
      expect(model.reportId, 'rep-abc');
      expect(model.message, 'Report received');
    });
  });

  group('BlockUserResponseModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'success': true,
        'targetUserId': 'u-456',
        'message': 'User blocked',
      };

      final model = BlockUserResponseModel.fromJson(json);

      expect(model.success, true);
      expect(model.targetUserId, 'u-456');
      expect(model.message, 'User blocked');
    });
  });

  group('BlockedUserModel', () {
    test('fromJson and toJson roundtrip', () {
      final json = {
        'userId': 'u-789',
        'displayName': 'Bad User',
        'blockedAt': '2026-10-14T08:30:00.000Z',
      };

      final model = BlockedUserModel.fromJson(json);

      expect(model.userId, 'u-789');
      expect(model.displayName, 'Bad User');
      expect(model.blockedAt, DateTime.parse('2026-10-14T08:30:00.000Z'));
      expect(model.toJson(), json);
    });
  });
}
