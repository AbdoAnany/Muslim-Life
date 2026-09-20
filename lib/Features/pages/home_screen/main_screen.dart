import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/pages/home_screen/widgets/TimeView.dart';
import 'package:azkar/Bloc/app_cubit.dart';
import 'package:azkar/app_routes.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/shared/styles.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/features/prayer/prayer_times_screen.dart';
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
    //print(SizeConfig.screenHeight);
    //print(SizeConfig.screenWidth);
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
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PrayerTimesScreen(),
                              ),
                            );
                          },
                          child: Container(

                              height:  SizeConfig.screenWidth * .5,

                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.screenWidth * .02,
                                  vertical: SizeConfig.screenHeight * .02,
                              ),
                              padding:
                                  EdgeInsets.symmetric(
                                    horizontal: SizeConfig.screenWidth * .01,
                                    vertical: SizeConfig.screenHeight * .01,
                                  ),
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
                                      padding: EdgeInsets.all(
                                          SizeConfig.screenWidth * .007),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${today.fullDate()}",
                                                style: TextStyle(
                                                    fontSize:
                                                        SizeConfig.screenWidth * .045,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: kWhite),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: SizeConfig.screenWidth * .007,
                                                          bottom: SizeConfig.screenWidth * .007),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            prayer.prayList.first.meta!.timezone!.split('/')[1].toUpperCase(),
                                                            style: TextStyle(
                                                                color: kWhite,letterSpacing: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: SizeConfig.screenWidth * .050),
                                                          ),
                                                          Icon(
                                                              Icons.pin_drop_outlined,
                                                              color: kWhite,
                                                              size: SizeConfig.screenWidth * .06),
                                                        ],
                                                      ))),
                                            ],
                                          ),

                                          Spacer(),
                                          Padding(
                                            padding:  EdgeInsets.symmetric(vertical: SizeConfig.screenWidth * .01),
                                            child: Text(
                                              'مواقيت الصلاة',
                                              style: TextStyle(
                                                  color: kWhite,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.screenWidth * .07),
                                            ),
                                          ),
                                          if(prayer.timingsList.length>5)Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: prayer.timingsList.sublist(0, 6).map((timings) =>
                                                      TimeView(pray: timings!)).toList())
                                          // SizedBox(height: 10,)
                                        ],
                                      ),
                                    )),
                        ),
                        BlocBuilder<AppCubit, AppStates>(
                          builder: (context, _) {
                            final menu = AppCubit.get(context).menuList;
                            return GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: menu.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) {
                                final item = menu[index];
                                final imagePath =
                                    'assets/images/${item.photo}';
                                return InkWell(
                                  onTap: () => AppRoutes.openAction(context, item),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.screenWidth * .04,
                                      vertical: SizeConfig.screenHeight * .02,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.2),
                                      border: Border.all(color: kMainColor, width: 1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: kMainColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig.screenWidth * .042,
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                                        Image.asset(
                                          imagePath,
                                          height: SizeConfig.screenHeight * .08,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.menu_book,
                                            color: kMainColor,
                                            size: SizeConfig.screenHeight * .08,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'النسخة 1.0.14',
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
