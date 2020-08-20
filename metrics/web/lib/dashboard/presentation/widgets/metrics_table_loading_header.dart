import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_header_loading_placeholder.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';

/// A widget that displays a metrics table header in a loading state.
class MetricsTableLoadingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MetricsTableRow(
      status: Container(),
      name: Container(),
      buildResults: MetricsTableHeaderLoadingPlaceholder(),
      performance: MetricsTableHeaderLoadingPlaceholder(),
      buildNumber: MetricsTableHeaderLoadingPlaceholder(),
      stability: MetricsTableHeaderLoadingPlaceholder(),
      coverage: MetricsTableHeaderLoadingPlaceholder(),
    );
  }
}
