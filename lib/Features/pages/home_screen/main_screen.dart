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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainBloc.maxSlide = MediaQuery.of(context).size.width * 0.835;
    SizeConfig().init(context);
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, mainState) {},
      builder: (context, mainState) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: HomeScreen(),
        );
      },
    );
  }
}
