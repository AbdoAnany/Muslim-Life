import 'dart:ui';

import 'package:azkar/Features/bloc/Sibha_cubit/misbaha_cubit.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/widgets/title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Misbaha extends StatelessWidget {
 late MisbahaCubit VM;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<MisbahaCubit, MisbahaState>(

          builder: (context, state) {
            VM = MisbahaCubit.get(context);
            return Scaffold(

              appBar: AppBar(
                  centerTitle: true,backgroundColor: Colors.transparent,
                  title:   const CustomTitle(
                    title: 'السبحة',
                  )),


              backgroundColor: kWhite,
              body: Stack(
                children: [
                  Positioned(
                    bottom: -250,
                    left: -200,
                    child: Opacity(
                        opacity: .2, child: Image.asset(StaticAssets.arabic)),
                  ),
                  Positioned(
                    top: 50,
                    left: -75,
                    child: Opacity(
                      opacity: .5,
                      child: Hero(
                          tag: StaticAssets.tasbih,
                          child: Image.asset(StaticAssets.tasbih,width: MediaQuery.of(context).size.height*.4,)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,

                    padding: EdgeInsets.symmetric(horizontal: 40,vertical: MediaQuery.of(context).size.height*.12),
                    child: Tooltip(
                        message: 'أضغط مطولا  لتصفير السبحة',
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onLongPress: () {
                                _showLogOutDialog(context);
                              },
                              onPressed: () {},
                              child: Text(
                                'عدد التسبيحات في المجموعة ${VM.GroubCounter}',textAlign: TextAlign.center,
                                style: TextStyle(fontSize:  MediaQuery.of(context).size.height*.05, color: Colors.black,),
                              ),
                            ),
                            Text(
                              'لتغير العدد اضغط فوق  مطولا ',textAlign: TextAlign.center,
                              style: TextStyle(fontSize:  MediaQuery.of(context).size.height*.02, color: Colors.black,),
                            ),

                            MaterialButton(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.1),

                              // onLongPress: () {
                              //   VM.ButtonCounter = -1;
                              //   VM.Counter = -1;
                              //   VM.Groub = 0;
                              //   VM.Clicked();
                              // },
                              // onPressed: () {    VM.ButtonCounter = -1;
                              // VM.Counter = -1;
                              // VM.Groub = 0;
                              // VM.Clicked();},
                              onPressed: () {  },
                              child: Text(
                                '${VM.Groub} عدد المجموعات ',
                                style:
                                TextStyle(fontSize:  MediaQuery.of(context).size.height*.035, color: Colors.black),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                MaterialButton(
                                  onLongPress: () {
                                    VM.ButtonCounter = -1;
                                    VM.Counter = -1;
                                    VM.Clicked();
                                  },
                                  onPressed: () {
                                    VM.Clicked();
                                  },
                                  child: Text(
                                    '${VM.ButtonCounter}',
                                    style: TextStyle(
                                        fontSize:  MediaQuery.of(context).size.height*.06,
                                        color: kMainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),




                                MaterialButton(
                                  onLongPress: () {
                                    VM.ButtonCounter = -1;
                                    VM.Counter = -1;
                                    VM.Groub = 0;
                                    VM.Clicked();
                                  },
                                  onPressed: () {    VM.ButtonCounter = -1;
                                  VM.Counter = -1;
                                  VM.Groub = 0;
                                  VM.Clicked();},
                                  child: Text(
                                    'صفر',
                                    style:
                                    TextStyle(fontSize:  MediaQuery.of(context).size.height*.03, color: Colors.black),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),

                ],
              ),
            );
          }),
    );
  }

  void _showLogOutDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('عدد التسبحات في كل مجموعة'),
            content: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black),
                //  gapPadding: 10,
              )),
              initialValue: VM.GroubCounter.toString(),
              keyboardType: TextInputType.number,
              onChanged: (e) {
                VM.GroubCounter = int.parse(e);
                VM.Changing();
              },
            ),
          );
        });
  }
}
