import 'dart:convert';

import 'package:azkar/core/storage/cash_local.dart';
import 'package:azkar/models/tasbeeh/sleep_hour_class.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:azkar/models/tasbeeh/zeker_time.dart';

enum ZekerListFor { selected, createdChanel }

class BuildAzkar {
  late ZekerTime everyTime;
  late SleepHourClass sleepTime;

  BuildAzkar() {
    everyTime = getEveryTime();
    sleepTime = SleepHourClass.get();
  }

  String stopTimeFormate() {
    if (!sleepTime.stopAt) return '';
    final timeStart = _timeFormat(sleepTime.startTime[0], sleepTime.startTime[1]);
    final timeEnd = _timeFormat(sleepTime.endTime[0], sleepTime.endTime[1]);
    return 'من $timeStart الى $timeEnd';
  }

  String _timeFormat(int hour, int minutes) {
    var am = 'ص';
    var newHour = hour;
    if (hour > 12) {
      am = 'م';
      newHour -= 12;
    }
    return '$newHour:$minutes $am';
  }

  static void play() => CashLocal.saveCash('ZekerPlay', 'true');

  static void stop() => CashLocal.saveCash('ZekerPlay', 'false');

  static bool isPlay() => CashLocal.getStringCash('ZekerPlay') == 'true';

  void saveEveryTime() {
    CashLocal.saveCash('ZekerTime', jsonEncode(everyTime.toJson()));
  }

  static ZekerTime getEveryTime() {
    final jsonCls = CashLocal.getStringCash('ZekerTime');
    if (jsonCls.isNotEmpty) {
      return ZekerTime.fromJson(json.decode(jsonCls) as Map<String, dynamic>);
    }
    return ZekerTime();
  }

  static void saveZekerListFor(List<ZekerModel> lst, ZekerListFor key) {
    CashLocal.saveCash(key.toString(), jsonEncode(lst.map((e) => e.toJson()).toList()));
  }

  static List<ZekerModel> getZekerListFor(ZekerListFor key) {
    final jsonCls = CashLocal.getStringCash(key.toString());
    if (jsonCls.isNotEmpty) {
      final lst = json.decode(jsonCls) as List;
      return ZekerModel.fromList(lst);
    }
    return [];
  }
}
