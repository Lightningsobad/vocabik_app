import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/services/audio_feedback_service.dart';
import 'package:vocabik_app/shared/settings/cubit/sound_settings_cubit.dart';
import 'package:vocabik_app/shared/settings/data/repositories/settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  bool soundEnabled = true;

  @override
  bool getSoundEnabled() => soundEnabled;

  @override
  Future<bool> saveSoundEnabled(bool value) async {
    soundEnabled = value;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSettingsRepository mockSettingsRepository;
  late SoundSettingsCubit soundSettingsCubit;
  late AudioFeedbackServiceImpl audioFeedbackService;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (MethodCall methodCall) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );

    mockSettingsRepository = MockSettingsRepository();
    soundSettingsCubit = SoundSettingsCubit(mockSettingsRepository);
    audioFeedbackService = AudioFeedbackServiceImpl(soundSettingsCubit);
  });

  tearDown(() {
    soundSettingsCubit.close();
    audioFeedbackService.dispose();
  });

  group('SoundSettingsCubit & AudioFeedbackService Tests', () {
    test('SoundSettingsCubit initial state matches repository default', () {
      expect(soundSettingsCubit.state.isSoundEnabled, true);
    });

    test('SoundSettingsCubit toggleSound updates state and repository', () async {
      soundSettingsCubit.toggleSound(false);
      expect(soundSettingsCubit.state.isSoundEnabled, false);
      expect(mockSettingsRepository.getSoundEnabled(), false);

      soundSettingsCubit.toggleSound(true);
      expect(soundSettingsCubit.state.isSoundEnabled, true);
      expect(mockSettingsRepository.getSoundEnabled(), true);
    });

    test('AudioFeedbackService executes feedback when enabled/disabled', () async {
      // When enabled
      await audioFeedbackService.init();
      await audioFeedbackService.playCorrectFeedback();
      await audioFeedbackService.playIncorrectFeedback();
      await audioFeedbackService.playCompletionFeedback();
      await audioFeedbackService.stop();

      // When disabled
      soundSettingsCubit.toggleSound(false);
      await audioFeedbackService.playCorrectFeedback();
      await audioFeedbackService.playIncorrectFeedback();
      await audioFeedbackService.playCompletionFeedback();
      await audioFeedbackService.stop();
    });
  });
}
