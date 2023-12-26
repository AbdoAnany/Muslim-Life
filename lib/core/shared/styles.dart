import 'package:azkar/core/utils/size_config.dart';
import 'package:flutter/material.dart';


TextStyle Headerstyle() => TextStyle(
    color: Colors.white,
    fontSize: SizeConfig.screenWidth! * .07,
    fontFamily: 'Tajwal',
    fontWeight: FontWeight.normal,
  );
//Azkarstyle
TextStyle Azkarstyle() => TextStyle(
    color: Colors.white,
    fontSize: SizeConfig.screenWidth! * .07,
    fontWeight: FontWeight.normal,
    fontFamily: 'GaliModern',
    fontStyle: FontStyle.italic);
TextStyle AzkarDescriptionstyle() => TextStyle(
    color: Colors.white,
    fontSize: SizeConfig.screenWidth! * .05,
    fontWeight: FontWeight.normal,
    fontFamily: 'GaliModern',
    fontStyle: FontStyle.italic);
TextStyle AzkarTitlestyle() => TextStyle(
    color: Colors.white,
    fontSize: SizeConfig.screenWidth! * .09,
    fontWeight: FontWeight.bold,
    fontFamily: 'GaliModern',
    fontStyle: FontStyle.italic);
//LightText
TextStyle LightText() => TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontFamily: 'Kufi',
    fontStyle: FontStyle.normal);
TextStyle GrayText() => TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: 'Kufi',
    fontStyle: FontStyle.normal);
TextStyle AzkarText() => TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'Kufi',
    fontStyle: FontStyle.normal);
