import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("CirclePercentageStyle", () {
    test("creates an instance with the given values", () {
      const valueStyle = TextStyle(color: Colors.yellow);
      const valueColor = Colors.red;
      const strokeColor = Colors.green;
      const backgroundColor = Colors.black;

      final style = CirclePercentageStyle(
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
