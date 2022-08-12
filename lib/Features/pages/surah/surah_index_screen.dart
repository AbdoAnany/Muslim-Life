
import 'package:azkar/Features/bloc/chapter/cubit.dart';
import 'package:azkar/Features/bloc/chapter/state.dart';
import 'package:azkar/Features/pages/surah/widgets/surah_tile.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/widgets/custom_image.dart';
import 'package:azkar/core/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SurahIndexScreen extends StatelessWidget {
  const SurahIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // App.init(context);
    final appProvider = Provider.of<AppProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocConsumer<ChapterCubit, ChapterState>(
      listener: (context, state) {},
      builder: (context, state) {
        ChapterCubit chapterCubit = ChapterCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor:
                  appProvider.isDark ? Colors.grey[850] : Colors.white,
              body: Stack(
                children: <Widget>[
                  Opacity(
                    opacity: .3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Hero(
                          tag: StaticAssets.koran,
                          child: Image.asset(
                            StaticAssets.koran,
                            height: MediaQuery.of(context).size.height * 0.22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomTitle(
                    title: 'سور القرآن الكريم',
                  ),
                  Positioned(
                    bottom: -200,
                    left: -200,
                    child: Opacity(
                        opacity: .2, child: Image.asset(StaticAssets.arabic)),
                  ),
                  if (chapterCubit.chapters.isEmpty)
                    Center(
                      child: BlocBuilder<ChapterCubit, ChapterState>(
                        builder: (context, state) {
                          if (state is ChapterFetchLoading) {
                            return LinearProgressIndicator(
                              //   backgroundColor: AppTheme.c!.accent,
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
                            );
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                              ),
                              Text(
                                'حدث خطاء ما',
                              ),
                              SizedBox(
                                child: ElevatedButton(
                                  // style: ButtonStyle(
                                  //   backgroundColor: MaterialStateProperty.all(
                                  //   ),
                                  // ),
                                  onPressed: () {
                                    chapterCubit.fetch(api: true);
                                  },
                                  child: const Text('أعادة'),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.17,
                      left: width * 0.05,
                      right: width * 0.05,
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        chapterCubit.surahSearchName();
                      },style:   TextStyle(
        fontSize:  MediaQuery.of(context).size.height * 0.03,
        ),
                      controller: chapterCubit.chaptercontroller,
                      decoration: InputDecoration(
                        hintText: 'أبحث عن السوره من هنا',
                        prefixIcon: Icon(
                          Icons.search,
                        ),  hintStyle:  TextStyle(
                        fontSize:  MediaQuery.of(context).size.height * 0.02,
                      ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  if (chapterCubit.chapters.isNotEmpty)
                    Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.22,
                        ),
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              Divider(color: kMainColor, height: 1),
                          itemCount: chapterCubit.chaptercontroller.text.isEmpty
                              ? chapterCubit.chapters.length
                              : chapterCubit.searchedChapters.length,
                          itemBuilder: (context, index) {
                            final chapter =
                                chapterCubit.searchedChapters[index];
                            return SurahTile(
                              chapter: chapter,
                            );
                          },
                        )),
                  Positioned(   top: 20,right: 0,

                      child:   IconButton(icon: Icon(Icons.arrow_back_outlined,color: kMainColor),onPressed: (){Navigator.of(context).pop();},)),

                  // if (appProvider.isDark) ...[
                  //   Flare(
                  //     color: const Color(0xfff9e9b8),
                  //     offset: Offset(width, -height),
                  //     bottom: -50,
                  //     flareDuration: const Duration(seconds: 17),
                  //     left: 100,
                  //     height: 60,
                  //     width: 60,
                  //   ),
                  //   Flare(
                  //     color: const Color(0xfff9e9b8),
                  //     offset: Offset(width, -height),
                  //     bottom: -50,
                  //     flareDuration: const Duration(seconds: 12),
                  //     left: 10,
                  //     height: 25,
                  //     width: 25,
                  //   ),
                  //   Flare(
                  //     color: const Color(0xfff9e9b8),
                  //     offset: Offset(width, -height),
                  //     bottom: -40,
                  //     left: -100,
                  //     flareDuration: const Duration(seconds: 18),
                  //     height: 50,
                  //     width: 50,
                  //   ),
                  //   Flare(
                  //     color: const Color(0xfff9e9b8),
                  //     offset: Offset(width, -height),
                  //     bottom: -50,
                  //     left: -80,
                  //     flareDuration: const Duration(seconds: 15),
                  //     height: 50,
                  //     width: 50,
                  //   ),
                  //   Flare(
                  //     color: const Color(0xfff9e9b8),
                  //     offset: Offset(width, -height),
                  //     bottom: -20,
                  //     left: -120,
                  //     flareDuration: const Duration(seconds: 12),
                  //     height: 40,
                  //     width: 40,
                  //   ),
                  // ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
