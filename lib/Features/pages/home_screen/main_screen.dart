import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/pages/home_screen/widgets/TimeView.dart';
import 'package:azkar/Features/scd.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/shared/styles.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/utils/drawer.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print(SizeConfig.screenHeight);
    print(SizeConfig.screenWidth);
    return Scaffold(
      backgroundColor: Colors.grey,
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          MainBloc prayer = MainBloc.get(context);
          HijriCalendar.setLocal('ar');
          HijriCalendar today = HijriCalendar.now();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: MediaQuery.of(context).size.height,
            color: Colors.white,

            margin: const EdgeInsets.only(top: 40),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -200,
                    left: -200,
                    child: Opacity(
                        opacity: .35,
                        child: Image.asset(StaticAssets.arabic)),
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
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minHeight: SizeConfig.screenHeight*.20,
                            maxHeight:SizeConfig.screenHeight*.20,
                          ),
                            margin:  EdgeInsets.all(SizeConfig.screenWidth * .02),
                            padding:  EdgeInsets.all(SizeConfig.screenWidth * .01),
                            decoration: BoxDecoration(
                                color: kMainColor,
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xffb0c168),
                                      Color(0xff57b78f),
                                      kMainColor,
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
                            child: prayer.prayList.isEmpty
                                ? Center(
                                    child: Text(
                                      prayer.textState,
                                      style: LightText(),
                                    ),
                                  )
                                : Padding(
                                  padding:  EdgeInsets.all(SizeConfig.screenWidth * .007),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${today.fullDate()}",
                                              style: TextStyle(
                                                  fontSize: SizeConfig.screenWidth * .055,
                                                  fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,
                                                  color: kWhite),
                                            ),
                                            Expanded(
                                                child: Padding(
                                                    padding:  EdgeInsets.only(left: SizeConfig.screenWidth * .007, bottom: SizeConfig.screenWidth * .007),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .end,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end,
                                                      children: [
                                                        Text(
                                                          prayer
                                                              .prayList
                                                              .first
                                                              .meta!
                                                              .timezone!
                                                              .split('/')[1],
                                                          style: TextStyle(
                                                              color: kWhite,overflow: TextOverflow.ellipsis,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: SizeConfig.screenWidth * .050),
                                                        ),
                                                        Icon(
                                                            Icons.pin_drop_outlined,
                                                            color: kWhite,
                                                            size: SizeConfig.screenWidth * .055),
                                                      ],
                                                    ))),
                                          ],
                                        ),

Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Text(
                                            'مواقيت الصلاة',
                                            style: TextStyle(
                                                color: kWhite,
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig.screenWidth * .07),
                                          ),
                                        ),
                                        if(prayer.timingsList.length>5)
                                        Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: prayer.timingsList
                                                .sublist(0, 6)
                                                .map((timings) =>
                                                TimeView(pray: timings!))
                                                .toList())
                                        // SizedBox(height: 10,)
                                      ],
                                    ),
                                )),
                        Center(
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
                                    border: Border.all(color: kMainColor, width: 1),
                                    borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DrawerUtils.items[index]['title'],
                                      style: TextStyle(
                                          color: kMainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.screenWidth * .05),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.01,
                                    ),
                                    Hero(
                                        tag: DrawerUtils.items[index]
                                            ['imagePath'],
                                        child: Image.asset(
                                          DrawerUtils.items[index]['imagePath'],
                                          height: SizeConfig.screenHeight * .1,

                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (kDebugMode)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => NotificationPanel()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(100.0),
                          child: Text('NTF'),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'النسخة 1.0.9',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
