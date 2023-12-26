
import 'package:azkar/core/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String? title;

  const CustomTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return
      Padding(
        padding:  EdgeInsets.only(top:  SizeConfig.screenHeight*.01),
        child: Text(
          title!,
          style: TextStyle(color: Colors.grey.shade700,fontWeight:FontWeight.bold,fontSize:  SizeConfig.screenWidth * 0.09,),

        ),
      )
    ;
  }
}
