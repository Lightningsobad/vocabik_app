import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/shared/theme/domain/repositories/theme_repository.dart';

@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeRepository themeRepository;

  ThemeCubit({required this.themeRepository}) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final theme = await themeRepository.getThemeMode();
      emit(theme);
    } catch (_) {
      // Fallback to system theme on error
      emit(ThemeMode.system);
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = (state == ThemeMode.light || state == ThemeMode.system) 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    emit(newTheme);
    
    try {
      await themeRepository.saveThemeMode(newTheme);
    } catch (_) {
      // Revert if saving fails? For now just handle the error silently or log.
      // Reverting state would be: emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    }
  }
}
