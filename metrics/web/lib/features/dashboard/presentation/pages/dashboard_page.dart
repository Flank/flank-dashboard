import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_title.dart';
import 'package:metrics/features/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// Shows the available projects and metrics for these projects.
class DashboardPage extends StatelessWidget {
  static const _contentPadding = EdgeInsets.symmetric(horizontal: 64.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            60.0,
          ),
          child: const Padding(
            padding: _contentPadding,
            child: MetricsTitle(),
          ),
        ),
      ),
      drawer: const MetricsDrawer(),
      body: SafeArea(
        child: WhenRebuilder<ProjectMetricsStore>(
          models: [Injector.getAsReactive<ProjectMetricsStore>()],
          onError: _buildLoadingErrorPlaceholder,
          onWaiting: () => const LoadingPlaceholder(),
          onIdle: () => const LoadingPlaceholder(),
          onData: (store) {
            return Container(
              alignment: Alignment.center,
              padding: _contentPadding,
              child: StreamBuilder<List<ProjectMetricsData>>(
                stream: store.projectsMetrics,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LoadingPlaceholder();

                  final projects = snapshot.data;

                  if (projects.isEmpty) {
                    return const _DashboardPlaceholder(
                      text: DashboardStrings.noConfiguredProjects,
                    );
                  }

                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];

                      return ProjectMetricsTile(projectMetrics: project);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the loading error placeholder.
  Widget _buildLoadingErrorPlaceholder(error) {
    return _DashboardPlaceholder(
      text: DashboardStrings.getLoadingErrorMessage("$error"),
    );
  }
}

/// Widget that displays the placeholder [text] in center of the screen.
class _DashboardPlaceholder extends StatelessWidget {
  final String text;

  /// Creates the dashboard placeholder widget with the given [text].
  const _DashboardPlaceholder({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
