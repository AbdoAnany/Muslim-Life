import 'dart:io';

import 'package:azkar/app_routes.dart';
import 'package:azkar/core/audio/app_audio.dart';
import 'package:azkar/core/theme/app_tokens.dart';
import 'package:azkar/core/widgets/dls/app_card.dart';
import 'package:azkar/core/widgets/dls/app_scaffold.dart';
import 'package:azkar/core/widgets/dls/app_snackbar.dart';
import 'package:azkar/core/widgets/home_widget_bridge.dart';
import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:azkar/models/tasbeeh/build_azkar.dart';
import 'package:azkar/models/tasbeeh/build_notifications.dart';
import 'package:azkar/models/tasbeeh/sleep_hour_class.dart';
import 'package:azkar/models/tasbeeh/zeker_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Tasbeeh AzkarScreen adapted for Muslim-Life (without nb_utils).
class DhikrAzkarScreen extends StatefulWidget {
  const DhikrAzkarScreen({super.key});

  @override
  State<DhikrAzkarScreen> createState() => _DhikrAzkarScreenState();
}

class _DhikrAzkarScreenState extends State<DhikrAzkarScreen> {
  final BuildAzkar _builder = BuildAzkar();
  List<ZekerModel> _zekerList = [];
  List<ZekerModel> _selected = [];
  int _segment = 1;
  bool _loading = true;
  bool _scheduling = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _selected = BuildAzkar.getZekerListFor(ZekerListFor.selected);
    _zekerList = await ZekerModel.getList(_segment + 1);
    setState(() => _loading = false);
  }

  Future<void> _schedule() async {
    if (_selected.isEmpty) {
      showAppSnackBar(context, 'اختر ذكراً واحداً على الأقل', isError: true);
      return;
    }
    setState(() => _scheduling = true);
    BuildAzkar.saveZekerListFor(_selected, ZekerListFor.selected);
    BuildAzkar.play();
    await BuildNotifications().build(_builder, context);
    await HomeWidgetBridge.syncNextReminderFromNotifications();
    if (!mounted) return;
    setState(() => _scheduling = false);
    AppRoutes.openAction(context, ApiModel.home(
      itemId: 'z',
      title: '',
      photo: '',
      subtype: ApiSubType.Zeker,
      appModel: AppModel.zeker,
    ));
  }

  Future<void> _pickInterval() async {
    var selectedHours = _builder.everyTime.hours;
    var selectedMinutes = _builder.everyTime.minutes;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
                  TextButton(
                    onPressed: () {
                      if (selectedHours == 0 && selectedMinutes == 0) {
                        return;
                      }
                      if (Platform.isAndroid &&
                          selectedHours == 0 &&
                          selectedMinutes < 3) {
                        showAppSnackBar(
                          context,
                          'أقل فترة على أندرويد: ٣ دقائق',
                          isError: true,
                        );
                        return;
                      }
                      _builder.everyTime.hours = selectedHours;
                      _builder.everyTime.minutes = selectedMinutes;
                      _builder.saveEveryTime();
                      Navigator.pop(ctx);
                      setState(() {});
                    },
                    child: const Text('موافق'),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedHours,
                        ),
                        itemExtent: 36,
                        onSelectedItemChanged: (v) => selectedHours = v,
                        children: List.generate(24, (i) => Text('$i')),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMinutes,
                        ),
                        itemExtent: 36,
                        onSelectedItemChanged: (v) => selectedMinutes = v,
                        children: List.generate(60, (i) => Text('$i')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggle(ZekerModel zeker, bool? value) {
    setState(() {
      zeker.selected = value ?? false;
      final idx = _selected.indexWhere((e) => e.zeker_id == zeker.zeker_id);
      if (zeker.selected && idx == -1) {
        _selected.add(zeker);
      } else if (!zeker.selected && idx != -1) {
        _selected.removeAt(idx);
      }
      BuildAzkar.saveZekerListFor(_selected, ZekerListFor.selected);
    });
  }

  Future<void> _play(ZekerModel zeker) async {
    final err = await AppAudio.playDhikr(zeker);
    if (!mounted || err == null) return;
    showAppSnackBar(context, err, isError: true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'الأذكار الصوتية',
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spaceMd),
          child: ElevatedButton(
            onPressed: _scheduling ? null : _schedule,
            child: Text(_scheduling ? 'جاري إنشاء التذكيرات...' : 'تشغيل الأذكار'),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              children: [
                AppCard(
                  child: ListTile(
                    title: const Text('تشغيل الذكر كل'),
                    subtitle: Text('${_builder.everyTime.hours}:${_builder.everyTime.minutes}'),
                    trailing: const Icon(Icons.chevron_left),
                    onTap: _pickInterval,
                  ),
                ),
                AppCard(
                  child: SwitchListTile(
                    title: const Text('إيقاف الذكر أثناء النوم'),
                    subtitle: Text(_builder.stopTimeFormate()),
                    value: _builder.sleepTime.stopAt,
                    onChanged: (v) {
                      setState(() {
                        _builder.sleepTime.stopAt = v;
                        _builder.sleepTime.save();
                      });
                    },
                  ),
                ),
                if (_builder.sleepTime.stopAt)
                  TextButton(
                    onPressed: () async {
                      await SleepHourClass.showTimeRange(context);
                      setState(() => _builder.sleepTime = SleepHourClass.get());
                    },
                    child: const Text('تعديل وقت النوم'),
                  ),
                CupertinoSegmentedControl<int>(
                  groupValue: _segment,
                  children: const {
                    0: Padding(padding: EdgeInsets.all(8), child: Text('تكرار')),
                    1: Padding(padding: EdgeInsets.all(8), child: Text('أذكار')),
                    2: Padding(padding: EdgeInsets.all(8), child: Text('دعاء')),
                    3: Padding(padding: EdgeInsets.all(8), child: Text('قرآن')),
                  },
                  onValueChanged: (v) async {
                    _segment = v;
                    setState(() => _loading = true);
                    await _load();
                  },
                ),
                const SizedBox(height: AppTokens.spaceMd),
                ..._zekerList.map((z) {
                  final selected = _selected.any((e) => e.zeker_id == z.zeker_id && e.selected);
                  return AppCard(
                    child: ListTile(
                      leading: Checkbox(value: selected, onChanged: (v) => _toggle(z, v)),
                      title: Text(z.zeker_name),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_circle, color: AppTokens.brand),
                        onPressed: () => _play(z),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
