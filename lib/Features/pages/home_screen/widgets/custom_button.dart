
import 'package:azkar/core/animations/bottom_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const CustomButton({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     // width: AppDimensions.normalize(100),
    //  height: AppDimensions.normalize(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color:  const Color(0x59ff3f3f),

          borderRadius: BorderRadius.all(Radius.circular(8))
      ),

      child: GestureDetector(
      //  shape: const StadiumBorder(),
        onTap: onPressed,

        child: WidgetAnimator(
          child: Text(
            title,
           // style: AppText.b1,
          ),
        ),
      ),
    );
  }
}
