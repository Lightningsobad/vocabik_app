import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/profile/data/models/update_profile_request_model.dart';
import 'package:vocabik_app/features/profile/data/models/update_profile_response_model.dart';

void main() {
  group('UpdateProfileRequestModel', () {
    test('toJson with both cefrLevel and displayName', () {
      const model = UpdateProfileRequestModel(
        cefrLevel: 'A1',
        displayName: 'Quang 226789',
      );

      final json = model.toJson();

      expect(json, {
        'cefrLevel': 'A1',
        'displayName': 'Quang 226789',
      });
    });

    test('toJson with only displayName', () {
      const model = UpdateProfileRequestModel(
        displayName: 'Quang',
      );

      final json = model.toJson();

      expect(json, {
        'displayName': 'Quang',
      });
      expect(json.containsKey('cefrLevel'), false);
    });

    test('toJson with only cefrLevel', () {
      const model = UpdateProfileRequestModel(
        cefrLevel: 'B2',
      );

      final json = model.toJson();

      expect(json, {
        'cefrLevel': 'B2',
      });
      expect(json.containsKey('displayName'), false);
    });
  });

  group('UpdateProfileResponseModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'cefrLevel': 'A1',
        'displayName': 'Quang 226789',
      };

      final model = UpdateProfileResponseModel.fromJson(json);

      expect(model.cefrLevel, 'A1');
      expect(model.displayName, 'Quang 226789');
    });

    test('toJson converts correctly', () {
      const model = UpdateProfileResponseModel(
        cefrLevel: 'A1',
        displayName: 'Quang 226789',
      );

      expect(model.toJson(), {
        'cefrLevel': 'A1',
        'displayName': 'Quang 226789',
      });
    });
  });
}
