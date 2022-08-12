
import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/Qibla_cubit/qibla_cubit.dart';
import 'package:azkar/Features/bloc/Sibha_cubit/misbaha_cubit.dart';
import 'package:azkar/Features/bloc/bookmarks/cubit.dart';
import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/pages/home_screen/main_screen.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:azkar/core/widgets/date_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'Features/bloc/chapter/cubit.dart';

import 'Features/pages/splash_screen.dart';
import 'Features/scd.dart';
import 'core/shared/themes.dart';


// adb tcpip 5555
// adb connect 192.168.1.14:5555

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // Bloc.observer = MyBlocObserver();
  await Hive.initFlutter();  await Hive.openBox('app');
  //diohelper.init();
  await configureLocalTimeZone();


  // Initialize the plugin

  var initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await  initializeNotifications();
 // await  scheduleReminderNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AzkarCubit()..getAzkar()),
         // BlocProvider(create: (context) => PrayerCubit()),
          BlocProvider(create: (context) => QiblaCubit()),
          BlocProvider(create: (context) => MisbahaCubit()),
          BlocProvider(create: (context) => ChapterCubit()),
          BlocProvider(create: (context) => BookmarkCubit()),
          BlocProvider(create: (context) => MainBloc()..getPrayTime()),
          BlocProvider(create: (_) => AppProvider()),


        ],
        child:MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            title: 'أدوات المسلم',
            home: SplashScreen()),);
  }
}