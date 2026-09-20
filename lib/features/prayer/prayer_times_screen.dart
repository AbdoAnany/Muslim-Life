import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/pages/home_screen/widgets/TimeView.dart';
import 'package:azkar/core/theme/app_tokens.dart';
import 'package:azkar/core/widgets/dls/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MainBloc.get(context).getPrayTime(forceRefresh: true);
    });
  }

  Future<void> _requestLocation() async {
    await Permission.location.request();
    await Geolocator.requestPermission();
    if (!mounted) return;
    await MainBloc.get(context).getPrayTime(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'مواقيت الصلاة',
      actions: [
        IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: _requestLocation,
        ),
      ],
      body: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            final bloc = MainBloc.get(context);
            if (bloc.prayList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(bloc.textState),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _requestLocation,
                      child: const Text('تفعيل الموقع وتحديث المواقيت'),
                    ),
                  ],
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              children: [
                if (MainBloc.currentPray != null)
                  Text(
                    'الصلاة الحالية: ${MainBloc.currentPray!.arabicName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (MainBloc.nextPray != null)
                  Text('التالية: ${MainBloc.nextPray!.arabicName}'),
                const SizedBox(height: 16),
                ...bloc.timingsList
                    .where((p) => p != null && (p!.englishName?.length ?? 0) < 7)
                    .map((p) => TimeView(pray: p!)),
              ],
            );
          },
        ),
    );
  }
}
