// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsColoredBarAttentionLevel", () {
    test(
      "creates an instance with default styles if the given styles are null",
      () {
        const attentionLevel = MetricsColoredBarAttentionLevel(
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
        const attentionLevel = MetricsColoredBarAttentionLevel();

        expect(attentionLevel.positive, isNotNull);
        expect(attentionLevel.neutral, isNotNull);
        expect(attentionLevel.negative, isNotNull);
      },
    );

    test("creates an instance with the given styles", () {
      const positive = MetricsColoredBarStyle(color: Colors.blue);
      const neutral = MetricsColoredBarStyle(color: Colors.yellow);
      const negative = MetricsColoredBarStyle(color: Colors.red);
      const attentionLevel = MetricsColoredBarAttentionLevel(
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
