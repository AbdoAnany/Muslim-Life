import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/Qibla_cubit/qibla_cubit.dart';
import 'package:azkar/Features/bloc/Sibha_cubit/misbaha_cubit.dart';
import 'package:azkar/Features/bloc/bookmarks/cubit.dart';
import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';

import 'package:azkar/core/providers/app_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Features/bloc/bookmarkCubit/BookMarkAppCubit.dart';
import 'Features/bloc/chapter/cubit.dart';
import 'Features/pages/splash_screen.dart';
import 'Features/scd.dart';
import 'core/shared/themes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Get {
  static BuildContext get context => navigatorKey.currentContext!;
  static NavigatorState get navigator => navigatorKey.currentState!;
}

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NTFConfig();
  await BookMarkAppCubit.inti();
  await Hive.initFlutter();
  await Hive.openBox('app');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp( MyApp());
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
        child: ScreenUtilInit(
            designSize: const Size( 411.86, 898.86),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp(
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  themeMode: ThemeMode.light,
                  title: 'أدوات المسلم',
                  home: SplashScreen());
            }));
  }
}
