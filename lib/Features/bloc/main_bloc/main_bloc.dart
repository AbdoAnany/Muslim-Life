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
    "Fajr": "assets/images/mosque.png",
    "Sunrise": "assets/images/mecca.png",
    "Dhuhr": "assets/images/pray.png",
    "Asr": "assets/images/mosque.png",
    "Maghrib": "assets/images/mecca.png",
    "Isha": "assets/images/mosque.png",
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
  /// Aladhan times look like "05:10 (EEST)" — keep HH:mm only.
  static String sanitizePrayerTime(String? time) {
    if (time == null || time.isEmpty) return '00:00';
    return time.replaceAll(RegExp(r'\s*\([^)]*\)\s*'), '').trim().split(' ').first;
  }

  static DateTime timeToDateTime({String? time = '', String? date}) {
    final customFormat = DateFormat("dd-MM-yyyy HH:mm");
    final now = DateTime.now();
    date = date ?? '${now.day}-${now.month}-${now.year}';
    final clean = sanitizePrayerTime(time);
    return customFormat.parse("$date $clean");
  }
  static String? convertTo12HourFormat(String time, showPeriod) {
    final clean = sanitizePrayerTime(time);
    final parts = clean.split(':');
    if (parts.length < 2) return clean;
    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1].replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final period = (hour >= 12) ? 'PM' : 'AM';
    hour = (hour > 12) ? hour - 12 : hour;
    hour = (hour == 0) ? 12 : hour;

    final formattedTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'
        '${showPeriod ? period : ''}';
    return formattedTime;
  }

  Future<void> getPrayTime({bool forceRefresh = false}) async {
    updateTextState();
    final date = DateTime.now();
    // Cairo defaults — used when permission/network is slow or missing.
    Position log = Position(
      longitude: 31.2357,
      latitude: 30.0444,
      timestamp: date,
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    try {
      PrayerTimesModel? pray =
          forceRefresh ? null : await PrayerTimesStorage.getPrayerTimes();

      if (pray == null) {
        try {
          final permission = await Geolocator.checkPermission()
              .timeout(const Duration(seconds: 2));
          if (permission == LocationPermission.denied) {
            updateTextState(message: "طلب صلاحية الموقع");
            await Geolocator.requestPermission()
                .timeout(const Duration(seconds: 3));
          }
          final current = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 4),
          ).timeout(const Duration(seconds: 5));
          log = current;
        } catch (_) {
          // Keep Cairo defaults — never block splash on location.
          updateTextState(message: "استخدام موقع افتراضي");
        }

        final url =
            'https://api.aladhan.com/v1/calendar?latitude=${log.latitude}&longitude=${log.longitude}&method=3&day=${date.day}&month=${date.month}&year=${date.year}';
        final parser1 = await Dio().get(
          url,
          options: Options(receiveTimeout: const Duration(seconds: 8), sendTimeout: const Duration(seconds: 8)),
        ).timeout(const Duration(seconds: 10));
        pray = PrayerTimesModel.fromJson(parser1.data);
        await PrayerTimesStorage.savePrayerTimes(pray);
      }

      updateTextState(message: "تحميل بيانات الصلاة لليوم");
      prayList = pray.data ?? [];
      if (prayList.isEmpty) {
        emit(MainSuccess());
        return;
      }

      final today = DateFormat("dd-MM-y").format(DateTime.now());
      timings = prayList
          .firstWhere(
            (element) => element.date?.gregorian?.date == today,
            orElse: () => prayList.first,
          )
          .timings!;
      timingsList = timingsListMethod(timings);

      currentPray = timingsList.lastWhere(
        (element) =>
            element!.englishName!.length < 7 &&
            timeToDateTime(time: element.time).isBefore(DateTime.now()),
        orElse: () => PrayerTimeModel(
          time: '',
          arabicName: '',
          englishName: '____________________________',
        ),
      );
      nextPray = timingsList.firstWhere(
        (element) =>
            element!.englishName!.length < 7 &&
            timeToDateTime(time: element.time).isAfter(DateTime.now()),
        orElse: () => PrayerTimeModel(
          time: '',
          arabicName: '',
          englishName: '____________________________',
        ),
      );

      emit(MainSuccess());
    } catch (e) {
      // Never leave splash hanging.
      updateTextState(message: "تعذر تحميل المواقيت");
      emit(MainSuccess());
    }
  }
}

