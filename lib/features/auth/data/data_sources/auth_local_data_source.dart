import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> init();
  Future<void> saveTokens(String accessToken, String refreshToken);
  String? getAccessToken();
  String? getRefreshToken();
  Future<void> saveUser(UserModel user);
  UserModel? getUser();
  Future<void> clear();
  Future<void> setCefrSkipped(bool value);
  bool isCefrSkipped();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';
  static const _cefrSkippedKey = 'HAS_SKIPPED_CEFR_SELECTION';
  static const _userKey = 'CACHED_USER_DATA';

  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  AuthLocalDataSourceImpl(
    this._prefs, [
    FlutterSecureStorage? secureStorage,
  ]) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> init() async {
    _cachedAccessToken = await _secureStorage.read(key: _accessTokenKey);
    _cachedRefreshToken = await _secureStorage.read(key: _refreshTokenKey);

    // Migration from plaintext SharedPreferences if secure storage was empty
    if (_cachedAccessToken == null || _cachedAccessToken!.isEmpty) {
      final legacyAccess = _prefs.getString(_accessTokenKey);
      final legacyRefresh = _prefs.getString(_refreshTokenKey);
      if (legacyAccess != null && legacyAccess.isNotEmpty) {
        _cachedAccessToken = legacyAccess;
        _cachedRefreshToken = legacyRefresh;
        await _secureStorage.write(key: _accessTokenKey, value: legacyAccess);
        if (legacyRefresh != null && legacyRefresh.isNotEmpty) {
          await _secureStorage.write(key: _refreshTokenKey, value: legacyRefresh);
        }
        await _prefs.remove(_accessTokenKey);
        await _prefs.remove(_refreshTokenKey);
      }
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  @override
  String? getAccessToken() {
    return _cachedAccessToken ?? _prefs.getString(_accessTokenKey);
  }

  @override
  String? getRefreshToken() {
    return _cachedRefreshToken ?? _prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  @override
  UserModel? getUser() {
    final userString = _prefs.getString(_userKey);
    if (userString == null || userString.isEmpty) return null;
    try {
      final jsonMap = jsonDecode(userString) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (_) {}
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_cefrSkippedKey);
    await _prefs.remove(_userKey);
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
