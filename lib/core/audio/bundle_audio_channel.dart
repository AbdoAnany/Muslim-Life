import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Resolves native bundle paths for dhikr mp3s (iOS Runner/raw resources).
class BundleAudioChannel {
  BundleAudioChannel._();

  static const channelName = 'com.anany.azkar/audio';
  static const _channel = MethodChannel(channelName);

  /// Activates platform playback session (iOS AVAudioSession).
  static Future<void> preparePlayback() async {
    try {
      await _channel.invokeMethod<void>('prepareAudioSession');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('BundleAudioChannel.preparePlayback PlatformException: $e');
      }
    } on MissingPluginException {
      if (kDebugMode) {
        debugPrint(
          'BundleAudioChannel.preparePlayback: MissingPluginException — '
          'native channel $channelName not registered (iOS AppDelegate?)',
        );
      }
    }
  }

  /// Returns absolute file path for [baseName] without extension, or null if missing.
  static Future<String?> bundleResourcePath(String baseName) async {
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
          'dhikr will fail until $channelName is registered on iOS',
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
