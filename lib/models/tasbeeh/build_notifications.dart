import 'dart:developer';

import 'package:azkar/core/notifications/app_notification_service.dart';
import 'package:azkar/models/tasbeeh/build_azkar.dart';
import 'package:azkar/models/tasbeeh/sleep_hour_class.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:azkar/models/tasbeeh/zeker_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

const String kDhikrDateFormat = 'MMM dd, yyyy';

class BuildNotifications {
  late List<ZekerModel> zekerList;
  int fileCursor = 0;

  Future<void> stop() async {
    await AppNotificationService.instance.cancelAll();
  }

  Future<void> build(BuildAzkar bz, BuildContext context) async {
    await AppNotificationService.instance.cancelAll();
    zekerList = BuildAzkar.getZekerListFor(ZekerListFor.selected);
    BuildAzkar.saveZekerListFor(zekerList, ZekerListFor.createdChanel);
    await _buildList(bz);
  }

  tz.TZDateTime _baseDate() {
    final currentDate = DateFormat(kDhikrDateFormat).format(DateTime.now());
    final tempDate = DateFormat(kDhikrDateFormat).parse(currentDate);
    return tz.TZDateTime.from(tempDate, tz.local);
  }

  List<ZekerTime> _listZekerTime(BuildAzkar bz) {
    final zTimeList = <ZekerTime>[];
    var fn = 1;
    var stop = false;
    final totalMinutes = bz.everyTime.hours * 60 + bz.everyTime.minutes;
    do {
      final x = ZekerTime();
      final newTotalMinutes = totalMinutes * fn;
      final h = newTotalMinutes ~/ 60;
      final m = newTotalMinutes % 60;
      x.hours = h;
      x.minutes = m;
      fn++;
      if (x.hours >= 24) {
        x.hours = 0;
        zTimeList.add(x);
        stop = true;
      } else if (!stop) {
        zTimeList.add(x);
      }
    } while (!stop);
    return zTimeList;
  }

  ZekerModel _nextZeker(int count) {
    final temp = zekerList[fileCursor];
    fileCursor = (fileCursor + 1) % count;
    final zekerId = temp.zeker_id;
    if (temp.choose_repeat.isNotEmpty && temp.zeker_repeat != 1) {
      var chooseRepeat = int.parse(temp.choose_repeat);
      if (temp.zeker_repeat < chooseRepeat) {
        chooseRepeat = temp.zeker_repeat;
      }
      temp.fullFileName = 'a${zekerId}_$chooseRepeat';
    } else {
      temp.fullFileName = 'a$zekerId';
    }
    return temp;
  }

  Future<void> _buildList(BuildAzkar bz) async {
    fileCursor = 0;
    final count = zekerList.length;
    if (count == 0) return;

    final zTimeList = _listZekerTime(bz);
    final sleepHours = SleepHourClass.get();

    for (final zekerTime in zTimeList) {
      if (_excludeTime(zekerTime, sleepHours, bz)) continue;
      final zekerModel = _nextZeker(count);
      zekerModel.channelID = zekerModel.soundFileName();
      zekerModel.channelName = zekerModel.zeker_name;
      zekerModel.notficationId = zekerTime.timeID();
      zekerModel.notficationTitle = zekerModel.zeker_name;
      zekerModel.notficationScheduledDate = zekerTime.scheduledDate();

      await AppNotificationService.instance.scheduleDhikr(
        id: zekerModel.notficationId!,
        channelId: zekerModel.channelID!,
        channelName: zekerModel.channelName!,
        title: zekerModel.notficationTitle!,
        body: zekerModel.notficationBody ?? zekerModel.zeker_name,
        scheduledDate: zekerModel.notficationScheduledDate!,
        androidRawSound: zekerModel.fullFileName,
        payload: zekerModel.toStringJson(),
      );
      log('Scheduled dhikr ${zekerModel.soundFileName()}');
    }
  }

  bool _excludeTime(
    ZekerTime zekerTime,
    SleepHourClass sleepHours,
    BuildAzkar bz,
  ) {
    if (!bz.sleepTime.stopAt) return false;
    final zekerMinutes = zekerTime.hours * 60 + zekerTime.minutes;
    final start = sleepHours.startTime[0] * 60 + sleepHours.startTime[1];
    final end = sleepHours.endTime[0] * 60 + sleepHours.endTime[1];
    if (start > end) {
      return (zekerMinutes >= start && zekerMinutes <= 1440) ||
          (zekerMinutes >= 0 && zekerMinutes <= end);
    }
    return zekerMinutes >= start && zekerMinutes <= end;
  }
}
