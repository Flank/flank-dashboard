// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:metrics/common/presentation/colored_bar/theme/theme_data/metrics_colored_bar_theme_data.dart';
import 'package:metrics/common/presentation/dropdown/theme/theme_data/dropdown_item_theme_data.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/theme_data/graph_indicator_theme_data.dart';
import 'package:metrics/common/presentation/manufacturer_banner/theme/theme_data/manufaacturer_banner_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/theme_data/add_project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/bar_graph_popup/theme_data/bar_graph_popup_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/theme_data/circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/date_range/theme_data/date_range_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/delete_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dropdown_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
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
import 'package:metrics/common/presentation/toast/theme/theme_data/toast_theme_data.dart';
import 'package:metrics/common/presentation/toggle/theme/theme_data/toggle_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_icon/theme/theme_data/tooltip_icon_theme_data.dart';
import 'package:metrics/common/presentation/tooltip_popup/theme/theme_data/tooltip_popup_theme_data.dart';
import 'package:metrics/common/presentation/user_menu_button/theme/user_menu_button_theme_data.dart';

/// Stores the theme data for all metrics widgets.
class MetricsThemeData {
  static const MetricsWidgetThemeData _defaultWidgetThemeData =
      MetricsWidgetThemeData();

  /// A theme of the metrics widgets used to set the default colors
  /// and text styles.
  final MetricsWidgetThemeData metricsWidgetTheme;

  /// A theme of the inactive metrics widgets used when there are no data
  /// for metrics.
  final MetricsWidgetThemeData inactiveWidgetTheme;

  /// A theme for colored bars.
  final MetricsColoredBarThemeData metricsColoredBarTheme;

  /// A theme for dialogs.
  final ProjectGroupDialogThemeData projectGroupDialogTheme;

  /// A theme for delete dialogs.
  final DeleteDialogThemeData deleteDialogTheme;

  /// A theme for project group cards.
  final ProjectGroupCardThemeData projectGroupCardTheme;

  /// A theme for the add project group card.
  final AddProjectGroupCardThemeData addProjectGroupCardTheme;

  /// A theme for the buttons.
  final MetricsButtonThemeData metricsButtonTheme;

  /// A theme for the text fields.
  final TextFieldThemeData textFieldTheme;

  /// A theme for the dropdowns.
  final DropdownThemeData dropdownTheme;

  /// A theme for the dropdown items.
  final DropdownItemThemeData dropdownItemTheme;

  /// A theme for the login page.
  final LoginThemeData loginTheme;

  /// A theme for the project metrics table.
  final ProjectMetricsTableThemeData projectMetricsTableTheme;

  /// A theme for the build number scorecard.
  final ScorecardThemeData buildNumberScorecardTheme;

  /// A theme for the date range.
  final DateRangeThemeData dateRangeTheme;

  /// The theme for the performance sparkline.
  final SparklineThemeData performanceSparklineTheme;

  /// A theme for the project build status.
  final ProjectBuildStatusThemeData projectBuildStatusTheme;

  /// A theme for the toggle widgets.
  final ToggleThemeData toggleTheme;

  /// A theme for the user menu button.
  final UserMenuButtonThemeData userMenuButtonTheme;

  /// A theme for the user menu popup.
  final UserMenuThemeData userMenuTheme;

  /// A theme for the text placeholders.
  final TextPlaceholderThemeData textPlaceholderTheme;

  /// A theme for the input placeholders.
  final ShimmerPlaceholderThemeData inputPlaceholderTheme;

  /// A theme for the circle percentage.
  final CirclePercentageThemeData circlePercentageTheme;

  /// A theme for the toasts.
  final ToastThemeData toastTheme;

  /// A theme for the page title.
  final PageTitleThemeData pageTitleTheme;

  /// A theme for the bar graph popup.
  final BarGraphPopupThemeData barGraphPopupTheme;

  /// A theme for the tooltip popup.
  final TooltipPopupThemeData tooltipPopupTheme;

  /// A theme for the tooltip icon.
  final TooltipIconThemeData tooltipIconTheme;

  /// A theme for the graph indicator.
  final GraphIndicatorThemeData graphIndicatorTheme;

  /// A theme for the debug menu.
  final DebugMenuThemeData debugMenuTheme;

  final ManufacturerBannerThemeData manufacturerBannerThemeData;

