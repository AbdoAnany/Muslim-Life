import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

int id = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final TextEditingController linuxIconPathController = TextEditingController();

bool notificationsEnabled = false;

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';



/// IMPORTANT: running the following code on its own won't work as there is
/// setup required for each platform head project.
///
/// Please download the complete example app from the GitHub repository where
/// all the setup has been done
 NotificationAppLaunchDetails? notificationAppLaunchDetails ;
Future<void> NTFConfig() async {
  print('================   NTFConfig');
  // needed if you intend to initialize in the `main` function


  await configureLocalTimeZone();

   notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = NotificationPanel.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
    initialRoute = SecondPage.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/launcher_icon');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
  <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

}

Future<void> configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
Future<void> isAndroidPermissionGranted() async {
  if (Platform.isAndroid) {
    final bool granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled() ??
        false;


    notificationsEnabled = granted;
    // setState(() {
    //
    // });
  }
}

Future<void> requestPermissions() async {
  if (Platform.isIOS || Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    final bool? grantedNotificationPermission = await androidImplementation?.areNotificationsEnabled();
    notificationsEnabled = grantedNotificationPermission ?? false;

    // setState(() {
    // });
  }
}

void configureDidReceiveLocalNotificationSubject() {
  didReceiveLocalNotificationStream.stream
      .listen((ReceivedNotification receivedNotification) async {
    await showDialog(
      context: Get.context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: receivedNotification.title != null ? Text(receivedNotification.title!) : null,
        content: receivedNotification.body != null ? Text(receivedNotification.body!) : null,
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => SecondPage(receivedNotification.payload),
                ),
              );
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  });
}

void configureSelectNotificationSubject() {
  selectNotificationStream.stream.listen((String? payload) async {
    await Navigator.of(Get.context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => SecondPage(payload),
    ));
  });
}

