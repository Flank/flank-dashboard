import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class DashboardPage extends StatelessWidget {
  static const double _gradientColorOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StateBuilder<ProjectMetricsStore>(
          models: [Injector.getAsReactive<ProjectMetricsStore>()],
          builder: (_, projectMetricsStore) {
            return projectMetricsStore.whenConnectionState(
              onWaiting: _buildProgressIndicator,
              onError: _buildLoadingErrorPlaceholder,
              onIdle: () => RaisedButton(
                onPressed: _loadMetrics,
                child: const Text("Load metrics"),
              ),
              onData: (store) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        child: CirclePercentage(
                          title: 'COVERAGE',
                          value: store.coverage.percent,
                          strokeColor: Colors.grey,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            child: SparklineGraph(
                              title: "Performance",
                              data: store.projectPerformanceMetrics,
                              value: '${store.averageBuildTime}M',
                              curveType: LineCurves.linear,
                              strokeColor: Colors.green,
                              gradientColor: Colors.green
                                  .withOpacity(_gradientColorOpacity),
                            ),
                          ),
                          Flexible(
                            child: SparklineGraph(
                              title: "Build",
                              data: store.projectBuildNumberMetrics,
                              value: '${store.totalBuildNumber}',
                              gradientColor: Colors.blue
                                  .withOpacity(_gradientColorOpacity),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BuildResultBarGraph(
                          data: store.projectBuildResultMetrics,
                          title: "Build task name",
                        ),
                      ),
                    ),
                  ],
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
      text: "An error occured during loading: $error",
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
