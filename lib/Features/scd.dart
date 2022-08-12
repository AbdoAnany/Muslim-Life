import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart';

import '../main.dart';
import 'model/SalatModel.dart';

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    // onDidReceiveBackgroundNotificationResponse: (notificationResponse)=>onClickNotification(notificationResponse,context),
  );




}


Future<void> scheduleReminderNotification() async {
  var scheduledNotificationDateTime = DateTime.now().add(Duration(minutes: 5)); // Adjust this time as needed

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'scheduled title',
      'scheduled body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      platformChannelSpecifics,


      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

  Future<void> _zonedScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),


        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  // await flutterLocalNotificationsPlugin.schedule(
  //   0, // Notification ID, should be unique for each notification
  //   'Reminder', // Title of the notification
  //   'This is your reminder notification', // Body of the notification
  //   scheduledNotificationDateTime,
  //   platformChannelSpecifics,
  //   payload: 'reminder_payload', // Optional, any data you want to pass when the notification is tapped
  // );
}

Future<void> scheduleLocalNotifications({int id=0,String title='',String body='', String? scheduledDate}) async {
  final time = DateTime.parse('${DateTime.now().toString().split(' ')[0]}' +" " + scheduledDate!.split(' ')[0]);

  tz.TZDateTime scheduledDate1 = tz.TZDateTime.from(time,tz.local);

  await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate1,
      // tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes)),
      const NotificationDetails(
      android: AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description')),
  androidAllowWhileIdle: true,
  uiLocalNotificationDateInterpretation:
  UILocalNotificationDateInterpretation.absoluteTime,
  matchDateTimeComponents: DateTimeComponents.time
  //  payload: zekerModel.toStringJson()
  );

  /*
         This shows the notification and repeat every day at the same time.
          matchDateTimeComponents: DateTimeComponents.time

        This shows the notification and repeat every week (same day of week and time).
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime


         */
}

Future<void> configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    ),
  );
}