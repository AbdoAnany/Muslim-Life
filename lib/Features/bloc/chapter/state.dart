import 'package:azkar/Features/model/chapter.dart';
abstract class ChapterState {

  final List<Chapter>? data;
  final String? message;

  ChapterState({
    this.data,
    this.message,
  });

  @override
  List<Object> get props => [
    data!,
    message!,
  ];
}

class ChapterInitState extends ChapterState {

}

class ChapterDefault extends ChapterState {}

class ChapterFetchLoading extends ChapterState {
   ChapterFetchLoading() : super();
}

class ChapterFetchSuccess extends ChapterState {
   ChapterFetchSuccess({List<Chapter>? data}) : super(data: data);
}

class ChapterFetchFailed extends ChapterState {
   ChapterFetchFailed({String? message}) : super(message: message);
}


class ChapterSearch extends ChapterState {
}

