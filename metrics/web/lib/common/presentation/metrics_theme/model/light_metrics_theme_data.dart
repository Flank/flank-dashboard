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
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_style_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/theme_data/add_project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/bar_graph_popup/theme_data/bar_graph_popup_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/theme_data/circle_percentage_theme_data.dart';
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
// Looking forward to the color palette from the design team.

/// Stores the theme data for light metrics theme.
class LightMetricsThemeData extends MetricsThemeData {
  static const Color scaffoldColor = Colors.white;
  static const Color inputColor = Color(0xFFF5F8FA);
  static const Color inputHoverColor = Color(0xfffafbfc);
  static const Color _inputHintTextColor = Color(0xFF868691);
  static const Color _inputFocusedBorderColor = Color(0xFF6D6D75);
  static const Color _inactiveBackgroundColor = Color(0xFFf0f0f5);
  static const Color _inactiveButtonColor = Color(0xFFf0f0f5);
  static const Color _inactiveButtonHoverColor = Color(0xFFcccccc);
  static const Color _inactiveTextColor = Color(0xff040d14);
  static const Color _userMenuTextColor = Color(0xFF0d0d0d);
  static const Color _cardHoverColor = Color(0xFFf6f8f9);
  static const Color _borderColor = Color(0xFFe3e9ed);
  static const Color _tableHeaderColor = Color(0xFF79858b);
  static const Color _textPlaceholderColor = Color(0xFFdcdce3);
  static const Color _addProjectGroupCardBackgroundColor = Color(0xffd7faf4);
  static const Color _addProjectGroupCardHoverColor = Color(0xffc3f5eb);
  static const Color _shadowColor = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color _hoverBorderColor = Color(0xffb6b6ba);
  static const Color _positiveToastColor = Color(0xFFE1FAF4);
  static const Color _negativeToastColor = Color(0xFFFFEDE5);
  static const Color _loginOptionTextColor = Color(0xFF757575);
  static const Color _userMenuInactiveColor = Color(0xFF272727);
  static const Color _userMenuActiveColor = Color(0xFF4F4F56);
  static const Color _closeIconColor = Color(0xFF00080C);
  static const Color _metricsTableHeaderLoadingColor = Color(0xFFdcdee0);
  static const Color _barrierColor = Color.fromRGBO(11, 11, 12, 0.3);
  static const Color _metricsTileHoverColor = Color(0xFFf6f8f9);
  static const Color _positiveStatusColor = Color(0xFFE6F9F3);
  static const Color _negativeStatusColor = Color(0xFFFFF5F3);
  static const Color _neutralStatusColor = Color(0xFFFAF6E6);
  static const Color _inactiveStatusColor = Color(0xFF43494D);
  static const Color _iconColor = Color(0xFF2d2d33);
  static const Color _performanceBackgroundColor = Color(0xFFf5f8fa);

