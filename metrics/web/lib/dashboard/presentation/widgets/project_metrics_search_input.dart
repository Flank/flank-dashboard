// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/project_search_input/widgets/projects_search_input.dart';
import 'package:metrics/common/presentation/widgets/metrics_input_placeholder.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';

/// A widget that displays a project metrics search input.
///
/// Displays the [MetricsInputPlaceholder] while metrics are loading,
/// and the [ProjectSearchInput] when metrics are loaded.
class ProjectMetricsSearchInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectMetricsNotifier>(
      builder: (_, notifier, __) {
        final isLoading = notifier.isMetricsLoading;
        final projectNameFilter = notifier.projectNameFilter;

        if (isLoading) return const MetricsInputPlaceholder();

        return ProjectSearchInput(
          onChanged: (value) => _filterProjectMetrics(context, value),
          initialValue: projectNameFilter,
        );
      },
    );
  }

  /// Filters the project metrics using the given [value].
  void _filterProjectMetrics(BuildContext context, String value) {
    final projectMetricsNotifier = Provider.of<ProjectMetricsNotifier>(
      context,
      listen: false,
    );

    projectMetricsNotifier.filterByProjectName(value);
  }
}
