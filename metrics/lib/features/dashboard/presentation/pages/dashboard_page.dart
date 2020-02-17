import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MetricsDrawer(),
      body: SafeArea(
        child: StateBuilder<ProjectMetricsStore>(
          models: [Injector.getAsReactive<ProjectMetricsStore>()],
          builder: (_, projectMetricsStore) {
            return projectMetricsStore.whenConnectionState(
              onWaiting: _buildProgressIndicator,
              onError: _buildLoadingErrorPlaceholder,
              onIdle: () => RaisedButton(
                onPressed: _loadMetrics,
                child: const Text(DashboardStrings.loadMetrics),
              ),
              onData: (store) {
                return Center(
                  child: Container(
                    height: 200.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: BuildResultBarGraph(
                            data: store.projectBuildResultMetrics,
                            title: DashboardStrings.buildTaskName,
                          ),
                        ),
                        Flexible(
                          child: SparklineGraph(
                            title: DashboardStrings.performance,
                            data: store.projectPerformanceMetrics,
                            value: '${store.averageBuildTime}M',
                            curveType: LineCurves.linear,
                          ),
                        ),
                        Flexible(
                          child: SparklineGraph(
                            title: DashboardStrings.builds,
                            data: store.projectBuildNumberMetrics,
                            value: '${store.totalBuildNumber}',
                          ),
                        ),
                        Flexible(
                          child: CirclePercentage(
                            title: DashboardStrings.stability,
                            value: store.coverage.percent,
                          ),
                        ),
                        Flexible(
                          child: CoverageCirclePercentage(
                            value: store.coverage.percent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadingErrorPlaceholder(error) {
    return _DashboardPlaceholder(
      text: DashboardStrings.getLoadingErrorMessage("$error"),
    );
  }

  void _loadMetrics() {
    const projectId = 'projectId';

    Injector.getAsReactive<ProjectMetricsStore>().setState((store) async {
      await store.getCoverage(projectId);
      await store.getBuildMetrics(projectId);

      return;
    });
  }
}

class _DashboardPlaceholder extends StatelessWidget {
  final String text;

  const _DashboardPlaceholder({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}
