// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/theme_data/graph_indicator_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GraphIndicatorThemeData", () {
    test(
      "creates a theme with default attention level if the given attention level is null",
      () {
        const theme = GraphIndicatorThemeData(
          attentionLevel: null,
        );

        expect(theme.attentionLevel, isNotNull);
      },
    );

    test("creates a theme with the given attention level", () {
      const attentionLevel = GraphIndicatorAttentionLevel(
        positive: GraphIndicatorStyle(
          innerColor: Colors.red,
        ),
      );

      const theme = GraphIndicatorThemeData(
        attentionLevel: attentionLevel,
      );

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
