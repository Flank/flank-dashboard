import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:metrics/common/presentation/dropdown/theme/theme_data/dropdown_item_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_style_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/delete_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dropdown_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_tile_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/attention_level/project_build_status_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/theme_data/project_build_status_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder/theme_data/shimmer_placeholder_theme_data.dart';
import 'package:metrics/common/presentation/toggle/theme/theme_data/toggle_theme_data.dart';
import 'package:metrics/common/presentation/text_placeholder/theme/theme_data/text_placeholder_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/user_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/scorecard/theme_data/scorecard_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/sparkline/theme_data/sparkline_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/text_field_theme_data.dart';

/// Stores the theme data for dark metrics theme.
class DarkMetricsThemeData extends MetricsThemeData {
  static const Color scaffoldColor = Color(0xFF1b1b1d);
  static const Color inputColor = Color(0xFF0d0d0d);
  static const inputFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: _focusedBorderColor),
  );

  static const Color _dropdownBorderColor = Color(0xFF878799);
  static const Color _dropdownHoverColor = Color(0xFF1d1d20);
  static const Color _dropdownHoverBorderColor = Color(0xFF37373f);
  static const Color _focusedBorderColor = Color(0xFF878799);
  static const Color _inactiveBackgroundColor = Color(0xFF242729);
  static const Color _inactiveColor = Color(0xFF43494d);
  static const Color _cardHoverColor = Color(0xFF212124);
  static const Color _borderColor = Color(0xFF2d2d33);
  static const Color _loginOptionHoverColor = Color(0xFFe5e5e5);
  static const Color _loginOptionTextColor = Color(0xFF757575);
  static const Color _tileBorderColor = Color(0xFF0e0d0d);
  static const Color _tileLoadingBackgroundColor = Color(0xFF242425);
  static const Color _tableHeaderColor = Color(0xFF79858b);
  static const Color _metricsLightGrey = Color(0xFFDCDCE5);
  static const Color _sparklineStrokeColor = Color(0xFFDCDCE5);
  static const Color _sparklineTextColor = Color(0xFFD7D7E5);
  static const Color _sparklineFillColor = Color(0xFF29292B);
  static const Color _inactiveToggleColor = Color(0xFF2F2F33);
  static const Color _inactiveToggleHoverColor = Color(0xFF262626);
  static const Color _textPlaceholderColor = Color(0xFF51585c);

  /// The default [TextStyle] for dropdown within the application.
  static const _defaultDropdownTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );

  /// A [TextStyle] of the dialog title.
  static const TextStyle _dialogTitleTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 26.0,
    fontWeight: FontWeight.w500,
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
                fontSize: 24.0,
                color: ColorConfig.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            mediumPercentTheme: MetricWidgetThemeData(
              primaryColor: ColorConfig.yellow,
              accentColor: Colors.transparent,
              backgroundColor: ColorConfig.yellowTranslucent,
              textStyle: TextStyle(
                fontSize: 24.0,
                color: ColorConfig.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            highPercentTheme: MetricWidgetThemeData(
              primaryColor: ColorConfig.primaryColor,
              accentColor: Colors.transparent,
              backgroundColor: ColorConfig.primaryTranslucentColor,
              textStyle: TextStyle(
                fontSize: 24.0,
                color: ColorConfig.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          metricWidgetTheme: const MetricWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: ColorConfig.primaryTranslucentColor,
            backgroundColor: scaffoldColor,
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
            borderColor: _borderColor,
            hoverColor: _cardHoverColor,
            backgroundColor: scaffoldColor,
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
          deleteDialogTheme: const DeleteDialogThemeData(
            backgroundColor: scaffoldColor,
            closeIconColor: Colors.white,
            titleTextStyle: _dialogTitleTextStyle,
            contentTextStyle: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          projectGroupDialogTheme: const ProjectGroupDialogThemeData(
            primaryColor: ColorConfig.primaryColor,
            backgroundColor: scaffoldColor,
            closeIconColor: Colors.white,
            contentBorderColor: _borderColor,
            titleTextStyle: _dialogTitleTextStyle,
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
          ),
          inactiveWidgetTheme: const MetricWidgetThemeData(
            primaryColor: _inactiveColor,
            accentColor: Colors.transparent,
            backgroundColor: _inactiveBackgroundColor,
            textStyle: TextStyle(
              color: _inactiveColor,
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
                elevation: 0.0,
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
            focusColor: Colors.black,
            hoverBorderColor: ColorConfig.hoverBorderColor,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          dropdownTheme: const DropdownThemeData(
            backgroundColor: Colors.black,
            openedButtonBackgroundColor: Colors.black,
            hoverBackgroundColor: Colors.black,
            hoverBorderColor: _dropdownHoverBorderColor,
            openedButtonBorderColor: _dropdownBorderColor,
            closedButtonBackgroundColor: inputColor,
            closedButtonBorderColor: inputColor,
            textStyle: _defaultDropdownTextStyle,
          ),
          dropdownItemTheme: const DropdownItemThemeData(
            backgroundColor: Colors.transparent,
            hoverColor: _dropdownHoverColor,
            textStyle: _defaultDropdownTextStyle,
          ),
          loginTheme: const LoginThemeData(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
            loginOptionButtonStyle: MetricsButtonStyle(
              color: Colors.white,
              hoverColor: _loginOptionHoverColor,
              labelStyle: TextStyle(
                color: _loginOptionTextColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          projectMetricsTableTheme: const ProjectMetricsTableThemeData(
            metricsTableHeaderTheme: MetricsTableHeaderThemeData(
              textStyle: TextStyle(
                color: _tableHeaderColor,
                fontWeight: FontWeight.normal,
              ),
            ),
            projectMetricsTileTheme: ProjectMetricsTileThemeData(
              backgroundColor: scaffoldColor,
              borderColor: _tileBorderColor,
              textStyle: TextStyle(fontSize: 24.0),
            ),
            projectMetricsTilePlaceholderTheme: ShimmerPlaceholderThemeData(
              backgroundColor: _tileLoadingBackgroundColor,
              shimmerColor: ColorConfig.focusedBorderColor,
            ),
          ),
          buildNumberScorecardTheme: const ScorecardThemeData(
            valueTextStyle: TextStyle(
              fontSize: 24.0,
              color: _metricsLightGrey,
              fontWeight: FontWeight.bold,
            ),
            descriptionTextStyle: TextStyle(
              fontSize: 14.0,
              color: _metricsLightGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          performanceSparklineTheme: const SparklineThemeData(
            textStyle: TextStyle(
              color: _sparklineTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
            strokeColor: _sparklineStrokeColor,
            fillColor: _sparklineFillColor,
          ),
          projectBuildStatusTheme: const ProjectBuildStatusThemeData(
            attentionLevel: ProjectBuildStatusAttentionLevel(
              positive: ProjectBuildStatusStyle(
                backgroundColor: ColorConfig.primaryTranslucentColor,
              ),
              negative: ProjectBuildStatusStyle(
                backgroundColor: ColorConfig.accentTranslucentColor,
              ),
              unknown: ProjectBuildStatusStyle(
                backgroundColor: ColorConfig.inactiveColor,
              ),
            ),
          ),
          toggleTheme: const ToggleThemeData(
            activeColor: ColorConfig.primaryColor,
            activeHoverColor: ColorConfig.primaryHoverColor,
            inactiveColor: _inactiveToggleColor,
            inactiveHoverColor: _inactiveToggleHoverColor,
          ),
          userMenuTheme: const UserMenuThemeData(
            backgroundColor: Colors.black,
            dividerColor: scaffoldColor,
            contentTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              height: 1.0,
            ),
          ),
          textPlaceholderTheme: const TextPlaceholderThemeData(
            textStyle: TextStyle(
              color: _textPlaceholderColor,
              fontSize: 14.0,
            ),
          ),
        );
}
