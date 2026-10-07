import 'package:flutter/material.dart';

abstract class ThemeRepository {
  ThemeMode getCachedThemeMode();
  Future<ThemeMode> getThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}
