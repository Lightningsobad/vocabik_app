abstract class SettingsRepository {
  bool getSoundEnabled();
  Future<bool> saveSoundEnabled(bool value);
}
