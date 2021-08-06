import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/manufacturer_banner/theme/theme_data/manufaacturer_banner_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("ManufacturerBannerThemeData", () {
    test(
      "create an instance with the given parameters",
      () {
        const textStyle = TextStyle(fontSize: 12.0);
        const backgroundColor = Colors.blue;

        final themeData = ManufacturerBannerThemeData(
          backgroundColor: backgroundColor,
          textStyle: textStyle,
        );

        expect(themeData.textStyle, equals(textStyle));
        expect(themeData.backgroundColor, equals(backgroundColor));
      },
    );
  });
}
