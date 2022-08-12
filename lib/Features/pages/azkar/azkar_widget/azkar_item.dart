import 'dart:ui';

import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/model/azkarModel.dart';
import 'package:azkar/core/animations/bottom_animation.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'azkarSlider.dart';

class AzkarItem extends StatelessWidget{
   final AzkarCategory item;

  const AzkarItem({Key? key,  required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      final appProvider = Provider.of<AppProvider>(context);

  return WidgetAnimator(
    child: GestureDetector(
      onTap: () async {
        AzkarCubit.get(context).azkartapped(item);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return azkarslider();
            });
      }
      ,
      child:
      Container(
     //   padding: EdgeInsets.all(50),
       margin: EdgeInsets.all(8),
        width:MediaQuery.of(context).size.width*.3 ,

        decoration: BoxDecoration(
          color: Colors.transparent,
         // image: DecorationImage(image: AssetImage(StaticAssets.frame),fit: BoxFit.contain,scale: 2,),

         borderRadius:
          BorderRadius.circular(15.0),
          border: Border.all(
            color: kMainColor,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child:       Stack(
          alignment: Alignment.center,
          children: [
         //   Image.asset(StaticAssets.frame,fit: BoxFit.fill,color: kMainColor),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                (item.category.toString()),textDirection: TextDirection.rtl,
                textAlign: TextAlign.center, softWrap: true,

                style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*.040
                ),
              ),
            ),
          ],
        ),
      ),




    ),
  );
  }


}


// Widget buildZekrItem(Azkardata item, context) {

// }