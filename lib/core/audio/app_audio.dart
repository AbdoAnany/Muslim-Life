import 'dart:io';

import 'package:azkar/core/audio/bundle_audio_channel.dart';
import 'package:azkar/core/audio/dhikr_sound_names.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// Shared [just_audio] helpers for click SFX, dhikr mp3s, and previews.
class AppAudio {
  AppAudio._();

  static final AudioPlayer _clickPlayer = AudioPlayer();
  static final AudioPlayer _dhikrPlayer = AudioPlayer();

  static AudioPlayer get dhikrPlayer => _dhikrPlayer;

  /// Plays `assets/music/click.wav`; failures are swallowed (no crash).
  static Future<void> playClick() async {
    try {
      await BundleAudioChannel.preparePlayback();
      await _clickPlayer.stop();
      await _clickPlayer.setAudioSource(
        AudioSource.asset(
          'assets/music/click.wav',
          tag: const MediaItem(
            id: 'click_sfx',
            title: 'نقر',
            playable: true,
          ),
        ),
      );
      await _clickPlayer.play();
    } catch (e, st) {
      debugPrint('AppAudio.playClick: $e\n$st');
    }
  }

  /// Plays dhikr audio for [zeker] using platform-native paths (Tasbeeh parity).
  ///
  /// Returns `null` on success, or an Arabic user message when playback cannot start.
  static Future<String?> playDhikr(ZekerModel zeker) async {
    final baseName = rawBaseNameFor(zeker);
    try {
      await BundleAudioChannel.preparePlayback();
      await _dhikrPlayer.stop();
      final source = await _sourceForZeker(zeker, baseName);
      if (source == null) {
        return 'ملف الصوت غير متوفر على هذا الجهاز ($baseName)';
      }
      await _dhikrPlayer.setAudioSource(source);
      await _dhikrPlayer.play();
      return null;
    } catch (e, st) {
      debugPrint('AppAudio.playDhikr($baseName): $e\n$st');
      return 'تعذر تشغيل الذكر';
    }
  }

  @visibleForTesting
  static String rawBaseNameFor(ZekerModel zeker) {
    return DhikrSoundNames.rawBaseName(
      zekerId: zeker.zeker_id,
      chooseRepeat: zeker.choose_repeat,
      zekerRepeat: zeker.zeker_repeat,
    );
  }

  static Future<AudioSource?> _sourceForZeker(
    ZekerModel zeker,
    String baseName,
  ) async {
    if (kIsWeb) return null;

    final tag = MediaItem(
      id: 'dhikr_$baseName',
      title: zeker.zeker_name,
      album: 'أذكار',
      playable: true,
    );

    if (Platform.isAndroid) {
      final exists = await BundleAudioChannel.androidRawExists(baseName);
      if (!exists) return null;
      return AudioSource.uri(
        Uri.parse(DhikrSoundNames.androidResourceUri(baseName)),
        tag: tag,
      );
    }

    if (Platform.isIOS) {
      final filePath = await BundleAudioChannel.bundleResourcePath(baseName);
      if (filePath == null) return null;
      debugPrint('AppAudio: iOS dhikr path resolved: $filePath');
      return AudioSource.file(filePath, tag: tag);
    }

    return null;
  }

  static Future<void> disposeAll() async {
    await _clickPlayer.dispose();
    await _dhikrPlayer.dispose();
  }
}
