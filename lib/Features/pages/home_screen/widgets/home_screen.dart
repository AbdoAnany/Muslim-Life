
import 'dart:ui';

import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/core/shared/styles.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/utils/drawer.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:azkar/core/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:hijri/hijri_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          MainBloc prayer = MainBloc.get(context);
          HijriCalendar.setLocal('ar');
          HijriCalendar today = HijriCalendar.now();


          return Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Stack(
                children: [
                  Positioned(
                    bottom: -200,
                    left: -200,
                    child: Opacity(
                        opacity: .35, child: Image.asset(StaticAssets.arabic)),
                  ),
                  Positioned(
                    top: -200,
                    right: -200,
                    child: Opacity(
                      opacity: .35,
                      child: Hero(
                          tag: StaticAssets.arabic,
                          child: Image.asset(StaticAssets.arabic)),
                    ),
                  ),
              Column(children: [
                GestureDetector(
                  onTap: (){
                    prayer.getPrayTime();
                  },


                  child: Container(
                      height: 200,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: kMainColor,
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xffb0c168),
                                Color(0xff57b78f),
                                Color(0xff0fafaf),
                                Colors.teal
                              ]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: Offset(0, 4)),
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.topCenter,
                      child:
                      prayer.prayList.isEmpty
                          ?
                           Center(
                        child: Text(
                          prayer.textState,
                          style: LightText(),
                        ),
                      ) :

                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10,),
                          Expanded(flex:1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 8, bottom: 20),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${today.fullDate()}",
                                      style: TextStyle(
                                          fontSize:24,
                                          color: kWhite),
                                    ),
                                  ),      Expanded(child:
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, bottom: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            prayer.prayList.first.meta!.timezone!.split('/')[1],
                                            style: TextStyle(
                                                color: kWhite,
                                                fontSize: 20),
                                          ),
                                          Icon(
                                              Icons.pin_drop_outlined,
                                              color: kWhite,
                                              size: 30),
                                        ],
                                      ))),
                                ],
                              ),
                            ),
                          ),
                          Expanded(flex:1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 8),
                              child: Text(
                                'مواقيت الصلاة',
                                style: TextStyle(
                                    color: kWhite,
                                    fontSize:
                                    24),
                              ),
                            ),
                          ),
                          Expanded(flex:1,
                            child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  6,
                                      (index) =>     Expanded(flex:1,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Text(
                                        prayer.prayerName['$index']
                                            .toString() +
                                            '\n' +
                                            prayer.prayList.first.timings!.pray[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize:
                                            SizeConfig.screenWidth! * .035),
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                          // SizedBox(height: 10,)
                        ],
                      )),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 20),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: DrawerUtils.items.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                              DrawerUtils.items[index]['route']),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.2),
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: Colors.grey[400],
                            //       blurRadius: 8,
                            //       spreadRadius: 1,
                            //       offset: Offset(4, 4)),
                            //   BoxShadow(
                            //       color: Colors.grey[200],
                            //       blurRadius: 8,
                            //       spreadRadius: 1,
                            //       offset: Offset(-4, -4)),
                            // ],
                            border: Border.all(color: kMainColor, width: 1),
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              DrawerUtils.items[index]['title'],
                              style: TextStyle(
                                  color: kMainColor,
                                  fontSize: SizeConfig.screenWidth! * .05),
                            ),
                            Hero(
                                tag: DrawerUtils.items[index]['imagePath'],
                                child: Image.asset(
                                  DrawerUtils.items[index]['imagePath'],
                                  height: SizeConfig.screenHeight! * .1,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],),
                  Align(alignment: Alignment.bottomCenter,
                    child: Text('النسخة 1.0.9',style: TextStyle(color: Colors.blueGrey ),),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //SliderWidget

//Header Time

}
