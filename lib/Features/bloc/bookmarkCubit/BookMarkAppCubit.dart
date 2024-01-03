import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/Azkar/azkar.dart';

class BookMarkAppCubit extends Cubit<BookMarkAppStates> {
  BookMarkAppCubit() : super(InitialBookMarkAppState());
  static BookMarkAppCubit get(context) => BlocProvider.of(context);
  static late final SharedPreferences prefs;
  static var AppModel;
  bool IsDark = false;
  Locale _appLocale = Locale('en');
  static String today = DateFormat('M/d/y').format(DateTime.now());
  static String dayNow = DateTime.now().day.toString();
  static String keyAzkar = 'AzkarItem';
  static String keyAzkarIndex = 'AzkarIndex';
  Locale get appLocal => _appLocale; //?? Locale("en");
  static Future<void> inti() async {
    prefs = await SharedPreferences.getInstance();
  }

  static int  getAzkarCurrentIndex(keyCategory)=>int.parse((prefs.get(keyAzkarIndex+"-"+dayNow+'-'+keyCategory)??"0").toString());
  static setAzkarCurrentIndex(keyCategory,index) async =>await prefs.setString(keyAzkarIndex+"-"+dayNow+'-'+keyCategory,'${index}');

  //=================== AzkarItem============================
  static Future<void> clearAzkarDayCount() async {
    Set<String> bookmarkKeys = prefs.getKeys();
    bookmarkKeys.forEach((element) async {
      if(element.contains(keyAzkar)&&!element.contains(today)) {
        //print('clearAzkarDayCount ');
        //print('element ${element}   keyAzkar  ${keyAzkar}    today: ${today}');

        prefs.setString(element, '');
      }
    });
  }
  static Future<void> saveAzkarItemCount(AzkarItemNew itemNew) async {
    // String bookmarks = prefs.getString(itemNew.id.toString()+itemNew.filename!)??'';
    String decode = jsonEncode(itemNew);
    await prefs.setString(keyAzkar+'-'+today +'-'+ itemNew.id.toString() +'-'+ itemNew.filename!, decode);
  }
  static int getAzkarItemNewCountById(AzkarItemNew itemNew) {
    var a = prefs.get(keyAzkar+'-'+today +'-'+ itemNew.id.toString() +'-'+ itemNew.filename!);
    if (a == null) return 0;
    AzkarItemNew decode = AzkarItemNew.fromJson(jsonDecode(a.toString()));
    return decode.currentCount ?? 0;
  }



}















abstract class BookMarkAppStates {
  const BookMarkAppStates();
}

class InitialBookMarkAppState extends BookMarkAppStates {}

class AppChangeModeState extends BookMarkAppStates {}

class AppChangeLangState extends BookMarkAppStates {}