void initStateNFT() {
  isAndroidPermissionGranted();
  requestPermissions();
  configureDidReceiveLocalNotificationSubject();
  configureSelectNotificationSubject();
}void disposeNTF() {
  didReceiveLocalNotificationStream.close();
  selectNotificationStream.close();

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

class NotificationPanel extends StatefulWidget {
  const NotificationPanel(
    {
        Key? key,
      }) : super(key: key);

  static const String routeName = '/';



  @override
  NotificationPanelState createState() => NotificationPanelState();
}

class NotificationPanelState extends State<NotificationPanel> {

  // @override
  // void initState() {
  //   super.initState();
  //   initStateNFT();
  //
  // }
  //
  //
  // @override
  // void dispose() {
  //   disposeNTF();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                        'Tap on a notification when it appears to trigger'
                            ' navigation'),
                  ),
                  // InfoValueString(
                  //   title: 'Did notification launch app?',
                  //   value: widget.didNotificationLaunchApp,
                  // ),
                  // if (widget.didNotificationLaunchApp) ...<Widget>[
                  //   const Text('Launch notification details'),
                  //   InfoValueString(
                  //       title: 'Notification id',
                  //       value: notificationAppLaunchDetails!.notificationResponse?.id),
                  //   InfoValueString(
                  //       title: 'Action id',
                  //       value:notificationAppLaunchDetails!.notificationResponse?.actionId),
                  //   InfoValueString(
                  //       title: 'Input',
                  //       value: notificationAppLaunchDetails!.notificationResponse?.input),
                  //   InfoValueString(
                  //     title: 'Payload:',
                  //     value: notificationAppLaunchDetails!.notificationResponse?.payload,
                  //   ),
                  // ],
                  PaddedElevatedButton(
                    buttonText: 'Show plain notification with payload',
                    onPressed: () async {
                      await showNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show plain notification that has no title with '
                        'payload',
                    onPressed: () async {
                      await showNotificationWithNoTitle();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show plain notification that has no body with '
                        'payload',
                    onPressed: () async {
                      await showNotificationWithNoBody();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with custom sound',
                    onPressed: () async {
                      await showNotificationCustomSound();
                    },
                  ),
                  if (kIsWeb || !Platform.isLinux) ...<Widget>[
                    PaddedElevatedButton(
                      buttonText: 'Schedule notification to appear in 5 seconds '
                          'based on local time zone',
                      onPressed: () async {
                        await zonedScheduleNotification(id: 0,title: 'TEST TITLE',body: 'BODY TEST',dateTime: await MainBloc.timeToDateTime(time: '15:35'));
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule notification to appear in 5 seconds '
                          'based on local time zone using alarm clock',
                      onPressed: () async {
                        await zonedScheduleAlarmClockNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Repeat notification every minute',
                      onPressed: () async {
                        await repeatNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule daily 10:00:00 am notification in your '
                          'local time zone',
                      onPressed: () async {
                        await scheduleDailyTenAMNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule daily 10:00:00 am notification in your '
                          "local time zone using last year's date",
                      onPressed: () async {
                        await scheduleDailyTenAMLastYearNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule weekly 10:00:00 am notification in your '
                          'local time zone',
                      onPressed: () async {
                        await scheduleWeeklyTenAMNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule weekly Monday 10:00:00 am notification '
                          'in your local time zone',
                      onPressed: () async {
                        await scheduleWeeklyMondayTenAMNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Check pending notifications',
                      onPressed: () async {
                        await checkPendingNotificationRequests();
                      },
                    ),
                    // PaddedElevatedButton(
                    //   buttonText: 'Get active notifications',
                    //   onPressed: () async {
                    //     await getActiveNotifications();
                    //   },
                    // ),
                  ],
                  PaddedElevatedButton(
                    buttonText: 'Schedule monthly Monday 10:00:00 am notification in '
                        'your local time zone',
                    onPressed: () async {
                      await scheduleMonthlyMondayTenAMNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Schedule yearly Monday 10:00:00 am notification in '
                        'your local time zone',
                    onPressed: () async {
                      await scheduleYearlyMondayTenAMNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification from silent channel',
                    onPressed: () async {
                      await showNotificationWithNoSound();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show silent notification from channel with sound',
                    onPressed: () async {
                      await showNotificationSilently();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Cancel latest notification',
                    onPressed: () async {
                      await cancelNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Cancel all notifications',
                    onPressed: () async {
                      await cancelAllNotifications();
                    },
                  ),
                  const Divider(),
                  const Text(
                    'Notifications with actions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with plain actions',
                    onPressed: () async {
                      await showNotificationWithActions();
                    },
                  ),
                  if (Platform.isLinux)
                    PaddedElevatedButton(
                      buttonText: 'Show notification with icon action (if supported)',
                      onPressed: () async {
                        await showNotificationWithIconAction();
                      },
                    ),
                  if (!Platform.isLinux)
                    PaddedElevatedButton(
                      buttonText: 'Show notification with text action',
                      onPressed: () async {
                        await showNotificationWithTextAction();
                      },
                    ),
                  if (!Platform.isLinux)
                    PaddedElevatedButton(
                      buttonText: 'Show notification with text choice',
                      onPressed: () async {
                        await showNotificationWithTextChoice();
                      },
                    ),
                  const Divider(),
                  if (Platform.isAndroid) ...<Widget>[
                    const Text(
                      'Android-specific examples',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('notifications enabled: $notificationsEnabled'),
                    PaddedElevatedButton(
                      buttonText: 'Check if notifications are enabled for this app',
                      onPressed: areNotifcationsEnabledOnAndroid,
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Request permission (API 33+)',
                      onPressed: () => requestPermissions(),
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show plain notification with payload and update '
                          'channel description',
                      onPressed: () async {
                        await showNotificationUpdateChannelDescription();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show plain notification as public on every '
                          'lockscreen',
                      onPressed: () async {
                        await showPublicNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with custom vibration pattern, '
                          'red LED and red icon',
                      onPressed: () async {
                        await showNotificationCustomVibrationIconLed();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification using Android Uri sound',
                      onPressed: () async {
                        await showSoundUriNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification that times out after 3 seconds',
                      onPressed: () async {
                        await showTimeoutNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show insistent notification',
                      onPressed: () async {
                        await showInsistentNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big picture notification using local images',
                      onPressed: () async {
                        await showBigPictureNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big picture notification using base64 String '
                          'for images',
                      onPressed: () async {
                        await showBigPictureNotificationBase64();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big picture notification using URLs for '
                          'Images',
                      onPressed: () async {
                        await showBigPictureNotificationURL();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big picture notification, hide large icon '
                          'on expand',
                      onPressed: () async {
                        await showBigPictureNotificationHiddenLargeIcon();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show media notification',
                      onPressed: () async {
                        await showNotificationMediaStyle();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big text notification',
                      onPressed: () async {
                        await showBigTextNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show inbox notification',
                      onPressed: () async {
                        await showInboxNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show messaging notification',
                      onPressed: () async {
                        await showMessagingNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show grouped notifications',
                      onPressed: () async {
                        await showGroupedNotifications();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with tag',
                      onPressed: () async {
                        await showNotificationWithTag();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Cancel notification with tag',
                      onPressed: () async {
                        await cancelNotificationWithTag();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show ongoing notification',
                      onPressed: () async {
                        await showOngoingNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with no badge, alert only once',
                      onPressed: () async {
                        await showNotificationWithNoBadge();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show progress notification - updates every second',
                      onPressed: () async {
                        await showProgressNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show indeterminate progress notification',
                      onPressed: () async {
                        await showIndeterminateProgressNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification without timestamp',
                      onPressed: () async {
                        await showNotificationWithoutTimestamp();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with custom timestamp',
                      onPressed: () async {
                        await showNotificationWithCustomTimestamp();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with custom sub-text',
                      onPressed: () async {
                        await showNotificationWithCustomSubText();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with chronometer',
                      onPressed: () async {
                        await showNotificationWithChronometer();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show full-screen notification',
                      onPressed: () async {
                        await showFullScreenNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with number if the launcher '
                          'supports',
                      onPressed: () async {
                        await showNotificationWithNumber();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with sound controlled by '
                          'alarm volume',
                      onPressed: () async {
                        await showNotificationWithAudioAttributeAlarm();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Create grouped notification channels',
                      onPressed: () async {
                        await createNotificationChannelGroup();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Delete notification channel group',
                      onPressed: () async {
                        await deleteNotificationChannelGroup();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Create notification channel',
                      onPressed: () async {
                        await createNotificationChannel();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Delete notification channel',
                      onPressed: () async {
                        await deleteNotificationChannel();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Get notification channels',
                      onPressed: () async {
                        await getNotificationChannels();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Start foreground service',
                      onPressed: () async {
                        await startForegroundService();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Start foreground service with blue background '
                          'notification',
                      onPressed: () async {
                        await startForegroundServiceWithBlueBackgroundNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Stop foreground service',
                      onPressed: () async {
                        await stopForegroundService();
                      },
                    ),
                  ],
                  if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) ...<
                      Widget>[
                    const Text(
                      'iOS and macOS-specific examples',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Request permission',
                      onPressed: requestPermissions,
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with subtitle',
                      onPressed: () async {
                        await showNotificationWithSubtitle();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with icon badge',
                      onPressed: () async {
                        await showNotificationWithIconBadge();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with attachment (with thumbnail)',
                      onPressed: () async {
                        await showNotificationWithAttachment(
                            hideThumbnail: false);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with attachment (no thumbnail)',
                      onPressed: () async {
                        await showNotificationWithAttachment(
                            hideThumbnail: true);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with attachment (clipped thumbnail)',
                      onPressed: () async {
                        await showNotificationWithClippedThumbnailAttachment();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notifications with thread identifier',
                      onPressed: () async {
                        await showNotificationsWithThreadIdentifier();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with time sensitive interruption '
                          'level',
                      onPressed: () async {
                        await showNotificationWithTimeSensitiveInterruptionLevel();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with banner but not in '
                          'notification centre',
                      onPressed: () async {
                        await showNotificationWithBannerNotInNotificationCentre();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification in notification centre only',
                      onPressed: () async {
                        await showNotificationInNotificationCentreOnly();
                      },
                    ),
                  ],
                  if (!kIsWeb && Platform.isLinux) ...<Widget>[
                    const Text(
                      'Linux-specific examples',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<LinuxServerCapabilities>(
                      future: getLinuxCapabilities(),
                      builder: (BuildContext context,
                          AsyncSnapshot<LinuxServerCapabilities> snapshot,) {
                        if (snapshot.hasData) {
                          final LinuxServerCapabilities caps = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Capabilities of the current system:',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                InfoValueString(
                                  title: 'Body text:',
                                  value: caps.body,
                                ),
                                InfoValueString(
                                  title: 'Hyperlinks in body text:',
                                  value: caps.bodyHyperlinks,
                                ),
                                InfoValueString(
                                  title: 'Images in body:',
                                  value: caps.bodyImages,
                                ),
                                InfoValueString(
                                  title: 'Markup in the body text:',
                                  value: caps.bodyMarkup,
                                ),
                                InfoValueString(
                                  title: 'Animated icons:',
                                  value: caps.iconMulti,
                                ),
                                InfoValueString(
                                  title: 'Static icons:',
                                  value: caps.iconStatic,
                                ),
                                InfoValueString(
                                  title: 'Notification persistence:',
                                  value: caps.persistence,
                                ),
                                InfoValueString(
                                  title: 'Sound:',
                                  value: caps.sound,
                                ),
                                InfoValueString(
                                  title: 'Actions:',
                                  value: caps.actions,
                                ),
                                InfoValueString(
                                  title: 'Action icons:',
                                  value: caps.actionIcons,
                                ),
                                InfoValueString(
                                  title: 'Other capabilities:',
                                  value: caps.otherCapabilities,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with body markup',
                      onPressed: () async {
                        await showLinuxNotificationWithBodyMarkup();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with category',
                      onPressed: () async {
                        await showLinuxNotificationWithCategory();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with byte data icon',
                      onPressed: () async {
                        //  await showLinuxNotificationWithByteDataIcon();
                      },
                    ),
                    Builder(
                      builder: (BuildContext context) =>
                          PaddedElevatedButton(
                            buttonText: 'Show notification with file path icon',
                            onPressed: () async {
                              final String path = linuxIconPathController.text;
                              if (path.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter the icon path'),
                                  ),
                                );
                                return;
                              }
                              await showLinuxNotificationWithPathIcon(path);
                            },
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: TextField(
                        controller: linuxIconPathController,
                        decoration: InputDecoration(
                          hintText: 'Enter the icon path',
                          constraints: const BoxConstraints.tightFor(
                            width: 300,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => linuxIconPathController.clear(),
                          ),
                        ),
                      ),
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with theme icon',
                      onPressed: () async {
                        await showLinuxNotificationWithThemeIcon();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with theme sound',
                      onPressed: () async {
                        await showLinuxNotificationWithThemeSound();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with critical urgency',
                      onPressed: () async {
                        await showLinuxNotificationWithCriticalUrgency();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with timeout',
                      onPressed: () async {
                        await showLinuxNotificationWithTimeout();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Suppress notification sound',
                      onPressed: () async {
                        await showLinuxNotificationSuppressSound();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Transient notification',
                      onPressed: () async {
                        await showLinuxNotificationTransient();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Resident notification',
                      onPressed: () async {
                        await showLinuxNotificationResident();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification on '
                          'different screen location',
                      onPressed: () async {
                        await showLinuxNotificationDifferentLocation();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item x');
}

Future<void> showNotificationWithActions() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        urlLaunchActionId,
        'Action 1',
        icon: DrawableResourceAndroidBitmap('food'),
        contextual: true,
      ),
      AndroidNotificationAction(
        'id_2',
        'Action 2',
        titleColor: Color.fromARGB(255, 255, 0, 0),
        icon: DrawableResourceAndroidBitmap('secondary_icon'),
      ),
      AndroidNotificationAction(
        navigationActionId,
        'Action 3',
        icon: DrawableResourceAndroidBitmap('secondary_icon'),
        showsUserInterface: true,
        // By default, Android plugin will dismiss the notification when the
        // user tapped on a action (this mimics the behavior on iOS).
        cancelNotification: false,
      ),
    ],
  );

  const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );

  const DarwinNotificationDetails macOSNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );

  const LinuxNotificationDetails linuxNotificationDetails = LinuxNotificationDetails(
    actions: <LinuxNotificationAction>[
      LinuxNotificationAction(
        key: urlLaunchActionId,
        label: 'Action 1',
      ),
      LinuxNotificationAction(
        key: navigationActionId,
        label: 'Action 2',
      ),
    ],
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
    macOS: macOSNotificationDetails,
    linux: linuxNotificationDetails,
  );
  await flutterLocalNotificationsPlugin
      .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item z');
}

Future<void> showNotificationWithTextAction() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        'text_id_1',
        'Enter Text',
        icon: DrawableResourceAndroidBitmap('food'),
        inputs: <AndroidNotificationActionInput>[
          AndroidNotificationActionInput(
            label: 'Enter a message',
          ),
        ],
      ),
    ],
  );

  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryText,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
    macOS: darwinNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
      id++, 'Text Input Notification', 'Expand to see input action', notificationDetails,
      payload: 'item x');
}

Future<void> showNotificationWithIconAction() async {
  const LinuxNotificationDetails linuxNotificationDetails = LinuxNotificationDetails(
    actions: <LinuxNotificationAction>[
      LinuxNotificationAction(
        key: 'media-eject',
        label: 'Eject',
      ),
    ],
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxNotificationDetails,
  );
  await flutterLocalNotificationsPlugin
      .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item z');
}

Future<void> showNotificationWithTextChoice() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        'text_id_2',
        'Action 2',
        icon: DrawableResourceAndroidBitmap('food'),
        inputs: <AndroidNotificationActionInput>[
          AndroidNotificationActionInput(
            choices: <String>['ABC', 'DEF'],
            allowFreeFormInput: false,
          ),
        ],
        contextual: true,
      ),
    ],
  );

  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryText,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
    macOS: darwinNotificationDetails,
  );
  await flutterLocalNotificationsPlugin
      .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item x');
}

Future<void> showFullScreenNotification() async {
  await showDialog(
    context:  Get.context,
    builder: (_) => AlertDialog(
      title: const Text('Turn off your screen'),
      content: const Text('to see the full-screen intent in 5 seconds, press OK and TURN '
          'OFF your screen'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop( Get.context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await flutterLocalNotificationsPlugin.zonedSchedule(
                0,
                'scheduled title',
                'scheduled body',
                tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                const NotificationDetails(
                    android: AndroidNotificationDetails(
                        'full screen channel id', 'full screen channel name',
                        channelDescription: 'full screen channel description',
                        priority: Priority.high,
                        importance: Importance.high,
                        fullScreenIntent: true)),
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);

            Navigator.pop( Get.context);
          },
          child: const Text('OK'),
        )
      ],
    ),
  );
}

Future<void> showNotificationWithNoBody() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(id++, 'plain title', null, notificationDetails,
      payload: 'item x');
}

Future<void> showNotificationWithNoTitle() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(id++, null, 'plain body', notificationDetails,
      payload: 'item x');
}

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancel(--id);
}

Future<void> cancelNotificationWithTag() async {
  await flutterLocalNotificationsPlugin.cancel(--id, tag: 'tag');
}

Future<void> showNotificationCustomSound() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'your other channel id',
    'your other channel name',
    channelDescription: 'your other channel description',
    sound: RawResourceAndroidNotificationSound(' azan'),
  );
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    sound: ' azan.mp3',
  );
  final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    sound: AssetsLinuxSound(' azan'),
  );
  final NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
    macOS: darwinNotificationDetails,
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'custom sound notification title',
    'custom sound notification body',
    notificationDetails,
  );
}

Future<void> showNotificationCustomVibrationIconLed() async {
  final Int64List vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'other custom channel id', 'other custom channel name',
      channelDescription: 'other custom channel description',
      icon: 'secondary_icon',
      largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500);

  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++,
      'title of notification with custom vibration pattern, LED and icon',
      'body of notification with custom vibration pattern, LED and icon',
      notificationDetails);
}

Future<void> zonedScheduleNotification({id,title,body,DateTime? dateTime}) async {
  print('zonedScheduleNotification ${id}');
  print(title);

  tz.TZDateTime time= tz.TZDateTime.from(dateTime!,tz.local);
  print(time.toIso8601String());
  print(tz.TZDateTime.now(tz.local).toIso8601String());

  await flutterLocalNotificationsPlugin.zonedSchedule(
      id??0,
      title??'title',
      body??'body',
      time,
      const NotificationDetails(
          android: AndroidNotificationDetails('your channel id', 'your channel name',
              channelDescription: 'your channel description')),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,payload: time.toIso8601String(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> zonedScheduleAlarmClockNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      123,
      'scheduled alarm clock title',
      'scheduled alarm clock body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails('alarm_clock_channel', 'Alarm Clock Channel',
              channelDescription: 'Alarm Clock Notification')),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime);
}

Future<void> showNotificationWithNoSound() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'silent channel id', 'silent channel name',
      channelDescription: 'silent channel description',
      playSound: false,
      styleInformation: DefaultStyleInformation(true, true));
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    presentSound: false,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, '<b>silent</b> title', '<b>silent</b> body', notificationDetails);
}

Future<void> showNotificationSilently() async {
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('your channel id', 'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const DarwinNotificationDetails darwinNotificationDetails =
  DarwinNotificationDetails(
    presentSound: false,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, '<b>silent</b> title', '<b>silent</b> body', notificationDetails);
}

Future<void> showSoundUriNotification() async {
  /// this calls a method over a platform channel implemented within the
  /// example app to return the Uri for the default alarm sound and uses
  /// as the notification sound
  final String? alarmUri = await platform.invokeMethod<String>('getAlarmUri');
  final UriAndroidNotificationSound uriSound = UriAndroidNotificationSound(alarmUri!);
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'uri channel id', 'uri channel name',
      channelDescription: 'uri channel description',
      sound: uriSound,
      styleInformation: const DefaultStyleInformation(true, true));
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'uri sound title', 'uri sound body', notificationDetails);
}

Future<void> showTimeoutNotification() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'silent channel id', 'silent channel name',
      channelDescription: 'silent channel description',
      timeoutAfter: 3000,
      styleInformation: DefaultStyleInformation(true, true));
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'timeout notification', 'Times out after 3 seconds', notificationDetails);
}

Future<void> showInsistentNotification() async {
  // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
  const int insistentFlag = 4;
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      additionalFlags: Int32List.fromList(<int>[insistentFlag]));
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, 'insistent title', 'insistent body', notificationDetails, payload: 'item x');
}

Future<String> downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> showBigPictureNotification() async {
  final String largeIconPath =
  await downloadAndSaveFile('https://dummyimage.com/48x48', 'largeIcon');
  final String bigPicturePath =
  await downloadAndSaveFile('https://dummyimage.com/400x800', 'bigPicture');
  final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'big text channel id', 'big text channel name',
      channelDescription: 'big text channel description',
      styleInformation: bigPictureStyleInformation);
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'big text title', 'silent body', notificationDetails);
}

Future<String> base64encodedImage(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  final String base64Data = base64Encode(response.bodyBytes);
  return base64Data;
}

Future<void> showBigPictureNotificationBase64() async {
  final String largeIcon = await base64encodedImage('https://dummyimage.com/48x48');
  final String bigPicture = await base64encodedImage('https://dummyimage.com/400x800');

  final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(bigPicture), //Base64AndroidBitmap(bigPicture),
      largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'big text channel id', 'big text channel name',
      channelDescription: 'big text channel description',
      styleInformation: bigPictureStyleInformation);
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'big text title', 'silent body', notificationDetails);
}

Future<Uint8List> getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}

Future<void> showBigPictureNotificationURL() async {
  final ByteArrayAndroidBitmap largeIcon =
  ByteArrayAndroidBitmap(await getByteArrayFromUrl('https://dummyimage.com/48x48'));
  final ByteArrayAndroidBitmap bigPicture =
  ByteArrayAndroidBitmap(await getByteArrayFromUrl('https://dummyimage.com/400x800'));

  final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      bigPicture,
      largeIcon: largeIcon,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'big text channel id', 'big text channel name',
      channelDescription: 'big text channel description',
      styleInformation: bigPictureStyleInformation);
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'big text title', 'silent body', notificationDetails);
}

Future<void> showBigPictureNotificationHiddenLargeIcon() async {
  final String largeIconPath =
  await downloadAndSaveFile('https://dummyimage.com/48x48', 'largeIcon');
  final String bigPicturePath =
  await downloadAndSaveFile('https://dummyimage.com/400x800', 'bigPicture');
  final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'big text channel id', 'big text channel name',
      channelDescription: 'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: bigPictureStyleInformation);
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'big text title', 'silent body', notificationDetails);
}

Future<void> showNotificationMediaStyle() async {
  final String largeIconPath =
  await downloadAndSaveFile('https://dummyimage.com/128x128/00FF00/000000', 'largeIcon');
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'media channel id',
    'media channel name',
    channelDescription: 'media channel description',
    largeIcon: FilePathAndroidBitmap(largeIconPath),
    styleInformation: const MediaStyleInformation(),
  );
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'notification title', 'notification body', notificationDetails);
}

Future<void> showBigTextNotification() async {
  const BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
    'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    htmlFormatBigText: true,
    contentTitle: 'overridden <b>big</b> content title',
    htmlFormatContentTitle: true,
    summaryText: 'summary <i>text</i>',
    htmlFormatSummaryText: true,
  );
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'big text channel id', 'big text channel name',
      channelDescription: 'big text channel description',
      styleInformation: bigTextStyleInformation);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'big text title', 'silent body', notificationDetails);
}

Future<void> showInboxNotification() async {
  final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
  final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
      htmlFormatLines: true,
      contentTitle: 'overridden <b>inbox</b>  Get.context title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'inbox channel id', 'inboxchannel name',
      channelDescription: 'inbox channel description', styleInformation: inboxStyleInformation);
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'inbox title', 'inbox body', notificationDetails);
}

Future<void> showMessagingNotification() async {
  // use a platform channel to resolve an Android drawable resource to a URI.
  // This is NOT part of the notifications plugin. Calls made over this
  /// channel is handled by the app
  final String? imageUri = await platform.invokeMethod('drawableToUri', 'food');

  /// First two person objects will use icons that part of the Android app's
  /// drawable resources
  const Person me = Person(
    name: 'Me',
    key: '1',
    uri: 'tel:1234567890',
    icon: DrawableResourceAndroidIcon('me'),
  );
  const Person coworker = Person(
    name: 'Coworker',
    key: '2',
    uri: 'tel:9876543210',
    icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
  );
  // download the icon that would be use for the lunch bot person
  final String largeIconPath =
  await downloadAndSaveFile('https://dummyimage.com/48x48', 'largeIcon');
  // this person object will use an icon that was downloaded
  final Person lunchBot = Person(
    name: 'Lunch bot',
    key: 'bot',
    bot: true,
    icon: BitmapFilePathAndroidIcon(largeIconPath),
  );
  final Person chef = Person(
      name: 'Master Chef',
      key: '3',
      uri: 'tel:111222333444',
      icon: ByteArrayAndroidIcon.fromBase64String(
          await base64encodedImage('https://placekitten.com/48/48')));

  final List<Message> messages = <Message>[
    Message('Hi', DateTime.now(), null),
    Message("What's up?", DateTime.now().add(const Duration(minutes: 5)), coworker),
    Message('Lunch?', DateTime.now().add(const Duration(minutes: 10)), null,
        dataMimeType: 'image/png', dataUri: imageUri),
    Message('What kind of food would you prefer?',
        DateTime.now().add(const Duration(minutes: 10)), lunchBot),
    Message('You do not have time eat! Keep working!',
        DateTime.now().add(const Duration(minutes: 11)), chef),
  ];
  final MessagingStyleInformation messagingStyle = MessagingStyleInformation(me,
      groupConversation: true,
      conversationTitle: 'Team lunch',
      htmlFormatContent: true,
      htmlFormatTitle: true,
      messages: messages);
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'message channel id', 'message channel name',
      channelDescription: 'message channel description',
      category: AndroidNotificationCategory.message,
      styleInformation: messagingStyle);
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id, 'message title', 'message body', notificationDetails);

  // wait 10 seconds and add another message to simulate another response
  await Future<void>.delayed(const Duration(seconds: 10), () async {
    messages.add(Message("I'm so sorry!!! But I really like thai food ...",
        DateTime.now().add(const Duration(minutes: 11)), null));
    await flutterLocalNotificationsPlugin.show(
        id++, 'message title', 'message body', notificationDetails);
  });
}

Future<void> showGroupedNotifications() async {
  const String groupKey = 'com.android.example.WORK_EMAIL';
  const String groupChannelId = 'grouped channel id';
  const String groupChannelName = 'grouped channel name';
  const String groupChannelDescription = 'grouped channel description';
  // example based on https://developer.android.com/training/notify-user/group.html
  const AndroidNotificationDetails firstNotificationAndroidSpecifics = AndroidNotificationDetails(
      groupChannelId, groupChannelName,
      channelDescription: groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: groupKey);
  const NotificationDetails firstNotificationPlatformSpecifics =
  NotificationDetails(android: firstNotificationAndroidSpecifics);
  await flutterLocalNotificationsPlugin.show(
      id++, 'Alex Faarborg', 'You will not believe...', firstNotificationPlatformSpecifics);
  const AndroidNotificationDetails secondNotificationAndroidSpecifics =
  AndroidNotificationDetails(groupChannelId, groupChannelName,
      channelDescription: groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: groupKey);
  const NotificationDetails secondNotificationPlatformSpecifics =
  NotificationDetails(android: secondNotificationAndroidSpecifics);
  await flutterLocalNotificationsPlugin.show(id++, 'Jeff Chang',
      'Please join us to celebrate the...', secondNotificationPlatformSpecifics);

  // Create the summary notification to support older devices that pre-date
  /// Android 7.0 (API level 24).
  ///
  /// Recommended to create this regardless as the behaviour may vary as
  /// mentioned in https://developer.android.com/training/notify-user/group
  const List<String> lines = <String>[
    'Alex Faarborg  Check this out',
    'Jeff Chang    Launch Party'
  ];
  const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
      contentTitle: '2 messages', summaryText: 'janedoe@example.com');
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      groupChannelId, groupChannelName,
      channelDescription: groupChannelDescription,
      styleInformation: inboxStyleInformation,
      groupKey: groupKey,
      setAsGroupSummary: true);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'Attention', 'Two messages', notificationDetails);
}

Future<void> showNotificationWithTag() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      tag: 'tag');
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(
      id++, 'first notification', null, notificationDetails);
}

Future<void> checkPendingNotificationRequests() async {
  final List<PendingNotificationRequest> pendingNotificationRequests =
  await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  pendingNotificationRequests.forEach((element) {

    print(element.id);
    print(element.title);
    print(element.body);
    print('+++++++++++++++++++++++++++');
  });
  return showDialog<void>(
    context:  Get.context,
    builder: (BuildContext context) => AlertDialog(
      content: Text('${pendingNotificationRequests.length} pending notification '
          'requests'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of( Get.context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> showOngoingNotification() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'ongoing notification title', 'ongoing notification body', notificationDetails);
}

Future<void> repeatNotification() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'repeating channel id', 'repeating channel name',
      channelDescription: 'repeating description');
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.periodicallyShow(
    id++,
    'repeating title',
    'repeating body',
    RepeatInterval.everyMinute,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

Future<void> scheduleDailyTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'daily scheduled notification title',
      'daily scheduled notification body',
      nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily notification channel id', 'daily notification channel name',
            channelDescription: 'daily notification description'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

/// To test we don't validate past dates when using `matchDateTimeComponents`
Future<void> scheduleDailyTenAMLastYearNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'daily scheduled notification title',
      'daily scheduled notification body',
      nextInstanceOfTenAMLastYear(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily notification channel id', 'daily notification channel name',
            channelDescription: 'daily notification description'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

Future<void> scheduleWeeklyTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'weekly scheduled notification title',
      'weekly scheduled notification body',
      nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'weekly notification channel id', 'weekly notification channel name',
            channelDescription: 'weekly notificationdescription'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

Future<void> scheduleWeeklyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'weekly scheduled notification title',
      'weekly scheduled notification body',
      nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'weekly notification channel id', 'weekly notification channel name',
            channelDescription: 'weekly notificationdescription'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

Future<void> scheduleMonthlyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'monthly scheduled notification title',
      'monthly scheduled notification body',
      nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'monthly notification channel id', 'monthly notification channel name',
            channelDescription: 'monthly notificationdescription'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
}

Future<void> scheduleYearlyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'yearly scheduled notification title',
      'yearly scheduled notification body',
      nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'yearly notification channel id', 'yearly notification channel name',
            channelDescription: 'yearly notification description'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime);
}

tz.TZDateTime nextInstanceOfTenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime nextInstanceOfTenAMLastYear() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  return tz.TZDateTime(tz.local, now.year - 1, now.month, now.day, 10);
}

tz.TZDateTime nextInstanceOfMondayTenAM() {
  tz.TZDateTime scheduledDate = nextInstanceOfTenAM();
  while (scheduledDate.weekday != DateTime.monday) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> showNotificationWithNoBadge() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'no badge channel', 'no badge name',
      channelDescription: 'no badge description',
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, 'no badge title', 'no badge body', notificationDetails, payload: 'item x');
}

Future<void> showProgressNotification() async {
  id++;
  final int progressId = id;
  const int maxProgress = 5;
  for (int i = 0; i <= maxProgress; i++) {
    await Future<void>.delayed(const Duration(seconds: 1), () async {
      final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
          'progress channel', 'progress channel',
          channelDescription: 'progress channel description',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: maxProgress,
          progress: i);
      final NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(progressId, 'progress notification title',
          'progress notification body', notificationDetails,
          payload: 'item x');
    });
  }
}

Future<void> showIndeterminateProgressNotification() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'indeterminate progress channel', 'indeterminate progress channel',
      channelDescription: 'indeterminate progress channel description',
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      indeterminate: true);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(id++, 'indeterminate progress notification title',
      'indeterminate progress notification body', notificationDetails,
      payload: 'item x');
}

Future<void> showNotificationUpdateChannelDescription() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your updated channel description',
      importance: Importance.max,
      priority: Priority.high,
      channelAction: AndroidNotificationChannelAction.update);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(id++, 'updated notification channel',
      'check settings to see updated channel description', notificationDetails,
      payload: 'item x');
}

Future<void> showPublicNotification() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      visibility: NotificationVisibility.public);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'public notification title', 'public notification body', notificationDetails,
      payload: 'item x');
}

Future<void> showNotificationWithSubtitle() async {
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    subtitle: 'the subtitle',
  );
  const NotificationDetails notificationDetails =
  NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(id++, 'title of notification with a subtitle',
      'body of notification with a subtitle', notificationDetails,
      payload: 'item x');
}

Future<void> showNotificationWithIconBadge() async {
  const DarwinNotificationDetails darwinNotificationDetails =
  DarwinNotificationDetails(badgeNumber: 1);
  const NotificationDetails notificationDetails =
  NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, 'icon badge title', 'icon badge body', notificationDetails, payload: 'item x');
}

Future<void> showNotificationsWithThreadIdentifier() async {
  NotificationDetails buildNotificationDetailsForThread(
      String threadIdentifier,
      ) {
    final DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      threadIdentifier: threadIdentifier,
    );
    return NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  }

  final NotificationDetails thread1PlatformChannelSpecifics =
  buildNotificationDetailsForThread('thread1');
  final NotificationDetails thread2PlatformChannelSpecifics =
  buildNotificationDetailsForThread('thread2');

  await flutterLocalNotificationsPlugin.show(
      id++, 'thread 1', 'first notification', thread1PlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      id++, 'thread 1', 'second notification', thread1PlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      id++, 'thread 1', 'third notification', thread1PlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
      id++, 'thread 2', 'first notification', thread2PlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      id++, 'thread 2', 'second notification', thread2PlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      id++, 'thread 2', 'third notification', thread2PlatformChannelSpecifics);
}

