import 'dart:io';

import 'package:home_widget/home_widget.dart';

/// Android home-screen dhikr widget bridge (iOS follow-up documented in PR).
class HomeWidgetBridge {
  static const _androidName = 'DhikrWidgetProvider';
  static const _dhikrKey = 'dhikr_text';
  static const _countKey = 'dhikr_count';

  static Future<void> init() async {
    if (!Platform.isAndroid) return;
    await HomeWidget.setAppGroupId('group.com.anany.azkar');
    await HomeWidget.registerInteractivityCallback(_backgroundCallback);
  }

  static Future<void> updateDhikr(String text, int count) async {
    await HomeWidget.saveWidgetData<String>(_dhikrKey, text);
    await HomeWidget.saveWidgetData<int>(_countKey, count);
    if (Platform.isAndroid) {
      await HomeWidget.updateWidget(
        qualifiedAndroidName: 'com.anany.azkar.$_androidName',
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundCallback(Uri? uri) async {
    if (uri?.host == 'increment') {
      final count = await HomeWidget.getWidgetData<int>(_countKey, defaultValue: 0) ?? 0;
      await HomeWidget.saveWidgetData<int>(_countKey, count + 1);
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          qualifiedAndroidName: 'com.anany.azkar.$_androidName',
        );
      }
    }
  }
}
