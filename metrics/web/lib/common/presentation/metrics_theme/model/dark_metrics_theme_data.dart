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
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/theme_data/graph_indicator_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/config/metrics_colors.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_style_config.dart';
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
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/attention_level/project_build_status_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
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

// ignore_for_file: public_member_api_docs

/// Stores the theme data for dark metrics theme.
class DarkMetricsThemeData extends MetricsThemeData {
  static final inputFocusedBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MetricsColors.gray[300],
    ),
  );

  static final TextStyle hintStyle = MetricsTextStyle(
    color: MetricsColors.gray[400],
    fontSize: 16.0,
    lineHeightInPixels: 20,
  );

  /// The default [TextStyle] for dropdown within the application.
  static const TextStyle _defaultDropdownTextStyle = MetricsTextStyle(
    color: MetricsColors.white,
    fontSize: 16.0,
    lineHeightInPixels: 20.0,
  );

  /// A [TextStyle] of the dialog title.
  static const TextStyle _dialogTitleTextStyle = TextStyle(
    color: MetricsColors.white,
    fontSize: 26.0,
    fontWeight: FontWeight.w500,
  );

  /// Creates the dark theme with the default widget theme configuration.
  DarkMetricsThemeData()
      : super(
          metricsWidgetTheme: MetricsWidgetThemeData(
            primaryColor: MetricsColors.green[500],
            accentColor: MetricsColors.green[900],
            backgroundColor: MetricsColors.gray[800],
            textStyle: TextStyle(
              color: MetricsColors.gray[100],
              fontWeight: FontWeight.bold,
            ),
          ),
          barGraphPopupTheme: BarGraphPopupThemeData(
            color: MetricsColors.gray[100],
            shadowColor: MetricsColors.shadow50,
            titleTextStyle: TextStyleConfig.popupTitleStyle,
            subtitleTextStyle: TextStyleConfig.popupSubtitleStyle,
          ),
          tooltipPopupTheme: TooltipPopupThemeData(
            backgroundColor: MetricsColors.gray[100],
            shadowColor: MetricsColors.shadow50,
            textStyle: TextStyleConfig.tooltipPopupStyle,
          ),
          tooltipIconTheme: TooltipIconThemeData(
            color: MetricsColors.gray[300],
            hoverColor: MetricsColors.gray[400],
          ),
          projectGroupCardTheme: ProjectGroupCardThemeData(
            borderColor: MetricsColors.gray[500],
            hoverColor: MetricsColors.gray[700],
            backgroundColor: MetricsColors.gray[800],
            primaryButtonStyle: MetricsButtonStyle(
              color: MetricsColors.green[500],
              hoverColor: MetricsColors.green[600],
            ),
            accentButtonStyle: MetricsButtonStyle(
              color: MetricsColors.orange[500],
              hoverColor: MetricsColors.orange[600],
            ),
            titleStyle: const MetricsTextStyle(
              color: MetricsColors.white,
              fontSize: 22.0,
              lineHeightInPixels: 26.0,
              fontWeight: FontWeight.w500,
            ),
            subtitleStyle: MetricsTextStyle(
              color: MetricsColors.gray[300],
              fontSize: 13.0,
              lineHeightInPixels: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          addProjectGroupCardTheme: AddProjectGroupCardThemeData(
            attentionLevel: AddProjectGroupCardAttentionLevel(
              positive: AddProjectGroupCardStyle(
                backgroundColor: MetricsColors.green[900],
                iconColor: MetricsColors.green[500],
                hoverColor: MetricsColors.green[800],
                labelStyle: MetricsTextStyle(
                  color: MetricsColors.green[500],
                  fontSize: 16.0,
                  lineHeightInPixels: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              inactive: AddProjectGroupCardStyle(
                backgroundColor: MetricsColors.gray[700],
                hoverColor: MetricsColors.gray[700],
                iconColor: MetricsColors.gray[800],
                labelStyle: MetricsTextStyle(
                  color: MetricsColors.gray[800],
                  fontSize: 16.0,
                  lineHeightInPixels: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          deleteDialogTheme: DeleteDialogThemeData(
            backgroundColor: MetricsColors.gray[800],
            closeIconColor: MetricsColors.white,
            titleTextStyle: _dialogTitleTextStyle,
            contentTextStyle: const MetricsTextStyle(
              fontSize: 16.0,
              lineHeightInPixels: 24.0,
              color: MetricsColors.white,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.14,
            ),
          ),
          projectGroupDialogTheme: ProjectGroupDialogThemeData(
            primaryColor: MetricsColors.green[500],
            backgroundColor: MetricsColors.gray[800],
            barrierColor: MetricsColors.barrierColor,
            closeIconColor: MetricsColors.white,
            contentBorderColor: MetricsColors.gray[600],
            titleTextStyle: _dialogTitleTextStyle,
            uncheckedProjectTextStyle: const MetricsTextStyle(
              color: MetricsColors.white,
              fontSize: 14.0,
              lineHeightInPixels: 20.0,
            ),
            checkedProjectTextStyle: const MetricsTextStyle(
              color: MetricsColors.white,
              fontSize: 14.0,
              lineHeightInPixels: 20.0,
            ),
            counterTextStyle: TextStyleConfig.captionTextStyle,
            errorTextStyle: TextStyle(
              color: MetricsColors.orange[500],
            ),
          ),
          inactiveWidgetTheme: MetricsWidgetThemeData(
            primaryColor: MetricsColors.gray[400],
            accentColor: Colors.transparent,
            backgroundColor: MetricsColors.gray[700],
            textStyle: TextStyle(
              color: MetricsColors.gray[400],
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          metricsButtonTheme: MetricsButtonThemeData(
            buttonAttentionLevel: MetricsButtonAttentionLevel(
              positive: MetricsButtonStyle(
                color: MetricsColors.green[500],
                hoverColor: MetricsColors.green[600],
                labelStyle: TextStyle(
                  color: MetricsColors.gray[900],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              neutral: MetricsButtonStyle(
                color: MetricsColors.gray[700],
                hoverColor: MetricsColors.gray[800],
                labelStyle: const TextStyle(
                  color: MetricsColors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              negative: MetricsButtonStyle(
                color: MetricsColors.orange[500],
                hoverColor: MetricsColors.orange[600],
                labelStyle: TextStyle(
                  color: MetricsColors.gray[900],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              inactive: MetricsButtonStyle(
                color: MetricsColors.gray[700],
                labelStyle: TextStyle(
                  color: MetricsColors.gray[800],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          textFieldTheme: TextFieldThemeData(
            focusColor: MetricsColors.black,
            hoverBorderColor: MetricsColors.gray[500],
            prefixIconColor: MetricsColors.gray[400],
            focusedPrefixIconColor: MetricsColors.white,
            textStyle: const MetricsTextStyle(
              color: MetricsColors.white,
              fontSize: 16.0,
              lineHeightInPixels: 20.0,
            ),
          ),
          dropdownTheme: DropdownThemeData(
            backgroundColor: MetricsColors.black,
            openedButtonBackgroundColor: MetricsColors.black,
            hoverBackgroundColor: MetricsColors.black,
            hoverBorderColor: MetricsColors.gray[400],
            openedButtonBorderColor: MetricsColors.gray[300],
            closedButtonBackgroundColor: MetricsColors.gray[900],
            closedButtonBorderColor: MetricsColors.gray[900],
            textStyle: _defaultDropdownTextStyle,
            shadowColor: MetricsColors.shadow32,
            iconColor: MetricsColors.white,
          ),
          dropdownItemTheme: DropdownItemThemeData(
            backgroundColor: Colors.transparent,
            hoverColor: MetricsColors.gray[800],
            textStyle: _defaultDropdownTextStyle,
            hoverTextStyle: _defaultDropdownTextStyle,
          ),
          loginTheme: LoginThemeData(
            titleTextStyle: const TextStyle(
              color: MetricsColors.white,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
            loginOptionButtonStyle: MetricsButtonStyle(
              color: MetricsColors.white,
              hoverColor: MetricsColors.gray[100],
              labelStyle: MetricsTextStyle(
                lineHeightInPixels: 20.0,
                color: MetricsColors.gray[300],
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            passwordVisibilityIconColor: MetricsColors.white,
            inactiveLoginOptionButtonStyle: MetricsButtonStyle(
              color: MetricsColors.gray[700],
              hoverColor: MetricsColors.gray[700],
              labelStyle: MetricsTextStyle(
                lineHeightInPixels: 20.0,
                color: MetricsColors.gray[800],
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          projectMetricsTableTheme: ProjectMetricsTableThemeData(
            metricsTableHeaderTheme: MetricsTableHeaderThemeData(
              textStyle: MetricsTextStyle(
                color: MetricsColors.gray[300],
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                lineHeightInPixels: 16.0,
              ),
            ),
            metricsTableHeaderPlaceholderTheme: ShimmerPlaceholderThemeData(
              backgroundColor: MetricsColors.gray[500],
              shimmerColor: MetricsColors.gray[300],
            ),
            projectMetricsTileTheme: ProjectMetricsTileThemeData(
              backgroundColor: MetricsColors.gray[800],
              hoverBackgroundColor: MetricsColors.gray[700],
              borderColor: MetricsColors.gray[900],
              hoverBorderColor: MetricsColors.gray[900],
              textStyle: const MetricsTextStyle(
                color: MetricsColors.white,
                fontSize: 24.0,
                lineHeightInPixels: 28.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            projectMetricsTilePlaceholderTheme: ShimmerPlaceholderThemeData(
              backgroundColor: MetricsColors.gray[700],
              shimmerColor: MetricsColors.gray[300],
            ),
          ),
          buildNumberScorecardTheme: ScorecardThemeData(
            valueTextStyle: MetricsTextStyle(
              fontSize: 24.0,
              lineHeightInPixels: 24.0,
              color: MetricsColors.gray[200],
              fontWeight: FontWeight.bold,
            ),
            descriptionTextStyle: MetricsTextStyle(
              fontSize: 14.0,
              lineHeightInPixels: 14.0,
              color: MetricsColors.gray[200],
              fontWeight: FontWeight.bold,
            ),
          ),
          dateRangeTheme: DateRangeThemeData(
            textStyle: MetricsTextStyle(
              color: MetricsColors.gray[200],
              fontWeight: FontWeight.bold,
              lineHeightInPixels: 13.0,
              fontSize: 14.0,
            ),
          ),
          performanceSparklineTheme: SparklineThemeData(
            textStyle: MetricsTextStyle(
              color: MetricsColors.gray[200],
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              lineHeightInPixels: 26.0,
            ),
            strokeColor: MetricsColors.gray[200],
            fillColor: MetricsColors.gray[700],
          ),
          projectBuildStatusTheme: ProjectBuildStatusThemeData(
            attentionLevel: ProjectBuildStatusAttentionLevel(
              positive: ProjectBuildStatusStyle(
                backgroundColor: MetricsColors.green[900],
              ),
              negative: ProjectBuildStatusStyle(
                backgroundColor: MetricsColors.orange[900],
              ),
              unknown: ProjectBuildStatusStyle(
                backgroundColor: MetricsColors.gray[700],
              ),
              inactive: const ProjectBuildStatusStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          circlePercentageTheme: CirclePercentageThemeData(
            attentionLevel: CirclePercentageAttentionLevel(
              positive: CirclePercentageStyle(
                strokeColor: MetricsColors.green[900],
                backgroundColor: MetricsColors.green[900],
                valueColor: MetricsColors.green[500],
                valueStyle: TextStyle(
                  color: MetricsColors.green[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              negative: CirclePercentageStyle(
                strokeColor: MetricsColors.orange[900],
                backgroundColor: MetricsColors.orange[900],
                valueColor: MetricsColors.orange[500],
                valueStyle: TextStyle(
                  color: MetricsColors.orange[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              neutral: CirclePercentageStyle(
                strokeColor: MetricsColors.yellow[900],
                backgroundColor: MetricsColors.yellow[900],
                valueColor: MetricsColors.yellow[500],
                valueStyle: TextStyle(
                  color: MetricsColors.yellow[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              inactive: CirclePercentageStyle(
                strokeColor: MetricsColors.gray[700],
                backgroundColor: MetricsColors.gray[700],
                valueColor: MetricsColors.gray[400],
                valueStyle: TextStyle(
                  color: MetricsColors.gray[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
          toggleTheme: ToggleThemeData(
            activeColor: MetricsColors.green[500],
            activeHoverColor: MetricsColors.green[600],
            inactiveColor: MetricsColors.gray[800],
            inactiveHoverColor: MetricsColors.gray[700],
          ),
          userMenuButtonTheme: UserMenuButtonThemeData(
            hoverColor: MetricsColors.gray[300],
            color: MetricsColors.white,
          ),
          userMenuTheme: UserMenuThemeData(
            backgroundColor: MetricsColors.black,
            dividerColor: MetricsColors.gray[700],
            shadowColor: MetricsColors.shadow32,
            contentTextStyle: const MetricsTextStyle(
              color: MetricsColors.white,
              lineHeightInPixels: 20.0,
              fontSize: 16.0,
            ),
          ),
          textPlaceholderTheme: TextPlaceholderThemeData(
            textStyle: TextStyle(
              color: MetricsColors.gray[400],
              fontSize: 14.0,
            ),
          ),
          inputPlaceholderTheme: ShimmerPlaceholderThemeData(
            backgroundColor: MetricsColors.gray[900],
            shimmerColor: MetricsColors.gray[300],
          ),
          toastTheme: ToastThemeData(
            toastAttentionLevel: ToastAttentionLevel(
              positive: ToastStyle(
                backgroundColor: MetricsColors.green[900],
                textStyle: TextStyle(
                  color: MetricsColors.green[500],
                  fontSize: 16.0,
                ),
              ),
              negative: ToastStyle(
                backgroundColor: MetricsColors.orange[900],
                textStyle: TextStyle(
                  color: MetricsColors.orange[500],
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          pageTitleTheme: PageTitleThemeData(
            iconColor: MetricsColors.gray[300],
            textStyle: const MetricsTextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.w500,
              lineHeightInPixels: 42.0,
              color: MetricsColors.white,
            ),
          ),
          graphIndicatorTheme: GraphIndicatorThemeData(
            attentionLevel: GraphIndicatorAttentionLevel(
              positive: GraphIndicatorStyle(
                innerColor: MetricsColors.green[500],
                outerColor: MetricsColors.white,
              ),
              negative: GraphIndicatorStyle(
                innerColor: MetricsColors.orange[500],
                outerColor: MetricsColors.white,
              ),
              neutral: GraphIndicatorStyle(
                innerColor: MetricsColors.gray[400],
                outerColor: MetricsColors.white,
              ),
            ),
          ),
          metricsColoredBarTheme: MetricsColoredBarThemeData(
            attentionLevel: MetricsColoredBarAttentionLevel(
              positive: MetricsColoredBarStyle(
                color: MetricsColors.green[500],
                hoverColor: MetricsColors.green[600],
              ),
              negative: MetricsColoredBarStyle(
                color: MetricsColors.orange[500],
                hoverColor: MetricsColors.orange[600],
              ),
              neutral: MetricsColoredBarStyle(
                color: MetricsColors.gray[300],
                hoverColor: MetricsColors.gray[400],
              ),
            ),
          ),
          debugMenuTheme: DebugMenuThemeData(
            sectionHeaderTextStyle: const MetricsTextStyle(
              color: MetricsColors.white,
              lineHeightInPixels: 26.0,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            sectionContentTextStyle: const MetricsTextStyle(
              color: MetricsColors.white,
              lineHeightInPixels: 20.0,
              fontSize: 16.0,
            ),
            sectionDividerColor: MetricsColors.gray[300],
          ),
        );
}
