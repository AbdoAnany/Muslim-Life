

import 'package:azkar/Features/bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:azkar/Features/bloc/bookmarks/cubit.dart';
import 'package:azkar/Features/bloc/bookmarks/state.dart';
import 'package:azkar/Features/bloc/chapter/cubit.dart';
import 'package:azkar/Features/bloc/chapter/state.dart';
import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/pages/home_screen/widgets/home_screen.dart';
import 'package:azkar/Features/scd.dart';
import 'package:azkar/core/animations/bottom_animation.dart';
import 'package:azkar/core/providers/app_provider.dart';
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
  void _next() async {
    // bool isNew = appProvider.init();
    final bookmarkCubit = BookmarkCubit.get(context);
    final chapterCubit = ChapterCubit.get(context);
    final azkarCubit = AzkarCubit.get(context);
    // final pray = MainBloc.get(context);
    azkarCubit.getAzkarModel();
  // await pray. getPrayTime();
    await chapterCubit.fetch();
    await bookmarkCubit.fetch();


    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=>const HomeScreen()),
        );
      }
    });
  }


  @override
  void initState() {
    _next();
    super.initState();
    initStateNFT();

  }


  @override
  void dispose() {
    disposeNTF();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkCubit = BookmarkCubit.get(context);
    final appProvider = Provider.of<AppProvider>(context);
    final pray = MainBloc.get(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetAnimator(
              child: Hero(

                tag:   StaticAssets.arabic,
                child: Image.asset(
                  StaticAssets.arabic,
                  height:MediaQuery.of(context).size.height*.5,
                ),
              ),
            ),

            Shimmer.fromColors(
              enabled: true,
              baseColor: appProvider.isDark ? Colors.white : Colors.black,
              highlightColor: appProvider.isDark ? Colors.grey : Colors.white,
              child: BlocBuilder<ChapterCubit, ChapterState>(
                builder: (context, state) {
                  if (state is ChapterFetchLoading) {
                    return const Text('تحميل سور القران ');
                  } else if (bookmarkCubit.state is BookmarkFetchLoading) {
                    return const Text('اعداد علامة ');
                  }else if (pray.state is MainSuccess) {
                    return const Text('اعداد مواقيت الصلاة');
                  }else
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
