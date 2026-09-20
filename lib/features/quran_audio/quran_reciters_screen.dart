import 'package:azkar/core/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// Multiple reciters via islamic.network CDN (streamed; offline text in QuranReader).
class QuranRecitersScreen extends StatefulWidget {
  const QuranRecitersScreen({super.key});

  @override
  State<QuranRecitersScreen> createState() => _QuranRecitersScreenState();
}

class _QuranRecitersScreenState extends State<QuranRecitersScreen> {
  final _player = AudioPlayer();
  bool _loading = false;

  /// Only editions that return HTTP 200 on the audio-surah CDN.
  static const _reciters = [
    _Reciter('عبد الباسط عبد الصمد', 'ar.abdulbasitmurattal'),
    _Reciter('مشاري راشد العفاسي', 'ar.alafasy'),
    _Reciter('سعود الشريم', 'ar.saudalshuraim'),
  ];
  int _surah = 1;

  Future<void> _play(_Reciter reciter) async {
    final url =
        'https://cdn.islamic.network/quran/audio-surah/128/${reciter.edition}/$_surah.mp3';
    setState(() {
      _loading = true;
    });
    try {
      await _player.stop();
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: url,
            title: 'سورة $_surah',
            artist: reciter.name,
          ),
        ),
      );
      await _player.play();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر تشغيل الصوت: ${_shortError(e)}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _shortError(Object e) {
    final s = e.toString();
    if (s.contains('11800')) {
      return 'الملف غير متاح أو الشبكة فشلت';
    }
    return s.length > 120 ? '${s.substring(0, 120)}…' : s;
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
        appBar: AppBar(
          title: const Text('القرآن — صوت'),
          backgroundColor: kMainColor,
        ),
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
                    onChanged: _loading
                        ? null
                        : (v) => setState(() => _surah = v.round()),
                  ),
                ),
                Text('$_surah'),
              ],
            ),
            if (_loading) const LinearProgressIndicator(),
            ..._reciters.map(
              (r) => Card(
                child: ListTile(
                  title: Text(r.name),
                  subtitle: Text(r.edition, style: const TextStyle(fontSize: 11)),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: _loading ? null : () => _play(r),
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
