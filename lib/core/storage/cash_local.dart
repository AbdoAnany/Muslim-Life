import 'package:shared_preferences/shared_preferences.dart';

/// Tasbeeh-style preferences wrapper (CashLocal).
class CashLocal {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveCash(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  static String getStringCash(String key) {
    return _prefs?.getString(key) ?? '';
  }

  static Future<void> saveBool(String key, bool value) async {
    await init();
    await _prefs!.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }
}