Future<void> showNotificationWithTimeSensitiveInterruptionLevel() async {
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    interruptionLevel: InterruptionLevel.timeSensitive,
  );
  const NotificationDetails notificationDetails =
  NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(id++, 'title of time sensitive notification',
      'body of time sensitive notification', notificationDetails,
      payload: 'item x');
}

Future<void> showNotificationWithBannerNotInNotificationCentre() async {
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    presentBanner: true,
    presentList: false,
  );
  const NotificationDetails notificationDetails =
  NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, 'title of banner notification', 'body of banner notification', notificationDetails,
      payload: 'item x');
}

Future<void> showNotificationInNotificationCentreOnly() async {
  const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    presentBanner: false,
    presentList: true,
  );
  const NotificationDetails notificationDetails =
  NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++,
      'title of notification shown only in notification centre',
      'body of notification shown only in notification centre',
      notificationDetails,
      payload: 'item x');
}

Future<void> showNotificationWithoutTimestamp() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false);
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item x');
}

Future<void> showNotificationWithCustomTimestamp() async {
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
  );
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item x');
}

Future<void> showNotificationWithCustomSubText() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    subText: 'custom subtext',
  );
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item x');
}

Future<void> showNotificationWithChronometer() async {
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
    usesChronometer: true,
    chronometerCountDown: true,
  );
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item x');
}

