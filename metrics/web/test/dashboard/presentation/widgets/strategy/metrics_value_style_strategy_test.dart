// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/theme_data/circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_style_strategy.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsValueStyleStrategy", () {
    const circlePercentageTheme = CirclePercentageThemeData(
      attentionLevel: CirclePercentageAttentionLevel(
        positive: CirclePercentageStyle(valueColor: Colors.green),
        neutral: CirclePercentageStyle(valueColor: Colors.yellow),
        negative: CirclePercentageStyle(valueColor: Colors.red),
        inactive: CirclePercentageStyle(valueColor: Colors.grey),
      ),
    );

    const theme = MetricsThemeData(
      circlePercentageTheme: circlePercentageTheme,
    );

    const styleStrategy = MetricsValueStyleStrategy();

    test(
      "returns the negative circle style if the given value is in bounds from 0.01 to 0.5",
      () {
        final lowerBoundTheme = styleStrategy.getWidgetAppearance(
          theme,
          0.01,
        );

        final upperBoundTheme = styleStrategy.getWidgetAppearance(
          theme,
          0.5,
        );

        expect(
          lowerBoundTheme,
          equals(circlePercentageTheme.attentionLevel.negative),
        );
        expect(
          upperBoundTheme,
          equals(circlePercentageTheme.attentionLevel.negative),
        );
      },
    );

    test(
      "returns the neutral circle style if the given value is in bounds from 0.51 to 0.79",
      () {
        final lowerBoundTheme = styleStrategy.getWidgetAppearance(
          theme,
          0.51,
        );

        final upperBoundTheme = styleStrategy.getWidgetAppearance(
          theme,
          0.79,
        );

        expect(
          lowerBoundTheme,
          equals(circlePercentageTheme.attentionLevel.neutral),
        );
        expect(
          upperBoundTheme,
          equals(circlePercentageTheme.attentionLevel.neutral),
        );
      },
    );

    test(
      "returns the positive circle style if the given value is grater or equals to 0.8",
      () {
        final lowerBoundTheme = styleStrategy.getWidgetAppearance(
          theme,
          0.8,
        );

        final upperBoundTheme = styleStrategy.getWidgetAppearance(
          theme,
          1.0,
        );

        expect(
          lowerBoundTheme,
          equals(circlePercentageTheme.attentionLevel.positive),
        );
        expect(
          upperBoundTheme,
          equals(circlePercentageTheme.attentionLevel.positive),
        );
      },
    );

    test(
      "returns the inactive circle style if the given value is equals to 0",
      () {
        final widgetTheme = styleStrategy.getWidgetAppearance(
          theme,
          0.0,
        );

        expect(
          widgetTheme,
          equals(theme.circlePercentageTheme.attentionLevel.inactive),
        );
      },
    );
  });
}
