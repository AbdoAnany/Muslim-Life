import 'dart:math' as math;

import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/bookmarkCubit/BookMarkAppCubit.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../model/Azkar/azkar.dart';

class BeautifulStepProgressIndicator extends StatefulWidget {
  final int totalCount;
  final AzkarItemNew controller;

  const BeautifulStepProgressIndicator({
    Key? key,
    required this.totalCount,
    required this.controller,
  }) : super(key: key);

  @override
  _BeautifulStepProgressIndicatorState createState() =>
      _BeautifulStepProgressIndicatorState();
}

class _BeautifulStepProgressIndicatorState
    extends State<BeautifulStepProgressIndicator> {
  @override
  void initState() {
    widget.controller.currentCount =
        BookMarkAppCubit.getAzkarItemNewCountById(widget.controller);
    super.initState();
  }

  Future<void> incrementCount() async {
    if (widget.controller.currentCount >= widget.controller.count!) {
      print('Complete');
      AzkarCubit.get(context).onTap();
    }
    if(widget.controller.currentCount < widget.controller.count!) {
      print('NOT  Complete');
      widget.controller.currentCount++;

      BookMarkAppCubit.saveAzkarItemCount(widget.controller);
    }
    if (widget.controller.currentCount == widget.controller.count!) {
      print('Complete');
      AzkarCubit.get(context).onTap();
    }
    await    AzkarCubit.onClick();
    setState(() {
      print('  currentCount ${widget.controller.currentCount } ======  count  ${ widget.controller.count!}');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent,
      child: InkWell(
        onTap: () => incrementCount(),
        onLongPress: () {
          setState(() {
            widget.controller.currentCount = 0;
          });
          BookMarkAppCubit.saveAzkarItemCount(widget.controller);
        },
        splashColor: Colors.transparent,
        radius: 100,

        borderRadius: BorderRadius.circular(100),
        child: CircularStepProgressIndicator(
          totalSteps: widget.totalCount,
          currentStep: widget.controller.currentCount,

          selectedColor: kMainColor,
          unselectedColor: Colors.grey.shade200,
          padding: math.pi / 80,
          width: 150,
          height: 150,
          startingAngle: -math.pi * 2 / 3,
          //arcSize: math.pi * 2 / 3 * 2,
          // gradientColor: LinearGradient(
          //   colors: [Color(0xffde9a49),
          //     Color(0xffa18e6d)],
          // ),
          child: Center(
            child: Text(
              widget.controller.currentCount.toString(),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 50,
                  color: //ThemeAppCubit.get(context).IsDark? Colors.white:
                      Color(0xff3e3e3e),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