Future<void> showNotificationWithAttachment({
  required bool hideThumbnail,
}) async {
  final String bigPicturePath =
  await downloadAndSaveFile('https://dummyimage.com/600x200', 'bigPicture.jpg');
  final DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    attachments: <DarwinNotificationAttachment>[
      DarwinNotificationAttachment(
        bigPicturePath,
        hideThumbnail: hideThumbnail,
      )
    ],
  );
  final NotificationDetails notificationDetails =
  NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(id++, 'notification with attachment title',
      'notification with attachment body', notificationDetails);
}

Future<void> showNotificationWithClippedThumbnailAttachment() async {
  final String bigPicturePath =
  await downloadAndSaveFile('https://dummyimage.com/600x200', 'bigPicture.jpg');
  final DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    attachments: <DarwinNotificationAttachment>[
      DarwinNotificationAttachment(
        bigPicturePath,
        thumbnailClippingRect:
        // lower right quadrant of the attachment
        const DarwinNotificationAttachmentThumbnailClippingRect(
          x: 0.5,
          y: 0.5,
          height: 0.5,
          width: 0.5,
        ),
      )
    ],
  );
  final NotificationDetails notificationDetails =
  NotificationDetails(iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(id++, 'notification with attachment title',
      'notification with attachment body', notificationDetails);
}

