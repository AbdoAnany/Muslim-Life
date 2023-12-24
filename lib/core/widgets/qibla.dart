import 'dart:math' show pi;
import 'dart:ui';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/core/utils/assets.dart';
import 'package:azkar/core/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:azkar/core/widgets/loading_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class QiblahCompassWidget extends StatefulWidget {
  QiblahCompassWidget({Key? key}) : super(key: key);

  @override
  State<QiblahCompassWidget> createState() => _QiblahCompassWidgetState();
}

class _QiblahCompassWidgetState extends State<QiblahCompassWidget> {
  late PermissionStatus status = PermissionStatus.denied;
  Future<void> _requestLocationPermission() async {
    LocationPermission a = await FlutterQiblah.requestPermissions();

    print("***** va.name");
    print(a.name);
    status = await Permission.location.status;

    if (status.isGranted) {
    } else if (status.isDenied) {
      status = await Permission.location.request();
    } else if (status.isPermanentlyDenied) {
      status = await Permission.location.request();
    }
    setState(() {});
  }

  @override
  void initState() {
    _requestLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const CustomTitle(
              title: 'أتجاه القبلة',
            )),
        backgroundColor: kWhite,
        body: !status.isGranted
            ? Center(
                child: InkWell(
                    onTap: () async {
                      status = await Permission.location.request();
                      setState(() {});
                      //  LocationPermission a =await  FlutterQiblah.requestPermissions();

                      // setState(() {
                      //
                      // });
                    },
                    child: Text('لا يمكن وصول الي بيانات الموقع الجغرافي')),
              )
            : StreamBuilder<QiblahDirection>(
                stream: FlutterQiblah.qiblahStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingIndicator();
                  }

                  if (snapshot.hasError) {
                    // Handle the error here
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    // Handle the case when there is no data available
                    return Center(
                      child: Text('No data available'),
                    );
                  }

                  final qiblahDirection = snapshot.data!;

                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        bottom: -200,
                        left: -200,
                        child: Opacity(
                          opacity: .2,
                          child: Image.asset(StaticAssets.arabic),
                        ),
                      ),
                      Center(
                        child: Transform.rotate(
                          angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                          alignment: Alignment.center,
                          child: Hero(
                            tag: StaticAssets.qibla,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Image.asset(
                                StaticAssets.qibla,
                                width: MediaQuery.of(context).size.height * 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
