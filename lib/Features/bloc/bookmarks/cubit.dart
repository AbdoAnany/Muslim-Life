import 'package:azkar/Features/bloc/bookmarks/data_provider.dart';
import 'package:azkar/Features/bloc/bookmarks/state.dart';
import 'package:azkar/Features/model/chapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkInitState());

  static BookmarkCubit get(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<BookmarkCubit>(context, listen: listen);


  Future<void> fetch() async {
    emit( BookmarkFetchLoading());
    try {
      List<Chapter> data = await BookmarksDataProvider.fetch();

      emit(BookmarkFetchSuccess(data: data, isBookmarked: false));
    } catch (e) {
      emit(BookmarkFetchFailed(message: e.toString()));
    }
  }

  Future<void> updateBookmark(Chapter chapter, bool add) async {
    emit( BookmarkFetchLoading());
    try {
      List<Chapter> data = [];
      if (add) {
        data = await BookmarksDataProvider.addBookmark(chapter);
      } else {
        data = await BookmarksDataProvider.removeBookmark(chapter);
      }
      emit(
        BookmarkFetchSuccess(data: data, isBookmarked: add),
      );
    } catch (e) {
      emit(BookmarkFetchFailed(message: e.toString()));
    }
  }

  Future<void> checkBookmarked(Chapter chapter) async {
    emit( BookmarkFetchLoading());
    try {
      final isBookmarked = await BookmarksDataProvider.checkBookmarked(chapter);
      final data = await BookmarksDataProvider.fetch();
      emit(
        BookmarkFetchSuccess(
          data: data,
          isBookmarked: isBookmarked ?? false,
        ),
      );
    } catch (e) {
      emit(BookmarkFetchFailed(message: e.toString()));
    }
  }
}
