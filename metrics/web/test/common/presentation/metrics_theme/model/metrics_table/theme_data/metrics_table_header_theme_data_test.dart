import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("MetricsTableHeaderThemeData", () {
    test(
      "creates an instance with a default text style if the given text style is null",
      () {
        const themeData = MetricsTableHeaderThemeData(textStyle: null);

        expect(themeData.textStyle, isNotNull);
      },
    );

    test("creates a theme with the given text style", () {
      final textStyle = TextStyle(color: Colors.red);
      final themeData = MetricsTableHeaderThemeData(textStyle: textStyle);

      expect(themeData.textStyle, equals(textStyle));
    });
  });
}
