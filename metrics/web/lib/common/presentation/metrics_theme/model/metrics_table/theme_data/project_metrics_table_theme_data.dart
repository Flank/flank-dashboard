import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/metrics_table_header_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_table/theme_data/project_metrics_tile_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/shimmer_placeholder_theme_data.dart';

/// A class that stores the theme data for the project metrics table.
class ProjectMetricsTableThemeData {
  /// A theme for the metrics table header.
  final MetricsTableHeaderThemeData metricsTableHeaderTheme;

  /// A theme for the project metrics tile.
  final ProjectMetricsTileThemeData projectMetricsTileTheme;

  /// A theme for the project metrics tile placeholder.
  final ShimmerPlaceholderThemeData projectMetricsTilePlaceholderTheme;

  /// Creates an instance of the [ProjectMetricsTableThemeData].
  ///
  /// If the [metricsTableHeaderTheme] is null, an instance of
  /// the [MetricsTableHeaderThemeData] used.
  /// If the [projectMetricsTileTheme] is null, an instance of
  /// the [ProjectMetricsTileThemeData] used.
  /// If the [projectMetricsTilePlaceholderTheme] is null, an instance of
  /// the [ShimmerPlaceholderThemeData] used.
  const ProjectMetricsTableThemeData({
    MetricsTableHeaderThemeData metricsTableHeaderTheme,
    ProjectMetricsTileThemeData projectMetricsTileTheme,
    ShimmerPlaceholderThemeData projectMetricsTilePlaceholderTheme,
  })  : metricsTableHeaderTheme =
            metricsTableHeaderTheme ?? const MetricsTableHeaderThemeData(),
        projectMetricsTileTheme =
            projectMetricsTileTheme ?? const ProjectMetricsTileThemeData(),
        projectMetricsTilePlaceholderTheme =
            projectMetricsTilePlaceholderTheme ??
                const ShimmerPlaceholderThemeData();
}
