import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

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
      const backgroundColor = Colors.grey;
      final style = MetricsColoredBarStyle(
        color: color,
        hoverColor: backgroundColor,
      );

      expect(style.color, equals(color));
      expect(style.hoverColor, equals(backgroundColor));
    });
  });
}
