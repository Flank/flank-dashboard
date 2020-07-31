import 'package:metrics/common/presentation/metrics_theme/model/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_metrics_tile_theme_data.dart';

/// A class that stores the theme data for the project metrics table.
class ProjectMetricsTableThemeData {
  /// A theme for the metrics table header.
  final MetricsTableHeaderThemeData metricsTableHeaderTheme;

  /// A theme for the project metrics tile.
  final ProjectMetricsTileThemeData projectMetricsTileTheme;

  /// Creates an instance of the [ProjectMetricsTableThemeData].
  const ProjectMetricsTableThemeData({
    this.metricsTableHeaderTheme = const MetricsTableHeaderThemeData(),
    this.projectMetricsTileTheme = const ProjectMetricsTileThemeData(),
  });
}
