import 'package:azkar/core/audio/app_audio.dart';
import 'package:azkar/core/notifications/app_notification_service.dart';
import 'package:azkar/core/theme/app_tokens.dart';
import 'package:azkar/core/widgets/dls/app_scaffold.dart';
import 'package:azkar/core/widgets/dls/app_snackbar.dart';
import 'package:azkar/core/widgets/dls/empty_state.dart';
import 'package:azkar/core/widgets/home_widget_bridge.dart';
import 'package:azkar/models/tasbeeh/build_azkar.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter/material.dart';

class DhikrScheduleScreen extends StatefulWidget {
  const DhikrScheduleScreen({super.key});

  @override
  State<DhikrScheduleScreen> createState() => _DhikrScheduleScreenState();
}

class _DhikrScheduleScreenState extends State<DhikrScheduleScreen> {
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
    await HomeWidgetBridge.syncNextReminderFromNotifications();
  }

  Future<void> _stop() async {
    BuildAzkar.stop();
    await AppNotificationService.instance.cancelAll();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _play(ZekerModel zeker) async {
    final err = await AppAudio.playDhikr(zeker);
    if (!mounted || err == null) return;
    showAppSnackBar(context, err, isError: true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'قائمة التنبيهات',
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spaceMd),
          child: ElevatedButton(
            onPressed: _stop,
            child: const Text('إيقاف الأذكار'),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _pending.isEmpty
              ? const EmptyState(message: 'لا توجد تنبيهات مجدولة')
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTokens.spaceMd),
                  itemCount: _pending.length,
                  itemBuilder: (context, index) {
                    final z = _pending[index];
                    return Dismissible(
                      key: ValueKey(z.notficationId),
                      background: Container(color: AppTokens.error),
                      onDismissed: (_) async {
                        await AppNotificationService.instance
                            .cancel(z.notficationId ?? 0);
                        _refresh();
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: AppTokens.spaceSm),
                        child: ListTile(
                          title: Text(z.zeker_name),
                          subtitle: Text(z.notficationScheduledDate != null
                              ? z.scheduledDate()
                              : 'كل ساعة — دقيقة ${z.notficationScheduledMinute}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_circle, color: AppTokens.brand),
                            onPressed: () => _play(z),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
