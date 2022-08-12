
import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String? title;

  const CustomTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Positioned(
      top: height * 0.10,
      right: width * 0.05,
      child: Text(
        title!,
        style: TextStyle(color: Colors.grey.shade700,fontSize:  height * 0.035,),

      ),
    );
  }
}
