

import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../../model/prayer_times_model.dart';

class TimeView extends StatelessWidget {
  TimeView({super.key, required this.pray});

  final PrayerTimeModel pray;

  @override
  Widget build(BuildContext context) {
    final isNext = MainBloc.nextPray?.englishName == pray.englishName;
    final isCurrent = MainBloc.currentPray?.englishName == pray.englishName;
    final badge = isNext
        ? 'التالي'
        : isCurrent
            ? 'الآن'
            : null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * .004),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          constraints: BoxConstraints(
            minWidth: SizeConfig.screenWidth * .11,
            maxWidth: SizeConfig.screenWidth * .15,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth * .012,
            vertical: SizeConfig.screenHeight * .004,
          ),
          decoration: BoxDecoration(
            color: (isNext || isCurrent)
                ? Colors.white.withValues(alpha: 0.22)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: (isNext || isCurrent)
                ? Border.all(color: Colors.white.withValues(alpha: 0.45))
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * .018,
                child: Center(
                  child: Text(
                    badge ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.amber.shade100,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      fontSize: SizeConfig.screenWidth * .028,
                    ),
                  ),
                ),
              ),
              Text(
                pray.arabicName.toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.screenWidth * .03,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * .003),
              Text(
                MainBloc.convertTo12HourFormat(pray.time ?? '', false) ?? '',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: kWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.screenWidth * .038,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
