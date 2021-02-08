// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/circle_percentage.dart';
import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/metrics_value_style_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/styled_circle_percentage.dart';

/// A [CirclePercentage] widget that displays the stability metric
/// and applies the [MetricsValueStyleStrategy].
class StabilityCirclePercentage extends StatelessWidget {
  /// A [StabilityViewModel] to display.
  final StabilityViewModel stability;

  /// Creates the [StabilityCirclePercentage] with the given [stability].
  const StabilityCirclePercentage({
    Key key,
    @required this.stability,
  })  : assert(stability != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledCirclePercentage(
      percent: stability,
      appearanceStrategy: const MetricsValueStyleStrategy(),
    );
  }
}
