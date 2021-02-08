// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_loading_header.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_title_header.dart';
import 'package:provider/provider.dart';

/// A widget that displays the header of the metrics table.
///
/// Displays the [MetricsTableLoadingHeader] while metrics are loading,
/// and [MetricsTableTitleHeader] when metrics are loaded.
class MetricsTableHeader extends StatelessWidget {
  /// Creates a new instance of the [MetricsTableHeader].
  const MetricsTableHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProjectMetricsNotifier, bool>(
      selector: (_, state) => state.isMetricsLoading,
      builder: (_, isLoading, __) {
        if (isLoading) return const MetricsTableLoadingHeader();

        return const MetricsTableTitleHeader();
      },
    );
  }
}
