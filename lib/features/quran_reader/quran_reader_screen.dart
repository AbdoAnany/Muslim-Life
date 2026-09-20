import 'dart:convert';

import 'package:azkar/core/theme/app_tokens.dart';
import 'package:azkar/core/widgets/dls/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuranReaderScreen extends StatefulWidget {
  const QuranReaderScreen({super.key});

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  List<_Surah> _surahs = [];
  Map<String, dynamic> _tafsir = {};
  int _selectedIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final quranRaw = await rootBundle.loadString('assets/data/surahs.json');
    final quranJson = json.decode(quranRaw) as Map<String, dynamic>;
    final surahList = (quranJson['data']?['surahs'] as List?) ?? [];
    final tafsirRaw = await rootBundle.loadString('assets/data/tafsir_ar.json');
    final tafsirJson = json.decode(tafsirRaw) as Map<String, dynamic>;
    setState(() {
      _surahs = surahList
          .map((s) => _Surah.fromJson(Map<String, dynamic>.from(s as Map)))
          .toList();
      _tafsir = Map<String, dynamic>.from(tafsirJson)..remove('attribution');
      _loading = false;
    });
  }

  String? _tafsirFor(int surahNumber, int ayahInSurah) {
    final surahMap = _tafsir['$surahNumber'];
    if (surahMap is Map) {
      return surahMap['$ayahInSurah']?.toString();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'القرآن — نص وتفسير',
      body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: ListView.builder(
                      itemCount: _surahs.length,
                      itemBuilder: (context, index) {
                        final s = _surahs[index];
                        return ListTile(
                          selected: index == _selectedIndex,
                          title: Text('${s.number}'),
                          subtitle: Text(s.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                          onTap: () => setState(() => _selectedIndex = index),
                        );
                      },
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: _AyahList(
                    surah: _surahs[_selectedIndex],
                    tafsirFor: _tafsirFor,
                  )),
                ],
              ),
    );
  }
}

class _AyahList extends StatelessWidget {
  const _AyahList({required this.surah, required this.tafsirFor});

  final _Surah surah;
  final String? Function(int surahNumber, int ayahInSurah) tafsirFor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: surah.ayahs.length,
      itemBuilder: (context, index) {
        final ayah = surah.ayahs[index];
        final tafsir = tafsirFor(surah.number, ayah.numberInSurah);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${ayah.numberInSurah}. ${ayah.text}',
                style: const TextStyle(fontSize: 22, height: 1.9),
                textAlign: TextAlign.right,
              ),
              if (tafsir != null) ...[
                const SizedBox(height: 8),
                Text(
                  'التفسير: $tafsir',
                  style: TextStyle(fontSize: 15, color: AppTokens.brandDark, height: 1.5),
                  textAlign: TextAlign.right,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Surah {
  _Surah({required this.number, required this.name, required this.ayahs});

  final int number;
  final String name;
  final List<_Ayah> ayahs;

  factory _Surah.fromJson(Map<String, dynamic> json) {
    final ayahsJson = json['ayahs'] as List? ?? [];
    return _Surah(
      number: json['number'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      ayahs: ayahsJson
          .map((a) => _Ayah.fromJson(Map<String, dynamic>.from(a as Map)))
          .toList(),
    );
  }
}

class _Ayah {
  _Ayah({required this.text, required this.numberInSurah});

  final String text;
  final int numberInSurah;

  factory _Ayah.fromJson(Map<String, dynamic> json) {
    return _Ayah(
      text: json['text']?.toString() ?? '',
      numberInSurah: json['numberInSurah'] as int? ?? 0,
    );
  }
}
