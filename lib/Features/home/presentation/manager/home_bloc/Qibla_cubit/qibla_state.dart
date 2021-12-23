part of 'qibla_cubit.dart';

@immutable
abstract class QiblaState {}

class QiblaInitial extends QiblaState {}



class GetGeoLocatorPermission extends QiblaState {}

class DeniedGeoLocatorPermission extends QiblaState {
  final String error;

  DeniedGeoLocatorPermission(this.error);
}

class DeniedForeverGeoLocatorPermission extends QiblaState {
  final String error;

  DeniedForeverGeoLocatorPermission(this.error);
}

class SucessLocatorPermission extends QiblaState {}