Future<void> createNotificationChannelGroup() async {
  const String channelGroupId = 'your channel group id';
  // create the group first
  const AndroidNotificationChannelGroup androidNotificationChannelGroup =
  AndroidNotificationChannelGroup(channelGroupId, 'your channel group name',
      description: 'your channel group description');
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannelGroup(androidNotificationChannelGroup);

  // create channels associated with the group
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(const AndroidNotificationChannel(
      'grouped channel id 1', 'grouped channel name 1',
      description: 'grouped channel description 1', groupId: channelGroupId));

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(const AndroidNotificationChannel(
      'grouped channel id 2', 'grouped channel name 2',
      description: 'grouped channel description 2', groupId: channelGroupId));

  await showDialog<void>(
      context:  Get.context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('Channel group with name '
            '${androidNotificationChannelGroup.name} created'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of( Get.context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ));
}

Future<void> deleteNotificationChannelGroup() async {
  const String channelGroupId = 'your channel group id';
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.deleteNotificationChannelGroup(channelGroupId);

  await showDialog<void>(
    context:  Get.context,
    builder: (BuildContext context) => AlertDialog(
      content: const Text('Channel group with id $channelGroupId deleted'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of( Get.context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> startForegroundService() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.startForegroundService(1, 'plain title', 'plain body',
      notificationDetails: androidNotificationDetails, payload: 'item x');
}

Future<void> startForegroundServiceWithBlueBackgroundNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'color background channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    color: Colors.blue,
    colorized: true,
  );

  /// only using foreground service can color the background
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.startForegroundService(1, 'colored background text title', 'colored background text body',
      notificationDetails: androidPlatformChannelSpecifics, payload: 'item x');
}

Future<void> stopForegroundService() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.stopForegroundService();
}

Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
    'your channel id 2',
    'your channel name 2',
    description: 'your channel description 2',
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  await showDialog<void>(
      context:  Get.context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('Channel with name ${androidNotificationChannel.name} '
            'created'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of( Get.context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ));
}

Future<void> areNotifcationsEnabledOnAndroid() async {
  final bool? areEnabled = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.areNotificationsEnabled();
  await showDialog<void>(
      context:  Get.context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(areEnabled == null
            ? 'ERROR: received null'
            : (areEnabled ? 'Notifications are enabled' : 'Notifications are NOT enabled')),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of( Get.context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ));
}

Future<void> deleteNotificationChannel() async {
  const String channelId = 'your channel id 2';
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.deleteNotificationChannel(channelId);

  await showDialog<void>(
    context:  Get.context,
    builder: (BuildContext context) => AlertDialog(
      content: const Text('Channel with id $channelId deleted'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// Future<void> getActiveNotifications() async {
//   final Widget activeNotificationsDialogContent = await getActiveNotificationsDialogContent();
//   await showDialog<void>(
//     context:  Get.context,
//     builder: (BuildContext context) => AlertDialog(
//       content: activeNotificationsDialogContent,
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('OK'),
//         ),
//       ],
//     ),
//   );
// }
//
// Future<Widget> getActiveNotificationsDialogContent() async {
//   if (Platform.isAndroid) {
//     final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     if (androidInfo.version.sdkInt < 23) {
//       return const Text(
//         '"getActiveNotifications" is available only for Android 6.0 or newer',
//       );
//     }
//   } else if (Platform.isIOS) {
//     final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//     final List<String> fullVersion = iosInfo.systemVersion!.split('.');
//     if (fullVersion.isNotEmpty) {
//       final int? version = int.tryParse(fullVersion[0]);
//       if (version != null && version < 10) {
//         return const Text(
//           '"getActiveNotifications" is available only for iOS 10.0 or newer',
//         );
//       }
//     }
//   }
//
//   try {
//     final List<ActiveNotification>? activeNotifications =
//     await flutterLocalNotificationsPlugin.getActiveNotifications();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         const Text(
//           'Active Notifications',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const Divider(color: Colors.black),
//         if (activeNotifications!.isEmpty) const Text('No active notifications'),
//         if (activeNotifications.isNotEmpty)
//           for (final ActiveNotification activeNotification in activeNotifications)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   'id: ${activeNotification.id}\n'
//                       'channelId: ${activeNotification.channelId}\n'
//                       'groupKey: ${activeNotification.groupKey}\n'
//                       'tag: ${activeNotification.tag}\n'
//                       'title: ${activeNotification.title}\n'
//                       'body: ${activeNotification.body}',
//                 ),
//                 if (Platform.isAndroid && activeNotification.id != null)
//                   TextButton(
//                     child: const Text('Get messaging style'),
//                     onPressed: () {
//                       getActiveNotificationMessagingStyle(
//                           activeNotification.id!, activeNotification.tag);
//                     },
//                   ),
//                 const Divider(color: Colors.black),
//               ],
//             ),
//       ],
//     );
//   } on PlatformException catch (error) {
//     return Text(
//       'Error calling "getActiveNotifications"\n'
//           'code: ${error.code}\n'
//           'message: ${error.message}',
//     );
//   }
// }

Future<void> getActiveNotificationMessagingStyle(int id, String? tag) async {
  Widget dialogContent;
  try {
    final MessagingStyleInformation? messagingStyle = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .getActiveNotificationMessagingStyle(id, tag: tag);
    if (messagingStyle == null) {
      dialogContent = const Text('No messaging style');
    } else {
      dialogContent = SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('person: ${formatPerson(messagingStyle.person)}\n'
                  'conversationTitle: ${messagingStyle.conversationTitle}\n'
                  'groupConversation: ${messagingStyle.groupConversation}'),
              const Divider(color: Colors.black),
              if (messagingStyle.messages == null) const Text('No messages'),
              if (messagingStyle.messages != null)
                for (final Message msg in messagingStyle.messages!)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('text: ${msg.text}\n'
                          'timestamp: ${msg.timestamp}\n'
                          'person: ${formatPerson(msg.person)}'),
                      const Divider(color: Colors.black),
                    ],
                  ),
            ],
          ));
    }
  } on PlatformException catch (error) {
    dialogContent = Text(
      'Error calling "getActiveNotificationMessagingStyle"\n'
          'code: ${error.code}\n'
          'message: ${error.message}',
    );
  }

  await showDialog<void>(
    context:  Get.context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Messaging style'),
      content: dialogContent,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

String formatPerson(Person? person) {
  if (person == null) {
    return 'null';
  }

  final List<String> attrs = <String>[];
  if (person.name != null) {
    attrs.add('name: "${person.name}"');
  }
  if (person.uri != null) {
    attrs.add('uri: "${person.uri}"');
  }
  if (person.key != null) {
    attrs.add('key: "${person.key}"');
  }
  if (person.important) {
    attrs.add('important: true');
  }
  if (person.bot) {
    attrs.add('bot: true');
  }
  if (person.icon != null) {
    attrs.add('icon: ${ formatAndroidIcon(person.icon)}');
  }
  return 'Person(${attrs.join(', ')})';
}

String formatAndroidIcon(Object? icon) {
  if (icon == null) {
    return 'null';
  }
  if (icon is DrawableResourceAndroidIcon) {
    return 'DrawableResourceAndroidIcon("${icon.data}")';
  } else if (icon is ContentUriAndroidIcon) {
    return 'ContentUriAndroidIcon("${icon.data}")';
  } else {
    return 'AndroidIcon()';
  }
}

Future<void> getNotificationChannels() async {
  final Widget notificationChannelsDialogContent = await getNotificationChannelsDialogContent();
  await showDialog<void>(
     context:  Get.context,
    builder: (BuildContext context) => AlertDialog(
      content: notificationChannelsDialogContent,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<Widget> getNotificationChannelsDialogContent() async {
  try {
    final List<AndroidNotificationChannel>? channels = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .getNotificationChannels();

    return Container(
      width: double.maxFinite,
      child: ListView(
        children: <Widget>[
          const Text(
            'Notifications Channels',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.black),
          if (channels?.isEmpty ?? true)
            const Text('No notification channels')
          else
            for (final AndroidNotificationChannel channel in channels!)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('id: ${channel.id}\n'
                      'name: ${channel.name}\n'
                      'description: ${channel.description}\n'
                      'groupId: ${channel.groupId}\n'
                      'importance: ${channel.importance.value}\n'
                      'playSound: ${channel.playSound}\n'
                      'sound: ${channel.sound?.sound}\n'
                      'enableVibration: ${channel.enableVibration}\n'
                      'vibrationPattern: ${channel.vibrationPattern}\n'
                      'showBadge: ${channel.showBadge}\n'
                      'enableLights: ${channel.enableLights}\n'
                      'ledColor: ${channel.ledColor}\n'),
                  const Divider(color: Colors.black),
                ],
              ),
        ],
      ),
    );
  } on PlatformException catch (error) {
    return Text(
      'Error calling "getNotificationChannels"\n'
          'code: ${error.code}\n'
          'message: ${error.message}',
    );
  }
}

Future<void> showNotificationWithNumber() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      number: 1);
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'icon badge title', 'icon badge body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> showNotificationWithAudioAttributeAlarm() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your alarm channel id',
    'your alarm channel name',
    channelDescription: 'your alarm channel description',
    importance: Importance.max,
    priority: Priority.high,
    audioAttributesUsage: AudioAttributesUsage.alarm,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification sound controlled by alarm volume',
    'alarm notification sound body',
    platformChannelSpecifics,
  );
}


Future<void> showLinuxNotificationWithBodyMarkup() async {
  await flutterLocalNotificationsPlugin.show(
    id++,
    'notification with body markup',
    '<b>bold text</b>\n'
        '<i>italic text</i>\n'
        '<u>underline text</u>\n'
        'https://example.com\n'
        '<a href="https://example.com">example.com</a>',
    null,
  );
}

Future<void> showLinuxNotificationWithCategory() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    category: LinuxNotificationCategory.emailArrived,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'notification with category',
    null,
    notificationDetails,
  );
}

