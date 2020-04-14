import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/project_metrics_circle_percentage_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/themed_circle_percentage.dart';
import 'package:test/test.dart';

void main() {
  group("CirclePercentageThemeStrategy", () {
    final circlePercentageTheme = ProjectMetricsCirclePercentageThemeData(
      lowPercentTheme: MetricWidgetThemeData(
        primaryColor: Colors.red[100],
        accentColor: Colors.red[200],
        backgroundColor: Colors.red[300],
      ),
      mediumPercentTheme: MetricWidgetThemeData(
        primaryColor: Colors.yellow[100],
        accentColor: Colors.yellow[200],
        backgroundColor: Colors.yellow[300],
      ),
      highPercentTheme: MetricWidgetThemeData(
        primaryColor: Colors.green[100],
        accentColor: Colors.green[200],
        backgroundColor: Colors.green[300],
      ),
    );
    final theme = MetricsThemeData(
      projectMetricsCirclePercentageTheme: circlePercentageTheme,
      inactiveWidgetTheme: MetricWidgetThemeData(
        primaryColor: Colors.grey[100],
        accentColor: Colors.grey[200],
        backgroundColor: Colors.grey[300],
      ),
    );

    const themeStrategy = CirclePercentageThemeStrategy();

    test(
      "returns low percent theme if the given value is in bounds from 0.01 to 0.5",
      () {
        final lowerBoundTheme = themeStrategy.getWidgetTheme(
          theme,
          0.01,
        );

        final upperBoundTheme = themeStrategy.getWidgetTheme(
          theme,
          0.5,
        );

        final expectedTheme = circlePercentageTheme.lowPercentTheme;

        expect(lowerBoundTheme, equals(expectedTheme));
        expect(upperBoundTheme, equals(expectedTheme));
      },
    );

    test(
      "returns medium percent theme if the given value is in bounds from 0.51 to 0.79",
      () {
        final lowerBoundTheme = themeStrategy.getWidgetTheme(
          theme,
          0.51,
        );

        final upperBoundTheme = themeStrategy.getWidgetTheme(
          theme,
          0.79,
        );

        final expectedTheme = circlePercentageTheme.mediumPercentTheme;

        expect(lowerBoundTheme, equals(expectedTheme));
        expect(upperBoundTheme, equals(expectedTheme));
      },
    );

    test(
      "returns high percent theme if the given value is grater or equals to 0.8",
      () {
        final lowerBoundTheme = themeStrategy.getWidgetTheme(
          theme,
          0.8,
        );

        final upperBoundTheme = themeStrategy.getWidgetTheme(
          theme,
          1.0,
        );

        final expectedTheme = circlePercentageTheme.highPercentTheme;

        expect(lowerBoundTheme, equals(expectedTheme));
        expect(upperBoundTheme, equals(expectedTheme));
      },
    );

    test(
      "returns inactive theme if the given value is equals to 0",
      () {
        final widgetTheme = themeStrategy.getWidgetTheme(
          theme,
          0.0,
        );

        final expectedTheme = theme.inactiveWidgetTheme;

        expect(widgetTheme, equals(expectedTheme));
      },
    );
  });
}
