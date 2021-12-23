import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khushoo3/Features/home/presentation/manager/home_bloc/Sibha_cubit/misbaha_cubit.dart';


class misbaha extends StatelessWidget {
  MisbahaCubit? VM;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MisbahaCubit(),
      child: BlocConsumer<MisbahaCubit, MisbahaState>(
          listener: (context, state) {},
          builder: (context, state) {
            VM = MisbahaCubit.get(context);
            return Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Tooltip(
                  message: 'أضغط مطولا  لتصفير السبحة',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onLongPress: () {
                          _showLogOutDialog(context);
                        },
                        onPressed: () {},
                        child: Text(
                          'عدد التسبيحات في المجموعة ${VM!.GroubCounter}',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onLongPress: () {
                              VM!.ButtonCounter = -1;
                              VM!.Counter = -1;
                              VM!.Clicked();
                            },
                            onPressed: () {
                              VM!.Clicked();
                            },
                            child: Text(
                              '${VM!.ButtonCounter}',
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                       SizedBox(width: 100,),
                          MaterialButton(
                            onLongPress: () {
                              VM!.ButtonCounter = -1;
                              VM!.Counter = -1;
                              VM!.Groub = 0;
                              VM!.Clicked();
                            },
                            onPressed: () {    VM!.ButtonCounter = -1;
                            VM!.Counter = -1;
                            VM!.Groub = 0;
                            VM!.Clicked();},
                            child: Text(
                              '${VM!.Groub}',
                              style:
                              TextStyle(fontSize: 25, color: Colors.black),
                            ),
                          ),

                        ],
                      )
                    ],
                  )),
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
              initialValue: VM!.GroubCounter.toString(),
              keyboardType: TextInputType.number,
              onChanged: (e) {
                VM!.GroubCounter = int.parse(e);
                VM!.Changing();
              },
            ),
          );
        });
  }
}
