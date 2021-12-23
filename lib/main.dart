import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:khushoo3/Features/home/presentation/manager/home_bloc/Azkar_cubit/azkar_cubit.dart';
import 'package:khushoo3/core/widgets/date_header.dart';
import 'Features/home/data/repositories/network/bloc_observer.dart';
import 'Features/home/presentation/manager/home_bloc/Qibla_cubit/qibla_cubit.dart';
import 'Features/home/presentation/manager/home_bloc/Sibha_cubit/misbaha_cubit.dart';
import 'core/shared/themes.dart';


import 'Features/home/data/repositories/network/remote/dio_helper.dart';
import 'Features/home/presentation/manager/home_bloc/prayer_cubit/prayer_cubit.dart';
import 'Features/home/presentation/page/Home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  diohelper.init();
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AzkarCubit()..getAzkar()),
          BlocProvider(create: (context) => PrayerCubit()..getPrayTime()),
          BlocProvider(create: (context) => QiblaCubit()),
          BlocProvider(create: (context) => MisbahaCubit()),
        ],
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: Scaffold(
              appBar: AppBar(
                title: DateHeader(),
                centerTitle: true,
                backgroundColor: Colors.black,
                actions: [
                  IconButton(
                      onPressed: () => Home.drawerController.toggle!(),
                      icon: Icon(
                        Icons.list,
                        color: Colors.white,
                      ))
                ],
              ),
              body: Container(
                  color: Colors.grey[700],
                  child: Home()),
            )));
  }
}
