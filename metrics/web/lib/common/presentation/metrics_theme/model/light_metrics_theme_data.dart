import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_style_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/text_field_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_groups_dropdown_item_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_groups_dropdown_theme_data.dart';

/// Stores the theme data for light metrics theme.
class LightMetricsThemeData extends MetricsThemeData {
  static const Color dropdownHoverColor = Color(0xFF1d1d20);
  static const Color focusedBorderColor = Colors.blue;
  static const inputFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: focusedBorderColor),
  );

  /// Creates the light theme with the default widget theme configuration.
  const LightMetricsThemeData()
      : super(
          metricCirclePercentageThemeData:
              const MetricCirclePercentageThemeData(
            lowPercentTheme: MetricWidgetThemeData(
              primaryColor: ColorConfig.accentColor,
              accentColor: Colors.transparent,
              backgroundColor: ColorConfig.accentTranslucentColor,
              textStyle: TextStyle(
                color: ColorConfig.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            mediumPercentTheme: MetricWidgetThemeData(
              primaryColor: ColorConfig.yellow,
              accentColor: Colors.transparent,
              backgroundColor: ColorConfig.yellowTranslucent,
              textStyle: TextStyle(
                color: ColorConfig.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            highPercentTheme: MetricWidgetThemeData(
              primaryColor: ColorConfig.primaryColor,
              accentColor: Colors.transparent,
              backgroundColor: ColorConfig.primaryTranslucentColor,
              textStyle: TextStyle(
                color: ColorConfig.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          metricWidgetTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: ColorConfig.primaryTranslucentColor,
            backgroundColor: Colors.white,
            textStyle: TextStyle(
              color: ColorConfig.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          buildResultTheme: const BuildResultsThemeData(
            canceledColor: ColorConfig.accentColor,
            successfulColor: ColorConfig.primaryColor,
            failedColor: ColorConfig.accentColor,
          ),
          projectGroupCardTheme: const ProjectGroupCardThemeData(
            borderColor: ColorConfig.darkBorderColor,
            hoverColor: ColorConfig.darkCardHoverColor,
            backgroundColor: ColorConfig.lightScaffoldColor,
            accentColor: ColorConfig.accentColor,
            primaryColor: ColorConfig.primaryColor,
            titleStyle: TextStyle(
              color: Colors.black,
              height: 1.09,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            subtitleStyle: TextStyle(
              color: ColorConfig.darkSecondaryTextColor,
              height: 1.23,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          addProjectGroupCardTheme: const ProjectGroupCardThemeData(
            primaryColor: ColorConfig.primaryColor,
            backgroundColor: ColorConfig.primaryTranslucentColor,
            titleStyle: TextStyle(
              color: ColorConfig.primaryColor,
              height: 1.5,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          projectGroupDialogTheme: const ProjectGroupDialogThemeData(
            primaryColor: ColorConfig.primaryColor,
            closeIconColor: Colors.black,
            contentBorderColor: ColorConfig.darkBorderColor,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 26.0,
              fontWeight: FontWeight.w500,
            ),
            uncheckedProjectTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
            ),
            checkedProjectTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            counterTextStyle: TextStyleConfig.captionTextStyle,
          ),
          inactiveWidgetTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.lightInactiveColor,
            accentColor: Colors.transparent,
            backgroundColor: ColorConfig.lightInactiveBackgroundColor,
            textStyle: TextStyle(
              color: Colors.grey,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          metricsButtonTheme: const MetricsButtonThemeData(
            buttonAttentionLevel: MetricsButtonAttentionLevel(
              positive: MetricsButtonStyle(
                color: ColorConfig.primaryColor,
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              neutral: MetricsButtonStyle(
                color: ColorConfig.inactiveColor,
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              negative: MetricsButtonStyle(
                color: ColorConfig.accentColor,
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              inactive: MetricsButtonStyle(
                color: ColorConfig.inactiveColor,
                labelStyle: TextStyle(
                  color: ColorConfig.inactiveTextColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          textFieldTheme: const TextFieldThemeData(
            focusColor: Colors.grey,
            hoverBorderColor: ColorConfig.hoverBorderColor,
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              height: 1.0,
            ),
          ),
          projectGroupDropdownTheme: const ProjectGroupsDropdownThemeData(),
          projectGroupDropdownItemTheme:
              const ProjectGroupsDropdownItemThemeData(
            backgroundColor: Colors.transparent,
            hoverColor: dropdownHoverColor,
            textStyle: TextStyle(fontSize: 16.0),
          ),
        );
}
