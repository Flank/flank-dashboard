import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_header.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:provider/provider.dart';

/// A widget that displays the [MetricsTableHeader] with the list of [ProjectMetricsTile].
class MetricsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const MetricsTableHeader(),
        Expanded(
          child: Consumer<ProjectMetricsNotifier>(
            builder: (_, projectsMetricsNotifier, __) {
              if (projectsMetricsNotifier.projectsErrorMessage != null) {
                return _buildLoadingErrorPlaceholder(
                  projectsMetricsNotifier.projectsErrorMessage,
                );
              }

              final projects = projectsMetricsNotifier.projectsMetrics;

              if (projects == null) return const LoadingPlaceholder();

              if (projects.isEmpty) {
                return const _DashboardTablePlaceholder(
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
        ),
      ],
    );
  }

  /// Builds the loading error placeholder.
  Widget _buildLoadingErrorPlaceholder(String errorMessage) {
    return _DashboardTablePlaceholder(
      text: CommonStrings.getLoadingErrorMessage(errorMessage),
    );
  }
}

/// Widget that displays the placeholder [text] in the center of the screen.
class _DashboardTablePlaceholder extends StatelessWidget {
  final String text;

  /// Creates the dashboard placeholder widget with the given [text].
  const _DashboardTablePlaceholder({
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
