import 'package:injectable/injectable.dart';
import '../datasources/settings_local_data_source.dart';
import 'settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  bool getSoundEnabled() {
    return _localDataSource.getSoundEnabled();
  }

  @override
  Future<bool> saveSoundEnabled(bool value) async {
    return await _localDataSource.saveSoundEnabled(value);
  }
}
