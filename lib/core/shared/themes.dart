import 'package:flutter/services.dart';
import 'colors.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData theme = ThemeData(
  //ThemeColors
  backgroundColor: Backgroundcolor,
  primaryColor: Golden,
  disabledColor: DarkGolden,
  primarySwatch: Colors.amber,

  //AppBarTheme
  appBarTheme: AppBarTheme(
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Backgroundcolor,
      )),
);
