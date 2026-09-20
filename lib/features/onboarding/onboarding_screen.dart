import 'package:azkar/app_routes.dart';
import 'package:azkar/core/storage/cash_local.dart';
import 'package:azkar/core/widgets/home_widget_bridge.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  bool _dark = false;
  String _lang = 'ar';
  int _dhikrMinutes = 15;

  Future<void> _finish() async {
    await CashLocal.saveBool('onboarding_complete', true);
    await CashLocal.saveBool('is_dark', _dark);
    await CashLocal.saveCash('app_lang', _lang);
    await CashLocal.saveCash('ZekerTime', '{"hours":0,"minutes":$_dhikrMinutes}');
    await HomeWidgetBridge.updateDhikr('سبحان الله', 0);
    if (!mounted) return;
    AppRoutes.openHome(context);
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
    await Permission.location.request();
    await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (p) => setState(() => _page = p),
                  children: [
                    _buildPage(
                      title: 'مرحباً في حياة المسلم',
                      body: 'تطبيق شامل للأذكار، القرآن، مواقيت الصلاة، والقبلة.',
                      child: const Icon(Icons.mosque, size: 80),
                    ),
                    _buildPage(
                      title: 'اللغة والمظهر',
                      body: 'اختر لغة الواجهة والوضع الليلي.',
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text('الوضع الداكن'),
                            value: _dark,
                            onChanged: (v) => setState(() => _dark = v),
                          ),
                          ListTile(
                            title: const Text('اللغة'),
                            trailing: DropdownButton<String>(
                              value: _lang,
                              items: const [
                                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                                DropdownMenuItem(value: 'en', child: Text('English')),
                              ],
                              onChanged: (v) => setState(() => _lang = v ?? 'ar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPage(
                      title: 'التنبيهات والموقع',
                      body: 'اسمح بالتنبيهات لمواقيت الصلاة والأذكار، والموقع لحساب المواقيت والقبلة.',
                      child: ElevatedButton(
                        onPressed: _requestPermissions,
                        child: const Text('منح الأذونات'),
                      ),
                    ),
                    _buildPage(
                      title: 'الذكر الافتراضي',
                      body: 'حدد الفترة بين تذكيرات الذكر الصوتي (Tasbeeh-style).',
                      child: Slider(
                        min: 3,
                        max: 120,
                        divisions: 39,
                        value: _dhikrMinutes.toDouble(),
                        label: '$_dhikrMinutes د',
                        onChanged: (v) => setState(() => _dhikrMinutes = v.round()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_page + 1} / 4'),
                    ElevatedButton(
                      onPressed: () {
                        if (_page < 3) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        } else {
                          _finish();
                        }
                      },
                      child: Text(_page < 3 ? 'التالي' : 'ابدأ'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String body, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(body, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}
