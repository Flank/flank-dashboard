// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/common/presentation/graph_indicator/strategy/metrics_graph_indicator_appearance_strategy.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/graph_indicator.dart';

/// A widget that displays the [GraphIndicator] for the given value.
class MetricsGraphIndicator<T> extends GraphIndicator {
  /// A [MetricsGraphIndicatorAppearanceStrategy] to apply to this graph
  /// indicator.
  final MetricsGraphIndicatorAppearanceStrategy<T> strategy;

  /// A value to display by this graph indicator.
  final T value;

  /// Creates a new instance of the [MetricsGraphIndicator] with the given
  /// [strategy] and [value].
  ///
  /// Throws an assertion error if the given [strategy] is `null`.
  const MetricsGraphIndicator({
    @required this.strategy,
    this.value,
  }) : assert(strategy != null);

  @override
  GraphIndicatorStyle selectStyle(GraphIndicatorAttentionLevel attentionLevel) {
    return strategy.selectStyle(attentionLevel, value);
  }
}
