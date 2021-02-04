// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/dashboard/presentation/view_models/coverage_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_style_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/styled_circle_percentage.dart';

/// A [CirclePercentage] widget that displays the coverage metric
/// and applies the [MetricsValueStyleStrategy].
class CoverageCirclePercentage extends StatelessWidget {
  /// A [CoverageViewModel] to display.
  final CoverageViewModel coverage;

  /// Creates a [CoverageCirclePercentage] with the given [coverage].
  const CoverageCirclePercentage({
    Key key,
    @required this.coverage,
  })  : assert(coverage != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledCirclePercentage(
      percent: coverage,
      appearanceStrategy: const MetricsValueStyleStrategy(),
    );
  }
}
