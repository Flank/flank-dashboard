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

/// Stores the theme data for light metrics theme.
class LightMetricsThemeData extends MetricsThemeData {
  static final inputFocusedBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MetricsColors.gray[400],
    ),
  );

  static final TextStyle hintStyle = MetricsTextStyle(
    color: MetricsColors.gray[300],
    fontSize: 16.0,
    lineHeightInPixels: 20.0,
  );

  /// The default [TextStyle] for a dropdown component within the application.
  static final TextStyle _defaultDropdownTextStyle = MetricsTextStyle(
    fontSize: 16.0,
    color: MetricsColors.gray[900],
    lineHeightInPixels: 20.0,
  );

  /// A [TextStyle] of the dialog title.
  static final TextStyle _dialogTitleTextStyle = TextStyle(
    color: MetricsColors.gray[900],
    fontSize: 26.0,
    fontWeight: FontWeight.w500,
  );

  /// Creates the light theme with the default widget theme configuration.
  LightMetricsThemeData()
      : super(
          metricsWidgetTheme: MetricsWidgetThemeData(
            primaryColor: MetricsColors.green[500],
            accentColor: MetricsColors.green[900],
            backgroundColor: MetricsColors.white,
            textStyle: TextStyle(
              color: MetricsColors.green[500],
              fontWeight: FontWeight.bold,
            ),
          ),
          barGraphPopupTheme: BarGraphPopupThemeData(
            color: MetricsColors.white,
            shadowColor: MetricsColors.shadow32,
            titleTextStyle: TextStyleConfig.popupTitleStyle,
            subtitleTextStyle: TextStyleConfig.popupSubtitleStyle,
          ),
          tooltipPopupTheme: TooltipPopupThemeData(
            backgroundColor: MetricsColors.white,
            shadowColor: MetricsColors.shadow32,
            textStyle: TextStyleConfig.tooltipPopupStyle,
          ),
          tooltipIconTheme: TooltipIconThemeData(
            color: MetricsColors.gray[300],
            hoverColor: MetricsColors.gray[400],
          ),
          projectGroupCardTheme: ProjectGroupCardThemeData(
            borderColor: MetricsColors.gray[200],
            hoverColor: MetricsColors.gray[100],
            backgroundColor: MetricsColors.white,
            primaryButtonStyle: MetricsButtonStyle(
              color: MetricsColors.green[500],
              hoverColor: MetricsColors.green[600],
            ),
            accentButtonStyle: MetricsButtonStyle(
              color: MetricsColors.orange[500],
              hoverColor: MetricsColors.orange[600],
            ),
            titleStyle: MetricsTextStyle(
              color: MetricsColors.gray[900],
              lineHeightInPixels: 26.0,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            subtitleStyle: MetricsTextStyle(
              color: MetricsColors.gray[300],
              lineHeightInPixels: 16.0,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          addProjectGroupCardTheme: AddProjectGroupCardThemeData(
            attentionLevel: AddProjectGroupCardAttentionLevel(
              positive: AddProjectGroupCardStyle(
                backgroundColor: MetricsColors.green[100],
                iconColor: MetricsColors.green[500],
                hoverColor: MetricsColors.green[200],
                labelStyle: MetricsTextStyle(
                  color: MetricsColors.green[500],
                  lineHeightInPixels: 20.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              inactive: AddProjectGroupCardStyle(
                backgroundColor: MetricsColors.gray[100],
                hoverColor: MetricsColors.gray[100],
                iconColor: MetricsColors.gray[200],
                labelStyle: MetricsTextStyle(
                  color: MetricsColors.gray[200],
                  lineHeightInPixels: 20.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          deleteDialogTheme: DeleteDialogThemeData(
            backgroundColor: MetricsColors.white,
            closeIconColor: MetricsColors.gray[900],
            titleTextStyle: _dialogTitleTextStyle,
            contentTextStyle: MetricsTextStyle(
              fontSize: 16.0,
              color: MetricsColors.gray[900],
              lineHeightInPixels: 24.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.14,
            ),
          ),
          projectGroupDialogTheme: ProjectGroupDialogThemeData(
            primaryColor: MetricsColors.green[500],
            barrierColor: MetricsColors.barrierColor,
            closeIconColor: MetricsColors.gray[900],
            contentBorderColor: MetricsColors.gray[200],
            titleTextStyle: _dialogTitleTextStyle,
            uncheckedProjectTextStyle: TextStyle(
              color: MetricsColors.gray[900],
              fontSize: 14.0,
            ),
            checkedProjectTextStyle: TextStyle(
              color: MetricsColors.gray[900],
              fontSize: 14.0,
            ),
            counterTextStyle: TextStyleConfig.captionTextStyle,
            errorTextStyle: TextStyle(
              color: MetricsColors.orange[500],
            ),
          ),
          inactiveWidgetTheme: MetricsWidgetThemeData(
            primaryColor: MetricsColors.gray[100],
            accentColor: Colors.transparent,
            backgroundColor: MetricsColors.gray[100],
            textStyle: MetricsTextStyle(
              color: MetricsColors.gray[900],
              fontSize: 32.0,
              lineHeightInPixels: 38.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          metricsButtonTheme: MetricsButtonThemeData(
            buttonAttentionLevel: MetricsButtonAttentionLevel(
              positive: MetricsButtonStyle(
                color: MetricsColors.green[500],
                hoverColor: MetricsColors.green[600],
                labelStyle: MetricsTextStyle(
                  color: MetricsColors.gray[900],
                  fontSize: 16.0,
                  lineHeightInPixels: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              neutral: MetricsButtonStyle(
                color: MetricsColors.gray[100],
                hoverColor: MetricsColors.gray[200],
                labelStyle: TextStyle(
                  color: MetricsColors.gray[900],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              negative: MetricsButtonStyle(
                color: MetricsColors.orange[500],
                hoverColor: MetricsColors.orange[600],
                labelStyle: MetricsTextStyle(
                  color: MetricsColors.gray[900],
                  fontSize: 16.0,
                  lineHeightInPixels: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              inactive: MetricsButtonStyle(
                color: MetricsColors.gray[100],
                labelStyle: MetricsTextStyle(
                  color: MetricsColors.gray[200],
                  lineHeightInPixels: 20,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          textFieldTheme: TextFieldThemeData(
            focusColor: MetricsColors.gray[100],
            hoverBorderColor: MetricsColors.gray[300],
            prefixIconColor: MetricsColors.gray[300],
            focusedPrefixIconColor: MetricsColors.gray[900],
            textStyle: MetricsTextStyle(
              color: MetricsColors.gray[900],
              fontSize: 16.0,
              lineHeightInPixels: 20,
            ),
          ),
          dropdownTheme: DropdownThemeData(
            backgroundColor: MetricsColors.white,
            openedButtonBackgroundColor: MetricsColors.white,
            hoverBackgroundColor: MetricsColors.gray[100],
            hoverBorderColor: MetricsColors.gray[300],
            openedButtonBorderColor: MetricsColors.gray[400],
            closedButtonBackgroundColor: MetricsColors.gray[100],
            closedButtonBorderColor: MetricsColors.gray[100],
            textStyle: _defaultDropdownTextStyle,
            shadowColor: MetricsColors.shadow50,
            iconColor: MetricsColors.black,
          ),
          dropdownItemTheme: DropdownItemThemeData(
            backgroundColor: MetricsColors.white,
            hoverColor: MetricsColors.gray[300],
            textStyle: MetricsTextStyle(
              fontSize: 16.0,
              color: MetricsColors.gray[900],
              lineHeightInPixels: 20,
            ),
            hoverTextStyle: const MetricsTextStyle(
              fontSize: 16.0,
              color: MetricsColors.white,
              lineHeightInPixels: 20,
            ),
          ),
          loginTheme: LoginThemeData(
            titleTextStyle: TextStyle(
              color: MetricsColors.gray[900],
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
            loginOptionButtonStyle: MetricsButtonStyle(
              color: MetricsColors.gray[100],
              hoverColor: MetricsColors.gray[200],
              labelStyle: MetricsTextStyle(
                color: MetricsColors.gray[300],
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                lineHeightInPixels: 20.0,
              ),
            ),
            passwordVisibilityIconColor: MetricsColors.gray[900],
            inactiveLoginOptionButtonStyle: MetricsButtonStyle(
              color: MetricsColors.gray[100],
              hoverColor: MetricsColors.gray[100],
              labelStyle: MetricsTextStyle(
                color: MetricsColors.gray[200],
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                lineHeightInPixels: 20.0,
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
            projectMetricsTileTheme: ProjectMetricsTileThemeData(
              backgroundColor: MetricsColors.white,
              hoverBackgroundColor: MetricsColors.gray[100],
              borderColor: MetricsColors.gray[200],
              hoverBorderColor: MetricsColors.gray[200],
              textStyle: MetricsTextStyle(
                fontSize: 24.0,
                color: MetricsColors.gray[900],
                fontWeight: FontWeight.w500,
                lineHeightInPixels: 28.0,
                letterSpacing: 0.0,
              ),
            ),
            projectMetricsTilePlaceholderTheme: ShimmerPlaceholderThemeData(
              backgroundColor: MetricsColors.gray[100],
              shimmerColor: MetricsColors.gray[300],
            ),
            metricsTableHeaderPlaceholderTheme: ShimmerPlaceholderThemeData(
              backgroundColor: MetricsColors.gray[200],
              shimmerColor: MetricsColors.gray[300],
            ),
          ),
          buildNumberScorecardTheme: ScorecardThemeData(
            valueTextStyle: MetricsTextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: MetricsColors.gray[900],
              lineHeightInPixels: 24.0,
            ),
            descriptionTextStyle: MetricsTextStyle(
              fontSize: 14.0,
              color: MetricsColors.gray[900],
              fontWeight: FontWeight.w700,
              lineHeightInPixels: 14.0,
            ),
          ),
          dateRangeTheme: DateRangeThemeData(
            textStyle: MetricsTextStyle(
              color: MetricsColors.gray[900],
              fontWeight: FontWeight.bold,
              lineHeightInPixels: 13.0,
              fontSize: 14.0,
            ),
          ),
          performanceSparklineTheme: SparklineThemeData(
            strokeColor: MetricsColors.gray[900],
            fillColor: MetricsColors.gray[100],
            textStyle: MetricsTextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: MetricsColors.gray[900],
              lineHeightInPixels: 26.0,
            ),
          ),
          projectBuildStatusTheme: ProjectBuildStatusThemeData(
            attentionLevel: ProjectBuildStatusAttentionLevel(
              positive: ProjectBuildStatusStyle(
                backgroundColor: MetricsColors.green[100],
              ),
              negative: ProjectBuildStatusStyle(
                backgroundColor: MetricsColors.orange[100],
              ),
              unknown: ProjectBuildStatusStyle(
                backgroundColor: MetricsColors.gray[100],
              ),
              inactive: const ProjectBuildStatusStyle(
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          toggleTheme: ToggleThemeData(
            activeColor: MetricsColors.green[500],
            activeHoverColor: MetricsColors.green[600],
            inactiveColor: MetricsColors.gray[300],
            inactiveHoverColor: MetricsColors.gray[400],
          ),
          userMenuButtonTheme: UserMenuButtonThemeData(
            hoverColor: MetricsColors.gray[400],
            color: MetricsColors.gray[900],
          ),
          toastTheme: ToastThemeData(
            toastAttentionLevel: ToastAttentionLevel(
              positive: ToastStyle(
                backgroundColor: MetricsColors.green[100],
                textStyle: MetricsTextStyle(
                  color: MetricsColors.green[500],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  lineHeightInPixels: 20,
                ),
              ),
              negative: ToastStyle(
                backgroundColor: MetricsColors.orange[100],
                textStyle: MetricsTextStyle(
                  color: MetricsColors.orange[500],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  lineHeightInPixels: 20.0,
                ),
              ),
            ),
          ),
          userMenuTheme: UserMenuThemeData(
            backgroundColor: MetricsColors.white,
            dividerColor: MetricsColors.gray[200],
            shadowColor: MetricsColors.shadow32,
            contentTextStyle: MetricsTextStyle(
              color: MetricsColors.gray[900],
              lineHeightInPixels: 20.0,
              fontSize: 16.0,
            ),
          ),
          textPlaceholderTheme: TextPlaceholderThemeData(
            textStyle: MetricsTextStyle(
              color: MetricsColors.gray[200],
              fontSize: 14.0,
              lineHeightInPixels: 18.0,
            ),
          ),
          inputPlaceholderTheme: ShimmerPlaceholderThemeData(
            backgroundColor: MetricsColors.gray[100],
            shimmerColor: MetricsColors.gray[300],
          ),
          circlePercentageTheme: CirclePercentageThemeData(
            attentionLevel: CirclePercentageAttentionLevel(
              positive: CirclePercentageStyle(
                strokeColor: MetricsColors.green[100],
                backgroundColor: MetricsColors.green[100],
                valueColor: MetricsColors.green[500],
                valueStyle: TextStyle(
                  color: MetricsColors.green[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              negative: CirclePercentageStyle(
                strokeColor: MetricsColors.orange[100],
                backgroundColor: MetricsColors.orange[100],
                valueColor: MetricsColors.orange[500],
                valueStyle: TextStyle(
                  color: MetricsColors.orange[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              neutral: CirclePercentageStyle(
                strokeColor: MetricsColors.yellow[100],
                backgroundColor: MetricsColors.yellow[100],
                valueColor: MetricsColors.yellow[500],
                valueStyle: TextStyle(
                  color: MetricsColors.yellow[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              inactive: CirclePercentageStyle(
                strokeColor: MetricsColors.gray[100],
                backgroundColor: MetricsColors.gray[100],
                valueColor: MetricsColors.gray[900],
                valueStyle: TextStyle(
                  color: MetricsColors.gray[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
          pageTitleTheme: PageTitleThemeData(
            iconColor: MetricsColors.gray[300],
            textStyle: MetricsTextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.w500,
              lineHeightInPixels: 42.0,
              color: MetricsColors.gray[900],
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
            sectionHeaderTextStyle: MetricsTextStyle(
              color: MetricsColors.gray[900],
              lineHeightInPixels: 26.0,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            sectionContentTextStyle: MetricsTextStyle(
              color: MetricsColors.gray[900],
              lineHeightInPixels: 20.0,
              fontSize: 16.0,
            ),
            sectionDividerColor: MetricsColors.gray[200],
          ),
        );
}
