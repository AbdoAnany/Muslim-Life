import 'dart:convert';
import 'dart:core';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:azkar/Features/bloc/bookmarkCubit/BookMarkAppCubit.dart';
import 'package:azkar/Features/model/Azkar/azkar.dart';
import 'package:azkar/Features/model/azkarModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'azkar_state.dart';


class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit() : super(AzkarInitial());
  late List<AzkarCategoryNew>? azkarNewList;
  late List<AzkarCategoryNew>? filteredNewList;
  late List<AzkarItemNew> azkarDataNewList;
  late AzkarCategoryNew? azkarCategoryNew;
  late AzkarItemNew? azkarItemNew;


  late List<AzkarCategory>? azkarCategoriesList = [];
  late List<AzkarData> azkarList;
  late AzkarData azkarDataItem;

  static AzkarCubit get(context) => BlocProvider.of(context);
  // List<AzkarCategory> filteredList = [];

  TextEditingController azkarController = TextEditingController();
  bool SState = false, counterVisibility = false;
  late String textState;
  static  final AssetsAudioPlayer player = AssetsAudioPlayer();

  int currentIndex = 0, currentPage = 0;
  var currentPosition;
  final CarouselController carouselController = CarouselController();



  clearAzkarTappedNew(){
    currentIndex=0;
    azkarCategoryNew=null;
    azkarDataNewList=[];
  }
  Future<void> azkarTappedNew(AzkarCategoryNew Category) async {
    try {
      azkarList = [];
      textState = 'تحميل الاذكار';
      emit(AzkarLoading());
      azkarDataNewList = Category.array!;
      azkarCategoryNew=Category;
       print(  "Category.toJson()");
       print(  Category.toJson());
      int index=   BookMarkAppCubit.getAzkarCurrentIndex(Category.category!);
      currentIndex=index;
      print('BookMarkAppCubit index  ${index}');
      await onScrollNew(index);
      carouselController.jumpToPage(index);

      textState = 'تم تحميل الاذكار';
      emit(AzkarSuccess());
    } catch (ex) {}
  }


  Future<void> onScrollNew(index) async {
    currentIndex=index;

    BookMarkAppCubit.setAzkarCurrentIndex(azkarCategoryNew!.category,currentIndex);
    await Future.delayed(Duration(milliseconds: 600));
     azkarItemNew = azkarDataNewList[index];

    emit(AzkarSuccess());
  }





 static onClick() async {
    HapticFeedback.vibrate();
    await  player.open(
      Audio('assets/music/click.wav'),
    );
    await player.play();
    print('player');


  }
  Future<void> getAzkarModel() async {
  //  player.setAsset('azkar/music/click.wav');

    try {
      textState = 'تحميل الاذكار';
      emit(AzkarLoading());
      var jsonText = await rootBundle.loadString('assets/data/adhkar.json');
      dynamic userMap = jsonDecode(jsonText);
      azkarNewList = [];
      // print("userMap[Azkar].toString()");
      // print(userMap["Azkar"].toString());
      for (var element in userMap["Azkar"]) {
        azkarNewList!.add(AzkarCategoryNew.fromJson(element));
      }
      filteredNewList=azkarNewList;

      textState = 'تم تحميل الاذكار';
    //  onTap();
      emit(AzkarSuccess());
    } catch (ex) {}
  }

  Future<void> onTap() async {
   // player.play();
  // await onClick();
      carouselController.nextPage();

    emit(AzkarSuccess());
  }

  Future<void> searchState() async {
    emit(AzkarSearchLoading());
    SState = !SState;
    await search();
    //   controller = TextEditingController();
    //  Azkarcontroller.clear();
    emit(AzkarSearchSuccess());
  }

  Future<void> search() async {
    emit(AzkarSearchLoading());
    filteredNewList = [];
    if (azkarController.text == "" || azkarController.text == null) {
      filteredNewList!.addAll(azkarNewList!);
    } else {
      filteredNewList = [];
      for (var element in azkarNewList!) {
        if (element.category!.contains(azkarController.text)) {
          filteredNewList!.add(element);
        }
      }
      if (filteredNewList!.isEmpty) {
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


}

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