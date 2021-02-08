// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder/theme_data/shimmer_placeholder_theme_data.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ShimmerPlaceholderThemeData", () {
    test(
      "creates an instance with the default background color if the given parameter is null",
      () {
        const themeData = ShimmerPlaceholderThemeData(
          backgroundColor: null,
        );

        expect(themeData.backgroundColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default shimmer color if the given parameter is null",
      () {
        const themeData = ShimmerPlaceholderThemeData(
          shimmerColor: null,
        );

        expect(themeData.shimmerColor, isNotNull);
      },
    );

    test("successfully creates an instance with the given values", () {
      const backgroundColor = Colors.blue;
      const shimmerColor = Colors.red;

      const themeData = ShimmerPlaceholderThemeData(
        backgroundColor: backgroundColor,
        shimmerColor: shimmerColor,
      );

      expect(themeData.backgroundColor, backgroundColor);
      expect(themeData.shimmerColor, shimmerColor);
    });
  });
}
