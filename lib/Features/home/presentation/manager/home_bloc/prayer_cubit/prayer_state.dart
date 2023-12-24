part of 'prayer_cubit.dart';

@immutable
abstract class PrayerState {}

class PrayerInitial extends PrayerState {}

class PrayerLoading extends PrayerState {}

class PrayerSuccess extends PrayerState {}

class PrayerFailure extends PrayerState {
  late final String error;
  PrayerFailure(this.error);
}
