
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AyahBottom extends StatelessWidget {
  const AyahBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const[
          Text(
            "رَّبِّ ٱغْفِرْ لِى وَلِوَٰلِدَىَّ وَلِمَن دَخَلَ بَيْتِىَ مُؤْمِنًۭا وَلِلْمُؤْمِنِينَ وَٱلْمُؤْمِنَٰتِ وَلَا تَزِدِ ٱلظَّٰلِمِينَ إِلَّا تَبَارًۢاِ",
            textAlign: TextAlign.center,
           // style: AppText.b2!.copyWith(color: Colors.white,),
          ),
        //  Space.y!,
          SizedBox(width: 50,
            child: Text(
              "سُورَةُ غَافِرٍ",maxLines: 1,
             // style: AppText.l1!.copyWith(color:  Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
