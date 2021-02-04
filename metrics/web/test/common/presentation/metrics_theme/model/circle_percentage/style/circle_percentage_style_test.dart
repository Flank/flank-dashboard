// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:test/test.dart';

void main() {
  group("CirclePercentageStyle", () {
    test("creates an instance with the given values", () {
      const valueStyle = TextStyle(color: Colors.yellow);
      const valueColor = Colors.red;
      const strokeColor = Colors.green;
      const backgroundColor = Colors.black;

      const style = CirclePercentageStyle(
        valueStyle: valueStyle,
        valueColor: valueColor,
        strokeColor: strokeColor,
        backgroundColor: backgroundColor,
      );

      expect(style.valueStyle, equals(valueStyle));
      expect(style.valueColor, equals(valueColor));
      expect(style.strokeColor, equals(strokeColor));
      expect(style.backgroundColor, equals(backgroundColor));
    });
  });
}