// Future<void> showLinuxNotificationWithByteDataIcon() async {
//   final ByteData assetIcon = await rootBundle.load(
//     'icons/app_icon_density.png',
//   );
//   final image.Image? iconData = image.decodePng(
//     assetIcon.buffer.asUint8List().toList(),
//   );
//   final Uint8List iconBytes = iconData!.getBytes();
//   final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
//     icon: ByteDataLinuxIcon(
//       LinuxRawIconData(
//         data: iconBytes,
//         width: iconData.width,
//         height: iconData.height,
//         channels: 4, // The icon has an alpha channel
//         hasAlpha: true,
//       ),
//     ),
//   );
//   final NotificationDetails notificationDetails = NotificationDetails(
//     linux: linuxPlatformChannelSpecifics,
//   );
//   await flutterLocalNotificationsPlugin.show(
//     id++,
//     'notification with byte data icon',
//     null,
//     notificationDetails,
//   );
// }

Future<void> showLinuxNotificationWithPathIcon(String path) async {
  final LinuxNotificationDetails linuxPlatformChannelSpecifics =
  LinuxNotificationDetails(icon: FilePathLinuxIcon(path));
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'notification with file path icon',
    null,
    platformChannelSpecifics,
  );
}

Future<void> showLinuxNotificationWithThemeIcon() async {
  final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    icon: ThemeLinuxIcon('media-eject'),
  );
  final NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'notification with theme icon',
    null,
    notificationDetails,
  );
}

