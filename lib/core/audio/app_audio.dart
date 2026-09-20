import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:azkar/core/audio/bundle_audio_channel.dart';
import 'package:azkar/core/audio/dhikr_sound_names.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

/// Shared audio helpers: short dhikr via [ap.AudioPlayer], Quran/SFX via [just_audio].
///
/// [JustAudioBackground] supports only one native player — keep that for Quran/click.
/// Local dhikr mp3s use [audioplayers] so iOS bundle files are not blocked by
/// background MediaItem / session coupling.
class AppAudio {
  AppAudio._();

  static final ap.AudioPlayer _dhikrFx = ap.AudioPlayer();

  static final AudioPlayer player = AudioPlayer(
    handleAudioSessionActivation: false,
  );

  /// Legacy alias for dhikr/schedule screens (just_audio instance).
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
      await BundleAudioChannel.preparePlayback();
      final resolved = await _resolvePlayable(zeker, baseName);
      if (resolved == null) {
        return 'ملف الصوت غير متوفر على هذا الجهاز ($baseName)';
      }
      debugPrint('AppAudio.playDhikr: playing ${resolved.debug}');

      await _dhikrFx.stop();
      await _dhikrFx.setReleaseMode(ap.ReleaseMode.stop);
      await _dhikrFx.play(resolved.source);
      return null;
    } catch (e, st) {
      debugPrint('AppAudio.playDhikr($baseName) fx failed: $e\n$st');
      try {
        final source = await _sourceForZeker(zeker, baseName);
        if (source == null) {
          return 'ملف الصوت غير متوفر على هذا الجهاز ($baseName)';
        }
        await _ensurePlaybackSession();
        await _stopAndIdle();
        await player.setAudioSource(source);
        await player.play();
        return null;
      } catch (e2, st2) {
        debugPrint('AppAudio.playDhikr($baseName) just_audio failed: $e2\n$st2');
        final short = e2.toString();
        final clipped =
            short.length > 80 ? '${short.substring(0, 80)}…' : short;
        return 'تعذر تشغيل الذكر ($clipped)';
      }
    }
  }

  @visibleForTesting
  static String rawBaseNameFor(ZekerModel zeker) {
    final fromModel = zeker.fullFileName?.trim();
    if (fromModel != null && fromModel.isNotEmpty) {
      var name = fromModel;
      if (name.toLowerCase().endsWith('.mp3')) {
        name = name.substring(0, name.length - 4);
      }
      // Legacy schedule payloads used unpadded a1 — map to on-disk a001.
      final mapped = DhikrSoundNames.normalizeLegacyBaseName(name);
      if (mapped != null) return mapped;
      return name;
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

  static List<String> _orderedNames(ZekerModel zeker, String baseName) {
    final candidates = DhikrSoundNames.candidateBaseNames(
      zekerId: zeker.zeker_id,
      chooseRepeat: zeker.choose_repeat,
      zekerRepeat: zeker.zeker_repeat,
    );
    final ordered = <String>[
      if (baseName.isNotEmpty) baseName,
      ...candidates,
    ];
    final seen = <String>{};
    final names = <String>[];
    for (final n in ordered) {
      if (seen.add(n)) names.add(n);
    }
    return names;
  }

  /// Resolves a playable [ap.Source] for audioplayers (file path or Android URI).
  static Future<_ResolvedFx?> _resolvePlayable(
    ZekerModel zeker,
    String baseName,
  ) async {
    if (kIsWeb) return null;
    final names = _orderedNames(zeker, baseName);

    if (Platform.isAndroid) {
      for (final name in names) {
        final exists = await BundleAudioChannel.androidRawExists(name);
        if (!exists) continue;
        final uri = DhikrSoundNames.androidResourceUri(name);
        debugPrint('AppAudio: android raw hit: $name');
        return _ResolvedFx(
          source: ap.UrlSource(uri),
          debug: uri,
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
        return _ResolvedFx(
          source: ap.DeviceFileSource(playPath),
          debug: playPath,
        );
      }
      debugPrint('AppAudio: iOS bundle miss for $names');
      return null;
    }

    return null;
  }

  static Future<AudioSource?> _sourceForZeker(
    ZekerModel zeker,
    String baseName,
  ) async {
    if (kIsWeb) return null;
    final names = _orderedNames(zeker, baseName);

    if (Platform.isAndroid) {
      for (final name in names) {
        final exists = await BundleAudioChannel.androidRawExists(name);
        if (!exists) continue;
        debugPrint('AppAudio: android raw hit (ja): $name');
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
      return null;
    }

    if (Platform.isIOS) {
      for (final name in names) {
        final filePath = await BundleAudioChannel.bundleResourcePath(name);
        if (filePath == null) continue;
        final bundleFile = File(filePath);
        if (!await bundleFile.exists()) continue;
        final playPath = await _iosPlayablePath(bundleFile, name);
        debugPrint('AppAudio: iOS dhikr path (ja) ($name): $playPath');
        return AudioSource.file(
          playPath,
          tag: MediaItem(
            id: 'dhikr_$name',
            title: zeker.zeker_name,
            artist: 'أذكار',
            album: 'حياة المسلم',
          ),
        );
      }
      return null;
    }

    return null;
  }

  /// Some iOS builds fail on direct bundle paths; temp copy is more reliable.
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
    await _dhikrFx.dispose();
    await player.dispose();
  }
}

class _ResolvedFx {
  const _ResolvedFx({required this.source, required this.debug});
  final ap.Source source;
  final String debug;
}
