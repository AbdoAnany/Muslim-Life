// import 'package:azkar/Features/bloc/Azkar_cubit/azkar_state.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
// import 'package:azkar/core/shared/colors.dart';
// import 'package:azkar/core/shared/styles.dart';
//
//
//
// class azkarSlider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AzkarCubit, AzkarState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           if (AzkarCubit.get(context).azkarList!.length > 0) {
//             return Padding(
//               padding: const EdgeInsets.fromLTRB(0, 100, 0, 70),
//               child: Container(
//                 child: Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
//                       child: Container(
//                           child: CarouselSlider(
//                         items: Cart(context),
//                         options: CarouselOptions(
//                           initialPage: 0,
//                           scrollDirection: Axis.horizontal,
//                           enlargeCenterPage: true,
//                           scrollPhysics: BouncingScrollPhysics(),
//                           enableInfiniteScroll: false,
//                           onPageChanged: (index, reason)  {
//                          //   AzkarCubit.get(context).onScroll(index);
//                           },
//                           height: MediaQuery.of(context).size.height,
//                           autoPlay: false,
//                         ),
//                         carouselController: AzkarCubit.get(context).carouselController,
//                       )),
//                     ),
//                     Visibility(
//                       visible: AzkarCubit.get(context).counterVisibility,
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             height: 70,
//                             child: FloatingActionButton(
//                               onPressed: () =>
//                                   {AzkarCubit.get(context).onTap()},
//                               child: Text('${AzkarCubit.get(context).counter}'),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
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
//                     '${AzkarCubit.get(context).textState}',
//                     style: LightText(),
//                   )
//                 ],
//               ),
//             ));
//           }
//         });
//   }
//
//   List<Widget> Cart(context) => AzkarCubit.get(context)
//       .azkarList!
//       .map((item) => Container(
//             width: MediaQuery.of(context).size.width - 80,
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Golden,
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 child: Container(
//                   color: Color.fromARGB(150, 0, 0, 0),
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
//                               style: Azkarstyle(),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.clip,
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Text(
//                               '${item.zekr}',
//                               style: Azkarstyle(),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.clip,
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Text(
//                               '${item.description}',
//                               style: Azkarstyle(),
//                               textAlign: TextAlign.start,
//                               overflow: TextOverflow.clip,
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Text(
//                               '${item.reference}',
//                               style: Headerstyle(),
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
