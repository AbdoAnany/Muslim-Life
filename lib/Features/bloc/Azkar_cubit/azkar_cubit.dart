
import 'dart:convert';
import 'dart:core';

import 'package:azkar/Features/model/azkarModel.dart';
import 'package:bloc/bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'azkar_state.dart';

class Model {
  late String category;
  late List AzkarList;

  Model(this.category, this.AzkarList);

  Model.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      if (json['category'] == category) AzkarList.add(json);
    }
  }
}

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit() : super(AzkarInitial());

  late List<AzkarCategory>? azkarCategoriesList = [];
 late  List<AzkarData> Azkarlist;

  static AzkarCubit get(context) => BlocProvider.of(context);
  List<AzkarCategory> filteredList = [];
   TextEditingController Azkarcontroller=TextEditingController();
  bool SState = false, counterVisibility = false;
  late   String textState;
  late   AudioPlayer player;
  int counter = 0, currentPage = 0;
  var currentPosition;
  final CarouselController carouselController = CarouselController();

  Future<void> azkartapped(AzkarCategory Category) async {
    try {
      Azkarlist = [];
      textState = 'تحميل الاذكار';
      emit(AzkarLoading());
      Azkarlist =Category.azkarList!;

      await onscroll(0);
      textState = 'تم تحميل الاذكار';
      emit(AzkarSuccess());
    } catch (ex) {}
  }

  Future<void> onscroll(index) async {
    emit(ScrollAzkar());
    await Future.delayed(Duration(milliseconds: 600));
    if (Azkarlist[index].count!.isNotEmpty) {
      counter = int.tryParse(Azkarlist[index].count!)!;
    } else {
      counter = 1;
    }
    if (counter > 0) {
      counterVisibility = true;
    } else {
      counterVisibility = false;
    }
    emit(AzkarSuccess());
  }

  Future<void> getAzkar() async {
    try {
      textState = 'تحميل الاذكار';
      emit(AzkarLoading());
      var jsonText = await rootBundle.loadString('assets/data/azkar.json');
      dynamic userMap = jsonDecode(jsonText);
      for (var element in userMap["Azkar"]) {
        azkarCategoriesList!.add(AzkarCategory.fromJson(element));
      }

      textState = 'تم تحميل الاذكار';
      onTap();
      emit(AzkarSuccess());
    } catch (ex) {

    }
  }

  Future<void> onTap() async {
    emit(AzkarLoading());

    player = AudioPlayer();
    player.setAsset('azkar/music/click.wav');
    player.play();
    if (counter > 1) {
      counter--;
    } else {
      // if (await Vibrate.canVibrate) {
      //   HapticFeedback.vibrate();
      // }
      counterVisibility = false;
      carouselController.nextPage();
    }
    emit(AzkarSuccess());
  }

  Future<void> searchstate() async {
    emit(AzkarSearchLoading());
    SState = !SState;
    await search();
    //   controller = TextEditingController();
    //  Azkarcontroller.clear();
    emit(AzkarSearchSuccess());
  }

  Future<void> search() async {
    emit(AzkarSearchLoading());
    filteredList = [];
    if (Azkarcontroller.text == "" || Azkarcontroller.text == null) {
      filteredList.addAll(azkarCategoriesList!);
    } else {
      filteredList = [];
      for (var element in azkarCategoriesList!) {
        if (element.category!.contains(Azkarcontroller.text)) {
          filteredList.add(element);
        }
      }
      if (filteredList.isEmpty) {
        textState = 'لا يوجد اذكار';
      }
    }
    emit(AzkarSearchSuccess());
  }

  void onChangeTap(index) {
    emit(AzkarSearchLoading());
    currentPage = index;
    emit(AzkarSearchSuccess());
  }

//azkarList
//   Future<void> getazkar() async {
//     try {
//       textState = 'تحميل الاذكار';
//       emit(AzkarLoading());
//       var jsonText = await rootBundle.loadString('assets/localdb/azkar.json');
//       dynamic userMap = jsonDecode(jsonText);
//      List azkarCategoryList=[];
//       print(userMap[ "Azkar"]);
//      for(var element in  userMap[ "Azkar"])
//        {
//          if(azkarCategoryList.contains(element[ "category"])) {
//            azkarCategoryList.add(element[ "category"]);
//          }
//
//
//        }
//      print(azkarCategoryList);
//
//       // var azkar = Azkar.fromJson(userMap).azkar;
//       // azkarlist = azkar.toSet().toList();
//       // filteredList.addAll(azkarlist);
//       textState = 'تم تحميل الاذكار';
//       onTap();
//       emit(AzkarSuccess());
//     } catch (ex) {}
//   }
}
