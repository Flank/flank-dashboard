// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/theme_data/circle_percentage_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("CirclePercentageTheme", () {
    test(
      "creates a theme with a default attention level if the given attention level is null",
      () {
        const theme = CirclePercentageThemeData(attentionLevel: null);

        expect(theme.attentionLevel, isNotNull);
      },
    );

    test("creates a theme with the given attention level", () {
      const attentionLevel = CirclePercentageAttentionLevel(
        positive: CirclePercentageStyle(strokeColor: Colors.red),
      );

      const theme = CirclePercentageThemeData(attentionLevel: attentionLevel);

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
