import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/domain/usecases/receive_project_metrics_updates.dart';
import 'package:metrics/features/dashboard/presentation/config/dashboard_widget_config.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_number_text_metric.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
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
    final projectMetrics = widget.projectMetrics;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 144.0,
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: DashboardWidgetConfig.leadingFlex,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  projectMetrics.projectName ?? '',
                  style: const TextStyle(fontSize: 22.0),
                ),
              ),
            ),
            Flexible(
              flex: DashboardWidgetConfig.trailingFlex,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: LoadingBuilder(
                        isLoading: projectMetrics.buildResultMetrics == null,
                        loadingPlaceholder: const LoadingPlaceholder(),
                        builder: (_) => BuildResultBarGraph(
                          data: widget.projectMetrics.buildResultMetrics,
                          numberOfBars: ReceiveProjectMetricsUpdates
                              .lastBuildsForChartsMetrics,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LoadingBuilder(
                      isLoading: projectMetrics.performanceMetrics == null,
                      loadingPlaceholder: const LoadingPlaceholder(),
                      builder: (_) => SparklineGraph(
                        data: projectMetrics.performanceMetrics,
                        value:
                            '${projectMetrics.averageBuildDurationInMinutes}M',
                      ),
                    ),
                  ),
                  Expanded(
                    child: LoadingBuilder(
                      isLoading: projectMetrics.buildNumberMetric == null,
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BuildNumberTextMetric(
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
                      builder: (_) => CirclePercentage(
                        value: projectMetrics.stability?.value,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LoadingBuilder(
                      isLoading: projectMetrics == null,
                      loadingPlaceholder: const LoadingPlaceholder(),
                      builder: (_) => CirclePercentage(
                        value: projectMetrics.coverage?.value,
                      ),
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
