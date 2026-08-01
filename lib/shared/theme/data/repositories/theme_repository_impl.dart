import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/shared/theme/domain/repositories/theme_repository.dart';

@Injectable(as: ThemeRepository)
class ThemeRepositoryImpl implements ThemeRepository {
  static const String _themeKey = 'theme_mode';
  static const String _lightModeVal = 'light';
  static const String _darkModeVal = 'dark';

  final SharedPreferences prefs;

  ThemeRepositoryImpl({required this.prefs});

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeString = prefs.getString(_themeKey);
    if (themeString == _lightModeVal) {
      return ThemeMode.light;
    } else if (themeString == _darkModeVal) {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    if (mode == ThemeMode.light) {
      await prefs.setString(_themeKey, _lightModeVal);
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(_themeKey, _darkModeVal);
    }
  }
}