  /// Creates the [MetricsThemeData].
  const MetricsThemeData({
    MetricsWidgetThemeData metricsWidgetTheme,
    MetricsWidgetThemeData inactiveWidgetTheme,
    MetricsColoredBarThemeData metricsColoredBarTheme,
    ProjectGroupDialogThemeData projectGroupDialogTheme,
    DeleteDialogThemeData deleteDialogTheme,
    ProjectGroupCardThemeData projectGroupCardTheme,
    AddProjectGroupCardThemeData addProjectGroupCardTheme,
    MetricsButtonThemeData metricsButtonTheme,
    TextFieldThemeData textFieldTheme,
    DropdownThemeData dropdownTheme,
    DropdownItemThemeData dropdownItemTheme,
    LoginThemeData loginTheme,
    ProjectMetricsTableThemeData projectMetricsTableTheme,
    ScorecardThemeData buildNumberScorecardTheme,
    DateRangeThemeData dateRangeTheme,
    SparklineThemeData performanceSparklineTheme,
    ProjectBuildStatusThemeData projectBuildStatusTheme,
    ToggleThemeData toggleTheme,
    UserMenuButtonThemeData userMenuButtonTheme,
    UserMenuThemeData userMenuTheme,
    TextPlaceholderThemeData textPlaceholderTheme,
    ShimmerPlaceholderThemeData inputPlaceholderTheme,
    CirclePercentageThemeData circlePercentageTheme,
    ToastThemeData toastTheme,
    BarGraphPopupThemeData barGraphPopupTheme,
    TooltipPopupThemeData tooltipPopupTheme,
    TooltipIconThemeData tooltipIconTheme,
    PageTitleThemeData pageTitleTheme,
    GraphIndicatorThemeData graphIndicatorTheme,
    DebugMenuThemeData debugMenuTheme,
    ManufacturerBannerThemeData manufacturerBannerThemeData,
  })  : inactiveWidgetTheme = inactiveWidgetTheme ?? _defaultWidgetThemeData,
        metricsWidgetTheme = metricsWidgetTheme ?? _defaultWidgetThemeData,
        metricsColoredBarTheme =
            metricsColoredBarTheme ?? const MetricsColoredBarThemeData(),
        projectGroupDialogTheme =
            projectGroupDialogTheme ?? const ProjectGroupDialogThemeData(),
        deleteDialogTheme = deleteDialogTheme ?? const DeleteDialogThemeData(),
        projectGroupCardTheme =
            projectGroupCardTheme ?? const ProjectGroupCardThemeData(),
        addProjectGroupCardTheme =
            addProjectGroupCardTheme ?? const AddProjectGroupCardThemeData(),
        metricsButtonTheme =
            metricsButtonTheme ?? const MetricsButtonThemeData(),
        textFieldTheme = textFieldTheme ?? const TextFieldThemeData(),
        dropdownTheme = dropdownTheme ?? const DropdownThemeData(),
        dropdownItemTheme = dropdownItemTheme ?? const DropdownItemThemeData(),
        loginTheme = loginTheme ?? const LoginThemeData(),
        projectMetricsTableTheme =
            projectMetricsTableTheme ?? const ProjectMetricsTableThemeData(),
        buildNumberScorecardTheme =
            buildNumberScorecardTheme ?? const ScorecardThemeData(),
        dateRangeTheme = dateRangeTheme ?? const DateRangeThemeData(),
        performanceSparklineTheme =
            performanceSparklineTheme ?? const SparklineThemeData(),
        projectBuildStatusTheme =
            projectBuildStatusTheme ?? const ProjectBuildStatusThemeData(),
        toggleTheme = toggleTheme ?? const ToggleThemeData(),
        userMenuButtonTheme =
            userMenuButtonTheme ?? const UserMenuButtonThemeData(),
        userMenuTheme = userMenuTheme ?? const UserMenuThemeData(),
        textPlaceholderTheme =
            textPlaceholderTheme ?? const TextPlaceholderThemeData(),
        inputPlaceholderTheme =
            inputPlaceholderTheme ?? const ShimmerPlaceholderThemeData(),
        circlePercentageTheme =
            circlePercentageTheme ?? const CirclePercentageThemeData(),
        toastTheme = toastTheme ?? const ToastThemeData(),
        barGraphPopupTheme =
            barGraphPopupTheme ?? const BarGraphPopupThemeData(),
        tooltipPopupTheme = tooltipPopupTheme ?? const TooltipPopupThemeData(),
        tooltipIconTheme = tooltipIconTheme ?? const TooltipIconThemeData(),
        pageTitleTheme = pageTitleTheme ?? const PageTitleThemeData(),
        graphIndicatorTheme =
            graphIndicatorTheme ?? const GraphIndicatorThemeData(),
        debugMenuTheme = debugMenuTheme ?? const DebugMenuThemeData(),
        manufacturerBannerThemeData =
            manufacturerBannerThemeData ?? const ManufacturerBannerThemeData();

