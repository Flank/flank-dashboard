import 'package:flutter/material.dart';

class AppColor {
  static const Color greenColor = Color.fromRGBO(28, 216, 194, 1);
  static const Color pinkColor = Color.fromRGBO(254, 46, 110, 1);
  static const Color purpleColor = Color.fromRGBO(193, 90, 255, 1);
  static const Color greyColor = Color.fromRGBO(237, 237, 237, 1);
  static const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color whiteColor0 = Color.fromRGBO(255, 255, 255, 0.11);
  static const Color blackColor = Color.fromRGBO(0, 0, 0, 1);
  static const Color blackColor0 = Color.fromRGBO(31, 42, 73, 1);


  static const Color cardColor = Color.fromRGBO(50, 63, 115, 1);
static const Color themeColor = Color.fromRGBO(39, 52, 101, 1);
 static const Color lightBlueColor = Color.fromRGBO(72, 156, 255, 1);
  static const Color mediumBlueColor = Color.fromRGBO(118, 123, 255, 1);

  static const Color blueColor0 = Color.fromRGBO(67, 83, 135, 1);
  static const Color blueColor1 = Color.fromRGBO(56, 77, 131, 1);
   static const Color blueColor2 = Color.fromRGBO(76, 154, 255, 1);
    static const Color blueColor3 = Color.fromRGBO(76, 154, 255, 0);

}

class CardGradient {
  static LinearGradient themeGradientColor = LinearGradient(
    colors: [
      AppColor.blueColor2,
      AppColor.blueColor3,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    tileMode: TileMode.mirror,
  );
}


