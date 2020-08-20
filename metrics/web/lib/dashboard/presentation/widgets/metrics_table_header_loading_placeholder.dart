import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/shimmer_container.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that displays a placeholder for the metrics table header
/// with a shimmer effect.
class MetricsTableHeaderLoadingPlaceholder extends StatelessWidget {
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
