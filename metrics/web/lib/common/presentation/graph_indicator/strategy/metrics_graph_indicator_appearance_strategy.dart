// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';

/// A class that represents the strategy of applying the [GraphIndicatorStyle]
/// based on the given [Value].
abstract class MetricsGraphIndicatorAppearanceStrategy<Value> {
  /// Creates a new instance of the [MetricsGraphIndicatorAppearanceStrategy].
  const MetricsGraphIndicatorAppearanceStrategy();

  /// Selects the proper [GraphIndicatorStyle] from the given [attentionLevel]
  /// according to the given [value].
  GraphIndicatorStyle selectStyle(
    GraphIndicatorAttentionLevel attentionLevel,
    Value value,
  );
}
