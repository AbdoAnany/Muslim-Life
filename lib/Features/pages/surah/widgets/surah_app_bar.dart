import 'package:azkar/Features/model/chapter.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:flutter/material.dart';

class SurahAppBar extends StatelessWidget {
  final Chapter data;

  const SurahAppBar({
    Key? key,
     required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = AppProvider.get(context);

    return FlexibleSpaceBar(
      centerTitle: true,
      // title: Text(
      //   data!.name!,
      //   style: AppText.b2b,
      // ),
      background: Stack(
        children: <Widget>[


          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[


                Hero(
                    tag: 'sname_${data.number.toString()}',
                    child: Image.asset(
                        'assets/surat/sname_${data.number.toString()}.png',
                        color:   !appProvider.isDark ? Colors.blueGrey.shade900 : Colors.white,
                        height: MediaQuery.of(context).size.height*.09,

                        fit: BoxFit.contain))

              ],
            ),
          ),
        ],
      ),
    );
  }
}
