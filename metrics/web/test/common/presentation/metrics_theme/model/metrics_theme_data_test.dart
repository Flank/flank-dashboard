// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/colored_bar/theme/theme_data/metrics_colored_bar_theme_data.dart';
import 'package:metrics/common/presentation/dropdown/theme/theme_data/dropdown_item_theme_data.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/theme_data/graph_indicator_theme_data.dart';
import 'package:metrics/common/presentation/manufacturer_banner/theme/theme_data/manufacturer_banner_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/theme_data/add_project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/bar_graph_popup/theme_data/bar_graph_popup_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/theme_data/circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/date_range/theme_data/date_range_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/delete_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dropdown_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_tile_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/theme_data/project_build_status_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/scorecard/theme_data/scorecard_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder/theme_data/shimmer_placeholder_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/sparkline/theme_data/sparkline_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/text_field_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/user_menu_theme_data.dart';
import 'package:metrics/common/presentation/page_title/theme/page_title_theme_data.dart';
import 'package:metrics/common/presentation/text_placeholder/theme/theme_data/text_placeholder_theme_data.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/theme/theme_data/toast_theme_data.dart';
import 'package:metrics/common/presentation/toggle/theme/theme_data/toggle_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_icon/theme/theme_data/tooltip_icon_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_popup/theme/theme_data/tooltip_popup_theme_data.dart';
import 'package:metrics/common/presentation/user_menu_button/theme/user_menu_button_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsThemeData", () {
    test(
      "creates a theme with the default theme data for metrics widgets if the parameters are not specified",
      () {
        const themeData = MetricsThemeData();

        expect(themeData.metricsWidgetTheme, isNotNull);
        expect(themeData.inactiveWidgetTheme, isNotNull);
        expect(themeData.metricsColoredBarTheme, isNotNull);
        expect(themeData.deleteDialogTheme, isNotNull);
        expect(themeData.projectGroupDialogTheme, isNotNull);
        expect(themeData.projectGroupCardTheme, isNotNull);
        expect(themeData.addProjectGroupCardTheme, isNotNull);
        expect(themeData.metricsButtonTheme, isNotNull);
        expect(themeData.textFieldTheme, isNotNull);
        expect(themeData.dropdownTheme, isNotNull);
        expect(themeData.dropdownItemTheme, isNotNull);
        expect(themeData.loginTheme, isNotNull);
        expect(themeData.projectMetricsTableTheme, isNotNull);
        expect(themeData.buildNumberScorecardTheme, isNotNull);
        expect(themeData.dateRangeTheme, isNotNull);
        expect(themeData.performanceSparklineTheme, isNotNull);
        expect(themeData.projectBuildStatusTheme, isNotNull);
        expect(themeData.userMenuButtonTheme, isNotNull);
        expect(themeData.userMenuTheme, isNotNull);
        expect(themeData.toggleTheme, isNotNull);
        expect(themeData.textPlaceholderTheme, isNotNull);
        expect(themeData.inputPlaceholderTheme, isNotNull);
        expect(themeData.toastTheme, isNotNull);
        expect(themeData.barGraphPopupTheme, isNotNull);
        expect(themeData.tooltipPopupTheme, isNotNull);
        expect(themeData.tooltipIconTheme, isNotNull);
        expect(themeData.pageTitleTheme, isNotNull);
        expect(themeData.graphIndicatorTheme, isNotNull);
        expect(themeData.debugMenuTheme, isNotNull);
        expect(themeData.manufacturerBannerThemeData, isNotNull);
      },
    );

    test(
      "creates a theme with the default metrics widgets theme data if nulls are passed",
      () {
        const themeData = MetricsThemeData(
          metricsWidgetTheme: null,
          inactiveWidgetTheme: null,
          metricsColoredBarTheme: null,
          projectGroupCardTheme: null,
          addProjectGroupCardTheme: null,
          deleteDialogTheme: null,
          projectGroupDialogTheme: null,
          metricsButtonTheme: null,
          textFieldTheme: null,
          dropdownTheme: null,
          dropdownItemTheme: null,
          loginTheme: null,
          projectMetricsTableTheme: null,
          buildNumberScorecardTheme: null,
          dateRangeTheme: null,
          performanceSparklineTheme: null,
          projectBuildStatusTheme: null,
          toggleTheme: null,
          userMenuButtonTheme: null,
          userMenuTheme: null,
          textPlaceholderTheme: null,
          inputPlaceholderTheme: null,
          circlePercentageTheme: null,
          toastTheme: null,
          barGraphPopupTheme: null,
          tooltipPopupTheme: null,
          tooltipIconTheme: null,
          pageTitleTheme: null,
          graphIndicatorTheme: null,
          debugMenuTheme: null,
          manufacturerBannerThemeData: null,
        );

        expect(themeData.metricsWidgetTheme, isNotNull);
        expect(themeData.inactiveWidgetTheme, isNotNull);
        expect(themeData.metricsColoredBarTheme, isNotNull);
        expect(themeData.projectGroupCardTheme, isNotNull);
        expect(themeData.addProjectGroupCardTheme, isNotNull);
        expect(themeData.deleteDialogTheme, isNotNull);
        expect(themeData.projectGroupDialogTheme, isNotNull);
        expect(themeData.metricsButtonTheme, isNotNull);
        expect(themeData.textFieldTheme, isNotNull);
        expect(themeData.dropdownTheme, isNotNull);
        expect(themeData.dropdownItemTheme, isNotNull);
        expect(themeData.loginTheme, isNotNull);
        expect(themeData.projectMetricsTableTheme, isNotNull);
        expect(themeData.buildNumberScorecardTheme, isNotNull);
        expect(themeData.dateRangeTheme, isNotNull);
        expect(themeData.performanceSparklineTheme, isNotNull);
        expect(themeData.projectBuildStatusTheme, isNotNull);
        expect(themeData.toggleTheme, isNotNull);
        expect(themeData.userMenuButtonTheme, isNotNull);
        expect(themeData.userMenuTheme, isNotNull);
        expect(themeData.textPlaceholderTheme, isNotNull);
        expect(themeData.inputPlaceholderTheme, isNotNull);
        expect(themeData.circlePercentageTheme, isNotNull);
        expect(themeData.toastTheme, isNotNull);
        expect(themeData.barGraphPopupTheme, isNotNull);
        expect(themeData.tooltipPopupTheme, isNotNull);
        expect(themeData.tooltipIconTheme, isNotNull);
        expect(themeData.pageTitleTheme, isNotNull);
        expect(themeData.graphIndicatorTheme, isNotNull);
        expect(themeData.debugMenuTheme, isNotNull);
        expect(themeData.manufacturerBannerThemeData, isNotNull);
      },
    );

    test(
      ".copyWith() creates a new theme from existing one",
      () {
        const primaryColor = Colors.red;
        const accentColor = Colors.orange;
        const backgroundColor = Colors.black;

        const metricsWidgetTheme = MetricsWidgetThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
        );

        const metricsColoredBarTheme = MetricsColoredBarThemeData(
          attentionLevel: MetricsColoredBarAttentionLevel(
            positive: MetricsColoredBarStyle(
              color: Colors.purpleAccent,
            ),
          ),
        );

        const projectGroupCardTheme = ProjectGroupCardThemeData(
          accentButtonStyle: MetricsButtonStyle(
            color: primaryColor,
          ),
        );

        const addProjectGroupTheme = AddProjectGroupCardThemeData(
          attentionLevel: AddProjectGroupCardAttentionLevel(
            positive: AddProjectGroupCardStyle(
              backgroundColor: Colors.red,
              iconColor: Colors.red,
              hoverColor: Colors.red,
              labelStyle: TextStyle(color: Colors.red),
            ),
            inactive: AddProjectGroupCardStyle(
              backgroundColor: Colors.grey,
              iconColor: Colors.grey,
              hoverColor: Colors.grey,
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
        );

        const deleteDialogTheme = DeleteDialogThemeData(
          backgroundColor: Colors.black,
        );

        const projectGroupDialogTheme = ProjectGroupDialogThemeData(
          backgroundColor: Colors.black,
        );

        const inactiveTheme = MetricsWidgetThemeData(
          primaryColor: primaryColor,
        );

        const metricsButtonTheme = MetricsButtonThemeData(
          buttonAttentionLevel: MetricsButtonAttentionLevel(
            positive: MetricsButtonStyle(color: Colors.green),
          ),
        );

        const textFieldTheme = TextFieldThemeData(focusColor: Colors.grey);

        const dropdownTheme = DropdownThemeData(
          backgroundColor: backgroundColor,
        );

        const dropdownItemTheme = DropdownItemThemeData(
          backgroundColor: backgroundColor,
        );

        const loginTheme = LoginThemeData(
          titleTextStyle: TextStyle(color: Colors.red),
        );

        const projectMetricsTableTheme = ProjectMetricsTableThemeData(
          projectMetricsTileTheme: ProjectMetricsTileThemeData(
            backgroundColor: Colors.red,
          ),
          metricsTableHeaderTheme: MetricsTableHeaderThemeData(
            textStyle: TextStyle(color: Colors.red),
          ),
        );

        const scorecardTheme = ScorecardThemeData(
          valueTextStyle: TextStyle(color: Colors.red),
        );

        const dateRangeTheme = DateRangeThemeData(
          textStyle: MetricsTextStyle(color: Colors.red),
        );

        const performanceSparklineTheme = SparklineThemeData(
          fillColor: primaryColor,
        );

        const projectBuildStatusTheme = ProjectBuildStatusThemeData();

        const userMenuButtonTheme = UserMenuButtonThemeData(
          hoverColor: Colors.white,
        );

        const userMenuTheme = UserMenuThemeData(
          backgroundColor: Colors.white,
        );

        const toggleTheme = ToggleThemeData(
          activeColor: Colors.green,
        );

        const textPlaceholderTheme = TextPlaceholderThemeData(
          textStyle: TextStyle(color: Colors.red),
        );

        const inputPlaceholderTheme = ShimmerPlaceholderThemeData(
          backgroundColor: Colors.red,
        );

        const circlePercentageTheme = CirclePercentageThemeData(
          attentionLevel: CirclePercentageAttentionLevel(
            positive: CirclePercentageStyle(
              valueColor: Colors.red,
            ),
          ),
        );

        const toastTheme = ToastThemeData(
          toastAttentionLevel: ToastAttentionLevel(
            positive: ToastStyle(backgroundColor: Colors.red),
          ),
        );

        const pageTitleTheme = PageTitleThemeData(
          iconColor: Colors.blue,
        );

        const barGraphPopupTheme = BarGraphPopupThemeData(
          color: Colors.green,
        );

        const tooltipPopupTheme = TooltipPopupThemeData(
          backgroundColor: Colors.blue,
        );

        const tooltipIconTheme = TooltipIconThemeData(
          color: Colors.yellow,
        );

        const graphIndicatorTheme = GraphIndicatorThemeData(
          attentionLevel: GraphIndicatorAttentionLevel(),
        );

        const debugMenuTheme = DebugMenuThemeData(
          sectionHeaderTextStyle: TextStyle(color: Colors.black),
          sectionContentTextStyle: TextStyle(color: Colors.red),
        );

        const manufacturerBannerThemeData = ManufacturerBannerThemeData(
          backgroundColor: Colors.blue,
          textStyle: TextStyle(fontSize: 12.0),
        );

        const themeData = MetricsThemeData();

        final copiedTheme = themeData.copyWith(
          metricsWidgetTheme: metricsWidgetTheme,
          metricsColoredBarTheme: metricsColoredBarTheme,
          projectGroupCardTheme: projectGroupCardTheme,
          addProjectGroupCardTheme: addProjectGroupTheme,
          deleteDialogTheme: deleteDialogTheme,
          projectGroupDialogTheme: projectGroupDialogTheme,
          inactiveWidgetTheme: inactiveTheme,
          metricsButtonTheme: metricsButtonTheme,
          textFieldTheme: textFieldTheme,
          dropdownTheme: dropdownTheme,
          dropdownItemTheme: dropdownItemTheme,
          loginTheme: loginTheme,
          projectMetricsTableTheme: projectMetricsTableTheme,
          buildNumberScorecardTheme: scorecardTheme,
          dateRangeTheme: dateRangeTheme,
          performanceSparklineTheme: performanceSparklineTheme,
          projectBuildStatusTheme: projectBuildStatusTheme,
          toggleTheme: toggleTheme,
          userMenuButtonTheme: userMenuButtonTheme,
          userMenuTheme: userMenuTheme,
          textPlaceholderTheme: textPlaceholderTheme,
          inputPlaceholderTheme: inputPlaceholderTheme,
          circlePercentageTheme: circlePercentageTheme,
          toastTheme: toastTheme,
          barGraphPopupTheme: barGraphPopupTheme,
          tooltipPopupTheme: tooltipPopupTheme,
          tooltipIconTheme: tooltipIconTheme,
          pageTitleTheme: pageTitleTheme,
          graphIndicatorTheme: graphIndicatorTheme,
          debugMenuTheme: debugMenuTheme,
          manufacturerBannerThemeData: manufacturerBannerThemeData,
        );

        expect(copiedTheme.metricsWidgetTheme, equals(metricsWidgetTheme));
        expect(copiedTheme.inactiveWidgetTheme, equals(inactiveTheme));
        expect(
          copiedTheme.metricsColoredBarTheme,
          equals(metricsColoredBarTheme),
        );
        expect(
          copiedTheme.projectGroupCardTheme,
          equals(projectGroupCardTheme),
        );
        expect(
          copiedTheme.addProjectGroupCardTheme,
          equals(addProjectGroupTheme),
        );
        expect(
          copiedTheme.deleteDialogTheme,
          equals(deleteDialogTheme),
        );
        expect(
          copiedTheme.projectGroupDialogTheme,
          equals(projectGroupDialogTheme),
        );
        expect(copiedTheme.metricsButtonTheme, equals(metricsButtonTheme));
        expect(copiedTheme.textFieldTheme, equals(textFieldTheme));
        expect(copiedTheme.dropdownTheme, equals(dropdownTheme));
        expect(copiedTheme.dropdownItemTheme, equals(dropdownItemTheme));
        expect(copiedTheme.loginTheme, equals(loginTheme));
        expect(
          copiedTheme.projectMetricsTableTheme,
          equals(projectMetricsTableTheme),
        );
        expect(copiedTheme.buildNumberScorecardTheme, equals(scorecardTheme));
        expect(
          copiedTheme.dateRangeTheme,
          equals(dateRangeTheme),
        );
        expect(
          copiedTheme.performanceSparklineTheme,
          equals(performanceSparklineTheme),
        );
        expect(
          copiedTheme.projectBuildStatusTheme,
          equals(projectBuildStatusTheme),
        );
        expect(copiedTheme.toggleTheme, equals(toggleTheme));
        expect(copiedTheme.userMenuButtonTheme, equals(userMenuButtonTheme));
        expect(copiedTheme.userMenuTheme, equals(userMenuTheme));
        expect(copiedTheme.textPlaceholderTheme, equals(textPlaceholderTheme));
        expect(
          copiedTheme.inputPlaceholderTheme,
          equals(inputPlaceholderTheme),
        );
        expect(
          copiedTheme.circlePercentageTheme,
          equals(circlePercentageTheme),
        );
        expect(copiedTheme.toastTheme, equals(toastTheme));
        expect(copiedTheme.barGraphPopupTheme, equals(barGraphPopupTheme));
        expect(copiedTheme.tooltipPopupTheme, equals(tooltipPopupTheme));
        expect(copiedTheme.tooltipIconTheme, equals(tooltipIconTheme));
        expect(copiedTheme.pageTitleTheme, equals(pageTitleTheme));
        expect(copiedTheme.graphIndicatorTheme, equals(graphIndicatorTheme));
        expect(copiedTheme.debugMenuTheme, equals(debugMenuTheme));
        expect(
          copiedTheme.manufacturerBannerThemeData,
          equals(manufacturerBannerThemeData),
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
          themeData.metricsWidgetTheme,
          equals(copiedTheme.metricsWidgetTheme),
        );
        expect(
          themeData.metricsColoredBarTheme,
          equals(copiedTheme.metricsColoredBarTheme),
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
          themeData.deleteDialogTheme,
          equals(copiedTheme.deleteDialogTheme),
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
        expect(themeData.dropdownTheme, equals(copiedTheme.dropdownTheme));
        expect(
          themeData.dropdownItemTheme,
          equals(copiedTheme.dropdownItemTheme),
        );
        expect(themeData.loginTheme, equals(copiedTheme.loginTheme));
        expect(
          themeData.projectMetricsTableTheme,
          equals(copiedTheme.projectMetricsTableTheme),
        );
        expect(
          themeData.buildNumberScorecardTheme,
          equals(copiedTheme.buildNumberScorecardTheme),
        );
        expect(
          themeData.dateRangeTheme,
          equals(copiedTheme.dateRangeTheme),
        );
        expect(
          themeData.performanceSparklineTheme,
          equals(copiedTheme.performanceSparklineTheme),
        );
        expect(
          themeData.projectBuildStatusTheme,
          copiedTheme.projectBuildStatusTheme,
        );
        expect(
          themeData.buildNumberScorecardTheme,
          equals(copiedTheme.buildNumberScorecardTheme),
        );
        expect(themeData.toggleTheme, equals(copiedTheme.toggleTheme));
        expect(
          themeData.userMenuButtonTheme,
          equals(copiedTheme.userMenuButtonTheme),
        );
        expect(themeData.userMenuTheme, equals(copiedTheme.userMenuTheme));
        expect(
          themeData.textPlaceholderTheme,
          equals(copiedTheme.textPlaceholderTheme),
        );
        expect(
          themeData.inputPlaceholderTheme,
          equals(copiedTheme.inputPlaceholderTheme),
        );
        expect(
          themeData.circlePercentageTheme,
          equals(copiedTheme.circlePercentageTheme),
        );
        expect(themeData.toastTheme, equals(copiedTheme.toastTheme));
        expect(
          themeData.barGraphPopupTheme,
          equals(copiedTheme.barGraphPopupTheme),
        );
        expect(
          themeData.tooltipPopupTheme,
          equals(copiedTheme.tooltipPopupTheme),
        );
        expect(
          themeData.tooltipIconTheme,
          equals(copiedTheme.tooltipIconTheme),
        );
        expect(themeData.pageTitleTheme, equals(copiedTheme.pageTitleTheme));
        expect(
          themeData.graphIndicatorTheme,
          equals(copiedTheme.graphIndicatorTheme),
        );
        expect(
          themeData.debugMenuTheme,
          equals(copiedTheme.debugMenuTheme),
        );
        expect(
          themeData.manufacturerBannerThemeData,
          equals(copiedTheme.manufacturerBannerThemeData),
        );
      },
    );
  });
}
