import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/Azkar_cubit/azkar_state.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/shared/styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class azkarslider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AzkarCubit, AzkarState>(
        listener: (context, state) {},
        builder: (context, state) {
          final appProvider = AppProvider.get(context);
          double height = MediaQuery.of(context).size.height;
          AzkarCubit azkarCubit=   AzkarCubit.get(context);
          if (azkarCubit.Azkarlist!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Container(
                child: Stack(
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      child: Container(
                          child: CarouselSlider(
                        items: Cart(azkarCubit,context,appProvider),
                        options: CarouselOptions(
                          initialPage: 0,viewportFraction: 0.9,
                          scrollDirection: Axis.horizontal,
                          enlargeCenterPage: true,
                          scrollPhysics: BouncingScrollPhysics(),
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            azkarCubit.onscroll(index);
                          },
                          height: MediaQuery.of(context).size.height,
                          autoPlay: false,
                        ),
                        carouselController:
                        azkarCubit.carouselController,
                      )),
                    ),
                    Visibility(
                      visible: azkarCubit.counterVisibility,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 70,
                            child: FloatingActionButton(
                              onPressed: () =>
                                  {azkarCubit.onTap()},backgroundColor:kMainColor,
                              child: Text('${azkarCubit.counter}',  style:TextStyle(
                                color: Colors.white,
                                fontSize: height * appProvider.fontSize,
                                fontFamily: 'Tajwal',
                                fontWeight: FontWeight.normal,
                              ),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Expanded(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${azkarCubit.textState}',
                    style: AzkarText(),
                  )
                ],
              ),
            ));
          }
        });
  }

  List<Widget> Cart(AzkarCubit azkarCubit,context,appProvider) {
    double height = MediaQuery.of(context).size.height;
    return azkarCubit.Azkarlist!
      .map((item) => Container(
            width: MediaQuery.of(context).size.width ,
            decoration: BoxDecoration(
                border: Border.all(
                  color: kMainColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Container(
                  color: kWhite,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              '${item.category}',
                             style:TextStyle(
                              color: Colors.blueGrey.shade900,
                              fontSize: height * (appProvider.fontSize+.005),
                              fontFamily: 'Tajwal',
                              fontWeight: FontWeight.bold,
                            ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              '${item.zekr}',
                              style:   TextStyle(
                                color: Colors.blueGrey.shade900,
                              fontSize: height * (appProvider.fontSize),
                              fontFamily: 'Tajwal',
                              fontWeight: FontWeight.normal,
                            ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${item.description}',
                                style:TextStyle(
                                  color: Colors.blueGrey.shade900,
                                  fontSize: height * (appProvider.fontSize-.01),
                                  fontFamily: 'Tajwal',
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${item.reference}',
                              style:TextStyle(
                                color: Colors.blueGrey.shade900,
                                fontSize: height * (appProvider.fontSize),
                                fontFamily: 'Tajwal',
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Add your onPressed code here!
                  ),
                ),
              ),
            ),
          ))
      .toList();
  }
}
