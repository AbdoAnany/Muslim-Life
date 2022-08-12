import 'package:azkar/Features/model/chapter.dart';

abstract class BookmarkState  {
  final List<Chapter>? data;
  final bool? isBookmarked;
  final String? message;

  const BookmarkState({
    this.data,
    this.message,
    this.isBookmarked = false,
  });

  @override
  List<Object> get props => [
        data!,
        message!,
        isBookmarked!,
      ];
}

class BookmarkInitState extends BookmarkState  {

}

class BookmarkDefault extends BookmarkState {}

class BookmarkFetchLoading extends BookmarkState {
  const BookmarkFetchLoading() : super();
}

class BookmarkFetchSuccess extends BookmarkState {
  const BookmarkFetchSuccess({List<Chapter>? data, bool? isBookmarked})
      : super(
          data: data,
          isBookmarked: isBookmarked,
        );
}

class BookmarkFetchFailed extends BookmarkState {
  const BookmarkFetchFailed({String? message}) : super(message: message);
}
