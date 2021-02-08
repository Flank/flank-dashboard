// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/shimmer_container.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that displays a placeholder for the metrics table header
/// with a shimmer effect displayed while the metrics are loading.
class MetricsTableHeaderLoadingPlaceholder extends StatelessWidget {
  /// Creates a new instance of the [MetricsTableHeaderLoadingPlaceholder].
  const MetricsTableHeaderLoadingPlaceholder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context)
        .projectMetricsTableTheme
        .metricsTableHeaderPlaceholderTheme;

    return ShimmerContainer(
      shimmerColor: theme.shimmerColor,
      height: 18.0,
      borderRadius: BorderRadius.circular(9.0),
      color: theme.backgroundColor,
    );
  }
}
