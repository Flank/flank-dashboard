import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/sparkline_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_metric_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/expandable_text.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';

/// A [SparklineGraph] that represents the performance metric.
class PerformanceSparklineGraph extends StatelessWidget {
  /// A [PerformanceMetricViewModel] with data to display.
  final PerformanceMetricViewModel performanceMetric;

  /// Creates [PerformanceSparklineGraph] with the given [performanceMetric].
  ///
  /// The [performanceMetric] is required and must not be `null`.
  const PerformanceSparklineGraph({
    Key key,
    @required this.performanceMetric,
  })  : assert(performanceMetric != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (performanceMetric.performance.isEmpty) {
      return const NoDataPlaceholder();
    }

    final performanceTheme = MetricsTheme.of(context).metricWidgetTheme;

    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ExpandableText(
              DashboardStrings.minutes(performanceMetric.value),
              style: TextStyle(
                color: performanceTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: SparklineGraph(
            data: performanceMetric.performance,
            strokeColor: performanceTheme.primaryColor,
            fillColor: performanceTheme.accentColor,
          ),
        ),
      ],
    );
  }
}
