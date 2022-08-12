// // @dart=2.9
// import 'package:azkar/core/shared/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:hijri/hijri_calendar.dart';
//
// import '../../Features/home/presentation/manager/home_bloc/prayer_cubit/prayer_cubit.dart';
//
// class DateHeader extends StatelessWidget {
//   DateHeader({
//     Key key,
//   }) : super(key: key);
//   HijriCalendar _today;
//
//   @override
//   Widget build(BuildContext context) {
//
//
//   //  _today = HijriCalendar.now();
//   HijriCalendar.setLocal('ar');
//     return Container(
//       color: Colors.transparent,
//       padding: EdgeInsets.all(15),
//       child:PrayerCubit.get(context).prayList.isNotEmpty? Text(  PrayerCubit.get(context).prayList.first.date.hijri.date):Text('التاريخ  الهجري',
//       style: Headerstyle(),)
//       // Row(
//       //   mainAxisSize: MainAxisSize.max,
//       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //   children: [
//       //     Text((() {
//       //       if (_today == null) {
//       //         return "--";
//       //       }
//       //
//       //       return '${_today.toFormat("dd-mm-yyyy")}';
//       //     })(), style: Headerstyle()),
//       //     Text((() {
//       //       if (_today == null) {
//       //         return "--";
//       //       }
//       //
//       //       return '${_today.getDayName()}';
//       //     })(), style: Headerstyle()),
//       //     Text((() {
//       //       if (_today == null) {
//       //         return "--";
//       //       }
//       //
//       //       return '${_today.toFormat("MMMM")}';
//       //     })(), style: Headerstyle()),
//       //   ],
//       // ),
//     );
//   }
// }
