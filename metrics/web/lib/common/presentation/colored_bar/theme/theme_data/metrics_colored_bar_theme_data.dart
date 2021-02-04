// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';

/// A class that stores the theme data for the application colored bars.
class MetricsColoredBarThemeData
    extends AttentionLevelThemeData<MetricsColoredBarAttentionLevel> {
  /// Creates a new instance of the [MetricsColoredBarThemeData].
  ///
  /// If the [attentionLevel] is `null`, an empty
  /// [MetricsColoredBarAttentionLevel] instance is used.
  const MetricsColoredBarThemeData({
    MetricsColoredBarAttentionLevel attentionLevel,
  }) : super(attentionLevel ?? const MetricsColoredBarAttentionLevel());
}
