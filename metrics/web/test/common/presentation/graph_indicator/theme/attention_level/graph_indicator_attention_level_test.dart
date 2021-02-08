// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("GraphIndicatorAttentionLevel", () {
    test(
      "creates an instance with default styles if the given styles are null",
      () {
        const attentionLevel = GraphIndicatorAttentionLevel(
          negative: null,
          neutral: null,
          positive: null,
        );

        expect(attentionLevel.positive, isNotNull);
        expect(attentionLevel.neutral, isNotNull);
        expect(attentionLevel.negative, isNotNull);
      },
    );

    test(
      "creates an instance with default styles if styles are not specified",
      () {
        const attentionLevel = GraphIndicatorAttentionLevel();

        expect(attentionLevel.positive, isNotNull);
        expect(attentionLevel.neutral, isNotNull);
        expect(attentionLevel.negative, isNotNull);
      },
    );

    test("creates an instance with the given styles", () {
      const positive = GraphIndicatorStyle(innerColor: Colors.blue);
      const neutral = GraphIndicatorStyle(innerColor: Colors.yellow);
      const negative = GraphIndicatorStyle(innerColor: Colors.red);
      const attentionLevel = GraphIndicatorAttentionLevel(
        positive: positive,
        neutral: neutral,
        negative: negative,
      );

      expect(attentionLevel.positive, equals(positive));
      expect(attentionLevel.neutral, equals(neutral));
      expect(attentionLevel.negative, equals(negative));
    });
  });
}
