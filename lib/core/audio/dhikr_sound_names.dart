/// Dhikr mp3 naming (Tasbeeh parity) — pure Dart for tests and [ZekerModel].
abstract final class DhikrSoundNames {
  static const androidPackage = 'com.anany.azkar';

  /// Base raw resource name without extension, e.g. `a1_1`.
  static String rawBaseName({
    required String zekerId,
    required String chooseRepeat,
    required int zekerRepeat,
  }) {
    var file = zekerId;
    if (chooseRepeat.isNotEmpty && zekerRepeat != 1) {
      var choose = int.tryParse(chooseRepeat) ?? 1;
      if (zekerRepeat < choose) {
        choose = zekerRepeat;
      }
      file = '${file}_$choose';
    }
    return 'a$file';
  }

  static String androidResourceUri(String baseName) =>
      'android.resource://$androidPackage/raw/$baseName';

  static String iosFileName(String baseName) => '$baseName.mp3';
}
