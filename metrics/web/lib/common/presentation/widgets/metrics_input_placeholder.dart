import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/shimmer_container.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// Displays the metrics styled [ShimmerContainer] as an input placeholder.
class MetricsInputPlaceholder extends StatelessWidget {
  /// Creates a new instance of the [MetricsInputPlaceholder].
  const MetricsInputPlaceholder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).inputPlaceholderTheme;

    return ShimmerContainer(
      height: 48.0,
      color: theme.backgroundColor,
      borderRadius: BorderRadius.circular(4.0),
    );
  }
}
