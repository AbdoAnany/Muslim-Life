import 'dart:convert';

import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/model/prayer_times_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Features/scd.dart';
import 'main.dart';

class PrayerTimesStorage {
  static const String key = 'prayer_times_key';
  static String today = DateFormat('M/y').format(DateTime.now());

  static Future<void> savePrayerTimes(PrayerTimesModel prayerTimes) async {
    final prefs = await SharedPreferences.getInstance();
    int x = 0;
    prayerTimes.data!.forEach((element) {
      List<PrayerTimeModel?> timingsElement = MainBloc.timingsListMethod(element.timings);
      String? date = element.date!.gregorian!.date;
      timingsElement.forEach((element) async {
        DateTime originalDate = await MainBloc.timeToDateTime(time: element?.time, date: date);
        if (originalDate.isAfter(DateTime.now())&&originalDate.isBefore(DateTime.now().add(Duration(days: 1)))) {

          await zonedScheduleNotification(
              id:originalDate.day+originalDate.month*10+x++,
              title: '${element?.arabicName!}',
              body: element!.englishName!.length > 7
                  ? "حان الان  ${element.arabicName!}"
                  : "حان الان موعد أذان ${element.arabicName!}",
              dateTime: originalDate);


          // await zonedScheduleNotification(
          //     id: x++,
          //     title: '${element?.arabicName!}',
          //     body: element!.englishName!.length > 7
          //         ? "أقترب  ${element.arabicName!}"
          //         : "أقترب موعد أذان ${element.arabicName!}",
          //     dateTime: originalDate.subtract(Duration(minutes: 5)));


        }
      });
    });

    final jsonString = json.encode(prayerTimes.toJson());
    await prefs.setString(key, jsonString);
  }

  static Future<PrayerTimesModel?> getPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();

    String jsonString = prefs.getString(key) ?? '';

    lastSync = await prefs.getString('lastSync') ?? '';
    if (lastSync.isEmpty) {
      lastSync = DateFormat('MM/y').format(DateTime.now());
      prefs.setString('lastSync', lastSync);
    } else {
      final customFormat = DateFormat('MM/y');

      if (!isSameMonth(customFormat.parse(lastSync))) {
        prefs.setString(key, '');
        jsonString = '';
      }
    }
    if (jsonString.isNotEmpty) {
      final map = json.decode(jsonString);

      // print(map.toString());
      return PrayerTimesModel.fromLocalJson(map);
    }
    return null;
  }

  static String lastSync = '';

  static bool isSameMonth(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}