Future<void> showLinuxNotificationWithThemeSound() async {
  final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    sound: ThemeLinuxSound('message-new-email'),
  );
  final NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'notification with theme sound',
    null,
    notificationDetails,
  );
}

Future<void> showLinuxNotificationWithCriticalUrgency() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    urgency: LinuxNotificationUrgency.critical,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'notification with critical urgency',
    null,
    notificationDetails,
  );
}

Future<void> showLinuxNotificationWithTimeout() async {
  final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    timeout: LinuxNotificationTimeout.fromDuration(
      const Duration(seconds: 1),
    ),
  );
  final NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'notification with timeout',
    null,
    notificationDetails,
  );
}

Future<void> showLinuxNotificationSuppressSound() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    suppressSound: true,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'suppress notification sound',
    null,
    notificationDetails,
  );
}

Future<void> showLinuxNotificationTransient() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    transient: true,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'transient notification',
    null,
    notificationDetails,
  );
}

Future<void> showLinuxNotificationResident() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(
    resident: true,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'resident notification',
    null,
    notificationDetails,
  );
}

Future<void> showLinuxNotificationDifferentLocation() async {
  const LinuxNotificationDetails linuxPlatformChannelSpecifics =
  LinuxNotificationDetails(location: LinuxNotificationLocation(10, 10));
  const NotificationDetails notificationDetails = NotificationDetails(
    linux: linuxPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id++,
    'notification on different screen location',
    null,
    notificationDetails,
  );
}

