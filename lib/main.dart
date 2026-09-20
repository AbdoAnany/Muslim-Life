import 'package:azkar/Bloc/app_cubit.dart';
import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/Qibla_cubit/qibla_cubit.dart';
import 'package:azkar/Features/bloc/Sibha_cubit/misbaha_cubit.dart';
import 'package:azkar/Features/bloc/bookmarks/cubit.dart';
import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/bookmarkCubit/BookMarkAppCubit.dart';
import 'package:azkar/Features/bloc/chapter/cubit.dart';
import 'package:azkar/Features/pages/splash_screen.dart';
import 'package:azkar/core/config/app_contact.dart';
import 'package:azkar/core/notifications/app_notification_service.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/shared/themes.dart';
import 'package:azkar/core/storage/cash_local.dart';
import 'package:azkar/core/widgets/home_widget_bridge.dart';
import 'package:azkar/features/content/content_favorites_store.dart';
import 'package:azkar/helper/db_sqlite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Get {
  static BuildContext get context => navigatorKey.currentContext!;
  static NavigatorState get navigator => navigatorKey.currentState!;
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashLocal.init();
  await configureNotifications();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.anany.azkar.audio',
    androidNotificationChannelName: 'تشغيل القرآن',
    androidNotificationOngoing: true,
  );
  await HomeWidgetBridge.init();
  await BookMarkAppCubit.inti();
  await ContentFavoritesStore.instance.init();
  await Hive.initFlutter();
  await Hive.openBox('app');
  await DbSQLiteProvider.db.database;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()..getHomeData()),
        BlocProvider(create: (context) => AzkarCubit()..getAzkarModel()),
        BlocProvider(create: (context) => QiblaCubit()),
        BlocProvider(create: (context) => MisbahaCubit()),
        BlocProvider(create: (context) => ChapterCubit()),
        BlocProvider(create: (context) => BookmarkCubit()),
        BlocProvider(create: (context) => MainBloc()..getPrayTime()),
        BlocProvider(create: (_) => AppProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411.86, 898.86),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: theme,
            themeMode: ThemeMode.light,
            locale: const Locale('ar'),
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            title: AppContact.appName,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
