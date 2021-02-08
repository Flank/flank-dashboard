// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/scorecard/theme_data/scorecard_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("ScorecardThemeData", () {
    test("creates an instance with the given parameters", () {
      const valueTextStyle = TextStyle(color: Colors.red);
      const descriptionTextStyle = TextStyle(color: Colors.green);

      const scorecardTheme = ScorecardThemeData(
        valueTextStyle: valueTextStyle,
        descriptionTextStyle: descriptionTextStyle,
      );

      expect(scorecardTheme.valueTextStyle, equals(valueTextStyle));
      expect(scorecardTheme.descriptionTextStyle, equals(descriptionTextStyle));
    });
  });
}
