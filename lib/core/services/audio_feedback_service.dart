import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

import '../../shared/settings/cubit/sound_settings_cubit.dart';

abstract class AudioFeedbackService {
  Future<void> init();
  Future<void> playCorrectFeedback();
  Future<void> playIncorrectFeedback();
  Future<void> playCompletionFeedback();
  Future<void> stop();
  void dispose();
}

enum HapticFeedbackType { light, medium, heavy }

@LazySingleton(as: AudioFeedbackService)
class AudioFeedbackServiceImpl implements AudioFeedbackService {
  final SoundSettingsCubit _soundSettingsCubit;
  AudioPlayer? _player;
  bool _isInitialized = false;

  AudioFeedbackServiceImpl(this._soundSettingsCubit);

  @override
  Future<void> init() async {
    if (_isInitialized && _player != null) return;

    try {
      AudioCache.instance = AudioCache(prefix: 'assets/');

      final player = _player ?? AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(1.0);

      await player.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.ambient,
            options: const {},
          ),
          android: const AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
        ),
      );

      _player = player;
      _isInitialized = true;
    } catch (e) {
      debugPrint('[AudioFeedbackService] init error: $e');
      _player ??= AudioPlayer();
      _isInitialized = true;
    }
  }

  bool get _isEnabled => _soundSettingsCubit.state.isSoundEnabled;

  @override
  Future<void> playCorrectFeedback() async {
    if (!_isEnabled) return;
    await _playSound('audio_asset/corect_answer.mp3');
    await _triggerHaptic(HapticsType.success, fallback: HapticFeedbackType.light);
  }

  @override
  Future<void> playIncorrectFeedback() async {
    if (!_isEnabled) return;
    await _playSound('audio_asset/wrong_answer.mp3');
    await _triggerHaptic(HapticsType.error, fallback: HapticFeedbackType.heavy);
  }

  @override
  Future<void> playCompletionFeedback() async {
    if (!_isEnabled) return;
    await _playSound('audio_asset/congratulation.mp3');
    await _triggerHaptic(HapticsType.success, fallback: HapticFeedbackType.medium);
  }

  Future<void> _playSound(String assetPath) async {
    try {
      if (_player == null || !_isInitialized) {
        await init();
      }
      _player?.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('[AudioFeedbackService] Error playing $assetPath: $e');
    }
  }

  Future<void> _triggerHaptic(
    HapticsType type, {
    required HapticFeedbackType fallback,
  }) async {
    try {
      final canVibrate = await Haptics.canVibrate();
      if (canVibrate) {
        await Haptics.vibrate(type);
      } else {
        _nativeFallback(fallback);
      }
    } catch (_) {
      _nativeFallback(fallback);
    }
  }

  void _nativeFallback(HapticFeedbackType fallback) {
    try {
      switch (fallback) {
        case HapticFeedbackType.light:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.medium:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavy:
          HapticFeedback.heavyImpact();
          break;
      }
    } catch (_) {}
  }

  @override
  Future<void> stop() async {
    try {
      await _player?.stop();
    } catch (_) {}
  }

  @override
  void dispose() {
    _player?.dispose();
    _player = null;
    _isInitialized = false;
  }
}
