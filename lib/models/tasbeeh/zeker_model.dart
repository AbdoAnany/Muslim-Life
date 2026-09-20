import 'dart:convert';
import 'dart:io';

import 'package:azkar/core/audio/dhikr_sound_names.dart';
import 'package:azkar/helper/db_sqlite_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class ZekerModel {
  ZekerModel();

  late String zeker_id;
  late int zeker_type_id;
  late String zeker_type;
  late String zeker_name;
  late int zeker_repeat;
  late int zeker_time;
  late int zeker_order;

  bool selected = false;
  String choose_repeat = '1';

  String? fullFileName;

  String? channelID;
  String? channelName;
  String? channelDescription;
  int? notficationId;
  String? notficationTitle;
  String? notficationBody;
  tz.TZDateTime? notficationScheduledDate;
  int? notficationScheduledMinute;

  String soundFileName() {
    if (Platform.isIOS) {
      return '${fullFileName ?? ''}.mp3';
    }
    return fullFileName ?? '';
  }

  String soundFileNamePath() {
    final base = DhikrSoundNames.rawBaseName(
      zekerId: zeker_id,
      chooseRepeat: choose_repeat,
      zekerRepeat: zeker_repeat,
    );
    if (Platform.isAndroid) {
      return DhikrSoundNames.androidResourceUri(base);
    }
    return DhikrSoundNames.iosFileName(base);
  }

  static Future<List<ZekerModel>> getList(int typeId) async {
    final db = await DbSQLiteProvider.db.database;
    if (db != null) {
      final results = await db.rawQuery(
        'SELECT * FROM zeker WHERE zeker_type_id = ?',
        [typeId],
      );
      if (results.isNotEmpty) {
        return fromList(results);
      }
    }
    return _fromSeed(typeId);
  }

  static Future<List<ZekerModel>> _fromSeed(int typeId) async {
    final raw = await rootBundle.loadString('assets/data/zeker_seed.json');
    final list = json.decode(raw) as List;
    return fromList(list.cast<Map<String, dynamic>>())
        .where((z) => z.zeker_type_id == typeId)
        .toList();
  }

  static List<ZekerModel> fromList(List<dynamic> data) {
    return data.map((e) => ZekerModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  factory ZekerModel.fromJson(Map<String, dynamic> map) {
    final cls = ZekerModel();
    cls.zeker_id = map['zeker_id']?.toString() ?? '';
    cls.zeker_type_id = map['zeker_type_id'] as int? ?? 2;
    cls.zeker_type = map['zeker_type']?.toString() ?? '';
    cls.zeker_name = map['zeker_name']?.toString() ?? '';
    cls.zeker_repeat = map['zeker_repeat'] as int? ?? 1;
    cls.zeker_time = map['zeker_time'] as int? ?? 0;
    cls.zeker_order = map['zeker_order'] as int? ?? 1000;
    cls.choose_repeat = map['choose_repeat']?.toString() ?? '1';
    cls.selected = map['selected'] as bool? ?? false;
    cls.fullFileName = map['fullFileName']?.toString() ?? '';
    cls.channelID = map['channelID']?.toString() ?? '';
    cls.channelName = map['channelName']?.toString() ?? '';
    cls.channelDescription = map['channelDescription']?.toString() ?? '';
    cls.notficationId = map['notficationId'] as int? ?? 0;
    cls.notficationTitle = map['notficationTitle']?.toString() ?? '';
    cls.notficationBody = map['notficationBody']?.toString() ?? '';
    cls.notficationScheduledMinute = map['notficationScheduledMinute'] as int? ?? 0;
    final dt = map['notficationScheduledDate']?.toString() ?? '';
    if (dt.isNotEmpty) {
      cls.notficationScheduledDate = tzDateTimeFromString(value: dt);
    }
    return cls;
  }

  Map<String, dynamic> toJson() => {
        'zeker_id': zeker_id,
        'zeker_type_id': zeker_type_id,
        'zeker_type': zeker_type,
        'zeker_name': zeker_name,
        'zeker_repeat': zeker_repeat,
        'zeker_time': zeker_time,
        'zeker_order': zeker_order,
        'choose_repeat': choose_repeat,
        'selected': selected,
        'fullFileName': fullFileName,
        'channelID': channelID,
        'channelName': channelName,
        'channelDescription': channelDescription,
        'notficationId': notficationId,
        'notficationTitle': notficationTitle,
        'notficationBody': notficationBody,
        'notficationScheduledMinute': notficationScheduledMinute,
        'notficationScheduledDate': notficationScheduledDate == null
            ? ''
            : tzDateTimeToString(dt: notficationScheduledDate!),
      };

  String toStringJson() => json.encode(toJson());

  static Map<String, dynamic> toMapString(String str) =>
      json.decode(str) as Map<String, dynamic>;

  String scheduledDate() {
    return tzDateTimeToString(
      dt: notficationScheduledDate!,
      currentFormat: 'hh:mm a',
    );
  }

  static String tzDateTimeToString({
    required tz.TZDateTime dt,
    String currentFormat = 'yyyy-MM-dd HH:mm:ss',
  }) {
    return DateFormat(currentFormat).format(dt);
  }

  static tz.TZDateTime? tzDateTimeFromString({
    required String value,
    String currentFormat = 'yyyy-MM-dd HH:mm:ss',
    bool isUtc = true,
  }) {
    if (value.isEmpty) return null;
    try {
      final dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      return tz.TZDateTime.from(dateTime, tz.local);
    } catch (_) {
      return null;
    }
  }
}
