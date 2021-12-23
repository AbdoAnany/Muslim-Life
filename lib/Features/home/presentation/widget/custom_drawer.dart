import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:khushoo3/Features/home/presentation/manager/home_bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:khushoo3/Features/home/presentation/page/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khushoo3/Features/home/presentation/widget/azkarbuilder.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  var _controller = new ScrollController();
  var Tabs = [
    "الأذكار",
    "السبحة",
    "القبلة",

  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AzkarCubit, AzkarState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
              color: Colors.white,
              alignment: Alignment.topRight,
              height: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 50),
              child: SingleChildScrollView(
                controller: _controller,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      ...List.generate(
                        Tabs.length,
                        (index) => MaterialButton(
                          child: Text(
                            Tabs[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 5.0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            AzkarCubit.get(context).onChangeTap(index);
                            ZoomDrawer.of(context)!.toggle();
                          },
                        ),
                      )
                    ]),
              ));
        });
  }
}

class CustomListTile extends StatelessWidget {
  final String? title;
  final String? image;
  final Function? onTap;
  final bool isImage;
  final IconData? icon;
  CustomListTile(
      {this.title, this.image, this.onTap, this.isImage = false, this.icon});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          leading:
              isImage ? Image.asset(image!) : Icon(icon, color: Colors.white),
          title: Text(
            title!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 7, 7, 7),
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 5.0,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
