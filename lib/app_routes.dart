import 'package:azkar/Features/pages/azkar/azkar_index_screen.dart';
import 'package:azkar/Features/pages/home_screen/main_screen.dart';
import 'package:azkar/Features/pages/surah/surah_index_screen.dart';
import 'package:azkar/core/widgets/misbaha.dart';
import 'package:azkar/core/widgets/qibla.dart';
import 'package:azkar/features/content/content_detail_screen.dart';
import 'package:azkar/features/content/content_list_screen.dart';
import 'package:azkar/features/dhikr_audio/dhikr_azkar_screen.dart';
import 'package:azkar/features/dhikr_audio/dhikr_schedule_screen.dart';
import 'package:azkar/features/about/about_screen.dart';
import 'package:azkar/features/content/content_favorites_screen.dart';
import 'package:azkar/features/onboarding/onboarding_screen.dart';
import 'package:azkar/features/prayer/prayer_times_screen.dart';
import 'package:azkar/features/quran_audio/quran_reciters_screen.dart';
import 'package:azkar/features/quran_reader/quran_reader_screen.dart';
import 'package:azkar/features/web/local_html_screen.dart';
import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:azkar/models/tasbeeh/build_azkar.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static void openHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (_) => false,
    );
  }

  static void openAction(BuildContext context, ApiModel model) {
    switch (model.appModel) {
      case AppModel.zeker:
        if (BuildAzkar.isPlay()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DhikrScheduleScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DhikrAzkarScreen()),
          );
        }
        break;
      case AppModel.quranReader:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuranReaderScreen()),
        );
        break;
      case AppModel.quran:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuranRecitersScreen()),
        );
        break;
      case AppModel.hades:
      case AppModel.doaaInQuran:
      case AppModel.firstInIslam:
      case AppModel.azkarElyome:
      case AppModel.islamEvents:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentListScreen(catalog: model.appModel, title: model.title),
          ),
        );
        break;
      case AppModel.hisnMuslim:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AzkarIndexScreen()),
        );
        break;
      case AppModel.prayer:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
        );
        break;
      case AppModel.qibla:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QiblahCompassWidget()),
        );
        break;
      case AppModel.sibha:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Misbaha()),
        );
        break;
      case AppModel.convertDate:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LocalHtmlScreen(
              title: model.title,
              assetPath: 'assets/convertdate.html',
            ),
          ),
        );
        break;
      case AppModel.about:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        );
        break;
      case AppModel.bookmarks:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ContentFavoritesScreen()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SurahIndexScreen()),
        );
    }
  }

  static void openContentDetail(BuildContext context, ApiModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ContentDetailScreen(item: item)),
    );
  }

  static void openOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }
}
