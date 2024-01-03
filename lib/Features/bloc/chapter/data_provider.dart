//dart=2.9
import 'dart:convert';

import 'package:azkar/Features/model/chapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class ChapterDataProvider {
 // static final cache = Hive.box('data');

  static Dio ins = Dio();

  static Future<List<Chapter>> chapterApi() async {
    try {
      final resp = await json.decoder
          .convert(await rootBundle.loadString('assets/data/surahs.json'));

      final Map<String, dynamic> raw = resp['data'];
      final List s = resp['surat'];

      final List data = raw['surahs'];



      final List<Chapter> chapters = List.generate(
        data.length,
        (index) {
       var a= Chapter.fromMap(data[index]);
       a.nameSearch=s[index]['name'];

          return a;
        },
      );
      // await cache.put(
      //   'chapters',
      //   chapters,
      // );

     // chapters.forEach((element) { //print(element.nameSearch);});

      return chapters;
    } on DioError catch (e) {
      if (e.type == DioErrorType.badResponse) {
        throw Exception('Problem with internet connection');
      } else {
        throw Exception('Problem on our side, Please try again');
      }
    } catch (e) {
      throw Exception("Internal Server Error");
    }
  }
  //
  // static Future<List<Chapter?>?> chapterHive1() async {
  //   try {
  //     final chapter = await cache.get('chapters');
  //
  //     if (chapter == null) return null;
  //
  //     final List<Chapter?>? chapters = List.from(chapter);
  //
  //     return chapters;
  //   } catch (e) {
  //     throw Exception("Internal Server Error");
  //   }
  // }
}
