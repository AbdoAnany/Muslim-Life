import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/core/widgets/home_widget_bridge.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'misbaha_state.dart';

class MisbahaCubit extends Cubit<MisbahaState> {
  MisbahaCubit() : super(MisbahaInitial()) {
    _load();
  }

  static MisbahaCubit get(Context) => BlocProvider.of(Context);
  int ButtonCounter = 0;
  int GroubCounter = 33;
  int targetCount = 99;
  int Counter = 0;
  int Groub = 0;

  Future<void> _load() async {
    final box = Hive.box('app');
    ButtonCounter = box.get('sibha_count', defaultValue: 0) as int;
    GroubCounter = box.get('sibha_group', defaultValue: 33) as int;
    targetCount = box.get('sibha_target', defaultValue: 99) as int;
    Groub = ButtonCounter ~/ GroubCounter;
    Counter = ButtonCounter % GroubCounter;
    emit(misbahaClicked());
  }

  Future<void> _persist() async {
    final box = Hive.box('app');
    await box.put('sibha_count', ButtonCounter);
    await box.put('sibha_group', GroubCounter);
    await box.put('sibha_target', targetCount);
    await HomeWidgetBridge.updateDhikr('السبحة', ButtonCounter);
  }

  void setTarget(int value) {
    targetCount = value.clamp(1, 9999);
    _persist();
    emit(misbahaClicked());
  }

  void Clicked() {
    try {
      AzkarCubit.onClick();
      HapticFeedback.lightImpact();

      ButtonCounter++;
      Groub = ButtonCounter ~/ GroubCounter;
      Counter++;
      if (Counter == GroubCounter) Counter = 0;
      if (ButtonCounter >= targetCount) {
        HapticFeedback.heavyImpact();
      }
      _persist();
      emit(misbahaClicked());
      //  final player = AudioCache();
      //  player.play('click.wav');
    } catch (ex) {}
    /* final player = AudioCache();
  player.play('assets/music/click.wav');
 */
  }

  void Changing() {
    try {
      ButtonCounter = 0;
      Counter = 0;
      Groub = 0;
      _persist();
      emit(misbahaClicked());
      //  final player = AudioCache();
      //  player.play('click.wav');
    } catch (ex) {}
    /* final player = AudioCache();
  player.play('assets/music/click.wav');
 */
  }

}
