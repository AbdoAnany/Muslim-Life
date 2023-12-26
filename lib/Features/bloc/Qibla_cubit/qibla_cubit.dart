import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit() : super(QiblaInitial());

  String? statetext;

  StreamController<LocationStatus>? locationStreamController;

  static QiblaCubit get(context) => BlocProvider.of(context);

  startcombass() {
    try {
      locationStreamController = StreamController<LocationStatus>.broadcast();
      locationStreamController!.stream;
    } catch (ex) {}
  }

  Future<void> checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      locationStreamController!.sink.add(s);
      emit(GetGeoLocatorPermission());
    } else
      locationStreamController!.sink.add(locationStatus);
    emit(SucessLocatorPermission());
  }

  void dispose() {
    locationStreamController!.close();
    FlutterQiblah().dispose();
  }

}
