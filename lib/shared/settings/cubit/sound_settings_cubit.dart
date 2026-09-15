import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../data/repositories/settings_repository.dart';

part 'sound_settings_state.dart';

@lazySingleton
class SoundSettingsCubit extends Cubit<SoundSettingsState> {
  final SettingsRepository _settingsRepository;

  SoundSettingsCubit(this._settingsRepository) 
      : super(SoundSettingsState(isSoundEnabled: _settingsRepository.getSoundEnabled()));

  void toggleSound(bool isEnabled) async {
    emit(state.copyWith(isSoundEnabled: isEnabled));
    await _settingsRepository.saveSoundEnabled(isEnabled);
  }
}
