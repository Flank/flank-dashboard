import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dialog_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsThemeData", () {
    test(
      "creates a theme with the default theme data for metric widgets if the parameters is not specified",
      () {
        const themeData = MetricsThemeData();

        expect(themeData.metricCirclePercentageThemeData, isNotNull);
        expect(themeData.metricWidgetTheme, isNotNull);
        expect(themeData.inactiveWidgetTheme, isNotNull);
        expect(themeData.buildResultTheme, isNotNull);
        expect(themeData.dialogThemeData, isNotNull);
        expect(themeData.projectGroupCardTheme, isNotNull);
        expect(themeData.addProjectGroupCardTheme, isNotNull);
      },
    );

    test(
      "creates a theme with the default metric widgets theme data if nulls are passed",
      () {
        const themeData = MetricsThemeData(
          metricCirclePercentageThemeData: null,
          metricWidgetTheme: null,
          inactiveWidgetTheme: null,
          buildResultTheme: null,
          dialogThemeData: null,
          projectGroupCardTheme: null,
          addProjectGroupCardTheme: null,
        );

        expect(themeData.metricCirclePercentageThemeData, isNotNull);
        expect(themeData.metricWidgetTheme, isNotNull);
        expect(themeData.inactiveWidgetTheme, isNotNull);
        expect(themeData.buildResultTheme, isNotNull);
        expect(themeData.dialogThemeData, isNotNull);
        expect(themeData.projectGroupCardTheme, isNotNull);
        expect(themeData.addProjectGroupCardTheme, isNotNull);
      },
    );

    test(
      ".copyWith() creates a new theme from existing one",
      () {
        const primaryColor = Colors.red;
        const accentColor = Colors.orange;
        const backgroundColor = Colors.black;

        const sparklineTheme = MetricWidgetThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
        );

        const circlePercentageTheme = MetricCirclePercentageThemeData(
          lowPercentTheme: MetricWidgetThemeData(
            primaryColor: primaryColor,
            accentColor: accentColor,
            backgroundColor: backgroundColor,
          ),
        );

        const buildResultsTheme = BuildResultsThemeData(
          successfulColor: primaryColor,
          failedColor: accentColor,
          canceledColor: backgroundColor,
        );

        const projectGroupCardTheme = ProjectGroupCardThemeData(
          primaryColor: primaryColor,
        );

        const addProjectGroupTheme = ProjectGroupCardThemeData(
          primaryColor: primaryColor,
        );

        const dialogThemeData = DialogThemeData(
          titlePadding: EdgeInsets.zero,
        );

        const themeData = MetricsThemeData();

        final copiedTheme = themeData.copyWith(
          metricWidgetTheme: sparklineTheme,
          metricCirclePercentageThemeData: circlePercentageTheme,
          barGraphBackgroundColor: backgroundColor,
          buildResultTheme: buildResultsTheme,
          projectGroupCardTheme: projectGroupCardTheme,
          addProjectGroupCardTheme: addProjectGroupTheme,
          dialogThemeData: dialogThemeData,
        );

        expect(
          copiedTheme.metricCirclePercentageThemeData,
          equals(circlePercentageTheme),
        );
        expect(copiedTheme.metricWidgetTheme, equals(sparklineTheme));
        expect(copiedTheme.buildResultTheme, equals(buildResultsTheme));
        expect(copiedTheme.buildResultTheme, equals(buildResultsTheme));
        expect(copiedTheme.buildResultTheme, equals(buildResultsTheme));
        expect(
          copiedTheme.projectGroupCardTheme,
          equals(projectGroupCardTheme),
        );
        expect(
          copiedTheme.addProjectGroupCardTheme,
          equals(addProjectGroupTheme),
        );
        expect(
          copiedTheme.dialogThemeData,
          equals(dialogThemeData),
        );
      },
    );

    test(
      ".copyWith() creates a new instance with the same fields if called without params",
      () {
        const themeData = MetricsThemeData();
        final copiedTheme = themeData.copyWith();

        expect(themeData, isNot(copiedTheme));
        expect(
          themeData.metricWidgetTheme,
          copiedTheme.metricWidgetTheme,
        );
        expect(
          themeData.metricCirclePercentageThemeData,
          copiedTheme.metricCirclePercentageThemeData,
        );
        expect(
          themeData.buildResultTheme,
          copiedTheme.buildResultTheme,
        );
        expect(
          themeData.projectGroupCardTheme,
          copiedTheme.projectGroupCardTheme,
        );
        expect(
          themeData.addProjectGroupCardTheme,
          copiedTheme.addProjectGroupCardTheme,
        );
        expect(
          themeData.dialogThemeData,
          copiedTheme.dialogThemeData,
        );
        expect(
          themeData.inactiveWidgetTheme,
          copiedTheme.inactiveWidgetTheme,
        );
      },
    );
  });
}
