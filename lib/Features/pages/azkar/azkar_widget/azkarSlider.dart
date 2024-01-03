import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/Azkar_cubit/azkar_state.dart';
import 'package:azkar/Features/model/Azkar/azkar.dart';
import 'package:azkar/Features/widget/bct.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/shared/styles.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:azkar/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class AzkarSliderNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Material(
      child: BlocBuilder<AzkarCubit, AzkarState>(

          builder: (context, state) {
            AzkarCubit azkarCubit = AzkarCubit.get(context);
            //print(azkarCubit.currentIndex);
            if (azkarCubit.azkarDataNewList.isNotEmpty) {
              return Container(
                color: Colors.white,
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SafeArea(bottom:false ,
                      child: StepProgressIndicator(
                        size: 5,
                        totalSteps: azkarCubit.azkarDataNewList.length,
                        currentStep: azkarCubit.currentIndex + 1,
                        selectedColor: kMainColor,
                        unselectedColor: Colors.grey.shade200,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenWidth * .22,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(  width:  SizeConfig.screenWidth * .1,),
                          SizedBox(width: SizeConfig.screenWidth * .7 ,
                            child: Text(
                              '${azkarCubit.azkarCategoryNew!.category}',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueGrey.shade700,
                                fontSize: SizeConfig.screenWidth * .055,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                              width:  SizeConfig.screenWidth * .1,
                              child:Center(child: IconButton(onPressed: ()=>Navigator.of(Get.context).pop(), icon: Icon(Icons.arrow_forward)))
                          ),
                        ],
                      ),
                    ),


                    Expanded(
                      child: CarouselSlider(
                        items: azkarCubit.azkarDataNewList
                            .map((item1) => AzkarCartWidget(item: item1))
                            .toList(),
                        options: CarouselOptions(
                          initialPage: azkarCubit.currentIndex,
                          viewportFraction: 1,
                          scrollDirection: Axis.horizontal,
                          enlargeCenterPage: true,
                          scrollPhysics: BouncingScrollPhysics(),
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            azkarCubit.onScrollNew(index);
                          },
                          height: SizeConfig.screenHeight,
                          autoPlay: false,
                        ),
                        carouselController: azkarCubit.carouselController,
                      ),
                    ),
                  ],
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
          }),
    );
  }

  // List<Widget> Cart(AzkarCubit azkarCubit, context, appProvider) {
  //   double height = MediaQuery.of(context).size.height;
  //   return azkarCubit.azkarList!
  //       .map((item) => Container(
  //             width: MediaQuery.of(context).size.width,
  //             decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: kMainColor,
  //                 ),
  //                 borderRadius: BorderRadius.all(Radius.circular(10))),
  //             child: Directionality(
  //               textDirection: TextDirection.rtl,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                 child: Container(
  //                   color: kWhite,
  //                   child: SingleChildScrollView(
  //                     child: Container(
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(4.0),
  //                         child: Column(
  //                           children: [
  //                             SizedBox(
  //                               height: 30,
  //                             ),
  //                             Text(
  //                               '${item.category}',
  //                               style: TextStyle(
  //                                 color: Colors.blueGrey.shade900,
  //                                 fontSize: SizeConfig.screenWidth * (appProvider.fontSize + .002),
  //                                 fontFamily: 'Tajwal',
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                               textAlign: TextAlign.center,
  //                               overflow: TextOverflow.clip,
  //                             ),
  //                             SizedBox(
  //                               height: 30,
  //                             ),
  //                             Text(
  //                               '${item.zekr}',
  //                               style: TextStyle(
  //                                 color: Colors.blueGrey.shade900,
  //                                 fontSize:  SizeConfig.screenWidth * (appProvider.fontSize),
  //                                 fontFamily: 'Tajwal',
  //                                 fontWeight: FontWeight.normal,
  //                               ),
  //                               textAlign: TextAlign.center,
  //                               overflow: TextOverflow.clip,
  //                             ),
  //                             SizedBox(
  //                               height: 20,
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Text(
  //                                 '${item.description}',
  //                                 style: TextStyle(
  //                                   color: Colors.blueGrey.shade900,
  //                                   fontSize: SizeConfig.screenWidth * (appProvider.fontSize - .01),
  //                                   fontFamily: 'Tajwal',
  //                                   fontWeight: FontWeight.normal,
  //                                 ),
  //                                 textAlign: TextAlign.justify,
  //                                 overflow: TextOverflow.clip,
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               height: 20,
  //                             ),
  //                             Text(
  //                               '${item.reference}',
  //                               style: TextStyle(
  //                                 color: Colors.blueGrey.shade900,
  //                                 fontSize:  SizeConfig.screenWidth * (appProvider.fontSize),
  //                                 fontFamily: 'Tajwal',
  //                                 fontWeight: FontWeight.normal,
  //                               ),
  //                               textAlign: TextAlign.start,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //
  //                     // Add your onPressed code here!
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ))
  //       .toList();
  // }
}

