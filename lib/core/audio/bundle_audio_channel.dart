import 'package:flutter/services.dart';

/// Resolves native bundle paths for dhikr mp3s (iOS Runner/raw resources).
class BundleAudioChannel {
  BundleAudioChannel._();

  static const _channel = MethodChannel('com.anany.azkar/audio');

  /// Activates platform playback session (iOS AVAudioSession).
  static Future<void> preparePlayback() async {
    try {
      await _channel.invokeMethod<void>('prepareAudioSession');
    } on PlatformException {
      // Android has no handler; ignore.
    } on MissingPluginException {
      // Tests / web.
    }
  }

  /// Returns absolute file path for [baseName] without extension, or null if missing.
  static Future<String?> bundleResourcePath(String baseName) async {
    try {
      final path = await _channel.invokeMethod<String>(
        'bundleResourcePath',
        {'name': baseName},
      );
      if (path == null || path.isEmpty) return null;
      return path;
    } on PlatformException {
      return null;
    } on MissingPluginException {
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
      return exists ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
