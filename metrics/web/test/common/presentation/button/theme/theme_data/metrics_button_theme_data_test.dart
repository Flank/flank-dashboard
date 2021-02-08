// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsButtonThemeData", () {
    test(
      "creates a theme with default attention level if the given attention level is null",
      () {
        const theme = MetricsButtonThemeData(
          buttonAttentionLevel: null,
        );

        expect(theme.attentionLevel, isNotNull);
      },
    );

    test("creates a theme with the given attention level", () {
      const attentionLevel = MetricsButtonAttentionLevel(
        positive: MetricsButtonStyle(
          color: Colors.red,
        ),
      );

      const theme = MetricsButtonThemeData(
        buttonAttentionLevel: attentionLevel,
      );

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
