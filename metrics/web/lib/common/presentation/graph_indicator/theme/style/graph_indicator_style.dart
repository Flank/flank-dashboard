// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/metrics_colors.dart';

/// A class that stores style data for graph indicators.
class GraphIndicatorStyle {
  /// An inner circle [Color].
  final Color innerColor;

  /// An outer circle [Color].
  final Color outerColor;

  /// Creates a new instance of the [GraphIndicatorStyle].
  ///
  /// The [innerColor] defaults to the [Colors.white].
  /// The [outerColor] defaults to the [MetricsColors.black].
  const GraphIndicatorStyle({
    this.innerColor = Colors.white,
    this.outerColor = MetricsColors.black,
  });
}
