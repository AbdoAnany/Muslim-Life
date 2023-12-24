//
//
// import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:azkar/Features/home/data/models/azkarModel.dart';
// import 'package:azkar/core/shared/styles.dart';
//
// import 'azkarSlider.dart';
//
// class AzkarBuilder extends StatelessWidget {
//    AzkarBuilder({Key? key}) : super(key: key);
//   late TabController _tabController;
//
//   List<Azkardata> _azkardata = [];
//   List<String> _azkarcategories = [];
//   @override
//   Widget build(BuildContext context) {
//
//       if (_azkardata.length > 0) {
//         return ListView.separated(
//           physics: BouncingScrollPhysics(),
//           itemBuilder: (context, index) => buildZekrItem(_azkarcategories.toSet().toList()[index], context),
//           separatorBuilder: (context, index) => Container(),
//           itemCount: _azkarcategories.toSet().length,
//         );
//       } else {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 '${AzkarCubit.get(context).textState}',
//                 style: LightText(),
//               )
//             ],
//           ),
//         );
//       }
//
//   }
//
// }
//
// Widget buildZekrItem(item, context) => InkWell(
//     onTap: () {
//       //AzkarCubit.get(context).azkarTapped(item);
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return azkarSlider();
//           });
//     },
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(50.0)),
//         boxShadow: [BoxShadow(color: Colors.white.withOpacity(.2))],
//         //   border: Border.all(width:0, color: Colors.amber,),
//         gradient: LinearGradient(
//           colors: [
//             Color.fromARGB(255, 9, 9, 9),
//             Color.fromARGB(255, 9, 9, 9),
//             Color.fromARGB(198, 16, 16, 16),
//             Color.fromARGB(100, 9, 9, 9),
//           ],
//           begin: Alignment.bottomRight,
//           tileMode: TileMode.decal,
//           end: Alignment.bottomLeft,
//         ),
//       ),
//       child: Text(
//         (item.toString()),
//         style: Azkarstyle(),
//       ),
//     ));
