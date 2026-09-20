import 'dart:io';

import 'package:azkar/core/audio/bundle_audio_channel.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Shared [just_audio] helpers for click SFX, dhikr mp3s, and previews.
class AppAudio {
  AppAudio._();

  static final AudioPlayer _clickPlayer = AudioPlayer();
  static final AudioPlayer _dhikrPlayer = AudioPlayer();

  static AudioPlayer get dhikrPlayer => _dhikrPlayer;

  /// Plays `assets/music/click.wav`; failures are swallowed (no crash).
  static Future<void> playClick() async {
    try {
      await _clickPlayer.stop();
      await _clickPlayer.setAsset('assets/music/click.wav');
      await _clickPlayer.play();
    } catch (e, st) {
      debugPrint('AppAudio.playClick: $e\n$st');
    }
  }

  /// Plays dhikr audio for [zeker] using platform-native paths (Tasbeeh parity).
  ///
  /// Returns `null` on success, or an Arabic user message when playback cannot start.
  static Future<String?> playDhikr(ZekerModel zeker) async {
    final baseName = _baseName(zeker);
    try {
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

  static String _baseName(ZekerModel zeker) {
    final path = zeker.soundFileNamePath();
    if (Platform.isAndroid) {
      final uri = Uri.parse(path);
      final segment = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : path;
      return segment.replaceAll('.mp3', '');
    }
    return path.replaceAll('.mp3', '');
  }

  static Future<AudioSource?> _sourceForZeker(
    ZekerModel zeker,
    String baseName,
  ) async {
    if (kIsWeb) return null;

    if (Platform.isAndroid) {
      final exists = await BundleAudioChannel.androidRawExists(baseName);
      if (!exists) return null;
      return AudioSource.uri(Uri.parse(zeker.soundFileNamePath()));
    }

    if (Platform.isIOS) {
      final filePath = await BundleAudioChannel.bundleResourcePath(baseName);
      if (filePath == null) return null;
      return AudioSource.file(filePath);
    }

    return null;
  }

  static Future<void> disposeAll() async {
    await _clickPlayer.dispose();
    await _dhikrPlayer.dispose();
  }
}
