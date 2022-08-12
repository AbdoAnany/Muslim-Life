
import 'dart:async';
import 'dart:io';

import 'package:azkar/Features/bloc/main_bloc/main_bloc.dart';
import 'package:azkar/Features/bloc/main_bloc/main_state.dart';
import 'package:azkar/Features/pages/home_screen/widgets/home_screen.dart';
import 'package:azkar/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainScreen> with TickerProviderStateMixin {
   late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

   late bool _canBeDragged;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / MainBloc.maxSlide;
      animationController.value -= delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = -details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  Future<bool> _onWillPop() async {
    return (await (showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text(
              "Exit Application",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text("Are You Sure?"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  exit(0);
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ) as FutureOr<bool>)) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // App.init(context);
    // final appProvider = BlocProvider.of<AppProvider>(context);
    MainBloc.maxSlide = MediaQuery.of(context).size.width * 0.835;
    SizeConfig().init(context);

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, mainState) {},
      builder: (context, mainState) {


        return Scaffold(


          backgroundColor: Colors.transparent,
          extendBody: true,
          body: WillPopScope(
            onWillPop: _onWillPop,
            child: GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              behavior: HitTestBehavior.translucent,
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, _) {
                  return Material(
                    //  color: appProvider.isDark ? Colors.grey[850] : Colors.white70,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[

                        HomeScreen(),
                        // Transform.translate(
                        //   offset: Offset(
                        //       -MainBloc.maxSlide *
                        //           (animationController.value - 1),
                        //       0),
                        //   child: Transform(
                        //     transform: Matrix4.identity()
                        //       ..setEntry(3, 2, 0.001)
                        //       ..rotateY(-math.pi /
                        //           2 *
                        //           (1 - animationController.value)),
                        //     alignment: Alignment.centerLeft,
                        //     child: CustomDrawer(
                        //         animationController: animationController),
                        //   ),
                        // ),
                        // Transform.translate(
                        //   offset: Offset(
                        //       -MainBloc.maxSlide * animationController.value,
                        //       0),
                        //   child: Transform(
                        //     transform: Matrix4.identity()
                        //       ..setEntry(3, 2, 0.001)
                        //       ..rotateY(
                        //           math.pi / 2 * animationController.value),
                        //     alignment: Alignment.centerRight,
                        //     child: HomeScreen(),
                        //   ),
                        // ),
                        // Positioned(
                        //   top: MediaQuery.of(context).size.height * 0.02,
                        //   right: width * 0.01 +
                        //       animationController.value * MainBloc.maxSlide,
                        //   child: IconButton(
                        //     icon: const Icon(Icons.menu),
                        //     onPressed: toggle,
                        //     //     color: appProvider.isDark ? Colors.white : Colors.black,
                        //   ),
                        // ),
                        // animationController.value != 1 &&
                        //         mainBloc.currIndex != 'MainScreen'
                        //     ? Positioned(
                        //         top: MediaQuery.of(context).size.height * 0.02,
                        //         left: MediaQuery.of(context).size.width * 0.02,
                        //         child: IconButton(
                        //           icon: const Icon(
                        //             Icons.arrow_back_outlined,
                        //           ),
                        //           onPressed: () {
                        //             animationController.reverse();
                        //
                        //             mainBloc.setCurrIndex('MainScreen');
                        //           },
                        //           iconSize: MediaQuery.of(context).size.height *
                        //               0.035,
                        //           tooltip: 'Back Button',
                        //         //  color: Provider.of<AppProvider>(context).isDark ? Colors.white : Colors.black54,
                        //         ),
                        //       )
                        //     : const SizedBox()
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );


  }
}
