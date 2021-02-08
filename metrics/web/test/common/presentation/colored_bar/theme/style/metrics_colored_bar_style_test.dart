// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsColoredBarStyle", () {
    test(
      "creates an instance with the default colors if the parameters are not specified",
      () {
        const style = MetricsColoredBarStyle();

        expect(style.color, isNotNull);
        expect(style.hoverColor, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const color = Colors.red;
      const hoverColor = Colors.grey;
      const style = MetricsColoredBarStyle(
        color: color,
        hoverColor: hoverColor,
      );

      expect(style.color, equals(color));
      expect(style.hoverColor, equals(hoverColor));
    });
  });
}
