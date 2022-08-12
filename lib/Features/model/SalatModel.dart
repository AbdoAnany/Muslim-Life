import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

class SalatModel {
  int? code;
  String? status;
  List<Data> data = [];

  SalatModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  Timings? timings;
  Date? date;
  Meta? meta;

  Data.fromJson(Map<String, dynamic> json) {
    timings =
        json['timings'] != null ? new Timings.fromJson(json['timings']) : null;
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
}

// class Timings {
//   String? fajr;
//   String? sunrise;
//   String? dhuhr;
//   String? asr;
//   String? sunset;
//   String? maghrib;
//   String? isha;
//   String? imsak;
//   String? midnight;
//   List<String> image = [];
//   List<String> pray = [];
//   Timings.fromJson(Map<String, dynamic> json) {
//
//     print(json);
//     fajr = (int.parse((json['Fajr'].toString().split(' ')[0].split(':')[0])))
//         .toString();
//     sunrise =
//         (int.parse((json['Sunrise'].toString().split(' ')[0].split(':')[0])))
//             .toString();
//     dhuhr =
//         (int.parse((json['Dhuhr'].toString().split(' ')[0].split(':')[0])) % 12)
//             .toString();
//     asr = (int.parse((json['Asr'].toString().split(' ')[0].split(':')[0])) % 12)
//         .toString();
//     sunset = json['Sunset'];
//     maghrib =
//         (int.parse((json['Maghrib'].toString().split(' ')[0].split(':')[0])) %
//                 12)
//             .toString();
//     isha =
//         (int.parse((json['Isha'].toString().split(' ')[0].split(':')[0])) % 12)
//             .toString();
//     imsak = json['Imsak'];
//     midnight = json['Midnight'];
//     pray = [
//       NumberFormat('00')
//               .format(int.parse(
//                   (json['Fajr'].toString().split(' ')[0].split(':')[0])))
//               .toString() +
//           ":" +
//           (int.parse((json['Fajr'].toString().split(' ')[0].split(':')[1])))
//               .toString(),
//       NumberFormat('00')
//               .format(int.parse(
//                   (json['Sunrise'].toString().split(' ')[0].split(':')[0])))
//               .toString() +
//           ":" +
//           (int.parse((json['Sunrise'].toString().split(' ')[0].split(':')[1])))
//               .toString(),
//       NumberFormat('00')
//               .format(int.parse(
//                       (json['Dhuhr'].toString().split(' ')[0].split(':')[0])) %
//                   12)
//               .toString() +
//           ":" +
//           (int.parse((json['Dhuhr'].toString().split(' ')[0].split(':')[1]))
//                   )
//               .toString(),
//       NumberFormat('00')
//               .format(int.parse(
//                       (json['Asr'].toString().split(' ')[0].split(':')[0])) %
//                   12)
//               .toString() +
//           ":" +
//           (int.parse((json['Asr'].toString().split(' ')[0].split(':')[1])) )
//               .toString(),
//       NumberFormat('00')
//               .format(int.parse((json['Maghrib']
//                       .toString()
//                       .split(' ')[0]
//                       .split(':')[0])) %
//                   12)
//               .toString() +
//           ":" +
//           NumberFormat('00')
//               .format(int.parse(
//                   (json['Maghrib'].toString().split(' ')[0].split(':')[1])))
//               .toString(),
//       NumberFormat('00')
//               .format(int.parse(
//                       (json['Isha'].toString().split(' ')[0].split(':')[0])) %
//                   12)
//               .toString() +
//           ":" +
//           NumberFormat('00')
//               .format(int.parse(
//                   (json['Isha'].toString().split(' ')[0].split(':')[1])))
//               .toString()
//     ];
//     image = [
//       'assets/images/FR.jpg',
//       'assets/images/SR.jpg',
//       'assets/images/ZH.jpg',
//       'assets/images/AS.jpg',
//       'assets/images/MA.jpg',
//       'assets/images/AS.jpg',
//     ];
//   }
// }

class Timings {
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? sunset;
  String? maghrib;
  String? isha;
  String? imsak;
  String? midnight;
  List<String> pray=[];
  List<String> image=[];

