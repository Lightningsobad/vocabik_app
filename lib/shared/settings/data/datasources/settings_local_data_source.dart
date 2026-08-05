import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  bool getSoundEnabled();
  Future<bool> saveSoundEnabled(bool value);
}

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;
  static const String _keySoundEnabled = 'sound_enabled';

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  bool getSoundEnabled() {
    return _prefs.getBool(_keySoundEnabled) ?? true;
  }

  @override
  Future<bool> saveSoundEnabled(bool value) async {
    return await _prefs.setBool(_keySoundEnabled, value);
  }
}
