// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';

/// A class that holds the different style configurations
/// for colored bar widgets.
class MetricsColoredBarAttentionLevel {
  /// A [MetricsColoredBarStyle] for a build result bar widget
  /// that provides colors for bars providing positive visual feedback.
  final MetricsColoredBarStyle positive;

  /// A [MetricsColoredBarStyle] for a build result bar widget
  /// that provides colors for bars providing neutral visual feedback.
  final MetricsColoredBarStyle neutral;

  /// A [MetricsColoredBarStyle] for a build result bar widget
  /// that provides colors for bars providing negative visual feedback.
  final MetricsColoredBarStyle negative;

  /// Creates a new instance of the [MetricsColoredBarAttentionLevel].
  ///
  /// If the [positive], [neutral] or [negative] is `null`,
  /// an empty instance of the [MetricsColoredBarStyle] is used.
  const MetricsColoredBarAttentionLevel({
    MetricsColoredBarStyle positive,
    MetricsColoredBarStyle neutral,
    MetricsColoredBarStyle negative,
  })  : positive = positive ?? const MetricsColoredBarStyle(),
        neutral = neutral ?? const MetricsColoredBarStyle(),
        negative = negative ?? const MetricsColoredBarStyle();
}
