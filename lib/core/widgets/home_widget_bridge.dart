import 'dart:io';

import 'package:azkar/core/notifications/app_notification_service.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

/// Home-screen dhikr widget bridge (Android AppWidget + iOS WidgetKit).
class HomeWidgetBridge {
  static const _androidName = 'DhikrWidgetProvider';
  static const _iosKind = 'DhikrWidget';
  static const _appGroupId = 'group.com.anany.azkar';

  static const _dhikrKey = 'dhikr_text';
  static const _countKey = 'dhikr_count';
  static const _nextReminderKey = 'dhikr_next_reminder';

  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
    if (Platform.isAndroid || Platform.isIOS) {
      await HomeWidget.registerInteractivityCallback(_backgroundCallback);
    }
  }

  static Future<void> updateDhikr(
    String text,
    int count, {
    String? nextReminder,
  }) async {
    await HomeWidget.saveWidgetData<String>(_dhikrKey, text);
    await HomeWidget.saveWidgetData<int>(_countKey, count);
    if (nextReminder != null) {
      await HomeWidget.saveWidgetData<String>(_nextReminderKey, nextReminder);
    }
    await _reloadWidget();
  }

  /// Reads the next pending dhikr/prayer notification label for the widget subtitle.
  static Future<void> syncNextReminderFromNotifications() async {
    final pending = await AppNotificationService.instance.pending();
    String? label;
    DateTime? earliest;

    for (final n in pending) {
      if (n.payload == null || n.payload!.isEmpty) continue;
      try {
        final map = ZekerModel.toMapString(n.payload!);
        final z = ZekerModel.fromJson(map);
        if (z.notficationScheduledDate != null) {
          final dt = z.notficationScheduledDate!.toLocal();
          if (dt.isAfter(DateTime.now()) &&
              (earliest == null || dt.isBefore(earliest!))) {
            earliest = dt;
            label = '${z.zeker_name} — ${DateFormat('HH:mm').format(dt)}';
          }
        }
      } catch (_) {
        // Prayer notifications store ISO date in payload.
        try {
          final dt = DateTime.parse(n.payload!);
          if (dt.isAfter(DateTime.now()) &&
              (earliest == null || dt.isBefore(earliest!))) {
            earliest = dt;
            label = '${n.title ?? 'تذكير'} — ${DateFormat('HH:mm').format(dt)}';
          }
        } catch (_) {}
      }
    }

    if (label != null) {
      await HomeWidget.saveWidgetData<String>(_nextReminderKey, label);
      await _reloadWidget();
    }
  }

  static Future<void> _reloadWidget() async {
    if (Platform.isAndroid) {
      await HomeWidget.updateWidget(
        qualifiedAndroidName: 'com.anany.azkar.$_androidName',
      );
    } else if (Platform.isIOS) {
      await HomeWidget.updateWidget(iOSName: _iosKind);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundCallback(Uri? uri) async {
    if (uri == null) return;
    if (uri.host == 'increment' || uri.path.contains('increment')) {
      final count =
          await HomeWidget.getWidgetData<int>(_countKey, defaultValue: 0) ?? 0;
      await HomeWidget.saveWidgetData<int>(_countKey, count + 1);
      await _reloadWidget();
    }
  }
}
