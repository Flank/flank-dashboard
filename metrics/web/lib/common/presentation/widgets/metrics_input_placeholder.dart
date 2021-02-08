// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/shimmer_container.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// Displays the metrics styled [ShimmerContainer] as an input placeholder.
///
/// Applies colors from the [MetricsThemeData.inputPlaceholderTheme].
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
      shimmerColor: theme.shimmerColor,
      borderRadius: BorderRadius.circular(4.0),
    );
  }
}
