// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/tooltip_title.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';

/// A widget that displays a metrics table header with titles of the metrics.
class MetricsTableTitleHeader extends StatelessWidget {
  /// Creates a new instance of the [MetricsTableTitleHeader].
  const MetricsTableTitleHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const src = 'icons/info.svg';

    return MetricsTableRow(
      status: Container(),
      name: Container(),
      buildResults: const TooltipTitle(
        src: src,
        tooltip: DashboardStrings.lastBuildsDescription,
        title: DashboardStrings.lastBuilds,
      ),
      performance: const TooltipTitle(
        src: src,
        tooltip: DashboardStrings.performanceDescription,
        title: DashboardStrings.performance,
      ),
      buildNumber: const TooltipTitle(
        src: src,
        tooltip: DashboardStrings.buildsDescription,
        title: DashboardStrings.builds,
      ),
      stability: const TooltipTitle(
        src: src,
        tooltip: DashboardStrings.stabilityDescription,
        title: DashboardStrings.stability,
      ),
      coverage: const TooltipTitle(
        src: src,
        tooltip: DashboardStrings.coverageDescription,
        title: DashboardStrings.coverage,
      ),
    );
  }
}
