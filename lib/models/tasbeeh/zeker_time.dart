import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class ZekerTime {
  int hours = 0;
  int minutes = 15;

  ZekerTime();

  factory ZekerTime.fromJson(Map<String, dynamic> json) {
    final t = ZekerTime();
    t.hours = json['hours'] as int? ?? 0;
    t.minutes = json['minutes'] as int? ?? 15;
    return t;
  }

  Map<String, dynamic> toJson() => {'hours': hours, 'minutes': minutes};

  int timeID() => hours * 100 + minutes;

  tz.TZDateTime scheduledDate() {
    final currentDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
    final tempDate = DateFormat('MMM dd, yyyy').parse(currentDate);
    var scheduled = tz.TZDateTime.from(tempDate, tz.local);
    scheduled = scheduled.add(Duration(hours: hours, minutes: minutes));
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
