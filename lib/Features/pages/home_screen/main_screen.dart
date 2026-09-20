import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/pages/home_screen/widgets/TimeView.dart';
import 'package:azkar/Features/pages/home_screen/widgets/home_location_label.dart';
import 'package:azkar/Bloc/app_cubit.dart';
import 'package:azkar/app_routes.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/shared/styles.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/updates/app_update_checker.dart';
import 'package:azkar/features/prayer/prayer_times_screen.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateChecker.checkIfNeeded(context);
    });
  }

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
                              height: SizeConfig.screenWidth * .52,
                              margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenWidth * .03,
                                vertical: SizeConfig.screenHeight * .015,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenWidth * .025,
                                vertical: SizeConfig.screenHeight * .012,
                              ),
                              decoration: BoxDecoration(
                                  color: kMainColor,
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xffb0c168),
                                        Color(0xff57b78f),
                                        Color(0xff3d9b7a),
                                        Color(0xff00897b),
                                      ]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal.withValues(alpha: 0.35),
                                      blurRadius: 14,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 6),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16)),
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
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                  today.fullDate(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .screenWidth *
                                                        .034,
                                                    fontWeight: FontWeight.w600,
                                                    color: kWhite,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          .02),
                                              Flexible(
                                                flex: 4,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        formatPrayerLocationLabel(
                                                          prayer
                                                              .prayList
                                                              .first
                                                              .meta
                                                              ?.timezone,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          color: kWhite,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: SizeConfig
                                                                  .screenWidth *
                                                              .034,
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: kWhite,
                                                      size: SizeConfig
                                                              .screenWidth *
                                                          .045,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: SizeConfig
                                                        .screenWidth *
                                                    .008),
                                            child: Text(
                                              'مواقيت الصلاة',
                                              style: TextStyle(
                                                color: kWhite,
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig
                                                        .screenWidth *
                                                    .055,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          if (prayer.timingsList.length > 5)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: prayer.timingsList
                                                  .sublist(0, 6)
                                                  .map(
                                                    (timings) => Expanded(
                                                      child: TimeView(
                                                          pray: timings!),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
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
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: SizeConfig.screenWidth * .02,
                                mainAxisSpacing: SizeConfig.screenHeight * .008,
                                childAspectRatio: 0.92,
                              ),
                              itemBuilder: (context, index) {
                                final item = menu[index];
                                final imagePath =
                                    'assets/images/${item.photo}';
                                return InkWell(
                                  onTap: () => AppRoutes.openAction(context, item),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.screenWidth * .01,
                                      vertical: SizeConfig.screenHeight * .006,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: kMainColor.withValues(alpha: 0.35),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.teal
                                              .withValues(alpha: 0.12),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.04),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.screenWidth * .03,
                                      vertical: SizeConfig.screenHeight * .012,
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: kMainColor,
                                            fontWeight: FontWeight.w700,
                                            height: 1.25,
                                            fontSize:
                                                SizeConfig.screenWidth * .038,
                                          ),
                                        ),
                                        SizedBox(
                                            height: SizeConfig.screenHeight *
                                                0.012),
                                        Expanded(
                                          child: Image.asset(
                                            imagePath,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.menu_book,
                                              color: kMainColor,
                                              size: SizeConfig.screenHeight *
                                                  .07,
                                            ),
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
