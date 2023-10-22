import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/model/SalatModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../scd.dart';

class MainBloc extends Cubit<MainState> {
  MainBloc() : super(MainInitState());
  static MainBloc cubit(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<MainBloc>(context, listen: listen);

  static MainBloc get(context) => BlocProvider.of(context);
  String currIndex = "MainScreen";
  bool sidebarOpen = false;
  Map images = {
    "Fajr": "assets/images/FR.jpg",
    "Sunrise": "assets/images/SR.jpg",
    "Dhuhr": "assets/images/ZH.jpg",
    "Asr": "assets/images/AS.jpg",
    "Maghrib": "assets/images/MA.jpg",
    "Isha": "assets/images/IS.jpg"
  };
  Map prayerName = {
    "0": "الفجر",
    "1": "الشروق",
    "2": "الظهر",
    "3": "العصر",
    "4": "المغرب",
    "5": "العشاء"
  };
  List<Data> prayList = [];
  List pageList = [
    'سور القران',
    'أذكار',
    'السبحة',
    'القبلة',
    'علامة القراء',
  ];
  String textState = 'لا بيانات';
  static double maxSlide = 0.0;
  var pages = {
    //  "MainScreen": const MainScreen(),
    //  "surahIndex":const SurahIndexScreen(),
    // // "juzIndex":const JuzIndexScreen(),
    //  "bookmarks":const BookmarksScreen(),
    //  "help":const HelpGuide(),
    //  "azkar":AzkarIndexScreen(),
    //  "intro":const OnboardingScreen(),
    //  "share":const ShareAppScreen(),
  };

  setCurrIndex(page) {
    sidebarOpen = false;
    currIndex = page;
    emit(MainPage());
  }

  Future<void> getPrayTime() async {
    emit(MainLoading());
    textState = 'لا يمكن وصول الي الإنترنت';

    await (Connectivity().checkConnectivity()).then((connectivityResult) async {
      if (connectivityResult == ConnectivityResult.wifi) {
        try {
          textState = "يتم حصول علي الموقع الجغرافي";

          await Geolocator.checkPermission().then((value) async {
            if (value.name == 'denied' || value.name == 'deniedForever') {
              await Geolocator.checkPermission();
              textState = "تحميل بيانات الصلاة لليوم";

              var date = DateTime.now();
              //   var parser = await Chaleno().load('https://www.islamicfinder.org/prayer-widget/360630/shafi/2/0/19.5/17.5');
              var parser1 = await Dio().get(
                  'https://api.aladhan.com/v1/calendar?latitude=30.2398005&longitude=31.4722447&method=3&day=${date.day}&month=${date.month}&year=${date.year}');
              var pray = SalatModel.fromJson(parser1.data);
              prayList = pray.data;

              textState = "تم تحميل البيانات";
              emit(MainSuccess());
            } else {
              textState = "تحميل بيانات الصلاة لليوم";

              var log = await Geolocator.getCurrentPosition();

              var date = DateTime.now();

              //   var parser = await Chaleno().load('https://www.islamicfinder.org/prayer-widget/360630/shafi/2/0/19.5/17.5');

              print(
                  'https://api.aladhan.com/v1/calendar?latitude=${log.latitude}&longitude=${log.longitude}&method=3&day=${date.day}&month=${date.month}&year=${date.year}');
              var parser1 = await Dio().get(
                  'https://api.aladhan.com/v1/calendar?latitude=${log.latitude}&longitude=${log.longitude}&method=3&day=${date.day}&month=${date.month}&year=${date.year}');

              var pray = SalatModel.fromJson(parser1.data);

              print(textState);
              prayList = pray.data;

              for (int index = 0; index < 6; index++) {
                print('3');
                print(prayerName['$index']);
                print(prayList.first.timings!.pray[index]);
                scheduleLocalNotifications(
                    id: index,
                    title: prayerName['$index'],
                    body: "حان الان موعد أذان ${prayerName['$index']}",
                    scheduledDate: prayList.first.timings!.pray[index]);
              }

              textState = "تم تحميل البيانات";
            }

            emit(MainSuccess());
          });
        } catch (e) {
          textState = 'لا يمكن وصول الي بيانات الموقع الجغرافي';
          emit(MainSuccess());
        }
      } else {
        emit(MainSuccess());
      }
    }).timeout(Duration(seconds: 30), onTimeout: () {
      textState = 'لا يمكن وصول الي الإنترنت';
      emit(MainSuccess());
    });
  }
}
