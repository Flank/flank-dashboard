import 'package:flutter/material.dart';
import 'package:metrics/utils/app_colors.dart';

ThemeData basicTheme() 
{
  TextTheme _basicTextTheme(TextTheme base) 
  {
    return base.copyWith(
         body1: base.display1.copyWith(
         fontFamily: 'Ubuntu',
          fontSize: 20.0,
          
          color: AppColor.whiteColor,
        ),
        display1: base.display1.copyWith(
           fontFamily: 'BebasNeue',
          fontSize: 23.3,
          
          color: AppColor.whiteColor,
        ),
        display2: base.display2.copyWith(
         fontFamily: 'BebasNeue',
          fontSize: 50.0,
           
          color: AppColor.whiteColor,
        ),
        display3: base.display3.copyWith(
         fontFamily: 'BebasNeue',
          fontSize: 52.0,
          
          color: AppColor.whiteColor,
        ),      
    );
  }

  final ThemeData base = ThemeData();

  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    primaryColor: AppColor.themeColor,
    accentColor: AppColor.whiteColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.themeColor,      
    
  );
}
