// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'prayer_times_model.dart';
//
// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************
//
// PrayerTimesModel _$PrayerTimesModelFromJson(Map<String, dynamic> json) =>
//     PrayerTimesModel(
//       code: json['code'] as int,
//       status: json['status'] as String,
//       data: (json['data'] as List<dynamic>)
//           .map((e) => PrayerData.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//
// Map<String, dynamic> _$PrayerTimesModelToJson(PrayerTimesModel instance) =>
//     <String, dynamic>{
//       'code': instance.code,
//       'status': instance.status,
//       'data': instance.data,
//     };
//
// PrayerData _$PrayerDataFromJson(Map<String, dynamic> json) {
//
//       print("ssssss  json['meta']");
//       print(json['meta']);
//       print(Meta.fromJson(json['meta']).toJson());
//       print("ssssss  json['date']");
//       print(json['date']);
//       print(Date.fromJson(json['date']).toJson());
//   return PrayerData(
//       timings: Timings.fromJson(json['timings'] as Map<String, dynamic>),
//       date: Date.fromJson(json['date'] as Map<String, dynamic>),
//       meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
//     );
// }
//
// Map<String, dynamic> _$PrayerDataToJson(PrayerData instance) =>
//     <String, dynamic>{
//       'timings': instance.timings,
//       'date': instance.date,
//       'meta': instance.meta,
//     };
//
// Timings _$TimingsFromJson(Map<String, dynamic> json) => Timings(
//       fajr: json['Fajr'] as String,
//       sunrise: json['Sunrise'] as String,
//       dhuhr: json['Dhuhr'] as String,
//       asr: json['Asr'] as String,
//       sunset: json['Sunset'] as String,
//       maghrib: json['Maghrib'] as String,
//       isha: json['Isha'] as String,
//       imsak: json['Imsak'] as String,
//       midnight: json['Midnight'] as String,
//       firstthird: json['Firstthird'] as String,
//       lastthird: json['Lastthird'] as String,
//     );
//
// Map<String, dynamic> _$TimingsToJson(Timings instance) => <String, dynamic>{
//       'Fajr': instance.fajr,
//       'Sunrise': instance.sunrise,
//       'Dhuhr': instance.dhuhr,
//       'Asr': instance.asr,
//       'Sunset': instance.sunset,
//       'Maghrib': instance.maghrib,
//       'Isha': instance.isha,
//       'Imsak': instance.imsak,
//       'Midnight': instance.midnight,
//       'Firstthird': instance.firstthird,
//       'Lastthird': instance.lastthird,
//     };
//
// Date _$DateFromJson(Map<String, dynamic> json) => Date(
//       readable: json['readable'] as String,
//       timestamp: json['timestamp'] as String,
//    gregorian:Gregorian() ,
//    //   gregorian: Gregorian.fromJson(json['gregorian'] as Map<String, dynamic>),
//       hijri: Hijri.fromJson(json['hijri'] as Map<String, dynamic>),
//     );
//
// Map<String, dynamic> _$DateToJson(Date instance) => <String, dynamic>{
//       'readable': instance.readable,
//       'timestamp': instance.timestamp,
//       'gregorian': instance.gregorian,
//       'hijri': instance.hijri,
//     };
//
// Gregorian _$GregorianFromJson(Map<String, dynamic> json) => Gregorian(
//       date: json['date'] as String,
//       format: json['format'] as String,
//       day: json['day'] as String,
//       weekday: Weekday.fromJson(json['weekday'] as Map<String, dynamic>),
//       month: Month.fromJson(json['month'] as Map<String, dynamic>),
//       year: json['year'] as String,
//       designation:
//           Designation.fromJson(json['designation'] as Map<String, dynamic>),
//     );
//
// Map<String, dynamic> _$GregorianToJson(Gregorian instance) => <String, dynamic>{
//       'date': instance.date,
//       'format': instance.format,
//       'day': instance.day,
//       'weekday': instance.weekday,
//       'month': instance.month,
//       'year': instance.year,
//       'designation': instance.designation,
//     };
//
// Hijri _$HijriFromJson(Map<String, dynamic> json) => Hijri(
//       date: json['date'] as String,
//       format: json['format'] as String,
//       day: json['day'] as String,
//       weekday: Weekday.fromJson(json['weekday'] as Map<String, dynamic>),
//       month: Month.fromJson(json['month'] as Map<String, dynamic>),
//       year: json['year'] as String,
//       designation:
//           Designation.fromJson(json['designation'] as Map<String, dynamic>),
//       holidays: json['holidays'] as List<dynamic>,
//     );
//
// Map<String, dynamic> _$HijriToJson(Hijri instance) => <String, dynamic>{
//       'date': instance.date,
//       'format': instance.format,
//       'day': instance.day,
//       'weekday': instance.weekday,
//       'month': instance.month,
//       'year': instance.year,
//       'designation': instance.designation,
//       'holidays': instance.holidays,
//     };
//
// Weekday _$WeekdayFromJson(Map<String, dynamic> json) => Weekday(
//       en: json['en'] as String,
//       ar: json['ar'] as String?,
//     );
//
// Map<String, dynamic> _$WeekdayToJson(Weekday instance) => <String, dynamic>{
//       'en': instance.en,
//       'ar': instance.ar,
//     };
//
// Month _$MonthFromJson(Map<String, dynamic> json) => Month(
//       number: json['number'] as int,
//       en: json['en'] as String,
//       ar: json['ar'] as String,
//     );
//
// Map<String, dynamic> _$MonthToJson(Month instance) => <String, dynamic>{
//       'number': instance.number,
//       'en': instance.en,
//       'ar': instance.ar,
//     };
//
// Designation _$DesignationFromJson(Map<String, dynamic> json) => Designation(
//       abbreviated: json['abbreviated'] as String,
//       expanded: json['expanded'] as String,
//     );
//
// Map<String, dynamic> _$DesignationToJson(Designation instance) =>
//     <String, dynamic>{
//       'abbreviated': instance.abbreviated,
//       'expanded': instance.expanded,
//     };
// // {latitude: 30.2665121, longitude: 31.4660208,
// // timezone: Africa/Cairo, method: {id: 3,
// // name: Muslim World League, params: {Fajr: 18, Isha: 17},
// // location: {latitude: 51.5194682, longitude: -0.1360365}},
// // latitudeAdjustmentMethod: ANGLE_BASED, midnightMode: STANDARD, school: STANDARD, offset:
// // {Imsak: 0, Fajr: 0, Sunrise: 0, Dhuhr: 0, Asr: 0, Maghrib: 0, Sunset: 0, Isha: 0, Midnight: 0}}
// Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
//       latitude: (json['latitude'] as num).toDouble(),
//       longitude: (json['longitude'] as num).toDouble(),
//       timezone: json['timezone'] as String,
//       method: Method.fromJson(json['method'] as Map<String, dynamic>),
//       latitudeAdjustmentMethod: json['latitudeAdjustmentMethod'] as String,
//       midnightMode: json['midnightMode'] as String,
//       school: json['school'] as String,
//       offset: Offset.fromJson(json['offset'] as Map<String, dynamic>),
//     );
//
// Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
//       'latitude': instance.latitude,
//       'longitude': instance.longitude,
//       'timezone': instance.timezone,
//       'method': instance.method,
//       'latitudeAdjustmentMethod': instance.latitudeAdjustmentMethod,
//       'midnightMode': instance.midnightMode,
//       'school': instance.school,
//       'offset': instance.offset,
//     };
//
// Method _$MethodFromJson(Map<String, dynamic> json) => Method(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       params: Params.fromJson(json['params'] as Map<String, dynamic>),
//       location: Location.fromJson(json['location'] as Map<String, dynamic>),
//     );
//
// Map<String, dynamic> _$MethodToJson(Method instance) => <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'params': instance.params,
//       'location': instance.location,
//     };
//
// Params _$ParamsFromJson(Map<String, dynamic> json) => Params(
//       fajr: json['Fajr'] as int,
//       isha: json['Isha'] as int,
//     );
//
// Map<String, dynamic> _$ParamsToJson(Params instance) => <String, dynamic>{
//       'Fajr': instance.fajr,
//       'Isha': instance.isha,
//     };
//
// Location _$LocationFromJson(Map<String, dynamic> json) => Location(
//       latitude: (json['latitude'] as num).toDouble(),
//       longitude: (json['longitude'] as num).toDouble(),
//     );
//
// Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
//       'latitude': instance.latitude,
//       'longitude': instance.longitude,
//     };
// //{Imsak: 0, Fajr: 0, Sunrise: 0, Dhuhr: 0, Asr: 0, Maghrib: 0, Sunset: 0, Isha: 0, Midnight: 0}}
// Offset _$OffsetFromJson(Map<String, dynamic> json) => Offset(
//       fajr: json['Fajr']??0,
//       sunrise: json['Sunrise'] ??0,
//       dhuhr: json['Dhuhr'] ??0,
//       asr: json['Asr'] ??0,
//       sunset: json['Sunset']??0,
//       maghrib: json['Maghrib'] ??0,
//       isha: json['Isha'] ??0,
//       imsak: json['Imsak'] ??0,
//       midnight: json['Midnight']??0,
//
//     );
//
// Map<String, dynamic> _$OffsetToJson(Offset instance) => <String, dynamic>{
//       'Fajr': instance.fajr,
//       'Sunrise': instance.sunrise,
//       'Dhuhr': instance.dhuhr,
//       'Asr': instance.asr,
//       'Sunset': instance.sunset,
//       'Maghrib': instance.maghrib,
//       'Isha': instance.isha,
//       'Imsak': instance.imsak,
//       'Midnight': instance.midnight,
//
//     };
