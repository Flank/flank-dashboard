import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsButtonStyle", () {
    test(
      "creates an instance with the default colors and elevation for buttons if the parameters are not specified",
      () {
        const style = MetricsButtonStyle();

        expect(style.color, isNotNull);
        expect(style.hoverColor, isNotNull);
        expect(style.elevation, isNotNull);
      },
    );

    test(
      "creates an instance with null text style for buttons if the text style is not specified",
      () {
        const style = MetricsButtonStyle();

        expect(style.labelStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const color = Colors.red;
      const hoverColor = Colors.grey;
      const elevation = 1.0;
      const labelStyle = TextStyle();

      final style = MetricsButtonStyle(
        color: color,
        hoverColor: hoverColor,
        labelStyle: labelStyle,
        elevation: elevation,
      );

      expect(style.color, equals(color));
      expect(style.hoverColor, equals(hoverColor));
      expect(style.labelStyle, equals(labelStyle));
      expect(style.elevation, equals(elevation));
    });
  });
}