  Timings.fromJson(Map<String, dynamic> json) {
    print('4444444444');
    fajr = _formatTime(json['Fajr']);    print('fajr');
    sunrise = _formatTime(json['Sunrise']);  print('Sunrise');
    dhuhr = _formatTime(json['Dhuhr'], is12HourFormat: true); print('Dhuhr');
    asr = _formatTime(json['Asr'], is12HourFormat: true);
    sunset = json['Sunset'];
    maghrib = _formatTime(json['Maghrib'], is12HourFormat: true);
    isha = _formatTime(json['Isha'], is12HourFormat: true);
    imsak =json['Imsak'];
    midnight = json['Midnight'];
    pray = [
      _formatTime(json['Fajr']),
      _formatTime(json['Sunrise']),
      _formatTime(json['Dhuhr'], is12HourFormat: true),
      _formatTime(json['Asr'], is12HourFormat: true),
      _formatTime(json['Maghrib'], is12HourFormat: true),
      _formatTime(json['Isha'], is12HourFormat: true),
    ];
    image = [
      'assets/images/FR.jpg',
      'assets/images/SR.jpg',
      'assets/images/ZH.jpg',
      'assets/images/AS.jpg',
      'assets/images/MA.jpg',
      'assets/images/AS.jpg',
    ];
  }

  String _formatTime(String timeString, {bool is12HourFormat = false}) {
    final time = DateTime.tryParse('2023-08-06'+" " + timeString.split(' ')[0]);
    print(time.toString());
    print(timeString);
    final formatter = DateFormat(is12HourFormat ? 'hh:mm' : 'HH:mm');
    return formatter.format(time!);
  }
}

class Date {
  String? readable;
  String? timestamp;
  Gregorian? gregorian;
  Hijri? hijri;

  Date.fromJson(Map<String, dynamic> json) {
    readable = json['readable'];
    timestamp = json['timestamp'];
    gregorian = json['gregorian'] != null
        ? new Gregorian.fromJson(json['gregorian'])
        : null;
    hijri = json['hijri'] != null ? new Hijri.fromJson(json['hijri']) : null;
  }
}

class Gregorian {
  String? date;
  String? format;
  String? day;

  Month? month;
  String? year;
  Designation? designation;

  Gregorian.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];

    month = json['month'] != null ? new Month.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null
        ? new Designation.fromJson(json['designation'])
        : null;
  }
}

class Month {
  int? number;
  String? en;

  Month.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
  }
}

class Designation {
  String? abbreviated;
  String? expanded;

  Designation({this.abbreviated, this.expanded});

  Designation.fromJson(Map<String, dynamic> json) {
    abbreviated = json['abbreviated'];
    expanded = json['expanded'];
  }
}

class Hijri {
  String? date = '';
  String? format;
  String? day;

  Month? month;
  String? year;
  Designation? designation;
  List<Null>? holidays = [];

  Hijri.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];

    month = json['month'] != null ? new Month.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null
        ? new Designation.fromJson(json['designation'])
        : null;
  }
}

class Meta {
  double? latitude;
  double? longitude;
  String? timezone;
  Method? method;
  String? latitudeAdjustmentMethod;
  String? midnightMode;
  String? school;
  Offset? offset;

  Meta.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    timezone = json['timezone'];
    method =
        json['method'] != null ? new Method.fromJson(json['method']) : null;
    latitudeAdjustmentMethod = json['latitudeAdjustmentMethod'];
    midnightMode = json['midnightMode'];
    school = json['school'];
    offset =
        json['offset'] != null ? new Offset.fromJson(json['offset']) : null;
  }
}

class Method {
  int? id;
  String? name;
  Params? params;

  Method.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    //   params = json['params'] != null ? new Params.fromJson(json['params']) : null;
  }
}

class Params {
  double? fajr;
  String? isha;

  Params.fromJson(Map<String, dynamic> json) {
    fajr = json['Fajr'];
    isha = json['Isha'];
  }
}

class Offset {
  int? imsak;
  int? fajr;
  int? sunrise;
  int? dhuhr;
  int? asr;
  int? maghrib;
  int? sunset;
  int? isha;
  int? midnight;

  Offset.fromJson(Map<String, dynamic> json) {
    imsak = json['Imsak'];
    fajr = json['Fajr'];
    sunrise = json['Sunrise'];
    dhuhr = json['Dhuhr'];
    asr = json['Asr'];
    maghrib = json['Maghrib'];
    sunset = json['Sunset'];
    isha = json['Isha'];
    midnight = json['Midnight'];
  }
}

class SalatTodayModel {
  String? Date;
  String? Salat;
  String? Time;
  String? Image;

  SalatTodayModel.fromJson(Map<String, dynamic> json) {
    Date = json['Date'];
    Date = json['Salat'];
    Date = json['Time'];
    Date = json['Image'];
  }
}
