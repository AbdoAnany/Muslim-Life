import 'dart:convert';

import 'package:azkar/helper/db_sqlite_provider.dart';
import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:flutter/services.dart';

/// Loads Tasbeeh catalog rows from SQLite when bundled, else JSON portable data.
class TasbeehContentRepository {
  static const _tableByModel = {
    AppModel.hades: 'hades',
    AppModel.doaaInQuran: 'doaa_in_quran',
    AppModel.firstInIslam: 'first_in_islam',
    AppModel.azkarElyome: 'azkar_elyome',
    AppModel.islamEvents: 'islam_events',
  };

  static const _jsonKeyByModel = {
    AppModel.hades: 'hades',
    AppModel.doaaInQuran: 'doaaInQuran',
    AppModel.firstInIslam: 'firstInIslam',
    AppModel.azkarElyome: 'azkarElyome',
    AppModel.islamEvents: 'islamEvents',
  };

  Future<List<ApiModel>> load(AppModel model) async {
    final db = await DbSQLiteProvider.db.database;
    final table = _tableByModel[model];
    if (db != null && table != null) {
      try {
        final rows = await db.query(table, orderBy: 'itemId ASC');
        if (rows.isNotEmpty) {
          return rows
              .map((r) => ApiModel.fromPortableJson(Map<String, dynamic>.from(r)))
              .toList();
        }
      } catch (_) {
        // Fall through to JSON.
      }
    }
    return _fromJson(model);
  }

  Future<List<ApiModel>> _fromJson(AppModel model) async {
    final raw = await rootBundle.loadString('assets/data/tasbeeh_portable.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    final key = _jsonKeyByModel[model];
    if (key == null) return [];
    final list = map[key] as List? ?? [];
    return list
        .map((e) => ApiModel.fromPortableJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