  /// Creates the new instance of the [MetricsThemeData] based on current instance.
  ///
  /// If any of the passed parameters are null, or parameter isn't specified,
  /// the value will be copied from the current instance.
  MetricsThemeData copyWith(
      {MetricsWidgetThemeData metricsWidgetTheme,
      MetricsColoredBarThemeData metricsColoredBarTheme,
      ProjectGroupDialogThemeData projectGroupDialogTheme,
      DeleteDialogThemeData deleteDialogTheme,
      ProjectGroupCardThemeData projectGroupCardTheme,
      AddProjectGroupCardThemeData addProjectGroupCardTheme,
      MetricsWidgetThemeData inactiveWidgetTheme,
      MetricsButtonThemeData metricsButtonTheme,
      TextFieldThemeData textFieldTheme,
      DropdownThemeData dropdownTheme,
      DropdownItemThemeData dropdownItemTheme,
      LoginThemeData loginTheme,
      ProjectMetricsTableThemeData projectMetricsTableTheme,
      ScorecardThemeData buildNumberScorecardTheme,
      DateRangeThemeData dateRangeTheme,
      SparklineThemeData performanceSparklineTheme,
      ProjectBuildStatusThemeData projectBuildStatusTheme,
      ToggleThemeData toggleTheme,
      UserMenuButtonThemeData userMenuButtonTheme,
      UserMenuThemeData userMenuTheme,
      TextPlaceholderThemeData textPlaceholderTheme,
      ShimmerPlaceholderThemeData inputPlaceholderTheme,
      CirclePercentageThemeData circlePercentageTheme,
      ToastThemeData toastTheme,
      BarGraphPopupThemeData barGraphPopupTheme,
      TooltipPopupThemeData tooltipPopupTheme,
      TooltipIconThemeData tooltipIconTheme,
      PageTitleThemeData pageTitleTheme,
      GraphIndicatorThemeData graphIndicatorTheme,
      DebugMenuThemeData debugMenuTheme,
      ManufacturerBannerThemeData manufacturerBannerThemeData}) {
    return MetricsThemeData(
      metricsWidgetTheme: metricsWidgetTheme ?? this.metricsWidgetTheme,
      metricsColoredBarTheme:
          metricsColoredBarTheme ?? this.metricsColoredBarTheme,
      projectGroupDialogTheme:
          projectGroupDialogTheme ?? this.projectGroupDialogTheme,
      deleteDialogTheme: deleteDialogTheme ?? this.deleteDialogTheme,
      projectGroupCardTheme:
          projectGroupCardTheme ?? this.projectGroupCardTheme,
      addProjectGroupCardTheme:
          addProjectGroupCardTheme ?? this.addProjectGroupCardTheme,
      inactiveWidgetTheme: inactiveWidgetTheme ?? this.inactiveWidgetTheme,
      metricsButtonTheme: metricsButtonTheme ?? this.metricsButtonTheme,
      textFieldTheme: textFieldTheme ?? this.textFieldTheme,
      dropdownTheme: dropdownTheme ?? this.dropdownTheme,
      dropdownItemTheme: dropdownItemTheme ?? this.dropdownItemTheme,
      loginTheme: loginTheme ?? this.loginTheme,
      projectMetricsTableTheme:
          projectMetricsTableTheme ?? this.projectMetricsTableTheme,
      buildNumberScorecardTheme:
          buildNumberScorecardTheme ?? this.buildNumberScorecardTheme,
      dateRangeTheme: dateRangeTheme ?? this.dateRangeTheme,
      performanceSparklineTheme:
          performanceSparklineTheme ?? this.performanceSparklineTheme,
      projectBuildStatusTheme:
          projectBuildStatusTheme ?? this.projectBuildStatusTheme,
      toggleTheme: toggleTheme ?? this.toggleTheme,
      userMenuButtonTheme: userMenuButtonTheme ?? this.userMenuButtonTheme,
      userMenuTheme: userMenuTheme ?? this.userMenuTheme,
      textPlaceholderTheme: textPlaceholderTheme ?? this.textPlaceholderTheme,
      inputPlaceholderTheme:
          inputPlaceholderTheme ?? this.inputPlaceholderTheme,
      circlePercentageTheme:
          circlePercentageTheme ?? this.circlePercentageTheme,
      toastTheme: toastTheme ?? this.toastTheme,
      pageTitleTheme: pageTitleTheme ?? this.pageTitleTheme,
      barGraphPopupTheme: barGraphPopupTheme ?? this.barGraphPopupTheme,
      tooltipPopupTheme: tooltipPopupTheme ?? this.tooltipPopupTheme,
      tooltipIconTheme: tooltipIconTheme ?? this.tooltipIconTheme,
      graphIndicatorTheme: graphIndicatorTheme ?? this.graphIndicatorTheme,
      debugMenuTheme: debugMenuTheme ?? this.debugMenuTheme,
      manufacturerBannerThemeData:
          manufacturerBannerThemeData ?? this.manufacturerBannerThemeData,
    );
  }
}
