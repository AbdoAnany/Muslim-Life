// import 'dart:ui';
//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:azkar/Features/home/presentation/manager/home_bloc/prayer_cubit/prayer_cubit.dart';
// import 'package:azkar/Features/home/presentation/widget/azkarTapped.dart';
// import 'package:azkar/core/shared/colors.dart';
//
// class MySlider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<PrayerCubit, PrayerState>(
//       listener: (context, state) {
//
//       },
//       builder: (context, state) {
//
//         return  Container(
//             height: Get.height,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage('assets/images/Background.png'),
//                   fit: BoxFit.cover,
//                   colorFilter: ColorFilter.mode(
//                       Color.fromARGB(15, 255, 255, 255), BlendMode.exclusion)),
//             ),
//             child: NestedScrollView(
//                 headerSliverBuilder:
//                     (BuildContext context, bool innerBoxIsScrolled) {
//                   return <Widget>[
//                     SliverAppBar(
//                       elevation: 10,
//                       centerTitle: true,
//                       backgroundColor: Colors.transparent,
//                       expandedHeight: 200,
//                       floating: true,
//                       pinned: false,
//                       flexibleSpace: Container(child: (() {
//                         if (PrayerCubit.get(context).model.length > 0) {
//                           return CarouselSlider(
//                               options: CarouselOptions(
//                                   height: 200,
//                                   pageSnapping: true,
//                                   aspectRatio: 3,
//                                   initialPage: 0,
//                                   viewportFraction: 1,
//                                   reverse: true,
//                                   enlargeCenterPage: true),
//                               items: PrayerCubit.get(context)
//                                   .model
//                                   .map((item) => InkWell(
//                                         onTap: () async {
//
//                                           item['Remaining']=  await      PrayerCubit.get(context).countTime(item['Time']);
//
//
//                                         },
//                                         child: Container(
//                                           margin:
//                                               EdgeInsets.fromLTRB(8, 30, 8, 0),
//                                           child: ClipRRect(
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10.0)),
//                                               child: Stack(
//                                                 children: <Widget>[
//                                                   Image.asset(item['Image'],
//                                                       fit: BoxFit.cover,
//                                                       width: 1000.0),
//                                                   Positioned(
//                                                     bottom: 0.0,
//                                                     left: 0.0,
//                                                     right: 0.0,
//                                                     child: Stack(
//                                                       children: <Widget>[
//                                                         Container(
//                                                           height: 50,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             gradient:
//                                                                 LinearGradient(
//                                                               colors: [
//                                                                 Color.fromARGB(
//                                                                     200,
//                                                                     255,
//                                                                     255,
//                                                                     255),
//                                                                 Color.fromARGB(
//                                                                     2,
//                                                                     255,
//                                                                     255,
//                                                                     255)
//                                                               ],
//                                                               begin: Alignment
//                                                                   .bottomRight,
//                                                               end: Alignment
//                                                                   .bottomLeft,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Row(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .center,
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceEvenly,
//                                                           children: [
//                                                             Container(
//                                                               margin:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       left:
//                                                                           20.0,
//                                                                       right:
//                                                                           20.0),
//                                                               child: Text(
//                                                                   item['Remaining'],
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   textDirection:
//                                                                       TextDirection
//                                                                           .rtl,
//                                                                   maxLines: 1,
//                                                                   style:
//                                                                       TextStyle(
//                                                                     fontSize:
//                                                                         14,
//                                                                     color: Colors
//                                                                         .black,
//                                                                     //     fontFamily: 'GaliModern'
//                                                                   )),
//                                                             ),
//                                                             Container(
//                                                               margin:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       left:
//                                                                           20.0,
//                                                                       right:
//                                                                           20.0),
//                                                               child: Text(
//                                                                   "${item["Salat"]}",
//                                                                   softWrap:
//                                                                       true,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   maxLines: 1,
//                                                                   style: TextStyle(
//                                                                     fontWeight: FontWeight.bold,
//                                                                       color: Colors. brown,
//                                                                       fontSize:
//                                                                           30,
//                                                                       fontFamily:
//                                                                           'GaliModern')),
//                                                             ),
//                                                           ],
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                       padding:
//                                                           EdgeInsets.all(7),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius.only(
//                                                                 bottomRight: Radius
//                                                                     .circular(
//                                                                         5.0)),
//                                                         color:
//                                                             Golden.withOpacity(
//                                                                 .6),
//                                                       ),
//                                                       child: Text(
//                                                           item['Time']
//                                                               .toString()
//                                                               .replaceAll(
//                                                                   '(EET)', ''),
//                                                           style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 16.0,
//                                                           ))),
//                                                 ],
//                                               )),
//                                         ),
//                                       ))
//                                   .toList());
//                         } else {
//                           return Container(
//                             height: 170,
//                             color: Colors.transparent ,
//                             alignment: Alignment.center,
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                       })()),
//                     ),
//                   ];
//                 },
//                 body: Directionality(
//                     textDirection: TextDirection.rtl, child: SliderList())));
//       },
//     );
//   }
//
//   //SliderWidget
//
// //Header Time
//
// }
