import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/loading_builder.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/dashboard/presentation/view_models/project_metrics_tile_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_number_scorecard.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_tile.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/stability_circle_percentage.dart';

/// Displays the project name and it's metrics.
class ProjectMetricsTile extends StatefulWidget {
  /// A [ProjectMetricsTileViewModel] to display.
  final ProjectMetricsTileViewModel projectMetricsViewModel;

  /// Creates the [ProjectMetricsTile].
  ///
  /// Throws an [AssertionError] when the given [projectMetricsViewModel] is null.
  const ProjectMetricsTile({
    Key key,
    @required this.projectMetricsViewModel,
  })  : assert(projectMetricsViewModel != null),
        super(key: key);

  @override
  _ProjectMetricsTileState createState() => _ProjectMetricsTileState();
}

class _ProjectMetricsTileState extends State<ProjectMetricsTile>
    with AutomaticKeepAliveClientMixin {
  /// A height of this tile.
  static const double _tileHeight = 144.0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final projectMetrics = widget.projectMetricsViewModel;
    final brightness = Theme.of(context).brightness;

    return Container(
      height: _tileHeight,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          border: Border.all(
            color: brightness == Brightness.dark
                ? Colors.black54
                : Colors.grey[300],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: MetricsTableTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                projectMetrics.projectName ?? '',
                style: const TextStyle(fontSize: 22.0),
              ),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LoadingBuilder(
                      isLoading: projectMetrics.buildResultMetrics == null,
                      loadingPlaceholder: const LoadingPlaceholder(),
                      builder: (_) => BuildResultBarGraph(
                        buildResultMetric:
                            widget.projectMetricsViewModel.buildResultMetrics,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: LoadingBuilder(
                    isLoading: projectMetrics.performanceSparkline == null,
                    loadingPlaceholder: const LoadingPlaceholder(),
                    builder: (_) => PerformanceSparklineGraph(
                      performanceSparkline: projectMetrics.performanceSparkline,
                    ),
                  ),
                ),
                Expanded(
                  child: LoadingBuilder(
                    isLoading: projectMetrics.buildNumberMetric == null,
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BuildNumberScorecard(
                          buildNumberMetric: projectMetrics.buildNumberMetric,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: LoadingBuilder(
                    isLoading: projectMetrics == null,
                    loadingPlaceholder: const LoadingPlaceholder(),
                    builder: (_) => StabilityCirclePercentage(
                      stability: projectMetrics.stability,
                    ),
                  ),
                ),
                Expanded(
                  child: LoadingBuilder(
                    isLoading: projectMetrics == null,
                    loadingPlaceholder: const LoadingPlaceholder(),
                    builder: (_) => CoverageCirclePercentage(
                      coverage: projectMetrics.coverage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
