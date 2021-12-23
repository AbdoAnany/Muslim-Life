import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:khushoo3/core/shared/styles.dart';

class DateHeader extends StatelessWidget {
  DateHeader({
    Key? key,
  }) : super(key: key);
  HijriCalendar? _today;

  @override
  Widget build(BuildContext context) {
    _today = HijriCalendar.now();
    HijriCalendar.setLocal('ar');
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text((() {
            if (_today == null) {
              return "--";
            }

            return '${_today!.toFormat("dd-mm-yyyy")}';
          })(), style: Headerstyle()),
          Text((() {
            if (_today == null) {
              return "--";
            }

            return '${_today!.getDayName()}';
          })(), style: Headerstyle()),
          Text((() {
            if (_today == null) {
              return "--";
            }

            return '${_today!.toFormat("MMMM")}';
          })(), style: Headerstyle()),
        ],
      ),
    );
  }
}
