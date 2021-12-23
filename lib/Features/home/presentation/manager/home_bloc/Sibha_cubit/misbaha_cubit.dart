import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

part 'misbaha_state.dart';

class MisbahaCubit extends Cubit<MisbahaState> {
  MisbahaCubit() : super(MisbahaInitial());




  static MisbahaCubit get(Context) => BlocProvider.of(Context);
  int ButtonCounter = 0;
  int GroubCounter = 33;
  int Counter = 0;
  int Groub = 0;
  AudioPlayer? player;
  void Clicked() {
    try {
      player = AudioPlayer();
      player!.setAsset('assets/music/click.wav');

      player!.play();
      ButtonCounter++;
      Groub = ButtonCounter ~/ GroubCounter;
      Counter++;
      print(GroubCounter);
      if (Counter == GroubCounter) Counter = 0;
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
      emit(misbahaClicked());
      //  final player = AudioCache();
      //  player.play('click.wav');
    } catch (ex) {}
    /* final player = AudioCache();
  player.play('assets/music/click.wav');
 */
  }

}
