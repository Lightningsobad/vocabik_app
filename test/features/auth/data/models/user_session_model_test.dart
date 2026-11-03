import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/auth/data/models/user_session_model.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';

void main() {
  group('UserSessionModel', () {
    final sampleJson = {
      "id": "4ab6ecc1-cf80-48a4-beed-c45e661bcbb0",
      "device": "Chrome trên Windows",
      "ip": "172.69.176.8",
      "createdAt": "2026-09-02T12:01:32.133Z",
      "lastActive": "2026-09-02T12:01:32.133Z",
      "current": true,
    };

    test('should correctly parse UserSessionModel from JSON', () {
      final model = UserSessionModel.fromJson(sampleJson);

      expect(model, isA<UserSession>());
      expect(model.id, '4ab6ecc1-cf80-48a4-beed-c45e661bcbb0');
      expect(model.device, 'Chrome trên Windows');
      expect(model.ip, '172.69.176.8');
      expect(model.createdAt, DateTime.parse('2026-09-02T12:01:32.133Z'));
      expect(model.lastActive, DateTime.parse('2026-09-02T12:01:32.133Z'));
      expect(model.current, true);
    });

    test('should convert UserSessionModel to JSON correctly', () {
      final model = UserSessionModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['id'], '4ab6ecc1-cf80-48a4-beed-c45e661bcbb0');
      expect(json['device'], 'Chrome trên Windows');
      expect(json['ip'], '172.69.176.8');
      expect(json['current'], true);
    });

    test('should handle null or missing optional fields gracefully', () {
      final minimalJson = {
        "id": "test-id",
        "device": "Ứng dụng di động",
      };

      final model = UserSessionModel.fromJson(minimalJson);

      expect(model.id, 'test-id');
      expect(model.device, 'Ứng dụng di động');
      expect(model.ip, '');
      expect(model.createdAt, isNull);
      expect(model.lastActive, isNull);
      expect(model.current, false);
    });
  });
}
