import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

abstract class LocalizationLocalDataSource {
  Future<String?> getLanguage();
  Future<void> saveLanguage(String languageCode);
}

@LazySingleton(as: LocalizationLocalDataSource)
class LocalizationLocalDataSourceImpl implements LocalizationLocalDataSource {
  final SharedPreferences _prefs;
  static const _languageKey = 'app_language_code';

  LocalizationLocalDataSourceImpl(this._prefs);

  @override
  Future<String?> getLanguage() async {
    return _prefs.getString(_languageKey);
  }

  @override
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }
}
