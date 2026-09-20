import 'package:azkar/core/audio/bundle_audio_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel(BundleAudioChannel.channelName);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('bundleResourcePath returns native path when channel is registered', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'bundleResourcePath');
      expect(call.arguments, {'name': 'a1_1'});
      return '/var/containers/Bundle/Application/ABC/Runner.app/raw/a1_1.mp3';
    });

    final path = await BundleAudioChannel.bundleResourcePath('a1_1');
    expect(path, contains('a1_1.mp3'));
  });

  test('bundleResourcePath returns null when native returns null', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => null);

    final path = await BundleAudioChannel.bundleResourcePath('missing');
    expect(path, isNull);
  });

  test('androidRawExists reflects platform response', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'androidRawExists') {
        return true;
      }
      return null;
    });

    expect(await BundleAudioChannel.androidRawExists('a001'), isTrue);
  });
}
