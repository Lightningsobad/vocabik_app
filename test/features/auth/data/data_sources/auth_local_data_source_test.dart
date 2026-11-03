import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AuthLocalDataSourceImpl Secure Storage', () {
    test('migrates legacy tokens from SharedPreferences to FlutterSecureStorage on init', () async {
      SharedPreferences.setMockInitialValues({
        'ACCESS_TOKEN': 'legacy_access_token',
        'REFRESH_TOKEN': 'legacy_refresh_token',
      });
      final prefs = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage();

      final dataSource = AuthLocalDataSourceImpl(prefs, secureStorage);

      await dataSource.init();

      expect(dataSource.getAccessToken(), 'legacy_access_token');
      expect(dataSource.getRefreshToken(), 'legacy_refresh_token');

      // Verified migrated to secure storage
      expect(await secureStorage.read(key: 'ACCESS_TOKEN'), 'legacy_access_token');
      expect(await secureStorage.read(key: 'REFRESH_TOKEN'), 'legacy_refresh_token');

      // Verified purged from plain SharedPreferences
      expect(prefs.getString('ACCESS_TOKEN'), isNull);
      expect(prefs.getString('REFRESH_TOKEN'), isNull);
    });

    test('saves and clears tokens securely', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage();

      final dataSource = AuthLocalDataSourceImpl(prefs, secureStorage);
      await dataSource.init();

      await dataSource.saveTokens('new_access', 'new_refresh');
      expect(dataSource.getAccessToken(), 'new_access');
      expect(dataSource.getRefreshToken(), 'new_refresh');
      expect(await secureStorage.read(key: 'ACCESS_TOKEN'), 'new_access');

      await dataSource.clear();
      expect(dataSource.getAccessToken(), isNull);
      expect(dataSource.getRefreshToken(), isNull);
      expect(await secureStorage.read(key: 'ACCESS_TOKEN'), isNull);
    });

    test('sets and checks legal accepted status', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final dataSource = AuthLocalDataSourceImpl(prefs);

      expect(dataSource.isLegalAccepted(AuthLocalDataSource.currentLegalVersion, userId: 'user1'), isFalse);

      await dataSource.setLegalAccepted(AuthLocalDataSource.currentLegalVersion, userId: 'user1');
      expect(dataSource.isLegalAccepted(AuthLocalDataSource.currentLegalVersion, userId: 'user1'), isTrue);
      expect(dataSource.isLegalAccepted('different_version', userId: 'user1'), isFalse);
      expect(dataSource.isLegalAccepted(AuthLocalDataSource.currentLegalVersion, userId: 'user2'), isFalse);
    });
  });
}
