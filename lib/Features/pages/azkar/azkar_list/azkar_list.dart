//
//
// import 'package:azkar/Features/model/azkarModel.dart';
// import 'package:azkar/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../bloc/Azkar_cubit/azkar_cubit.dart';
// import '../../../bloc/Azkar_cubit/azkar_state.dart';
// import '../../../home/presentation/manager/home_bloc/Azkar_cubit/azkar_cubit.dart';
//
// class AzkarListScreen extends StatelessWidget {
//   const AzkarListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(title: Text('AZKAR TITE')),
//       body: BlocBuilder<AzkarCubit, AzkarState>(
//
//         builder: (context,_) {
//           AzkarCubit azkarCubit=   AzkarCubit.get(context);
//
//           return SingleChildScrollView(
//             child: Column(
//
//               children: azkarCubit.azkarList.map((e) =>cellList(e)).toList(),
//             ),
//           );
//         }
//       ),
//     );
//   }
//   Widget cellList(AzkarData azkarData) {
//     double height = MediaQuery.of(Get.context).size.height;
//     double width = MediaQuery.of(Get.context).size.width;
//
//     return ExpansionTile(leading: null,trailing: SizedBox(),tilePadding: EdgeInsets.zero,
//       childrenPadding:  EdgeInsets.zero,
//
//
//       title:  Container(
//       //  margin: EdgeInsets.only(top: 5),
//         color: Colors.white54,
//
//         height: height*.1,width:width ,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(    width: 35,            padding: const EdgeInsets.all(8.0),
//                 decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(12)),
//                 child: Center(child: Text(azkarData.count!,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),))),
//
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align( alignment: Alignment.centerRight,
//                   child: Text(azkarData.zekr!,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     textDirection: TextDirection.rtl,
//                     style: TextStyle(fontSize: 20),)
//               ),
//             )
//
//           ],
//         ),
//       ),
//
//    children: [ Container(
//      margin: EdgeInsets.only(top: 5),
//    width:width ,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Align( alignment: Alignment.centerRight,child: Text(azkarData.zekr!,maxLines: 3,overflow: TextOverflow.ellipsis,textDirection: TextDirection.rtl,style: TextStyle(fontSize: 20),)),
//          ),
//           Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Align( alignment: Alignment.centerRight,child: Text(azkarData.description!,maxLines: 3,overflow: TextOverflow.ellipsis,textDirection: TextDirection.rtl,style: TextStyle(fontSize: 20),)),
//          ),
//         Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Align( alignment: Alignment.centerRight,child: Text(azkarData.reference!,maxLines: 3,overflow: TextOverflow.ellipsis,textDirection: TextDirection.rtl,style: TextStyle(fontSize: 20),)),
//          )
//
//        ],
//      ),
//    ),
//    ],
//     );
//   }
//
// }
