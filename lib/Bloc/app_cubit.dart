import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStates {}

class InitialAppStates extends AppStates {}

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppStates());

  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  List<ApiModel> menuList = [
    ApiModel.home(
      itemId: '01',
      title: 'تسبيح / أذكار صوتية',
      photo: 'azkar_audio.png',
      subtype: ApiSubType.Zeker,
      appModel: AppModel.zeker,
    ),
    ApiModel.home(
      itemId: '02',
      title: 'القرآن الكريم (نص + تفسير)',
      photo: 'koran.png',
      subtype: ApiSubType.Open_view,
      appModel: AppModel.quranReader,
    ),
    ApiModel.home(
      itemId: '03',
      title: 'القرآن الكريم (صوت)',
      photo: 'quran_audio.png',
      url: 'https://api.alquran.cloud/v1/edition/format/audio',
      subtype: ApiSubType.Open_sound,
      appModel: AppModel.quran,
    ),
    ApiModel.home(
      itemId: '04',
      title: 'حصن المسلم',
      photo: 'hisn_muslim.png',
      subtype: ApiSubType.Open_view,
      appModel: AppModel.hisnMuslim,
    ),
    ApiModel.home(
      itemId: '05',
      title: 'أحاديث نبوية',
      photo: 'hadith_scroll.png',
      subtype: ApiSubType.Open_list_db,
      appModel: AppModel.hades,
      readFrom: ApiReadFrom.database,
    ),
    ApiModel.home(
      itemId: '06',
      title: 'الدعاء في القرآن',
      photo: 'doaa_quran.png',
      subtype: ApiSubType.Open_list_db,
      appModel: AppModel.doaaInQuran,
      readFrom: ApiReadFrom.database,
    ),
    ApiModel.home(
      itemId: '07',
      title: 'الأوائل في الإسلام',
      photo: 'first_islam.png',
      subtype: ApiSubType.Open_list_db,
      appModel: AppModel.firstInIslam,
      readFrom: ApiReadFrom.database,
    ),
    ApiModel.home(
      itemId: '08',
      title: 'أذكار اليوم',
      photo: 'azkar_day.png',
      subtype: ApiSubType.Open_list_db,
      appModel: AppModel.azkarElyome,
      readFrom: ApiReadFrom.database,
    ),
    ApiModel.home(
      itemId: '09',
      title: 'الأحداث الإسلامية',
      photo: 'islam_events.png',
      subtype: ApiSubType.Open_list_db,
      appModel: AppModel.islamEvents,
      readFrom: ApiReadFrom.database,
    ),
    ApiModel.home(
      itemId: '10',
      title: 'مواقيت الصلاة',
      photo: 'prayer_clock.png',
      subtype: ApiSubType.Open_view,
      appModel: AppModel.prayer,
    ),
    ApiModel.home(
      itemId: '11',
      title: 'القبلة',
      photo: 'qibla_compass.png',
      subtype: ApiSubType.Open_view,
      appModel: AppModel.qibla,
    ),
    ApiModel.home(
      itemId: '12',
      title: 'السبحة',
      photo: 'sibha_counter.png',
      subtype: ApiSubType.Open_view,
      appModel: AppModel.sibha,
    ),
    ApiModel.home(
      itemId: '13',
      title: 'محول التقويم',
      photo: 'convert_date.png',
      url: 'assets/convertdate.html',
      subtype: ApiSubType.Open_url,
      appModel: AppModel.convertDate,
    ),
    ApiModel.home(
      itemId: '14',
      title: 'المفضلة',
      photo: 'bookmarks.png',
      subtype: ApiSubType.Open_view,
      appModel: AppModel.bookmarks,
    ),
    ApiModel.home(
      itemId: '15',
      title: 'عن التطبيق',
      photo: 'about_app.png',
      subtype: ApiSubType.Open_about,
      appModel: AppModel.about,
    ),
  ];

  void getHomeData() {
    emit(InitialAppStates());
  }
}