// class AzkarSlider extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AzkarCubit, AzkarState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           final appProvider = AppProvider.get(context);
//           double height = MediaQuery.of(context).size.height;
//           double width = MediaQuery.of(context).size.width;
//           AzkarCubit azkarCubit=   AzkarCubit.get(context);
//           if (azkarCubit.azkarList.isNotEmpty) {
//             return Container(
//                 child: CarouselSlider(
//                   items: Cart(azkarCubit,context,appProvider),
//                   options: CarouselOptions(
//                     initialPage: 0,viewportFraction: 1,
//                     scrollDirection: Axis.horizontal,
//                     enlargeCenterPage: true,
//                     scrollPhysics: BouncingScrollPhysics(),
//                     enableInfiniteScroll: false,
//                     onPageChanged: (index, reason) {
//                       azkarCubit.onScrollNew(index);
//                     },
//                     height: MediaQuery.of(context).size.height,
//                     autoPlay: false,
//                   ),
//                   carouselController: azkarCubit.carouselController,
//                 ));
//           } else {
//             return Expanded(
//                 child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     '${azkarCubit.textState}',
//                     style: AzkarText(),
//                   )
//                 ],
//               ),
//             ));
//           }
//         });
//   }
//
//   List<Widget> Cart(AzkarCubit azkarCubit,context,appProvider) {
//     double height = MediaQuery.of(context).size.height;
//     return azkarCubit.azkarList!
//       .map((item) => Container(
//             width: MediaQuery.of(context).size.width ,
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   color: kMainColor,
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 child: Container(
//                   color: kWhite,
//                   child: SingleChildScrollView(
//                     child: Container(
//                       child: Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Text(
//                               '${item.category}',
//                              style:TextStyle(
//                               color: Colors.blueGrey.shade900,
//                               fontSize: height * (appProvider.fontSize+.005),
//                               fontFamily: 'Tajwal',
//                               fontWeight: FontWeight.bold,
//                             ),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.clip,
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Text(
//                               '${item.zekr}',
//                               style:   TextStyle(
//                                 color: Colors.blueGrey.shade900,
//                               fontSize: height * (appProvider.fontSize),
//                               fontFamily: 'Tajwal',
//                               fontWeight: FontWeight.normal,
//                             ),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.clip,
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 '${item.description}',
//                                 style:TextStyle(
//                                   color: Colors.blueGrey.shade900,
//                                   fontSize: height * (appProvider.fontSize-.01),
//                                   fontFamily: 'Tajwal',
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                                 textAlign: TextAlign.justify,
//                                 overflow: TextOverflow.clip,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Text(
//                               '${item.reference}',
//                               style:TextStyle(
//                                 color: Colors.blueGrey.shade900,
//                                 fontSize: height * (appProvider.fontSize),
//                                 fontFamily: 'Tajwal',
//                                 fontWeight: FontWeight.normal,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     // Add your onPressed code here!
//                   ),
//                 ),
//               ),
//             ),
//           ))
//       .toList();
//   }
// }

class AzkarCartWidget extends StatelessWidget {
  final AzkarItemNew item;
  AzkarCartWidget({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    String text = item.text!;


    return Container(
    //  padding: EdgeInsets.all(8),
      width:  SizeConfig.screenWidth,height: SizeConfig.screenHeight,

      color: kWhite,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '${text}',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: SizeConfig.screenWidth * .06,height: 1.8,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.clip,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * .05,
                ),
                BeautifulStepProgressIndicator(
                    totalCount: item.count!, controller: item),
                SizedBox(
                  height: SizeConfig.screenHeight * .05,
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: height*.05,
          //   child:BeautifulStepProgressIndicator(totalCount: item.count!, controller:item),
          // )
        ],
      ),
      // Add your onPressed code here!
    );
  }
}
