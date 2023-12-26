

import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../../model/prayer_times_model.dart';

class TimeView extends StatelessWidget {
   TimeView({super.key,required this.pray});
   PrayerTimeModel pray;
  @override
  Widget build(BuildContext context) {


    return   Column(
      children: [
        // Text(
        //   "الان".toString()??'' ,
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //       color: kWhite,fontWeight: FontWeight.bold,letterSpacing: 2,
        //
        //       fontSize: SizeConfig.screenWidth * .04),
        // ),
        Text(
          pray.arabicName
              .toString()??'' ,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: kWhite,fontWeight: FontWeight.bold,letterSpacing: 2,overflow: TextOverflow.ellipsis,

              fontSize: SizeConfig.screenWidth * .035),
        ),
        SizedBox(height:  SizeConfig.screenHeight * .008,),

        Text(
          "${MainBloc.convertTo12HourFormat(pray.time!, false)}",textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,

          style: TextStyle(
              color: kWhite,fontWeight: FontWeight.bold,letterSpacing:1.2,
              fontSize:
              SizeConfig.screenWidth * .05),
        ),

      ],
    );
  }

//   Future<bool> isNow(time) async {
//    DateTime  originalDate= await MainBloc.timeToDateTime(time: time);
//
//
// }
}
