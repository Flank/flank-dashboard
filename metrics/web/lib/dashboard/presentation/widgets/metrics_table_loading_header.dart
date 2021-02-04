// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_header_loading_placeholder.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table_row.dart';

/// A widget that displays a metrics table header in a loading state.
class MetricsTableLoadingHeader extends StatelessWidget {
  /// Creates a new instance of the [MetricsTableLoadingHeader].
  const MetricsTableLoadingHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsTableRow(
      status: Container(),
      name: Container(),
      buildResults: const MetricsTableHeaderLoadingPlaceholder(),
      performance: const MetricsTableHeaderLoadingPlaceholder(),
      buildNumber: const MetricsTableHeaderLoadingPlaceholder(),
      stability: const MetricsTableHeaderLoadingPlaceholder(),
      coverage: const MetricsTableHeaderLoadingPlaceholder(),
    );
  }
}
