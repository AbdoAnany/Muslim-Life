import 'package:bloc/bloc.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  PrayerCubit() : super(PrayerInitial());
  static PrayerCubit get(context) => BlocProvider.of(context);
  Map images = {
    "Fajr": "assets/images/FR.gif",
    "Sunrise": "assets/images/SR.gif",
    "Dhuhr": "assets/images/ZH.gif",
    "Asr": "assets/images/AS.gif",
    "Maghrib": "assets/images/MA.gif",
    "Isha": "assets/images/IS.gif"
  };
  Map prayerName = {
    "Fajr": "الفجر",
    "Sunrise": "الشروق",
    "Dhuhr": "الظهر",
    "Asr": "العصر",
    "Maghrib": "المغرب",
    "Isha": "العشاء"
  };
  List<Map> model = [];
  String? textState;
  countTime(String item) {
    emit(PrayerLoading());
   var t=item.split(' ').first;
   var  h=int.parse(t.split(":").first);
   var  m=int.parse(t.split(":")[1]);
   if(item.split(' ')[1]=='PM') h=h+12;
   var hour= h-DateTime.now().hour;
  var minute = m-DateTime.now().minute;
  if(hour<0)
    hour+=24;
   if(minute<0)
     minute+=60;

    emit(PrayerSuccess());
if(h==1)  return" ${(minute).toStringAsFixed(0)}" +'دقيقة';
   return" ${(hour).toStringAsFixed(0)} "+ ' ساعة'+"و  ${(minute).toStringAsFixed(0)}" +'دقيقة';

  }
  // Future<void> getPrayTime() async {
  //   emit(PrayerLoading());
  //   textState = "تحميل بيانات الصلاة لليوم";
  //   var parser = await Chaleno().load(
  //       'https://www.islamicfinder.org/prayer-widget/360630/shafi/2/0/19.5/17.5');
  //   var header = parser!.getElementsByClassName(
  //       'd-flex flex-direction-row flex-justify-sb pad-top-sm pad-left-sm pad-right-sm  ');
  //   header.forEach((element) {
  //     var remaining = 'الان صلاة';
  //
  //     model.add({
  //       "Salat": prayerName[element.text!.trim().split('\n')[0].trim()],
  //       "Time": element.text!.trim().split('\n')[1].trim(),
  //       "Image": images[element.text!.trim().split('\n')[0].trim()],
  //       "Remaining":   countTime(element.text!.trim().split('\n')[1].trim()),
  //     });
  //   });
  //   model.sort((a, b) => (a['Remaining'].toString().length
  //       .compareTo(b['Remaining'].toString().length)));
  //   textState = "تم تحميل البيانات";
  //   emit(PrayerSuccess());
  // }
}
