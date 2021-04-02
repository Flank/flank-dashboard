// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/graph_indicator/strategy/metrics_graph_indicator_appearance_strategy.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents a strategy for selecting a [GraphIndicatorStyle]
/// based on the given [BuildStatus] value.
class BuildStatusGraphIndicatorAppearanceStrategy
    implements MetricsGraphIndicatorAppearanceStrategy<BuildStatus> {
  /// Creates a new instance of the
  /// [BuildStatusGraphIndicatorAppearanceStrategy].
  const BuildStatusGraphIndicatorAppearanceStrategy();

  @override
  GraphIndicatorStyle selectStyle(
    GraphIndicatorAttentionLevel attentionLevel,
    BuildStatus value,
  ) {
    switch (value) {
      case BuildStatus.successful:
        return attentionLevel.positive;
      case BuildStatus.failed:
        return attentionLevel.negative;
      case BuildStatus.unknown:
        return attentionLevel.neutral;
      case BuildStatus.inProgress:
        return attentionLevel.neutral;
    }

    return null;
  }
}
