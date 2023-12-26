import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/bookmarkCubit/BookMarkAppCubit.dart';
import 'package:azkar/Features/model/Azkar/azkar.dart';
import 'package:azkar/core/animations/bottom_animation.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:flutter/material.dart';

import 'azkarSlider.dart';
class AzkarItemNew extends StatelessWidget{
  final AzkarCategoryNew item;

  const AzkarItemNew({Key? key,  required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return WidgetAnimator(
      child: GestureDetector(
        onTap: () async {
          AzkarCubit.get(context).azkarTappedNew(item);
          BookMarkAppCubit.clearAzkarDayCount();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AzkarSliderNew();
              }).whenComplete(() {
                print("whenComplete");
            AzkarCubit.get(context).clearAzkarTappedNew();
          });
        },
        child: Container(
          margin: EdgeInsets.all(8),
          width:MediaQuery.of(context).size.width*.3 ,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius:
            BorderRadius.circular(15.0),
            border: Border.all(
              color: kMainColor,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child:       Text(
            (item.category.toString()),textDirection: TextDirection.rtl,
            textAlign: TextAlign.center, softWrap: true,

            style: TextStyle(
                fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*.040
            ),
          ),
        ),




      ),
    );
  }


}

