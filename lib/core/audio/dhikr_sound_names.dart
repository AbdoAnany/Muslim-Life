/// Dhikr mp3 naming aligned with bundled `raw/` assets (Tasbeeh library).
///
/// On disk:
/// - base clips are **zero-padded** (`a001.mp3`, `a010.mp3`)
/// - multi-repeat clips use **unpadded** ids (`a1_1.mp3`, `a10_2.mp3`)
abstract final class DhikrSoundNames {
  static const androidPackage = 'com.anany.azkar';

  /// Preferred raw resource name without extension.
  static String rawBaseName({
    required String zekerId,
    required String chooseRepeat,
    required int zekerRepeat,
  }) {
    final idNum = int.tryParse(zekerId.trim());
    final unpadded = idNum != null ? '$idNum' : zekerId.replaceFirst(RegExp(r'^0+'), '');
    final padded = idNum != null
        ? idNum.toString().padLeft(3, '0')
        : zekerId.padLeft(3, '0');

    if (chooseRepeat.isNotEmpty && zekerRepeat != 1) {
      var choose = int.tryParse(chooseRepeat) ?? 1;
      if (zekerRepeat < choose) choose = zekerRepeat;
      // Multi-repeat files: a1_1.mp3 (unpadded)
      return 'a${unpadded}_$choose';
    }

    // Base files: a001.mp3 (3-digit pad)
    return 'a$padded';
  }

  /// All plausible names to try when resolving a bundle/raw resource.
  static List<String> candidateBaseNames({
    required String zekerId,
    required String chooseRepeat,
    required int zekerRepeat,
  }) {
    final idNum = int.tryParse(zekerId.trim());
    final unpadded =
        idNum != null ? '$idNum' : zekerId.replaceFirst(RegExp(r'^0+'), '');
    final padded = idNum != null
        ? idNum.toString().padLeft(3, '0')
        : zekerId.padLeft(3, '0');

    final names = <String>{
      rawBaseName(
        zekerId: zekerId,
        chooseRepeat: chooseRepeat,
        zekerRepeat: zekerRepeat,
      ),
      'a$padded',
      'a$unpadded',
    };

    if (zekerRepeat != 1) {
      var choose = int.tryParse(chooseRepeat);
      choose ??= 1;
      if (zekerRepeat < choose) choose = zekerRepeat;
      names.add('a${unpadded}_$choose');
      names.add('a${padded}_$choose');
      // Also try every repeat index 1..zekerRepeat (schedule payloads vary)
      for (var i = 1; i <= zekerRepeat && i <= 10; i++) {
        names.add('a${unpadded}_$i');
        names.add('a${padded}_$i');
      }
    }

    return names.toList();
  }

  static String androidResourceUri(String baseName) =>
      'android.resource://$androidPackage/raw/$baseName';

  static String iosFileName(String baseName) => '$baseName.mp3';
}
