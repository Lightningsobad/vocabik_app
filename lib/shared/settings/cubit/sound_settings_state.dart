part of 'sound_settings_cubit.dart';

class SoundSettingsState extends Equatable {
  final bool isSoundEnabled;

  const SoundSettingsState({
    required this.isSoundEnabled,
  });

  SoundSettingsState copyWith({
    bool? isSoundEnabled,
  }) {
    return SoundSettingsState(
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
    );
  }

  @override
  List<Object> get props => [isSoundEnabled];
}
