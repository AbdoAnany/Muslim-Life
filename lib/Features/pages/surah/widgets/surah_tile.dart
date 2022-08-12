import 'dart:ui';

import 'package:azkar/Features/model/chapter.dart';
import 'package:azkar/Features/pages/surah/widgets/surah_information.dart';
import 'package:azkar/core/animations/bottom_animation.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'page_screen.dart';

class SurahTile extends StatelessWidget {
  final Chapter chapter;

  const SurahTile({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetAnimator(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PageScreen(
                chapter: chapter,
              ),
            ),
          );
        },    onLongPress: () => showDialog(
        context: context,
        builder: (context) => SurahInformation(
          chapterData: chapter,
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              SizedBox(width: 10,),
              Container(height:  MediaQuery.of(context).size.height * 0.04,width:  MediaQuery.of(context).size.height * 0.06,alignment: Alignment.center,
                decoration: BoxDecoration(
                 image: DecorationImage(image: AssetImage(StaticAssets.frame),fit: BoxFit.contain,),

                ),
                  child: Text(chapter!.number.toString(),
                  style:  TextStyle(
                    fontSize:  MediaQuery.of(context).size.height * 0.012,
                  ),
                  )),
              Hero(
                  tag: 'sname_${chapter!.number.toString()}',
                  child: Image.asset(
                      'assets/surat/sname_${chapter!.number.toString()}.png',
                      height: MediaQuery.of(context).size.height * .06,
                   //   color: AppTheme.c.textSub
                  )),
              Spacer(),
              Column(
                children: [

                  Text(chapter!.ayahs!.length.toString() + '  آية'),
                Image.asset(chapter!.revelationType == "Meccan" ? StaticAssets.mecca : StaticAssets.mosque, height: 30,),

                ],
              ),
              SizedBox(width: 20,),
            ],

            // Text(
            //   chapter!.name!,
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),


          ),
        ),
      ),
    );
  }
}
