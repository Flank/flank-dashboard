import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_groups_dropdown_item_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_groups_dropdown_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/text_field_theme_data.dart';
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
        expect(themeData.projectGroupDialogTheme, isNotNull);
        expect(themeData.projectGroupCardTheme, isNotNull);
        expect(themeData.addProjectGroupCardTheme, isNotNull);
        expect(themeData.metricsButtonTheme, isNotNull);
        expect(themeData.textFieldTheme, isNotNull);
        expect(themeData.projectGroupDropdownTheme, isNotNull);
        expect(themeData.projectGroupDropdownItemTheme, isNotNull);
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
          projectGroupCardTheme: null,
          addProjectGroupCardTheme: null,
          projectGroupDialogTheme: null,
          metricsButtonTheme: null,
          textFieldTheme: null,
          projectGroupDropdownTheme: null,
          projectGroupDropdownItemTheme: null,
        );

        expect(themeData.metricCirclePercentageThemeData, isNotNull);
        expect(themeData.metricWidgetTheme, isNotNull);
        expect(themeData.inactiveWidgetTheme, isNotNull);
        expect(themeData.buildResultTheme, isNotNull);
        expect(themeData.projectGroupCardTheme, isNotNull);
        expect(themeData.addProjectGroupCardTheme, isNotNull);
        expect(themeData.projectGroupDialogTheme, isNotNull);
        expect(themeData.metricsButtonTheme, isNotNull);
        expect(themeData.textFieldTheme, isNotNull);
        expect(themeData.projectGroupDropdownTheme, isNotNull);
        expect(themeData.projectGroupDropdownItemTheme, isNotNull);
      },
    );

    test(
      ".copyWith() creates a new theme from existing one",
      () {
        const primaryColor = Colors.red;
        const accentColor = Colors.orange;
        const backgroundColor = Colors.black;

        const metricWidgetTheme = MetricWidgetThemeData(
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

        const projectGroupDialogTheme = ProjectGroupDialogThemeData();

        const inactiveThemeData = MetricWidgetThemeData(
          primaryColor: primaryColor,
        );

        const metricsButtonTheme = MetricsButtonThemeData(
          buttonAttentionLevel: MetricsButtonAttentionLevel(
            positive: MetricsButtonStyle(color: Colors.green),
          ),
        );

        const textFieldTheme = TextFieldThemeData(focusColor: Colors.black);

        const projectGroupDropdownTheme = ProjectGroupsDropdownThemeData(
          backgroundColor: backgroundColor,
        );

        const projectGroupDropdownItemTheme =
            ProjectGroupsDropdownItemThemeData(backgroundColor: backgroundColor);

        const themeData = MetricsThemeData();

        final copiedTheme = themeData.copyWith(
          metricWidgetTheme: metricWidgetTheme,
          metricCirclePercentageThemeData: circlePercentageTheme,
          buildResultTheme: buildResultsTheme,
          projectGroupCardTheme: projectGroupCardTheme,
          addProjectGroupCardTheme: addProjectGroupTheme,
          projectGroupDialogTheme: projectGroupDialogTheme,
          inactiveWidgetTheme: inactiveThemeData,
          metricsButtonTheme: metricsButtonTheme,
          textFieldTheme: textFieldTheme,
          projectGroupDropdownTheme: projectGroupDropdownTheme,
          projectGroupDropdownItemTheme: projectGroupDropdownItemTheme,
        );

        expect(
          copiedTheme.metricCirclePercentageThemeData,
          equals(circlePercentageTheme),
        );
        expect(copiedTheme.metricWidgetTheme, equals(metricWidgetTheme));
        expect(copiedTheme.inactiveWidgetTheme, equals(inactiveThemeData));
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
          copiedTheme.projectGroupDialogTheme,
          equals(projectGroupDialogTheme),
        );
        expect(copiedTheme.metricsButtonTheme, equals(metricsButtonTheme));
        expect(copiedTheme.textFieldTheme, equals(textFieldTheme));
        expect(
          copiedTheme.projectGroupDropdownTheme,
          equals(projectGroupDropdownTheme),
        );
        expect(
          copiedTheme.projectGroupDropdownItemTheme,
          equals(projectGroupDropdownItemTheme),
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
          equals(copiedTheme.metricWidgetTheme),
        );
        expect(
          themeData.metricCirclePercentageThemeData,
          equals(copiedTheme.metricCirclePercentageThemeData),
        );
        expect(
          themeData.buildResultTheme,
          equals(copiedTheme.buildResultTheme),
        );
        expect(
          themeData.projectGroupCardTheme,
          equals(copiedTheme.projectGroupCardTheme),
        );
        expect(
          themeData.addProjectGroupCardTheme,
          equals(copiedTheme.addProjectGroupCardTheme),
        );
        expect(
          themeData.projectGroupDialogTheme,
          equals(copiedTheme.projectGroupDialogTheme),
        );
        expect(
          themeData.inactiveWidgetTheme,
          equals(copiedTheme.inactiveWidgetTheme),
        );
        expect(
          themeData.metricsButtonTheme,
          equals(copiedTheme.metricsButtonTheme),
        );
        expect(themeData.textFieldTheme, equals(themeData.textFieldTheme));
        expect(
          themeData.projectGroupDropdownTheme,
          copiedTheme.projectGroupDropdownTheme,
        );
        expect(
          themeData.projectGroupDropdownItemTheme,
          copiedTheme.projectGroupDropdownItemTheme,
        );
      },
    );
  });
}
