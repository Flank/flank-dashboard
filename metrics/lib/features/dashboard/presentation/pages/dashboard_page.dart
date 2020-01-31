import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../widgets/circle_percentage.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StateBuilder<ProjectMetricsStore>(
          models: [Injector.getAsReactive<ProjectMetricsStore>()],
          builder: (_, coverageStore) {
            return Center(
              child: coverageStore.whenConnectionState(
                onIdle: () => RaisedButton(
                  onPressed: _loadCoverageInfo,
                  child: const Text("Load coverage info"),
                ),
                onWaiting: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                onData: (store) => Container(
                  alignment: Alignment.center,
                  height: 200.0,
                  child: CirclePercentage(
                    title: 'COVERAGE',
                    value: store.coverage.percent,
                    strokeColor: Colors.grey,
                  ),
                ),
                onError: (error) => _DashboardPlaceholder(
                  text: "An error occured during loading: $error",
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _loadCoverageInfo() {
    Injector.getAsReactive<ProjectMetricsStore>()
        .setState((store) => store.getCoverage('projectId'));
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