Future<LinuxServerCapabilities> getLinuxCapabilities() => flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<LinuxFlutterLocalNotificationsPlugin>()!
    .getCapabilities();
class SecondPage extends StatefulWidget {
  const SecondPage(
      this.payload, {
        Key? key,
      }) : super(key: key);

  static const String routeName = '/secondPage';

  final String? payload;

  @override
  State<StatefulWidget> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  String? payload;

  @override
  void initState() {
    super.initState();
    payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Second Screen'),
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('payload ${payload ?? ''}'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      ),
    ),
  );
}

class InfoValueString extends StatelessWidget {
  const InfoValueString({
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  final String title;
  final Object? value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
    child: Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '$title ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '$value',
          )
        ],
      ),
    ),
  );
}







// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/timezone.dart';
//
// import '../main.dart';
// import 'model/SalatModel.dart';
//
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
//   const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//     // onDidReceiveBackgroundNotificationResponse: (notificationResponse)=>onClickNotification(notificationResponse,context),
//   );
//
//
//
//
// }
//
//
// Future<void> scheduleReminderNotification() async {
//   var scheduledNotificationDateTime = DateTime.now().add(Duration(minutes: 5)); // Adjust this time as needed
//
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails('your channel id', 'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker');
//   var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     iOS: iOSPlatformChannelSpecifics,
//   );
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'scheduled title',
//       'scheduled body',
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//       platformChannelSpecifics,
//
//
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
//
//   Future<void> zonedScheduleNotification() async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'scheduled title',
//         'scheduled body',
//         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'your channel id', 'your channel name',
//                 channelDescription: 'your channel description')),
//
//
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
//   }
//
//   // await flutterLocalNotificationsPlugin.schedule(
//   //   0, // Notification ID, should be unique for each notification
//   //   'Reminder', // Title of the notification
//   //   'This is your reminder notification', // Body of the notification
//   //   scheduledNotificationDateTime,
//   //   platformChannelSpecifics,
//   //   payload: 'reminder_payload', // Optional, any data you want to pass when the notification is tapped
//   // );
// }
// Future<void> scheduleLocalNotifications({
//   int id = 0,
//   String title = '',
//   String body = '',
//   String? scheduledDate,
// }) async {
//   if (scheduledDate == null) {
//     // Handle the case when scheduledDate is null.
//     return;
//   }
//   final tz.TZDateTime scheduledDate1 =
//   // tz.TZDateTime.from(DateTime.parse('${DateTime.now().toString().split(' ')[0]}' +" " + scheduledDate!), tz.local);
//   tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 80)), tz.local);
//   print(scheduledDate1);
//
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     id,
//     title,
//     body,
//     scheduledDate1,
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'your channel id',
//         'your channel name',
//         channelDescription: 'your channel description',
//       ),
//     ),
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//     UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//     //  payload: zekerModel.toStringJson()
//   );
// }
//
// Future<void> scheduleLocalNotifications1({int id=0,String title='',String body='', String? scheduledDate}) async {
//   final time = DateTime.parse('${DateTime.now().toString().split(' ')[0]}' +" " + scheduledDate!);
//   tz.TZDateTime scheduledDate1 = tz.TZDateTime.from(time,tz.local);
//
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDate1,
//       // tz.TZDateTime.now(tz.local).add( Duration(minutes: minutes)),
//       const NotificationDetails(
//       android: AndroidNotificationDetails(
//       'your channel id', 'your channel name',
//       channelDescription: 'your channel description')),
//   androidAllowWhileIdle: true,
//   uiLocalNotificationDateInterpretation:
//   UILocalNotificationDateInterpretation.absoluteTime,
//   matchDateTimeComponents: DateTimeComponents.time
//   //  payload: zekerModel.toStringJson()
//   );
//
//   /*
//          This shows the notification and repeat every day at the same time.
//           matchDateTimeComponents: DateTimeComponents.time
//
//         This shows the notification and repeat every week (same day of week and time).
//         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
//
//
//          */
// }
//
// Future<void> configureLocalTimeZone() async {
//   if (kIsWeb || Platform.isLinux) {
//     return;
//   }
//   tz.initializeTimeZones();
//   final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZoneName!));
// }
//
// class PaddedElevatedButton extends StatelessWidget {
//   const PaddedElevatedButton({
//     required this.buttonText,
//     required this.onPressed,
//     Key? key,
//   }) : super(key: key);
//
//   final String buttonText;
//   final VoidCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//     child: ElevatedButton(
//       onPressed: onPressed,
//       child: Text(buttonText),
//     ),
//   );
// }
//
// Future<void> scheduleNotification() async {
//   const int notificationId = 0;
//   const String title = 'Scheduled Notification';
//   const String body = 'This is a scheduled notification!';
//   final DateTime scheduledDate = DateTime.now().add(const Duration(minutes: 1));
//
//   final AndroidNotificationDetails androidDetails =
//   AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     importance: Importance.high,
//     priority: Priority.high,
//   );
//    NotificationDetails notificationDetails =
//   NotificationDetails(     android: androidDetails);
//
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     notificationId,
//     title,
//     body,
//     tz.TZDateTime.from(scheduledDate, tz.local),
//     notificationDetails,
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//     UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );
// }