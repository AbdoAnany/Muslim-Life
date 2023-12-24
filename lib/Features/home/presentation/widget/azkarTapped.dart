// import 'package:azkar/Features/bloc/Azkar_cubit/azkar_state.dart';
// import 'package:azkar/Features/model/azkarModel.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
// import 'package:azkar/core/shared/colors.dart';
// import 'package:azkar/core/shared/styles.dart';
// import 'package:azkar/core/widgets/misbaha.dart';
// import 'package:azkar/core/widgets/privacy.dart';
// import 'package:azkar/core/widgets/qiblah_compass.dart';
//
// import 'package:azkar/Features/home/data/models/azkarModel.dart';
// import 'package:path/path.dart';
//
// import '../../../bloc/bookmarkCubit/BookMarkAppCubit.dart';
// import 'azkarSlider.dart';
//
// class SliderList extends StatelessWidget {
//   late TabController _tabController;
//
//
//   var Page=[
//     AzkarBuilder(),
//     Misbaha(),
//     Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Container(child: getQibla()),
//     ),
//   //  privacy(),
//   ];
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AzkarCubit, AzkarState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           return DefaultTabController(
//               length: 3,
//               initialIndex: 0,
//               child: Scaffold(
//                   backgroundColor: Colors.transparent,
//                   body: Column(children: [
//                     AzkarCubit.get(context).currentPage == 0?     Row(children: [IconButton(
//                       onPressed: () {
//                         AzkarCubit.get(context).currentPage == 0
//                             ? AzkarCubit.get(context).searchState()
//                             : null;
//                       },
//                       icon: Icon(
//                         Icons.search,
//                         color: Colors.brown,
//                       ),
//                       color: Colors.brown,
//                     ),   Container(
//                       width:
//                       MediaQuery.of(context).size.width*.8,
//
//                       child:  TextFormField(
//
//                         controller: AzkarCubit.get(context).azkarController,
//                         decoration: InputDecoration(
//                             hintText: 'بحث عن ذكر',
//                             hintStyle: GrayText()),
//                         onChanged: ((value) async {
//                           await AzkarCubit.get(context).search();
//                         }),
//                         style: GrayText(),
//                         validator: (String? value) {
//                           if (value == null || value.isEmpty) {}
//                           return null;
//                         },
//                       ),
//                     ),],):SizedBox()
//                     ,
//                     Expanded(
//
//                         child:Page[ AzkarCubit.get(context).currentPage])
//                   ],)));});
//
//   }
//
//
//
// //Azkar Builder
//
// }
// // class AzkarBuilder extends StatelessWidget {
// //   const AzkarBuilder({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //       return BlocConsumer<AzkarCubit, AzkarState>(
// //           listener: (context, state) {},
// //           builder: (context, state) {
// //             List<AzkarData> _azkardata = [];
// //             List<String> _azkarcategories = [];
// //
// //             _azkardata = AzkarCubit.get(context).azkarList!;
// //             print(_azkardata.length);
// //             if (_azkardata.length > 0) {
// //               _azkardata.forEach((element) {
// //                 _azkarcategories.add(element.category!);
// //               });
// //             }
// //             if (_azkardata.length > 0) {
// //               return ListView.separated(
// //                 physics: BouncingScrollPhysics(),
// //                 itemBuilder: (context, index) => BuildAzkarItem(item: _azkarcategories.toSet().toList()[index]),
// //                 separatorBuilder: (context, index) => Container(),
// //                 itemCount: _azkarcategories.toSet().length,
// //               );
// //             } else {
// //               return Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     CircularProgressIndicator(),
// //                     SizedBox(
// //                       height: 20,
// //                     ),
// //                     Text(
// //                       '${AzkarCubit.get(context).textState}',
// //                       style: LightText(),
// //                     )
// //                   ],
// //                 ),
// //               );
// //             }});
// //
// //   }
// // }
// // class BuildAzkarItem extends StatelessWidget {
// //   const BuildAzkarItem({super.key,this.item});
// // final item;
// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //         onTap: () {
// //         //  AzkarCubit.get(context).azkarTapped(item);
// //
// //           showDialog(
// //               context: context,
// //               builder: (BuildContext context) {
// //                 return azkarSlider();
// //               });
// //         },
// //         child: Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //           margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //           width: double.infinity,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.all(Radius.circular(50.0)),
// //             boxShadow: [BoxShadow(color: Colors.white.withOpacity(.2))],
// //             //   border: Border.all(width:0, color: Colors.amber,),
// //             gradient: LinearGradient(
// //               colors: [
// //                 Color.fromARGB(255, 9, 9, 9),
// //                 Color.fromARGB(255, 9, 9, 9),
// //                 Color.fromARGB(198, 16, 16, 16),
// //                 Color.fromARGB(100, 9, 9, 9),
// //               ],
// //               begin: Alignment.bottomRight,
// //               tileMode: TileMode.decal,
// //               end: Alignment.bottomLeft,
// //             ),
// //           ),
// //           child: Text(
// //             (item.toString()),
// //             style: Azkarstyle(),
// //           ),
// //         ));
// //   }
// // }
//
