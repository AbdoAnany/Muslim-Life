import 'package:azkar/core/audio/app_audio.dart';
import 'package:azkar/core/audio/dhikr_sound_names.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DhikrSoundNames', () {
    test('single repeat uses a{id}', () {
      expect(
        DhikrSoundNames.rawBaseName(
          zekerId: '5',
          chooseRepeat: '1',
          zekerRepeat: 1,
        ),
        'a5',
      );
    });

    test('multi repeat uses suffix from choose_repeat', () {
      expect(
        DhikrSoundNames.rawBaseName(
          zekerId: '1',
          chooseRepeat: '2',
          zekerRepeat: 3,
        ),
        'a1_2',
      );
    });

    test('choose_repeat clamped to zeker_repeat', () {
      expect(
        DhikrSoundNames.rawBaseName(
          zekerId: '1',
          chooseRepeat: '9',
          zekerRepeat: 3,
        ),
        'a1_3',
      );
    });

    test('android URI uses applicationId package', () {
      expect(
        DhikrSoundNames.androidResourceUri('a1_1'),
        'android.resource://com.anany.azkar/raw/a1_1',
      );
    });

    test('AppAudio.rawBaseNameFor matches ZekerModel.soundFileNamePath base', () {
      final z = ZekerModel.fromJson({
        'zeker_id': '1',
        'zeker_repeat': 3,
        'choose_repeat': '1',
        'zeker_name': 'سبحان الله',
        'zeker_type_id': 2,
      });
      expect(AppAudio.rawBaseNameFor(z), 'a1_1');
      expect(z.soundFileNamePath(), contains('a1_1'));
    });
  });
}
