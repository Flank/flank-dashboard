// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/negative_graph_indicator.dart';

void main() {
  group("NegativeGraphIndicator", () {
    test(
      ".selectStyle() returns a negative style of the given attention level",
      () {
        const graphIndicatorAttentionLevel = GraphIndicatorAttentionLevel(
          negative: GraphIndicatorStyle(innerColor: Colors.grey),
        );

        const indicator = NegativeGraphIndicator();
        final style = indicator.selectStyle(graphIndicatorAttentionLevel);

        expect(style, equals(graphIndicatorAttentionLevel.negative));
      },
    );
  });
}
