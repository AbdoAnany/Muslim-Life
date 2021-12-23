import 'package:khushoo3/Features/home/presentation/widget/custom_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:khushoo3/Features/home/presentation/widget/slider_widget.dart';

class Home extends StatefulWidget {
  static final drawerController = ZoomDrawerController();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        ZoomDrawer.of(context)!.toggle();
      },
      child:


 Scaffold(backgroundColor:  Colors.transparent,
            body: ZoomDrawer(
          controller: Home.drawerController,
          style: DrawerStyle.Style7,
          menuScreen: CustomDrawer(),
          mainScreen: MySlider(),
          borderRadius: 24.0,
          isRtl: true,
          showShadow: true,
          angle: -12.0,
          mainScreenScale: .1,
         // backgroundColor: Colors.black,
          slideWidth: MediaQuery.of(context).size.width * .45,
        )),

    );
  }
}
