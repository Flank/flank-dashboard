import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/scorecard/theme_data/scorecard_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ScorecardThemeData", () {
    test("creates an instance with the given parameters", () {
      const valueTextStyle = TextStyle(color: Colors.red);
      const descriptionTextStyle = TextStyle(color: Colors.green);

      final scorecardTheme = ScorecardThemeData(
        valueTextStyle: valueTextStyle,
        descriptionTextStyle: descriptionTextStyle,
      );

      expect(scorecardTheme.valueTextStyle, equals(valueTextStyle));
      expect(scorecardTheme.descriptionTextStyle, equals(descriptionTextStyle));
    });
  });
}
