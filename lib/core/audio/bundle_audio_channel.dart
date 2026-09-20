import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Resolves native bundle paths for dhikr mp3s (iOS Runner/raw resources).
class BundleAudioChannel {
  BundleAudioChannel._();

  static const channelName = 'com.anany.azkar/audio';
  static const _channel = MethodChannel(channelName);

  static const _pathRetryDelaysMs = [0, 50, 120];

  /// Activates platform playback session (iOS AVAudioSession).
  static Future<void> preparePlayback() async {
    for (final delayMs in _pathRetryDelaysMs) {
      if (delayMs > 0) {
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      }
      try {
        await _channel.invokeMethod<void>('prepareAudioSession');
        return;
      } on PlatformException catch (e) {
        if (kDebugMode) {
          debugPrint('BundleAudioChannel.preparePlayback PlatformException: $e');
        }
        return;
      } on MissingPluginException {
        if (kDebugMode && delayMs == _pathRetryDelaysMs.last) {
          debugPrint(
            'BundleAudioChannel.preparePlayback: MissingPluginException — '
            'native channel $channelName not registered (iOS AudioBundlePlugin?)',
          );
        }
      }
    }
  }

  /// Returns absolute file path for [baseName] without extension, or null if missing.
  static Future<String?> bundleResourcePath(String baseName) async {
    for (var i = 0; i < _pathRetryDelaysMs.length; i++) {
      final delayMs = _pathRetryDelaysMs[i];
      if (delayMs > 0) {
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      }
      final path = await _invokeBundlePath(baseName);
      if (path != null) return path;
    }
    return null;
  }

  static Future<String?> _invokeBundlePath(String baseName) async {
    try {
      final path = await _channel.invokeMethod<String>(
        'bundleResourcePath',
        {'name': baseName},
      );
      if (kDebugMode) {
        debugPrint(
          'BundleAudioChannel.bundleResourcePath($baseName) => ${path ?? 'null'}',
        );
      }
      if (path == null || path.isEmpty) return null;
      return path;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('BundleAudioChannel.bundleResourcePath PlatformException: $e');
      }
      return null;
    } on MissingPluginException {
      if (kDebugMode) {
        debugPrint(
          'BundleAudioChannel.bundleResourcePath: MissingPluginException — '
          'retrying / check AudioBundlePlugin on iOS',
        );
      }
      return null;
    }
  }

  /// Android only: whether `res/raw/[baseName].mp3` exists.
  static Future<bool> androidRawExists(String baseName) async {
    try {
      final exists = await _channel.invokeMethod<bool>(
        'androidRawExists',
        {'name': baseName},
      );
      if (kDebugMode) {
        debugPrint('BundleAudioChannel.androidRawExists($baseName) => $exists');
      }
      return exists ?? false;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('BundleAudioChannel.androidRawExists PlatformException: $e');
      }
      return false;
    } on MissingPluginException {
      if (kDebugMode) {
        debugPrint('BundleAudioChannel.androidRawExists: MissingPluginException');
      }
      return false;
    }
  }
}
