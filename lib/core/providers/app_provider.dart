import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

final themeMap = {
  "dark": ThemeMode.dark,
  "light": ThemeMode.light,
};

class AppProvider extends Cubit<MainState> {
  AppProvider() : super(MainInitState());
  static AppProvider get(context) => BlocProvider.of(context);

  final _cache = Hive.box('app');

  int _first = 0;
  double fontSize = .04;
  int get checkVisit => _first;

  bool init() {
    int? visit = _cache.get('visit');
    if (visit == null || visit == 0) {
      _cache.put('visit', 1);
      return true;
    }
    return false;
  }

  void visited() {
    _first = 1;

    emit(MainInitState());
  }

  ThemeMode? _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode!;

  bool get isDark => _themeMode == ThemeMode.dark;

  void initTheme() {
    String? stringTheme = _cache.get('theme');

    ThemeMode? theme =
        stringTheme == null ? ThemeMode.light : themeMap[stringTheme];

    if (theme == null) {
      _cache.put(
        'theme',
        ThemeMode.light.toString().split(".").last,
      );
      _themeMode = ThemeMode.light;
    }
    _themeMode = theme;

    emit(MainInitState());
  }

  void setTheme(ThemeMode newTheme) {
    if (_themeMode == newTheme) {
      return;
    }
    _themeMode = newTheme;

    _cache.put(
      'theme',
      newTheme.toString().split('.').last,
    );
    emit(MainInitState());
  }
}
