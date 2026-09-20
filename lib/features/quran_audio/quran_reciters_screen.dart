import 'package:azkar/core/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// Multiple reciters via Al Quran Cloud CDN (streamed; offline text in QuranReader).
class QuranRecitersScreen extends StatefulWidget {
  const QuranRecitersScreen({super.key});

  @override
  State<QuranRecitersScreen> createState() => _QuranRecitersScreenState();
}

class _QuranRecitersScreenState extends State<QuranRecitersScreen> {
  final _player = AudioPlayer();
  static const _reciters = [
    _Reciter('AbdulBaset AbdulSamad', 'ar.abdulbasitmurattal'),
    _Reciter('Mishary Rashid Alafasy', 'ar.alafasy'),
    _Reciter('Saad Al-Ghamdi', 'ar.saadalgamdi'),
  ];
  int _surah = 1;

  Future<void> _play(_Reciter reciter) async {
    final url =
        'https://cdn.islamic.network/quran/audio-surah/128/${reciter.edition}/$_surah.mp3';
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(id: url, title: 'سورة $_surah', artist: reciter.name),
      ),
    );
    await _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('القرآن — صوت'), backgroundColor: kMainColor),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const Text('السورة:'),
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 114,
                    divisions: 113,
                    value: _surah.toDouble(),
                    label: '$_surah',
                    onChanged: (v) => setState(() => _surah = v.round()),
                  ),
                ),
                Text('$_surah'),
              ],
            ),
            ..._reciters.map(
              (r) => Card(
                child: ListTile(
                  title: Text(r.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () => _play(r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Reciter {
  const _Reciter(this.name, this.edition);
  final String name;
  final String edition;
}
