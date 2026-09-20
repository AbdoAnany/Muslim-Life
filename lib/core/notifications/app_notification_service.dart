import 'dart:io';

import 'package:azkar/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Production notification bootstrap (Tasbeeh NotificationService + Muslim-Life init).
class AppNotificationService {
  AppNotificationService._();
  static final AppNotificationService instance = AppNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  Future<void> initialize() async {
    await _configureLocalTimeZone();

    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> schedulePrayer({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (!dateTime.isAfter(DateTime.now())) {
      return;
    }
    final scheduled = tz.TZDateTime.from(dateTime, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'muslim_life_prayer',
          'مواقيت الصلاة',
          channelDescription: 'تنبيهات أوقات الصلاة',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: scheduled.toIso8601String(),
    );
  }

  Future<void> scheduleDhikr({
    required int id,
    required String channelId,
    required String channelName,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? androidRawSound,
    String payload = '',
    bool repeatDaily = true,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: 'تذكير بالذكر',
          importance: Importance.high,
          priority: Priority.high,
          playSound: androidRawSound != null,
          sound: androidRawSound != null
              ? RawResourceAndroidNotificationSound(androidRawSound)
              : null,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          sound: androidRawSound != null ? '$androidRawSound.mp3' : null,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          repeatDaily ? DateTimeComponents.time : null,
      payload: payload,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<List<PendingNotificationRequest>> pending() =>
      _plugin.pendingNotificationRequests();
}

Future<void> configureNotifications() =>
    AppNotificationService.instance.initialize();

Future<void> zonedScheduleNotification({
  int? id,
  String? title,
  String? body,
  DateTime? dateTime,
}) {
  return AppNotificationService.instance.schedulePrayer(
    id: id ?? 0,
    title: title ?? '',
    body: body ?? '',
    dateTime: dateTime ?? DateTime.now(),
  );
}
