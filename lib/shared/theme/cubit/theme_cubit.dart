import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences prefs;

  ThemeCubit({required this.prefs}) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeString = prefs.getString(_themeKey);
    if (themeString != null) {
      if (themeString == 'light') {
        emit(ThemeMode.light);
      } else if (themeString == 'dark') {
        emit(ThemeMode.dark);
      }
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.light || state == ThemeMode.system) {
      emit(ThemeMode.dark);
      prefs.setString(_themeKey, 'dark');
    } else {
      emit(ThemeMode.light);
      prefs.setString(_themeKey, 'light');
    }
  }
}
