// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/bar_graph_popup/theme_data/bar_graph_popup_theme_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BarGraphPopupThemeData", () {
    test(
      "creates an instance with the default color if the color is not specified",
      () {
        const themeData = BarGraphPopupThemeData();

        expect(themeData.color, isNotNull);
      },
    );

    test(
      "creates an instance with the default color if the given color is null",
      () {
        const themeData = BarGraphPopupThemeData(color: null);

        expect(themeData.color, isNotNull);
      },
    );

    test(
      "creates an instance with the default shadow color if the shadow color is not specified",
      () {
        const themeData = BarGraphPopupThemeData();

        expect(themeData.shadowColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default shadow color if the given shadow color is null",
      () {
        const themeData = BarGraphPopupThemeData(shadowColor: null);

        expect(themeData.shadowColor, isNotNull);
      },
    );

    test(
      "creates an instance with null text styles if the parameters are not specified",
      () {
        const themeData = BarGraphPopupThemeData();

        expect(themeData.titleTextStyle, isNull);
        expect(themeData.subtitleTextStyle, isNull);
      },
    );

    test(
      "creates an instance with the given values",
      () {
        const color = Colors.white;
        const shadowColor = Colors.grey;
        const titleTextStyle = TextStyle(color: Colors.green);
        const subtitleTextStyle = TextStyle(color: Colors.yellow);

        const themeData = BarGraphPopupThemeData(
          color: color,
          shadowColor: shadowColor,
          titleTextStyle: titleTextStyle,
          subtitleTextStyle: subtitleTextStyle,
        );

        expect(themeData.color, equals(color));
        expect(themeData.shadowColor, equals(shadowColor));
        expect(themeData.titleTextStyle, equals(titleTextStyle));
        expect(themeData.subtitleTextStyle, equals(subtitleTextStyle));
      },
    );
  });
}
