import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/loading_builder.dart';
import 'package:metrics/features/dashboard/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';

/// Displays the project name and it's metrics.
class ProjectMetricsTile extends StatefulWidget {
  final ProjectMetricsData projectMetrics;

  /// Creates the [ProjectMetricsTile].
  ///
  /// [projectMetrics] is the metrics of the project to be displayed.
  const ProjectMetricsTile({
    Key key,
    @required this.projectMetrics,
  })  : assert(projectMetrics != null),
        super(key: key);

  @override
  _ProjectMetricsTileState createState() => _ProjectMetricsTileState();
}

class _ProjectMetricsTileState extends State<ProjectMetricsTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      child: Container(
        height: 150.0,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.projectMetrics.projectName ?? '',
                  style: const TextStyle(fontSize: 22.0),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: LoadingBuilder(
                      isLoading:
                          widget.projectMetrics.buildResultMetrics == null,
                      loadingPlaceholder: const LoadingPlaceholder(),
                      builder: (_) => BuildResultBarGraph(
                        data: widget.projectMetrics.buildResultMetrics,
                        title: DashboardStrings.buildTaskName,
                        numberOfBars:
                            ReceiveProjectMetricsUpdates.numberOfBuildResults,
                      ),
                    ),
                  ),
                  Flexible(
                    child: LoadingBuilder(
                      isLoading:
                          widget.projectMetrics.performanceMetrics == null,
                      loadingPlaceholder: const LoadingPlaceholder(),
                      builder: (_) => SparklineGraph(
                        title: DashboardStrings.performance,
                        data: widget.projectMetrics.performanceMetrics,
                        value:
                            '${widget.projectMetrics.averageBuildDurationInMinutes}M',
                      ),
                    ),
                  ),
                  Flexible(
                    child: LoadingBuilder(
                      isLoading:
                          widget.projectMetrics.buildNumberMetrics == null,
                      loadingPlaceholder: const LoadingPlaceholder(),
                      builder: (_) => SparklineGraph(
                        title: DashboardStrings.builds,
                        data: widget.projectMetrics.buildNumberMetrics,
                        value: '${widget.projectMetrics.numberOfBuilds}',
                      ),
                    ),
                  ),
                  LoadingBuilder(
                    isLoading: widget.projectMetrics.coverage == null,
                    loadingPlaceholder: const Flexible(
                      child: LoadingPlaceholder(),
                    ),
                    builder: (_) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CirclePercentage(
                        title: DashboardStrings.stability,
                        value: widget.projectMetrics.stability.value,
                      ),
                    ),
                  ),
                  LoadingBuilder(
                    isLoading: widget.projectMetrics.coverage == null,
                    loadingPlaceholder: const Flexible(
                      child: LoadingPlaceholder(),
                    ),
                    builder: (_) => CoverageCirclePercentage(
                      value: widget.projectMetrics.coverage.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
