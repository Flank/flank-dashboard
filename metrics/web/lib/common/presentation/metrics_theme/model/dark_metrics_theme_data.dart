import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_style_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';

/// Stores the theme data for dark metrics theme.
class DarkMetricsThemeData extends MetricsThemeData {
  static const Color inactiveColor = Color(0xFF43494d);
  static const Color inactiveBackgroundColor = Color(0xFF232729);
  static const Color cardHoverColor = Color(0xFF212124);
  static const Color optionTextColor = Color(0xFF757575);
  static const Color inputColor = Color(0xFF0d0d0d);
  static const Color inputHoverBorderColor = Color(0xFF37373f);

  /// The default [TextStyle] for [TextField]s within the application.
  static const _defaultTextFieldTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );

  /// Creates the dark theme with the default widget theme configuration.
  const DarkMetricsThemeData()
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
            backgroundColor: ColorConfig.darkScaffoldColor,
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
            borderColor: ColorConfig.borderColor,
            hoverColor: cardHoverColor,
            backgroundColor: ColorConfig.darkScaffoldColor,
            accentColor: ColorConfig.accentColor,
            primaryColor: ColorConfig.primaryColor,
            titleStyle: TextStyle(
              color: Colors.white,
              height: 1.09,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            subtitleStyle: TextStyle(
              color: ColorConfig.secondaryTextColor,
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
            accentColor: ColorConfig.accentColor,
            primaryColor: ColorConfig.primaryColor,
            backgroundColor: ColorConfig.darkScaffoldColor,
            closeIconColor: Colors.white,
            contentBorderColor: ColorConfig.borderColor,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 26.0,
              fontWeight: FontWeight.w500,
            ),
            groupNameTextStyle: _defaultTextFieldTextStyle,
            searchForProjectTextStyle: _defaultTextFieldTextStyle,
            uncheckedProjectTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            checkedProjectTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            counterTextStyle: TextStyleConfig.captionTextStyle,
            actionsTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          inactiveWidgetTheme: const MetricWidgetThemeData(
            primaryColor: inactiveColor,
            accentColor: Colors.transparent,
            backgroundColor: inactiveBackgroundColor,
            textStyle: TextStyle(
              color: inactiveColor,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          loginTheme: const LoginThemeData(
            primaryColor: ColorConfig.primaryColor,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
            textFieldHoverColor: Colors.black,
            textFieldHoverBorderColor: inputHoverBorderColor,
            loginButtonTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            loginOptionTextStyle: TextStyle(
              color: optionTextColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            loginOptionColor: Colors.white,
          ),
        );
}
