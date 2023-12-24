import 'package:azkar/Features/pages/azkar/azkar_index_screen.dart';
import 'package:azkar/Features/pages/surah/surah_index_screen.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/widgets/misbaha.dart';
import 'package:azkar/core/widgets/qibla.dart';

class DrawerUtils {
  static  List items = [
    {
      'title': 'القرآن الكريم',
      "imagePath": StaticAssets.koran,
      'route': SurahIndexScreen(),
    },
    {
      'title': 'حصن المسلم',
      "imagePath": StaticAssets.pray,
      'route': AzkarIndexScreen(),
    },
    {
      'title': 'السبحة',
      "imagePath": StaticAssets.tasbih,
      'route': Misbaha(),
    },
    {
      'title': 'القبلة',
      "imagePath": StaticAssets.qibla,
      'route': QiblahCompassWidget(),
    },
    // {
    //   'title': 'أرشادات',
    //   'icon': Icons.help_outline,
    //   'route': 'help',
    // },
    // {
    //   'title': 'Introduction',
    //   'icon': Icons.info_outline,
    //   'route': 'intro',
    // },
    // {
    //   'title': 'مشاركة التطبيق',
    //   "imagePath": StaticAssets.frame,
    //   'route': 'share',
    // },
  ];
}
