import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

/// Port of Tasbeeh `dbSQLiteProvider` for Muslim-Life (`package:azkar`).
class DbSQLiteProvider {
  DbSQLiteProvider._();
  static final DbSQLiteProvider db = DbSQLiteProvider._();
  static Database? _database;
  static const String databaseName = 'databaseV1.db';

  Future<Database?> get database async {
    if (_database != null) return _database;
    try {
      _database = await _initDb();
      if (_database != null && _database!.isOpen) {
        await _updateDb(_database!);
      }
      return _database;
    } catch (_) {
      return null;
    }
  }

  Future<void> _copyDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, databaseName);
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      try {
        final data =
            await rootBundle.load(join('assets/db/', databaseName));
        final bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes);
      } catch (_) {
        // DB not bundled — JSON fallbacks used instead.
      }
    }
  }

  Future<Database?> _initDb() async {
    await _copyDb();
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, databaseName);
    if (!File(path).existsSync()) {
      return null;
    }
    return openDatabase(
      path,
      version: 6,
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          _upgrade(db);
        }
      },
    );
  }

  void _upgrade(Database db) {}

  Future<void> _updateDb(Database db) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('db_ver')) {
      await prefs.setString('db_ver', '1');
    }
  }
}
