import 'dart:io';

import 'package:azkar/core/audio/bundle_audio_channel.dart';
import 'package:azkar/core/audio/dhikr_sound_names.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// Shared [just_audio] helpers for click SFX, dhikr mp3s, and previews.
///
/// Uses a single [AudioPlayer] because [JustAudioBackground] supports only one
/// native player instance per app.
class AppAudio {
  AppAudio._();

  static final AudioPlayer player = AudioPlayer();

  /// Legacy alias for dhikr/schedule screens.
  static AudioPlayer get dhikrPlayer => player;

  /// Plays `assets/music/click.wav`; failures are swallowed (no crash).
  static Future<void> playClick() async {
    try {
      await BundleAudioChannel.preparePlayback();
      await player.stop();
      await player.setAudioSource(
        AudioSource.asset(
          'assets/music/click.wav',
          tag: const MediaItem(
            id: 'click_sfx',
            title: 'نقر',
            artist: 'حياة المسلم',
          ),
        ),
      );
      await player.play();
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
      await player.stop();
      final source = await _sourceForZeker(zeker, baseName);
      if (source == null) {
        return 'ملف الصوت غير متوفر على هذا الجهاز ($baseName)';
      }
      await player.setAudioSource(source);
      await player.play();
      return null;
    } catch (e, st) {
      debugPrint('AppAudio.playDhikr($baseName): $e\n$st');
      return 'تعذر تشغيل الذكر';
    }
  }

  @visibleForTesting
  static String rawBaseNameFor(ZekerModel zeker) {
    final fromModel = zeker.fullFileName?.trim();
    if (fromModel != null && fromModel.isNotEmpty) {
      return fromModel;
    }
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
      artist: 'أذكار',
      album: 'حياة المسلم',
    );

    if (Platform.isAndroid) {
      final exists = await BundleAudioChannel.androidRawExists(baseName);
      if (!exists) {
        if (kDebugMode) {
          debugPrint(
            'AppAudio: android raw missing for $baseName — skipping URI load',
          );
        }
        return null;
      }
      return AudioSource.uri(
        Uri.parse(DhikrSoundNames.androidResourceUri(baseName)),
        tag: tag,
      );
    }

    if (Platform.isIOS) {
      final filePath = await BundleAudioChannel.bundleResourcePath(baseName);
      if (filePath == null) return null;
      debugPrint('AppAudio: iOS dhikr path resolved: $filePath');
      return AudioSource.uri(Uri.file(filePath), tag: tag);
    }

    return null;
  }

  static Future<void> disposeAll() async {
    await player.dispose();
  }
}
