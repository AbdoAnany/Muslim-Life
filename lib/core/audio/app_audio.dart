import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:azkar/core/audio/bundle_audio_channel.dart';
import 'package:azkar/core/audio/dhikr_sound_names.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

/// Shared [just_audio] helpers for click SFX, dhikr mp3s, and previews.
///
/// Uses a single [AudioPlayer] because [JustAudioBackground] supports only one
/// native player instance per app.
class AppAudio {
  AppAudio._();

  static final AudioPlayer player = AudioPlayer(
    handleAudioSessionActivation: false,
  );

  /// Legacy alias for dhikr/schedule screens.
  static AudioPlayer get dhikrPlayer => player;

  /// Plays `assets/music/click.wav`; failures are swallowed (no crash).
  static Future<void> playClick() async {
    try {
      await _ensurePlaybackSession();
      await _stopAndIdle();
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
      await _ensurePlaybackSession();
      await _stopAndIdle();
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

  static Future<void> _ensurePlaybackSession() async {
    await BundleAudioChannel.preparePlayback();
    try {
      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.duckOthers,
          avAudioSessionMode: AVAudioSessionMode.spokenAudio,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.speech,
            usage: AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
          androidWillPauseWhenDucked: true,
        ),
      );
      await session.setActive(true);
    } catch (e, st) {
      debugPrint('AppAudio._ensurePlaybackSession: $e\n$st');
    }
  }

  static Future<void> _stopAndIdle() async {
    await player.stop();
    if (player.processingState == ProcessingState.idle) return;
    try {
      await player.processingStateStream
          .firstWhere((s) => s == ProcessingState.idle)
          .timeout(const Duration(seconds: 2));
    } catch (_) {}
  }

  static Future<AudioSource?> _sourceForZeker(
    ZekerModel zeker,
    String baseName,
  ) async {
    if (kIsWeb) return null;

    final candidates = DhikrSoundNames.candidateBaseNames(
      zekerId: zeker.zeker_id,
      chooseRepeat: zeker.choose_repeat,
      zekerRepeat: zeker.zeker_repeat,
    );
    // Prefer explicit fullFileName / computed baseName first
    final ordered = <String>[
      if (baseName.isNotEmpty) baseName,
      ...candidates,
    ];
    final seen = <String>{};
    final names = <String>[];
    for (final n in ordered) {
      if (seen.add(n)) names.add(n);
    }

    if (Platform.isAndroid) {
      for (final name in names) {
        final exists = await BundleAudioChannel.androidRawExists(name);
        if (!exists) continue;
        debugPrint('AppAudio: android raw hit: $name');
        return AudioSource.uri(
          Uri.parse(DhikrSoundNames.androidResourceUri(name)),
          tag: MediaItem(
            id: 'dhikr_$name',
            title: zeker.zeker_name,
            artist: 'أذكار',
            album: 'حياة المسلم',
          ),
        );
      }
      debugPrint('AppAudio: android raw miss for $names');
      return null;
    }

    if (Platform.isIOS) {
      for (final name in names) {
        final filePath = await BundleAudioChannel.bundleResourcePath(name);
        if (filePath == null) continue;
        final bundleFile = File(filePath);
        if (!await bundleFile.exists()) continue;
        final playPath = await _iosPlayablePath(bundleFile, name);
        debugPrint('AppAudio: iOS dhikr path resolved ($name): $playPath');
        return AudioSource.uri(
          Uri.file(playPath),
          tag: MediaItem(
            id: 'dhikr_$name',
            title: zeker.zeker_name,
            artist: 'أذكار',
            album: 'حياة المسلم',
          ),
        );
      }
      debugPrint('AppAudio: iOS bundle miss for $names');
      return null;
    }

    return null;
  }

  /// Some iOS + [JustAudioBackground] builds fail on direct bundle paths; temp copy works.
  static Future<String> _iosPlayablePath(File bundleFile, String baseName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final dest = File('${tempDir.path}/dhikr_$baseName.mp3');
      final srcLen = await bundleFile.length();
      if (await dest.exists()) {
        final destLen = await dest.length();
        if (destLen == srcLen && srcLen > 0) {
          return dest.path;
        }
      }
      await bundleFile.copy(dest.path);
      return dest.path;
    } catch (e, st) {
      debugPrint('AppAudio._iosPlayablePath fallback to bundle: $e\n$st');
      return bundleFile.path;
    }
  }

  static Future<void> disposeAll() async {
    await player.dispose();
  }
}
