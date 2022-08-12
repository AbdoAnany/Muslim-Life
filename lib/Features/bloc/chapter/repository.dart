import 'package:azkar/Features/bloc/chapter/data_provider.dart';
import 'package:azkar/Features/model/chapter.dart';

class ChapterRepository {
  Future<List<Chapter>> chapterApi() => ChapterDataProvider.chapterApi();

 // Future<List<Chapter?>?> chapterHive() => ChapterDataProvider.chapterHive();
}
