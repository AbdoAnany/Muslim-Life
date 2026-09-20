import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/bookmarks/cubit.dart';
import 'package:azkar/Features/bloc/bookmarks/state.dart';
import 'package:azkar/Features/bloc/chapter/cubit.dart';
import 'package:azkar/Features/bloc/chapter/state.dart';
import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/app_routes.dart';
import 'package:azkar/core/animations/bottom_animation.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/storage/cash_local.dart';
import 'package:azkar/core/theme/app_tokens.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _bootstrap() async {
    final azkarCubit = AzkarCubit.get(context);
    final chapterCubit = ChapterCubit.get(context);
    final bookmarkCubit = BookmarkCubit.get(context);
    final mainBloc = MainBloc.get(context);

    try {
      azkarCubit.getAzkarModel();
      await chapterCubit.fetch().timeout(const Duration(seconds: 15));
      await bookmarkCubit.fetch().timeout(const Duration(seconds: 10));
      await mainBloc.getPrayTime().timeout(const Duration(seconds: 20));
    } catch (_) {
      // Continue to UI even if a bootstrap step fails.
    }

    if (!mounted) return;
    final onboardingDone = CashLocal.getBool('onboarding_complete');
    if (!onboardingDone) {
      AppRoutes.openOnboarding(context);
      return;
    }
    AppRoutes.openHome(context);
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkCubit = BookmarkCubit.get(context);
    final appProvider = Provider.of<AppProvider>(context);
    final pray = MainBloc.get(context);

    return Scaffold(
      backgroundColor: AppTokens.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetAnimator(
              child: Hero(
                tag: StaticAssets.arabic,
                child: Image.asset(
                  StaticAssets.arabic,
                  height: MediaQuery.of(context).size.height * .5,
                ),
              ),
            ),
            Shimmer.fromColors(
              enabled: true,
              baseColor: AppTokens.courtyardMuted,
              highlightColor: AppTokens.brand.withOpacity(0.35),
              child: BlocBuilder<ChapterCubit, ChapterState>(
                builder: (context, state) {
                  if (state is ChapterFetchLoading) {
                    return const Text('تحميل سور القران ');
                  } else if (bookmarkCubit.state is BookmarkFetchLoading) {
                    return const Text('اعداد علامة ');
                  } else if (pray.state is MainSuccess) {
                    return const Text('اعداد مواقيت الصلاة');
                  }
                  return const Text('تحميل البيانات ');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
