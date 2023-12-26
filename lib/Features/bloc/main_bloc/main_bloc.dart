import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/model/prayer_times_model.dart';
import 'package:azkar/StorePray.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

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
  // Map prayerName = {
  //   "0": "الفجر",
  //   "1": "الشروق",
  //   "2": "الظهر",
  //   "3": "العصر",
  //   "4": "المغرب",
  //   "5": "العشاء"
  // };
  List<Data> prayList = [];
  Timings timings = Timings();
  List<PrayerTimeModel?> timingsList = [];

  List<PrayerTimeModel?> timingsListMethod(timings) => [
        timings.fajr,
        timings.sunrise,
        timings.dhuhr,
        timings.asr,
        timings.maghrib,
        timings.isha,
        timings.firstthird,
        timings.midnight,
        timings.lastthird
      ];

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

  updateTextState({String message = 'جاري تحميل البيانات'}) {
    textState = message;

    emit(MainLoading());
  }
  static Future<DateTime> timeToDateTime({String? time='',String? date}) async {
    final customFormat = DateFormat("dd-MM-yyyy HH:mm");
    DateTime now=DateTime.now();
    date=date??'${now.day}-${now.month}-${now.year}';
    String originalDateString = "$date ${time}";
    DateTime originalDate = await customFormat.parse(originalDateString);
   return originalDate ;
  }
  static String? convertTo12HourFormat(String time, showPeriod) {
    // Parse the time string
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Determine the period (AM/PM)
    String period = (hour >= 12) ? 'PM' : 'AM';

    // Convert to 12-hour format
    hour = (hour > 12) ? hour - 12 : hour;
    hour = (hour == 0) ? 12 : hour;

    // Format the time in 12-hour format
    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}' +
            '${showPeriod ? period : ''}';

    return formattedTime;
  }

  Future<void> getPrayTime() async {
    updateTextState();
    DateTime date = DateTime.now();
    PrayerTimesModel? pray = await PrayerTimesStorage.getPrayerTimes();
    LocationPermission permission = await Geolocator.checkPermission();
    Position log =   Position(longitude: 31.4722447, latitude: 30.2398005, timestamp: date, accuracy: 0.0, altitude: 0.0, altitudeAccuracy: 0.0, heading: 0.0, headingAccuracy: 0.0, speed: 0.0, speedAccuracy: 0.0);

    var parser1;
    if (pray == null) {
      if (permission.name == 'denied' || permission.name == 'deniedForever') {
        print('>>>>>>>>>>>>     GET DATE FROM SERVER  WITHOUT PERMISSION');
        updateTextState(message: "لايمكن  حصول علي الموقع الجغرافي");
        await Geolocator.checkPermission();
        // parser1 = await Dio().get('https://api.aladhan.com/v1/calendar?latitude=30.2398005&longitude=31.4722447&method=3&day=${date.day}&month=${date.month}&year=${date.year}');
      } else {
         log = await Geolocator.getCurrentPosition();
      }
      parser1 = await Dio().get('https://api.aladhan.com/v1/calendar?latitude=${log.latitude}&longitude=${log.longitude}&method=3&day=${date.day}&month=${date.month}&year=${date.year}');

      pray = PrayerTimesModel.fromJson(parser1.data);
      PrayerTimesStorage.savePrayerTimes(pray);
    } else {

      print('>>>>>>>>>>>>     GET DATE FROM LOCAL ');
    }
  //PrayerTimesStorage.savePrayerTimes(pray) ;

    updateTextState(message: "تحميل بيانات الصلاة لليوم");
    prayList = pray.data!;
    int x = 0;
    timings = prayList
        .firstWhere((element) =>
            element.date!.gregorian!.date == DateFormat("d-M-y").format(DateTime.now()).toString())
        .timings!;
    timingsList = timingsListMethod(timings);
    String originalDateString = "23-12-2023 10:10";

    // Define the custom date format
    final customFormat = DateFormat("dd-MM-yyyy HH:mm");

    // Parse the original date string
    DateTime originalDate = customFormat.parse(originalDateString);

    //  zonedScheduleNotification(id: 80,title: 'TEST 123',body: "TEFKLAVJKLJFAJJDVKVJHPVVN",dateTime: originalDate.add(Duration(seconds:52 )));

    updateTextState(message: "تم تحميل البيانات");
  }
}
