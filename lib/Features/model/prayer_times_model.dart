

class PrayerTimesModel {
  int? code;
  String? status;
  List<Data>? data;

  PrayerTimesModel({this.code, this.status, this.data});

  PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
  PrayerTimesModel.fromLocalJson(Map<String, dynamic> jsons) {
    code = jsons['code'];
    status = jsons['status'];
    if (jsons['data'] != null) {
      data = <Data>[];
      data=  jsons['data'].map<Data>((e)=> Data.fromLocalJson(e)).toList();

    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Timings? timings;
  Date? date;
  Meta? meta;

  Data({this.timings, this.date, this.meta});

  Data.fromJson(Map<String, dynamic> json) {
    timings =
    json['timings'] != null ? new Timings.fromJson(json['timings']) : null;
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
  Data.fromLocalJson(Map<String, dynamic> jsons) {
    timings =Timings.fromLocalJson(jsons['timings']);
    date =Date.fromLocalJson(jsons['date']);
    meta =Meta.fromLocalJson(jsons['meta']);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timings != null) {
      data['timings'] = this.timings!.toJson();
    }
    if (this.date != null) {
      data['date'] = this.date!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}
class Timings {
  PrayerTimeModel? fajr;
  PrayerTimeModel? sunrise;
  PrayerTimeModel? dhuhr;
  PrayerTimeModel? asr;
  PrayerTimeModel? sunset;
  PrayerTimeModel? maghrib;
  PrayerTimeModel? isha;
  PrayerTimeModel? imsak;
  PrayerTimeModel? midnight;
  PrayerTimeModel? firstthird;
  PrayerTimeModel? lastthird;

  Timings({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
  });

  // Create a method to get Arabic time for a given prayer

  factory Timings.fromJson(Map<String, dynamic> json) {
    return Timings(
      fajr: PrayerTimeModel.fromString( json['Fajr']!,'Fajr'),
      sunrise:  PrayerTimeModel.fromString( json['Sunrise']!,'Sunrise'),
      dhuhr:  PrayerTimeModel.fromString( json['Dhuhr']!,'Dhuhr'),
      asr:  PrayerTimeModel.fromString( json['Asr']!,'Asr'),
      sunset:  PrayerTimeModel.fromString( json['Sunset']!,'Sunset'),
      maghrib:  PrayerTimeModel.fromString( json['Maghrib']!,'Maghrib'),
      isha:  PrayerTimeModel.fromString( json['Isha']!,'Isha'),
      imsak:  PrayerTimeModel.fromString( json['Imsak']!,'Imsak'),
      midnight:  PrayerTimeModel.fromString( json['Midnight']!,'Midnight'),
      firstthird:  PrayerTimeModel.fromString( json['Firstthird']!,'Firstthird'),
      lastthird: PrayerTimeModel.fromString(  json['Lastthird']!,'Lastthird'),
    );
  }

  factory Timings.fromLocalJson(Map<String, dynamic> json) {
    return Timings(
      fajr: PrayerTimeModel.fromLocalString( json['Fajr']!,'Fajr'),
      sunrise:  PrayerTimeModel.fromLocalString( json['Sunrise']!,'Sunrise'),
      dhuhr:  PrayerTimeModel.fromLocalString( json['Dhuhr']!,'Dhuhr'),
      asr:  PrayerTimeModel.fromLocalString( json['Asr']!,'Asr'),
      sunset:  PrayerTimeModel.fromLocalString( json['Sunset']!,'Sunset'),
      maghrib:  PrayerTimeModel.fromLocalString( json['Maghrib']!,'Maghrib'),
      isha:  PrayerTimeModel.fromLocalString( json['Isha']!,'Isha'),
      imsak:  PrayerTimeModel.fromLocalString( json['Imsak']!,'Imsak'),
      midnight:  PrayerTimeModel.fromLocalString( json['Midnight']!,'Midnight'),
      firstthird:  PrayerTimeModel.fromLocalString( json['Firstthird']!,'Firstthird'),
      lastthird: PrayerTimeModel.fromLocalString(  json['Lastthird']!,'Lastthird'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Fajr': fajr!.toJson(),
      'Sunrise': sunrise!.toJson(),
      'Dhuhr': dhuhr!.toJson(),
      'Asr': asr!.toJson(),
      'Sunset': sunset!.toJson(),
      'Maghrib': maghrib!.toJson(),
      'Isha': isha!.toJson(),
      'Imsak': imsak!.toJson(),
      'Midnight': midnight!.toJson(),
      'Firstthird': firstthird!.toJson(),
      'Lastthird': lastthird!.toJson(),
    };
  }
}


class PrayerTimeModel {
  String? arabicName;
  String? englishName;
  String? time;

  PrayerTimeModel({
     this.arabicName,
     this.englishName,
     this.time,
  });

  factory PrayerTimeModel.fromString( val,String key) {


    String? englishName = key;
    String? time = val.toString().replaceAll('(EET)', ''.trim());//1

    // Map English names to Arabic names (you can extend this mapping)
    Map<String, String> arabicNameMap = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Sunset': 'الغروب',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
      'Imsak': 'الإمساك',
      'Midnight': 'منتصف الليل',
      'Firstthird': 'الثلث الأول من الليل',
      'Lastthird': 'الثلث الأخير من الليل',
    };

    String arabicName = arabicNameMap[key] ?? '';
    return PrayerTimeModel(
      arabicName: arabicName,
      englishName: englishName,
      time: time,
    );
  }

  factory PrayerTimeModel.fromLocalString( val,String key) {


    String? englishName = key;
    String? time = val['time'].toString().replaceAll('(EET)', '').trim();

    // Map English names to Arabic names (you can extend this mapping)
    Map<String, String> arabicNameMap = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Sunset': 'الغروب',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
      'Imsak': 'الإمساك',
      'Midnight': 'منتصف الليل',
      'Firstthird': 'الثلث الأول من الليل',
      'Lastthird': 'الثلث الأخير من الليل',
    };

    String arabicName = arabicNameMap[key] ?? '';
    return PrayerTimeModel(
      arabicName: arabicName,
      englishName: englishName,
      time: time,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['arabicName'] = this.arabicName;
    data['englishName'] = this.englishName;
    data['time'] = this.time;

    return data;
  }

}





class Date {
  String? readable;
  String? timestamp;
  Gregorian? gregorian;
  Hijri? hijri;

  Date({this.readable, this.timestamp, this.gregorian, this.hijri});

  Date.fromJson(Map<String, dynamic> json) {
    readable = json['readable'];
    timestamp = json['timestamp'];
    gregorian = json['gregorian'] != null
        ? new Gregorian.fromJson(json['gregorian'])
        : null;
    hijri = json['hijri'] != null ? new Hijri.fromJson(json['hijri']) : null;
  }
  Date.fromLocalJson(Map<String, dynamic> jsons) {
    readable = jsons['readable'];
    timestamp = jsons['timestamp'];
    gregorian =  new Gregorian.fromLocalJson(jsons['gregorian']);
    hijri =Hijri.fromJson(jsons['hijri']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readable'] = this.readable;
    data['timestamp'] = this.timestamp;
    if (this.gregorian != null) {
      data['gregorian'] = this.gregorian!.toJson();
    }
    if (this.hijri != null) {
      data['hijri'] = this.hijri!.toJson();
    }
    return data;
  }
}

class Gregorian {
  String? date;
  String? format;
  String? day;
  Weekday? weekday;
  Month? month;
  String? year;
  Designation? designation;

  Gregorian(
      {this.date,
        this.format,
        this.day,
        this.weekday,
        this.month,
        this.year,
        this.designation});

  Gregorian.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday =
    json['weekday'] != null ? new Weekday.fromJson(json['weekday']) : null;
    month = json['month'] != null ? new Month.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null
        ? new Designation.fromJson(json['designation'])
        : null;
  }
  Gregorian.fromLocalJson(Map<String, dynamic> jsons) {
    date = jsons['date'];
    format = jsons['format'];
    day = jsons['day'];
    weekday =Weekday.fromLocalJson(jsons['weekday']);
    month = Month.fromLocalJson(jsons['month']) ;
    year = jsons['year'];
    designation =  new Designation.fromLocalJson(jsons['designation']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['format'] = this.format;
    data['day'] = this.day;
    if (this.weekday != null) {
      data['weekday'] = this.weekday!.toJson();
    }
    if (this.month != null) {
      data['month'] = this.month!.toJson();
    }
    data['year'] = this.year;
    if (this.designation != null) {
      data['designation'] = this.designation!.toJson();
    }
    return data;
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
  Designation.fromLocalJson(Map<String, dynamic> json) {
    abbreviated = json['abbreviated'];
    expanded = json['expanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abbreviated'] = this.abbreviated;
    data['expanded'] = this.expanded;
    return data;
  }
}

class Hijri {
  String? date;
  String? format;
  String? day;
  Weekday? weekday;
  Month? month;
  String? year;
  Designation? designation;
  List<dynamic>? holidays;

  Hijri(
      {this.date,
        this.format,
        this.day,
        this.weekday,
        this.month,
        this.year,
        this.designation,
        this.holidays});

  Hijri.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday =
    json['weekday'] != null ? new Weekday.fromJson(json['weekday']) : null;
    month = json['month'] != null ? new Month.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null
        ? new Designation.fromJson(json['designation'])
        : null;
    if (json['holidays'] != null) {
      holidays = <Null>[];
      json['holidays'].forEach((v) {
        holidays=[];
       // holidays!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['format'] = this.format;
    data['day'] = this.day;
    if (this.weekday != null) {
      data['weekday'] = this.weekday!.toJson();
    }
    if (this.month != null) {
      data['month'] = this.month!.toJson();
    }
    data['year'] = this.year;
    if (this.designation != null) {
      data['designation'] = this.designation!.toJson();
    }
    if (this.holidays != null) {
      data['holidays'] = this.holidays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weekday {
  String? en;
  String? ar;

  Weekday({this.en, this.ar});

  Weekday.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }  Weekday.fromLocalJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

class Month {
  int? number;
  String? en;
  String? ar;

  Month({this.number, this.en, this.ar});

  Month.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
    ar = json['ar'];
  }
  Month.fromLocalJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
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

  Meta(
      {this.latitude,
        this.longitude,
        this.timezone,
        this.method,
        this.latitudeAdjustmentMethod,
        this.midnightMode,
        this.school,
        this.offset});

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
  Meta.fromLocalJson(Map<String, dynamic> jsons) {
    latitude = jsons['latitude'];
    longitude = jsons['longitude'];
    timezone = jsons['timezone'];
    method = Method.fromJson(jsons['method']);
    latitudeAdjustmentMethod = jsons['latitudeAdjustmentMethod'];
    midnightMode = jsons['midnightMode'];
    school = jsons['school'];
    offset = Offset.fromJson(jsons['offset']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['timezone'] = this.timezone;
    if (this.method != null) {
      data['method'] = this.method!.toJson();
    }
    data['latitudeAdjustmentMethod'] = this.latitudeAdjustmentMethod;
    data['midnightMode'] = this.midnightMode;
    data['school'] = this.school;
    if (this.offset != null) {
      data['offset'] = this.offset!.toJson();
    }
    return data;
  }
}

class Method {
  int? id;
  String? name;
  Params? params;
  Location? location;

  Method({this.id, this.name, this.params, this.location});

  Method.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    params =
    json['params'] != null ? new Params.fromJson(json['params']) : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.params != null) {
      data['params'] = this.params!.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Params {
  int? fajr;
  int? isha;

  Params({this.fajr, this.isha});

  Params.fromJson(Map<String, dynamic> json) {
    fajr = json['Fajr'];
    isha = json['Isha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Fajr'] = this.fajr;
    data['Isha'] = this.isha;
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
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

  Offset(
      {this.imsak,
        this.fajr,
        this.sunrise,
        this.dhuhr,
        this.asr,
        this.maghrib,
        this.sunset,
        this.isha,
        this.midnight});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Imsak'] = this.imsak;
    data['Fajr'] = this.fajr;
    data['Sunrise'] = this.sunrise;
    data['Dhuhr'] = this.dhuhr;
    data['Asr'] = this.asr;
    data['Maghrib'] = this.maghrib;
    data['Sunset'] = this.sunset;
    data['Isha'] = this.isha;
    data['Midnight'] = this.midnight;
    return data;
  }
}
