// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';

/// A class that stores [GraphIndicatorStyle]s for different
/// visual feedback levels for graph indicators within application.
class GraphIndicatorAttentionLevel {
  /// A [GraphIndicatorStyle] for graph indicators that provide colors
  /// for positive graph elements.
  final GraphIndicatorStyle positive;

  /// A [GraphIndicatorStyle] for graph indicators that provide colors
  /// for negative graph elements.
  final GraphIndicatorStyle negative;

  /// A [GraphIndicatorStyle] for graph indicators that provide colors
  /// for neutral graph elements.
  final GraphIndicatorStyle neutral;

  /// Creates a new instance of the [GraphIndicatorAttentionLevel].
  ///
  /// If the given parameters are `null`, an empty instance of
  /// the [GraphIndicatorStyle] is used.
  const GraphIndicatorAttentionLevel({
    GraphIndicatorStyle positive,
    GraphIndicatorStyle negative,
    GraphIndicatorStyle neutral,
  })  : positive = positive ?? const GraphIndicatorStyle(),
        negative = negative ?? const GraphIndicatorStyle(),
        neutral = neutral ?? const GraphIndicatorStyle();
}
