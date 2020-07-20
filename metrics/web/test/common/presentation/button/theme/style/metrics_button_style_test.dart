import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsButtonStyle", () {
    test(
      "creates an instance with the default colors for buttons if the parameters are not specified",
      () {
        const style = MetricsButtonStyle();

        expect(style.color, isNotNull);
        expect(style.hoverColor, isNotNull);
        expect(style.labelColor, isNotNull);
      },
    );

    test(
      "creates an instance with null text styles for buttons if the text styles are not specified",
      () {
        const style = MetricsButtonStyle();

        expect(style.labelStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const color = Colors.red;
      const hoverColor = Colors.grey;
      const labelColor = Colors.black;
      const labelStyle = TextStyle();

      final style = MetricsButtonStyle(
        color: color,
        hoverColor: hoverColor,
        labelColor: labelColor,
        labelStyle: labelStyle,
      );

      expect(style.color, equals(color));
      expect(style.hoverColor, equals(hoverColor));
      expect(style.labelColor, equals(labelColor));
      expect(style.labelStyle, equals(labelStyle));
    });
  });
}
