// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_vibrate/flutter_vibrate.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:azkar/Features/home/data/models/azkarModel.dart';
// import 'package:sqflite/sqflite.dart';
// part 'azkar_state.dart';
// //1
// class AzkarCubit extends Cubit<AzkarState> {
//   List? list;
//   AzkarCubit() : super(AzkarInitial());
//   static AzkarCubit get(context) => BlocProvider.of(context);
//   List<Azkardata>? filteredList = [], azkarlist = [];
//   TextEditingController? controller;
//   bool SState = false,counterVisibility = false;
//   String? textState;
//   AudioPlayer? player;
//   int counter = 0,currentPage = 0;
//   var currentPosition;
//   final CarouselController carouselController = CarouselController();
//
//
//
//   Future<void> azkartapped(Category) async {
//     try {
//       list = [];
//       textState = 'تحميل الاذكار';
//       emit(AzkarLoading());
//       azkarlist!.forEach((element) {
//         if (element.category == Category) {
//           list!.add(element);
//         }
//       });
//       await onscroll(0);
//       textState = 'تم تحميل الاذكار';
//       emit(AzkarSuccess());
//     } catch (ex) {}
//   }
//
//   Future<void> onscroll(index) async {
//     emit(ScrollAzkar());
//     await Future.delayed(Duration(milliseconds: 600));
//     if (list![index].count!.isNotEmpty)
//       counter = int.tryParse(list![index].count!)!;
//      else counter = 1;
//     if (counter > 0) counterVisibility = true;
//     else counterVisibility = false;
//     emit(AzkarSuccess());
//   }
//
//   Future<void> getAzkar() async {
//     try {
//       textState = 'تحميل الاذكار';
//       emit(AzkarLoading());
//       var jsonText = await rootBundle.loadString('assets/localdb/azkar.json');
//       dynamic userMap = jsonDecode(jsonText);
//       var azkar = Azkar.fromJson(userMap).azkar;
//       azkarlist = azkar.toSet().toList();
//       filteredList!.addAll(azkarlist!);
//       textState = 'تم تحميل الاذكار';
//       onTap();
//       emit(AzkarSuccess());
//     } catch (ex) {}
//   }
//
//   Future<void> onTap() async {
//     emit(AzkarLoading());
//
//     player = AudioPlayer();
//     player!.setAsset('assets/music/click.wav');
//     player!.play();
//     if (counter > 1) {
//
//       counter--;
//
//     } else {
//
//       if (await Vibrate.canVibrate) {
//         HapticFeedback.vibrate();
//       }
//       counterVisibility = false;
//       carouselController.nextPage();
//     }
//     emit(AzkarSuccess());
//   }
//
//
//
//   Future<void> searchstate() async {
//     emit(AzkarSearchLoading());
//     SState = !SState;
//     await search(controller?.text);
//     //   controller = TextEditingController();
//     controller?.clear();
//     emit(AzkarSearchSuccess());
//   }
//
//   Future<void> search(searchtext) async {
//     emit(AzkarSearchLoading());
//     filteredList=[];
//     if (searchtext == "" || searchtext == null) {
//       filteredList!.addAll(azkarlist!);
//     } else {
//       filteredList=[];
//       azkarlist!.forEach((element) {
//
//         if (element.category!.contains(searchtext)) {
//           filteredList!.add(element);
//         }
//       });
//       if (filteredList!.length < 1) {
//         textState = 'لا يوجد اذكار';
//       }
//
//
//     } emit(AzkarSearchSuccess());
//   }
//   void onChangeTap(index) {
//     emit(AzkarSearchLoading());
//     currentPage = index;
//     print(currentPage);
//     emit(AzkarSearchSuccess());
//   }
// //azkarList
//   Future<void> getazkar() async {
//     try {
//       textState = 'تحميل الاذكار';
//       emit(AzkarLoading());
//       var jsonText = await rootBundle.loadString('assets/localdb/azkar.json');
//       dynamic userMap = jsonDecode(jsonText);
//       var azkar = Azkar.fromJson(userMap).azkar;
//       azkarlist = azkar.toSet().toList();
//       filteredList!.addAll(azkarlist!);
//       textState = 'تم تحميل الاذكار';
//       onTap();
//       emit(AzkarSuccess());
//     } catch (ex) {}
//   }
// }
