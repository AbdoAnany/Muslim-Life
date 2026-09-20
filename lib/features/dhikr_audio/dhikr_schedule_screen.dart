import 'package:azkar/core/notifications/app_notification_service.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/models/tasbeeh/build_azkar.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class DhikrScheduleScreen extends StatefulWidget {
  const DhikrScheduleScreen({super.key});

  @override
  State<DhikrScheduleScreen> createState() => _DhikrScheduleScreenState();
}

class _DhikrScheduleScreenState extends State<DhikrScheduleScreen> {
  final AssetsAudioPlayer _player = AssetsAudioPlayer();
  List<ZekerModel> _pending = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final list = await AppNotificationService.instance.pending();
    final models = <ZekerModel>[];
    for (final n in list) {
      if (n.payload != null && n.payload!.isNotEmpty) {
        try {
          models.add(ZekerModel.fromJson(ZekerModel.toMapString(n.payload!)));
        } catch (_) {}
      }
    }
    models.sort((a, b) => (a.notficationId ?? 0).compareTo(b.notficationId ?? 0));
    setState(() {
      _pending = models;
      _loading = false;
    });
  }

  Future<void> _stop() async {
    BuildAzkar.stop();
    await AppNotificationService.instance.cancelAll();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _play(ZekerModel zeker) async {
    try {
      await _player.open(Audio('assets/music/click.wav'));
      await _player.play();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('قائمة التنبيهات'), backgroundColor: kMainColor),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: _stop,
              child: const Text('إيقاف الأذكار'),
            ),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _pending.isEmpty
                ? const Center(child: Text('لا توجد تنبيهات مجدولة'))
                : ListView.builder(
                    itemCount: _pending.length,
                    itemBuilder: (context, index) {
                      final z = _pending[index];
                      return Dismissible(
                        key: ValueKey(z.notficationId),
                        background: Container(color: Colors.red),
                        onDismissed: (_) async {
                          await AppNotificationService.instance
                              .cancel(z.notficationId ?? 0);
                          _refresh();
                        },
                        child: ListTile(
                          title: Text(z.zeker_name),
                          subtitle: Text(z.notficationScheduledDate != null
                              ? z.scheduledDate()
                              : 'كل ساعة — دقيقة ${z.notficationScheduledMinute}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_circle),
                            onPressed: () => _play(z),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
