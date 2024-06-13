import 'package:azkar/Features/model/chapter.dart';
import 'package:azkar/core/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SurahInformation extends StatefulWidget {
  final  Chapter chapterData;

  const SurahInformation({
    Key? key,
    required this.chapterData,
  }) : super(key: key);

  @override
  _SurahInformationState createState() => _SurahInformationState();
}

class _SurahInformationState extends State<SurahInformation>
    with SingleTickerProviderStateMixin {
   late AnimationController controller;
   late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ScaleTransition(
      scale: scaleAnimation,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            width: width * 0.75,
            height: height * 0.37,
            decoration: ShapeDecoration(
              color: appProvider.isDark ? Colors.grey[800] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // style: GoogleFonts.scheherazadeNew(   fontSize: height * 0.05,color:Colors.grey.shade900),
           //     style: GoogleFonts.lato(   fontSize: height * 0.05,color:Colors.grey.shade900),

                Text(
                  'Surah Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.03,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.chapterData.englishName!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      widget.chapterData.name!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Text("Ayahs: ${widget.chapterData .ayahs !.length}"),
                Text("Surah Number: ${widget.chapterData .number }"),
                Text("Revelation: ${widget.chapterData .revelationType }"),
                Text("Meaning: ${widget.chapterData .englishNameTranslation }"),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.05,
                  child: ElevatedButton(
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(
                    //   //  AppTheme.c .accent,
                    //   ),
                    // ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
