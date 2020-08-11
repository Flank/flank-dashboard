import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:metrics/common/presentation/dropdown/theme/theme_data/dropdown_item_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/build_results_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/delete_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dropdown_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_circle_percentage_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_table_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/theme_data/project_build_status_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/toggle_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/user_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_card_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/scorecard/theme_data/scorecard_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/sparkline/theme_data/sparkline_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/text_field_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';

/// Stores the theme data for all metric widgets.
class MetricsThemeData {
  static const MetricWidgetThemeData _defaultWidgetThemeData =
      MetricWidgetThemeData();

  /// A theme of the [CirclePercentage]
  final MetricCirclePercentageThemeData metricCirclePercentageThemeData;

  /// A theme of the metrics widgets used to set the default colors
  /// and text styles.
  final MetricWidgetThemeData metricWidgetTheme;

  /// A theme of the inactive metric widgets used when there are no data
  /// for metric.
  final MetricWidgetThemeData inactiveWidgetTheme;

  /// A theme for the [BuildResultBarGraph] used to set the colors
  /// of the graph bars.
  final BuildResultsThemeData buildResultTheme;

  /// A theme for dialogs.
  final ProjectGroupDialogThemeData projectGroupDialogTheme;

  /// A theme for delete dialogs.
  final DeleteDialogThemeData deleteDialogTheme;

  /// A theme for project group cards.
  final ProjectGroupCardThemeData projectGroupCardTheme;

  /// A theme for the add project group card.
  final ProjectGroupCardThemeData addProjectGroupCardTheme;

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

  /// The theme for the performance sparkline.
  final SparklineThemeData performanceSparklineTheme;

  /// A theme for the project build status.
  final ProjectBuildStatusThemeData projectBuildStatusTheme;

  /// A theme for the toggle widgets.
  final ToggleThemeData toggleTheme;

  /// A theme for the user menu popup.
  final UserMenuThemeData userMenuTheme;

  /// Creates the [MetricsThemeData].
  const MetricsThemeData({
    MetricCirclePercentageThemeData metricCirclePercentageThemeData,
    MetricWidgetThemeData metricWidgetTheme,
    MetricWidgetThemeData inactiveWidgetTheme,
    BuildResultsThemeData buildResultTheme,
    ProjectGroupDialogThemeData projectGroupDialogTheme,
    DeleteDialogThemeData deleteDialogTheme,
    ProjectGroupCardThemeData projectGroupCardTheme,
    ProjectGroupCardThemeData addProjectGroupCardTheme,
    MetricsButtonThemeData metricsButtonTheme,
    TextFieldThemeData textFieldTheme,
    DropdownThemeData dropdownTheme,
    DropdownItemThemeData dropdownItemTheme,
    LoginThemeData loginTheme,
    ProjectMetricsTableThemeData projectMetricsTableTheme,
    ScorecardThemeData buildNumberScorecardTheme,
    SparklineThemeData performanceSparklineTheme,
    ProjectBuildStatusThemeData projectBuildStatusTheme,
    ToggleThemeData toggleTheme,
    UserMenuThemeData userMenuTheme,
  })  : metricCirclePercentageThemeData = metricCirclePercentageThemeData ??
            const MetricCirclePercentageThemeData(),
        inactiveWidgetTheme = inactiveWidgetTheme ?? _defaultWidgetThemeData,
        metricWidgetTheme = metricWidgetTheme ?? _defaultWidgetThemeData,
        buildResultTheme = buildResultTheme ??
            const BuildResultsThemeData(
              canceledColor: Colors.grey,
              successfulColor: Colors.teal,
              failedColor: Colors.redAccent,
            ),
        projectGroupDialogTheme =
            projectGroupDialogTheme ?? const ProjectGroupDialogThemeData(),
        deleteDialogTheme = deleteDialogTheme ?? const DeleteDialogThemeData(),
        projectGroupCardTheme =
            projectGroupCardTheme ?? const ProjectGroupCardThemeData(),
        addProjectGroupCardTheme =
            addProjectGroupCardTheme ?? const ProjectGroupCardThemeData(),
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
        performanceSparklineTheme =
            performanceSparklineTheme ?? const SparklineThemeData(),
        projectBuildStatusTheme =
            projectBuildStatusTheme ?? const ProjectBuildStatusThemeData(),
        toggleTheme = toggleTheme ?? const ToggleThemeData(),
        userMenuTheme = userMenuTheme ?? const UserMenuThemeData();

  /// Creates the new instance of the [MetricsThemeData] based on current instance.
  ///
  /// If any of the passed parameters are null, or parameter isn't specified,
  /// the value will be copied from the current instance.
  MetricsThemeData copyWith({
    MetricCirclePercentageThemeData metricCirclePercentageThemeData,
    MetricWidgetThemeData metricWidgetTheme,
    BuildResultsThemeData buildResultTheme,
    ProjectGroupDialogThemeData projectGroupDialogTheme,
    DeleteDialogThemeData deleteDialogTheme,
    ProjectGroupCardThemeData projectGroupCardTheme,
    ProjectGroupCardThemeData addProjectGroupCardTheme,
    MetricWidgetThemeData inactiveWidgetTheme,
    MetricsButtonThemeData metricsButtonTheme,
    TextFieldThemeData textFieldTheme,
    DropdownThemeData dropdownTheme,
    DropdownItemThemeData dropdownItemTheme,
    LoginThemeData loginTheme,
    ProjectMetricsTableThemeData projectMetricsTableTheme,
    ScorecardThemeData buildNumberScorecardTheme,
    SparklineThemeData performanceSparklineTheme,
    ProjectBuildStatusThemeData projectBuildStatusTheme,
    ToggleThemeData toggleTheme,
    UserMenuThemeData userMenuTheme,
  }) {
    return MetricsThemeData(
      metricCirclePercentageThemeData: metricCirclePercentageThemeData ??
          this.metricCirclePercentageThemeData,
      metricWidgetTheme: metricWidgetTheme ?? this.metricWidgetTheme,
      buildResultTheme: buildResultTheme ?? this.buildResultTheme,
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
      performanceSparklineTheme:
          performanceSparklineTheme ?? this.performanceSparklineTheme,
      projectBuildStatusTheme:
          projectBuildStatusTheme ?? this.projectBuildStatusTheme,
      toggleTheme: toggleTheme ?? this.toggleTheme,
      userMenuTheme: userMenuTheme ?? this.userMenuTheme,
    );
  }
}
