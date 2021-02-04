// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/theme_data/graph_indicator_theme_data.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/graph_indicator.dart';

/// A [GraphIndicator] widget that applies
/// the [GraphIndicatorAttentionLevel.neutral] indicator style
/// from the [GraphIndicatorThemeData].
class NeutralGraphIndicator extends GraphIndicator {
  /// Creates a new instance of the [NeutralGraphIndicator].
  const NeutralGraphIndicator({Key key}) : super(key: key);

  @override
  GraphIndicatorStyle selectStyle(GraphIndicatorAttentionLevel attentionLevel) {
    return attentionLevel.neutral;
  }
}