  static const inputFocusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: _inputFocusedBorderColor),
  );
  static const TextStyle _defaultDropdownTextStyle = MetricsTextStyle(
    fontSize: 16.0,
    color: _inactiveTextColor,
    lineHeightInPixels: 20.0,
  );
  static const TextStyle hintStyle = MetricsTextStyle(
    color: _inputHintTextColor,
    fontSize: 16.0,
    lineHeightInPixels: 20,
  );

  /// A [TextStyle] of the dialog title.
  static const TextStyle _dialogTitleTextStyle = TextStyle(
    color: _inactiveTextColor,
    fontSize: 26.0,
    fontWeight: FontWeight.w500,
  );

  /// Creates the light theme with the default widget theme configuration.
  const LightMetricsThemeData()
      : super(
          metricsWidgetTheme: const MetricsWidgetThemeData(
            primaryColor: ColorConfig.primaryColor,
            accentColor: ColorConfig.accentColor,
            backgroundColor: Colors.white,
            textStyle: TextStyle(
              color: ColorConfig.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          barGraphPopupTheme: const BarGraphPopupThemeData(
            color: Colors.white,
            shadowColor: _shadowColor,
            titleTextStyle: TextStyleConfig.popupTitleStyle,
            subtitleTextStyle: TextStyleConfig.popupSubtitleStyle,
          ),
          tooltipPopupTheme: const TooltipPopupThemeData(
            backgroundColor: Colors.white,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.32),
            textStyle: TextStyleConfig.tooltipPopupStyle,
          ),
          tooltipIconTheme: const TooltipIconThemeData(
            color: ColorConfig.shimmerColor,
            hoverColor: ColorConfig.tooltipIconHoverColor,
          ),
          projectGroupCardTheme: const ProjectGroupCardThemeData(
            borderColor: _borderColor,
            hoverColor: _cardHoverColor,
            backgroundColor: scaffoldColor,
            primaryButtonStyle: MetricsButtonStyle(
              color: ColorConfig.primaryColor,
              hoverColor: ColorConfig.primaryButtonHoverColor,
            ),
            accentButtonStyle: MetricsButtonStyle(
              color: ColorConfig.accentButtonColor,
              hoverColor: ColorConfig.accentButtonHoverColor,
            ),
            titleStyle: MetricsTextStyle(
              color: _inactiveTextColor,
              lineHeightInPixels: 26.0,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            subtitleStyle: MetricsTextStyle(
              color: ColorConfig.secondaryTextColor,
              lineHeightInPixels: 16.0,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          addProjectGroupCardTheme: const AddProjectGroupCardThemeData(
            attentionLevel: AddProjectGroupCardAttentionLevel(
              positive: AddProjectGroupCardStyle(
                backgroundColor: _addProjectGroupCardBackgroundColor,
                iconColor: ColorConfig.primaryColor,
                hoverColor: _addProjectGroupCardHoverColor,
                labelStyle: MetricsTextStyle(
                  color: ColorConfig.primaryColor,
                  lineHeightInPixels: 20.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              inactive: AddProjectGroupCardStyle(
                backgroundColor: _inactiveBackgroundColor,
                hoverColor: _inactiveBackgroundColor,
                iconColor: _inactiveButtonHoverColor,
                labelStyle: MetricsTextStyle(
                  color: _inactiveButtonHoverColor,
                  lineHeightInPixels: 20.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          deleteDialogTheme: const DeleteDialogThemeData(
            backgroundColor: scaffoldColor,
            closeIconColor: _closeIconColor,
            titleTextStyle: _dialogTitleTextStyle,
            contentTextStyle: MetricsTextStyle(
              fontSize: 16.0,
              color: _inactiveTextColor,
              lineHeightInPixels: 24.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.14,
            ),
          ),
          projectGroupDialogTheme: const ProjectGroupDialogThemeData(
            primaryColor: ColorConfig.primaryColor,
            barrierColor: _barrierColor,
            closeIconColor: _closeIconColor,
            contentBorderColor: _borderColor,
            titleTextStyle: _dialogTitleTextStyle,
            uncheckedProjectTextStyle: TextStyle(
              color: _inactiveTextColor,
              fontSize: 14.0,
            ),
            checkedProjectTextStyle: TextStyle(
              color: _inactiveTextColor,
              fontSize: 14.0,
            ),
            counterTextStyle: TextStyleConfig.captionTextStyle,
            errorTextStyle: TextStyle(color: ColorConfig.accentColor),
          ),
          inactiveWidgetTheme: const MetricsWidgetThemeData(
            primaryColor: inputColor,
            accentColor: Colors.transparent,
            backgroundColor: _inactiveBackgroundColor,
            textStyle: MetricsTextStyle(
              color: _inactiveTextColor,
              fontSize: 32.0,
              lineHeightInPixels: 38.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          metricsButtonTheme: const MetricsButtonThemeData(
            buttonAttentionLevel: MetricsButtonAttentionLevel(
              positive: MetricsButtonStyle(
                color: ColorConfig.primaryColor,
                hoverColor: ColorConfig.primaryButtonHoverColor,
                labelStyle: MetricsTextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  lineHeightInPixels: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              neutral: MetricsButtonStyle(
                color: _inactiveButtonColor,
                hoverColor: _inactiveButtonHoverColor,
                labelStyle: TextStyle(
                  color: _inactiveTextColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              negative: MetricsButtonStyle(
                color: ColorConfig.accentColor,
                hoverColor: ColorConfig.accentButtonHoverColor,
                labelStyle: MetricsTextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  lineHeightInPixels: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              inactive: MetricsButtonStyle(
                color: _inactiveButtonColor,
                labelStyle: MetricsTextStyle(
                  color: _inactiveButtonHoverColor,
                  lineHeightInPixels: 20,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          textFieldTheme: const TextFieldThemeData(
            focusColor: inputHoverColor,
            hoverBorderColor: _hoverBorderColor,
            prefixIconColor: _inputHintTextColor,
            focusedPrefixIconColor: _inactiveTextColor,
            textStyle: MetricsTextStyle(
              color: _inactiveTextColor,
              fontSize: 16.0,
              lineHeightInPixels: 20,
            ),
          ),
          dropdownTheme: const DropdownThemeData(
            backgroundColor: Colors.white,
            openedButtonBackgroundColor: inputHoverColor,
            hoverBackgroundColor: inputHoverColor,
            hoverBorderColor: _hoverBorderColor,
            openedButtonBorderColor: _inputFocusedBorderColor,
            closedButtonBackgroundColor: inputColor,
            closedButtonBorderColor: inputColor,
            textStyle: _defaultDropdownTextStyle,
            shadowColor: _shadowColor,
            iconColor: _iconColor,
          ),
          dropdownItemTheme: const DropdownItemThemeData(
            backgroundColor: Colors.white,
            hoverColor: ColorConfig.shimmerColor,
            textStyle: MetricsTextStyle(
              fontSize: 16.0,
              color: _inactiveTextColor,
              lineHeightInPixels: 20,
            ),
            hoverTextStyle: MetricsTextStyle(
              fontSize: 16.0,
              color: Colors.white,
              lineHeightInPixels: 20,
            ),
          ),
          loginTheme: const LoginThemeData(
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
            loginOptionButtonStyle: MetricsButtonStyle(
              color: inputColor,
              hoverColor: _inactiveButtonHoverColor,
              labelStyle: MetricsTextStyle(
                color: _loginOptionTextColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                lineHeightInPixels: 20.0,
              ),
            ),
            passwordVisibilityIconColor: _iconColor,
            inactiveLoginOptionButtonStyle: MetricsButtonStyle(
              color: _inactiveButtonColor,
              hoverColor: _inactiveButtonColor,
              labelStyle: MetricsTextStyle(
                color: _inactiveButtonHoverColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                lineHeightInPixels: 20.0,
              ),
            ),
          ),
          projectMetricsTableTheme: const ProjectMetricsTableThemeData(
            metricsTableHeaderTheme: MetricsTableHeaderThemeData(
              textStyle: MetricsTextStyle(
                  color: _tableHeaderColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  lineHeightInPixels: 16.0),
            ),
            projectMetricsTileTheme: ProjectMetricsTileThemeData(
              backgroundColor: Colors.white,
              hoverBackgroundColor: _metricsTileHoverColor,
              borderColor: _borderColor,
              hoverBorderColor: _borderColor,
              textStyle: MetricsTextStyle(
                fontSize: 24.0,
                color: _inactiveTextColor,
                fontWeight: FontWeight.w500,
                lineHeightInPixels: 28.0,
                letterSpacing: 0.0,
              ),
            ),
            projectMetricsTilePlaceholderTheme: ShimmerPlaceholderThemeData(
              backgroundColor: inputColor,
              shimmerColor: ColorConfig.shimmerColor,
            ),
            metricsTableHeaderPlaceholderTheme: ShimmerPlaceholderThemeData(
              backgroundColor: _metricsTableHeaderLoadingColor,
              shimmerColor: ColorConfig.shimmerColor,
            ),
          ),
          buildNumberScorecardTheme: const ScorecardThemeData(
            valueTextStyle: MetricsTextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: _inactiveTextColor,
              lineHeightInPixels: 24.0,
            ),
            descriptionTextStyle: MetricsTextStyle(
              fontSize: 14.0,
              color: _inactiveTextColor,
              fontWeight: FontWeight.w700,
              lineHeightInPixels: 14.0,
            ),
          ),
          performanceSparklineTheme: const SparklineThemeData(
            strokeColor: _inactiveTextColor,
            fillColor: _performanceBackgroundColor,
            textStyle: MetricsTextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: _inactiveTextColor,
              lineHeightInPixels: 26.0,
            ),
          ),
          projectBuildStatusTheme: const ProjectBuildStatusThemeData(
            attentionLevel: ProjectBuildStatusAttentionLevel(
              positive: ProjectBuildStatusStyle(
                backgroundColor: _positiveStatusColor,
              ),
              negative: ProjectBuildStatusStyle(
                backgroundColor: _negativeStatusColor,
              ),
              unknown: ProjectBuildStatusStyle(
                backgroundColor: inputColor,
              ),
            ),
          ),
          toggleTheme: const ToggleThemeData(
            activeColor: ColorConfig.primaryColor,
            activeHoverColor: ColorConfig.primaryButtonHoverColor,
            inactiveColor: ColorConfig.shimmerColor,
            inactiveHoverColor: _userMenuActiveColor,
          ),
          userMenuButtonTheme: const UserMenuButtonThemeData(
            hoverColor: _userMenuActiveColor,
            color: _userMenuInactiveColor,
          ),
          toastTheme: const ToastThemeData(
            toastAttentionLevel: ToastAttentionLevel(
              positive: ToastStyle(
                backgroundColor: _positiveToastColor,
                textStyle: MetricsTextStyle(
                  color: ColorConfig.primaryTranslucentColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  lineHeightInPixels: 20,
                ),
              ),
              negative: ToastStyle(
                backgroundColor: _negativeToastColor,
                textStyle: MetricsTextStyle(
                  color: ColorConfig.accentTranslucentColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  lineHeightInPixels: 20.0,
                ),
              ),
            ),
          ),
          userMenuTheme: const UserMenuThemeData(
            backgroundColor: Colors.white,
            dividerColor: _textPlaceholderColor,
            shadowColor: _shadowColor,
            contentTextStyle: MetricsTextStyle(
              color: _userMenuTextColor,
              lineHeightInPixels: 20.0,
              fontSize: 16.0,
            ),
          ),
          textPlaceholderTheme: const TextPlaceholderThemeData(
            textStyle: MetricsTextStyle(
              color: _textPlaceholderColor,
              fontSize: 14.0,
              lineHeightInPixels: 18.0,
            ),
          ),
          inputPlaceholderTheme: const ShimmerPlaceholderThemeData(
            backgroundColor: inputColor,
            shimmerColor: ColorConfig.shimmerColor,
          ),
          circlePercentageTheme: const CirclePercentageThemeData(
            attentionLevel: CirclePercentageAttentionLevel(
              positive: CirclePercentageStyle(
                strokeColor: _positiveStatusColor,
                backgroundColor: _positiveStatusColor,
                valueColor: ColorConfig.primaryColor,
                valueStyle: TextStyle(
                  color: ColorConfig.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              negative: CirclePercentageStyle(
                strokeColor: _negativeStatusColor,
                backgroundColor: _negativeStatusColor,
                valueColor: ColorConfig.accentColor,
                valueStyle: TextStyle(
                  color: ColorConfig.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              neutral: CirclePercentageStyle(
                strokeColor: _neutralStatusColor,
                backgroundColor: _neutralStatusColor,
                valueColor: ColorConfig.yellow,
                valueStyle: TextStyle(
                  color: ColorConfig.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              inactive: CirclePercentageStyle(
                strokeColor: inputColor,
                backgroundColor: inputColor,
                valueColor: _inactiveStatusColor,
                valueStyle: TextStyle(
                  color: _userMenuTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
          pageTitleTheme: const PageTitleThemeData(
            iconColor: _inactiveTextColor,
            textStyle: MetricsTextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.w500,
              lineHeightInPixels: 42.0,
              color: _inactiveTextColor,
            ),
          ),
          graphIndicatorTheme: const GraphIndicatorThemeData(
            attentionLevel: GraphIndicatorAttentionLevel(
              positive: GraphIndicatorStyle(
                innerColor: ColorConfig.primaryColor,
                outerColor: Colors.white,
              ),
              negative: GraphIndicatorStyle(
                innerColor: ColorConfig.accentColor,
                outerColor: Colors.white,
              ),
              neutral: GraphIndicatorStyle(
                innerColor: _userMenuActiveColor,
                outerColor: Colors.white,
              ),
            ),
          ),
          metricsColoredBarTheme: const MetricsColoredBarThemeData(
            attentionLevel: MetricsColoredBarAttentionLevel(
              positive: MetricsColoredBarStyle(
                color: ColorConfig.primaryColor,
                hoverColor: ColorConfig.primaryButtonHoverColor,
              ),
              negative: MetricsColoredBarStyle(
                color: ColorConfig.accentColor,
                hoverColor: ColorConfig.accentButtonHoverColor,
              ),
              neutral: MetricsColoredBarStyle(
                color: ColorConfig.shimmerColor,
                hoverColor: _userMenuActiveColor,
              ),
            ),
          ),
          debugMenuTheme: const DebugMenuThemeData(
            sectionHeaderTextStyle: MetricsTextStyle(
              color: _inactiveTextColor,
              lineHeightInPixels: 26.0,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            sectionContentTextStyle: MetricsTextStyle(
              color: _userMenuTextColor,
              lineHeightInPixels: 20.0,
              fontSize: 16.0,
            ),
            sectionDividerColor: _borderColor,
          ),
        );
}
