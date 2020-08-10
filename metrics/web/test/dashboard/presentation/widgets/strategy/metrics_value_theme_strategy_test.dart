// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/theme_data/circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_theme_strategy.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsValueThemeStrategy", () {
    final circlePercentageTheme = CirclePercentageThemeData(
      attentionLevel: CirclePercentageAttentionLevel(
        positive: CirclePercentageStyle(valueColor: Colors.red),
        neutral: CirclePercentageStyle(valueColor: Colors.red),
        negative: CirclePercentageStyle(valueColor: Colors.red),
        inactive: CirclePercentageStyle(valueColor: Colors.red),
      ),
    );

    final theme = MetricsThemeData(
      circlePercentageTheme: circlePercentageTheme,
    );

    final themeStrategy = MetricsValueThemeStrategy();

    test(
      "returns the negative circle style if the given value is in bounds from 0.01 to 0.5",
      () {
        final lowerBoundTheme = themeStrategy.getWidgetAppearance(
          theme,
          0.01,
        );

        final upperBoundTheme = themeStrategy.getWidgetAppearance(
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
        final lowerBoundTheme = themeStrategy.getWidgetAppearance(
          theme,
          0.51,
        );

        final upperBoundTheme = themeStrategy.getWidgetAppearance(
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
        final lowerBoundTheme = themeStrategy.getWidgetAppearance(
          theme,
          0.8,
        );

        final upperBoundTheme = themeStrategy.getWidgetAppearance(
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
        final widgetTheme = themeStrategy.getWidgetAppearance(
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
