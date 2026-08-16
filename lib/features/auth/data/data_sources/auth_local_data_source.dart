import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(String accessToken, String refreshToken);
  String? getAccessToken();
  Future<void> clear();
  Future<void> setCefrSkipped(bool value);
  bool isCefrSkipped();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';
  static const _cefrSkippedKey = 'HAS_SKIPPED_CEFR_SELECTION';

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  @override
  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_cefrSkippedKey);
  }

  @override
  Future<void> setCefrSkipped(bool value) async {
    await _prefs.setBool(_cefrSkippedKey, value);
  }

  @override
  bool isCefrSkipped() {
    return _prefs.getBool(_cefrSkippedKey) ?? false;
  }
}
