import 'dart:convert';

import 'package:azkar/core/storage/cash_local.dart';
import 'package:flutter/material.dart';

class SleepHourClass {
  SleepHourClass();

  bool stopAt = false;
  List<int> startTime = [22, 0];
  List<int> endTime = [6, 0];

  static SleepHourClass get() {
    final jsonCls = CashLocal.getStringCash('SleepHourClass');
    if (jsonCls.isNotEmpty) {
      return SleepHourClass.fromJson(
          json.decode(jsonCls) as Map<String, dynamic>);
    }
    return SleepHourClass();
  }

  factory SleepHourClass.fromJson(Map<String, dynamic> json) {
    final s = SleepHourClass();
    s.stopAt = json['stopAt'] as bool? ?? false;
    s.startTime = (json['startTime'] as List?)?.cast<int>() ?? [22, 0];
    s.endTime = (json['endTime'] as List?)?.cast<int>() ?? [6, 0];
    return s;
  }

  Map<String, dynamic> toJson() => {
        'stopAt': stopAt,
        'startTime': startTime,
        'endTime': endTime,
      };

  void save() {
    CashLocal.saveCash('SleepHourClass', json.encode(toJson()));
  }

  static Future<void> showTimeRange(BuildContext context) async {
    final sleep = get();
    TimeOfDay? start = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: sleep.startTime[0], minute: sleep.startTime[1]),
    );
    if (start == null) return;
    if (!context.mounted) return;
    TimeOfDay? end = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: sleep.endTime[0], minute: sleep.endTime[1]),
    );
    if (end == null) return;
    sleep.startTime = [start.hour, start.minute];
    sleep.endTime = [end.hour, end.minute];
    sleep.save();
  }
}
