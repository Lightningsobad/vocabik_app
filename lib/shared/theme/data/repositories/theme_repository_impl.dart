import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/shared/theme/domain/repositories/theme_repository.dart';

@Injectable(as: ThemeRepository)
class ThemeRepositoryImpl implements ThemeRepository {
  static const String _themeKey = 'theme_mode';
  static const String _lightModeVal = 'light';
  static const String _darkModeVal = 'dark';
  static const _platformChannel = MethodChannel('com.snapsofts.vocabik/theme');

  final SharedPreferences prefs;

  ThemeRepositoryImpl({required this.prefs});

  Future<void> _syncNativeTheme(ThemeMode mode) async {
    try {
      final modeStr = mode == ThemeMode.dark
          ? _darkModeVal
          : (mode == ThemeMode.light ? _lightModeVal : 'system');
      await _platformChannel.invokeMethod('setThemeMode', modeStr);
    } catch (_) {
      // Safe fallback in tests or unsupported environments
    }
  }

  @override
  ThemeMode getCachedThemeMode() {
    final themeString = prefs.getString(_themeKey);
    final mode = themeString == _lightModeVal
        ? ThemeMode.light
        : (themeString == _darkModeVal ? ThemeMode.dark : ThemeMode.system);
    _syncNativeTheme(mode);
    return mode;
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    return getCachedThemeMode();
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    if (mode == ThemeMode.light) {
      await prefs.setString(_themeKey, _lightModeVal);
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(_themeKey, _darkModeVal);
    }
    await _syncNativeTheme(mode);
  }
}
