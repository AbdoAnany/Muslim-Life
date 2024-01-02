import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/model/prayer_times_model.dart';
import 'package:azkar/StorePray.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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
 static PrayerTimeModel? currentPray;
  static PrayerTimeModel? nextPray;

  static List<PrayerTimeModel?> timingsListMethod(timings) => [
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
  static DateTime timeToDateTime({String? time='',String? date})  {
    final customFormat = DateFormat("dd-MM-yyyy HH:mm");
    DateTime now=DateTime.now();
    date=date??'${now.day}-${now.month}-${now.year}';
    String originalDateString = "$date ${time}";
    DateTime originalDate =  customFormat.parse(originalDateString);
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
    LocationPermission locationPermission = await Geolocator.checkPermission();
    Permission permission =Permission.accessNotificationPolicy;
    print('permission value '+(await permission.status).name);

    Position log =   Position(longitude: 31.4722447, latitude: 30.2398005, timestamp: date, accuracy: 0.0, altitude: 0.0, altitudeAccuracy: 0.0, heading: 0.0, headingAccuracy: 0.0, speed: 0.0, speedAccuracy: 0.0);
// print(pray?.toJson());
//     print(locationPermission.name);
    var parser1;
    if (pray == null) {
      if (locationPermission.name == 'denied' || locationPermission.name == 'deniedForever') {
        print('>>>>>>>>>>>>     GET DATE FROM SERVER  WITHOUT PERMISSION');
        updateTextState(message: "لايمكن  حصول علي الموقع الجغرافي");
        await Geolocator.requestPermission();
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
  //   print('https://api.aladhan.com/v1/calendar?latitude=${log.latitude}&longitude=${log.longitude}&method=3&day=${date.day}&month=${date.month}&year=${date.year}');

    updateTextState(message: "تحميل بيانات الصلاة لليوم");
    prayList = pray.data!;
    print(prayList[1].toJson());
    print(DateFormat("dd-MM-y").format(DateTime.now()));
    timings = prayList.firstWhere((element) => element.date!.gregorian!.date == DateFormat("dd-MM-y").format(DateTime.now()).toString()).timings!;
    timingsList = timingsListMethod(timings);
print(timingsList.length);

    currentPray =timingsList.lastWhere((element)  =>element!.englishName!.length<7 && (  timeToDateTime(time: element!.time)).isBefore(DateTime.now()),orElse:()=> PrayerTimeModel(time: '',arabicName: '',englishName: '____________________________'));
    nextPray =timingsList.firstWhere((element)  =>element!.englishName!.length<7 && (  timeToDateTime(time: element!.time)).isAfter(DateTime.now()),orElse:()=> PrayerTimeModel(time: '',arabicName: '',englishName: '____________________________'));

    updateTextState(message: "تم تحميل البيانات");
  }
}
