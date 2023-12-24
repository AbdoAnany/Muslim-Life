
import 'package:flutter/material.dart';

import '../shared/colors.dart';

class CustomTitle extends StatelessWidget {
  final String? title;

  const CustomTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return
      Text(
        title!,
        style: TextStyle(color: Colors.grey.shade700,fontWeight:FontWeight.bold,fontSize:  height * 0.04,),

      )
    //   Positioned(
    //   top: height * 0.05,
    //   right: width * 0.05,left: 0,
    //   child:
    //
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       Text(
    //         title!,
    //         style: TextStyle(color: Colors.grey.shade700,fontSize:  height * 0.035,),
    //
    //       ),
    //
    //       IconButton(icon: Icon(Icons.arrow_forward,color: kMainColor),onPressed: (){Navigator.of(context).pop();},),
    //
    //     ],
    //   ),
    // )
    ;
  }
}
