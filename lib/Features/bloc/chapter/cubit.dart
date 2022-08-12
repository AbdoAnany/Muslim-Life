import 'dart:async';
import 'package:azkar/Features/bloc/chapter/cubit.dart';
import 'package:azkar/Features/bloc/chapter/repository.dart';
import 'package:azkar/Features/bloc/chapter/state.dart';
import 'package:azkar/Features/model/chapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChapterCubit extends Cubit<ChapterState> {
  ChapterCubit() : super(ChapterInitState());

  static ChapterCubit get(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<ChapterCubit>(context, listen: listen);

   TextEditingController chaptercontroller=TextEditingController();

  final repo = ChapterRepository();
  List<Chapter> chapters = [];
  List<Chapter> searchedChapters = [];
  Future<void> fetch({bool api = false}) async {
    emit( ChapterFetchLoading());
    try {
      chapters = await repo.chapterApi();
      searchedChapters =chapters;
      emit(ChapterFetchSuccess(data: chapters));
    } catch (e) {
      emit(ChapterFetchFailed(message: e.toString()));
    }
  }

  surahSearchName(){
    emit(ChapterSearch());
    searchedChapters=[];
    chaptercontroller.text.toLowerCase();
    if (chaptercontroller.text==''||chaptercontroller.text==null) {
      searchedChapters =chapters;
      emit(ChapterFetchSuccess());
    }
   else  {
      var lowerCaseQuery = chaptercontroller.text.toLowerCase().trim();
      searchedChapters=[];
        searchedChapters = chapters .where((chapter) {
          return chapter .nameSearch !.toLowerCase()
            .contains(lowerCaseQuery);
      }).toList(growable: false)
        ..sort((a, b) => a .nameSearch!
              .toLowerCase()
              .indexOf(lowerCaseQuery)
              .compareTo(
            b .nameSearch! .toLowerCase().indexOf(lowerCaseQuery),),
        );
      emit(ChapterDefault());

    }
  }

}
