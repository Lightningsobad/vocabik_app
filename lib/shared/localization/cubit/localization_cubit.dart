import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'localization_state.dart';
import '../domain/usecases/get_language_usecase.dart';
import '../domain/usecases/save_language_usecase.dart';

@singleton
class LocalizationCubit extends Cubit<LocalizationState> {
  final GetLanguageUseCase _getLanguageUseCase;
  final SaveLanguageUseCase _saveLanguageUseCase;

  LocalizationCubit(
    this._getLanguageUseCase,
    this._saveLanguageUseCase,
  ) : super(const LocalizationState(currentLocale: Locale('vi'))); // Default to Vietnamese initially

  Future<void> initLanguage() async {
    try {
      emit(state.copyWith(status: LocalizationStatus.loading));
      final languageCode = await _getLanguageUseCase.call();
      if (languageCode != null) {
        emit(state.copyWith(
          currentLocale: Locale(languageCode),
          status: LocalizationStatus.success,
        ));
      } else {
        // Use device locale or default
        final systemLocale = PlatformDispatcher.instance.locale;
        if (systemLocale.languageCode == 'en') {
          emit(state.copyWith(
            currentLocale: const Locale('en'),
            status: LocalizationStatus.success,
          ));
        } else {
          emit(state.copyWith(
            currentLocale: const Locale('vi'),
            status: LocalizationStatus.success,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        status: LocalizationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      emit(state.copyWith(status: LocalizationStatus.loading));
      await _saveLanguageUseCase.call(languageCode);
      emit(state.copyWith(
        currentLocale: Locale(languageCode),
        status: LocalizationStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LocalizationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
