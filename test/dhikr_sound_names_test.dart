import 'package:azkar/core/audio/app_audio.dart';
import 'package:azkar/core/audio/dhikr_sound_names.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DhikrSoundNames', () {
    test('single repeat uses zero-padded a{id}', () {
      expect(
        DhikrSoundNames.rawBaseName(
          zekerId: '5',
          chooseRepeat: '1',
          zekerRepeat: 1,
        ),
        'a005',
      );
      expect(
        DhikrSoundNames.rawBaseName(
          zekerId: '1',
          chooseRepeat: '',
          zekerRepeat: 1,
        ),
        'a001',
      );
    });

    test('multi repeat uses unpadded suffix from choose_repeat', () {
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

    test('candidates include padded and unpadded forms', () {
      final c = DhikrSoundNames.candidateBaseNames(
        zekerId: '1',
        chooseRepeat: '',
        zekerRepeat: 1,
      );
      expect(c, containsAll(['a001', 'a1']));
    });

    test('android URI uses applicationId package', () {
      expect(
        DhikrSoundNames.androidResourceUri('a1_1'),
        'android.resource://com.anany.azkar/raw/a1_1',
      );
    });

    test('AppAudio.rawBaseNameFor prefers fullFileName when set', () {
      final z = ZekerModel.fromJson({
        'zeker_id': '99',
        'fullFileName': 'a1_1',
        'zeker_repeat': 1,
        'choose_repeat': '1',
        'zeker_name': 'test',
        'zeker_type_id': 2,
      });
      expect(AppAudio.rawBaseNameFor(z), 'a1_1');
    });

    test('AppAudio.rawBaseNameFor pads base clip for id 1', () {
      final z = ZekerModel.fromJson({
        'zeker_id': '1',
        'zeker_repeat': 1,
        'choose_repeat': '',
        'zeker_name': 'سبحان الله',
        'zeker_type_id': 2,
      });
      expect(AppAudio.rawBaseNameFor(z), 'a001');
    });

    test('AppAudio.rawBaseNameFor multi-repeat uses a1_1', () {
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
