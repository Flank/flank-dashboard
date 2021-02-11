// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_result_bar_graph/theme_data/build_result_bar_graph_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultBarGraphThemeData", () {
    test(
      "creates an instance with a default text style if the given text style is null",
      () {
        const themeData = BuildResultBarGraphThemeData(textStyle: null);

        expect(themeData.textStyle, isNotNull);
      },
    );

    test("creates a theme with the given text style", () {
      const textStyle = TextStyle(color: Colors.yellow);

      const themeData = BuildResultBarGraphThemeData(textStyle: textStyle);

      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
