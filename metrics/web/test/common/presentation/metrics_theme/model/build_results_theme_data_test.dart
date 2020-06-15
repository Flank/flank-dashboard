// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultsThemeData", () {
    test(
      "creates a new instance with given colors and textStyle",
      () {
        const textStyle = TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        );

        final buildResultsThemeData = BuildResultsThemeData(
          canceledColor: ColorConfig.accentColor,
          successfulColor: ColorConfig.primaryColor,
          failedColor: ColorConfig.accentColor,
          titleStyle: textStyle,
        );

        expect(
          buildResultsThemeData.canceledColor,
          equals(ColorConfig.accentColor),
        );
        expect(
          buildResultsThemeData.successfulColor,
          equals(ColorConfig.primaryColor),
        );
        expect(
          buildResultsThemeData.failedColor,
          equals(ColorConfig.accentColor),
        );
        expect(buildResultsThemeData.titleStyle, equals(textStyle));
      },
    );
  });
}
