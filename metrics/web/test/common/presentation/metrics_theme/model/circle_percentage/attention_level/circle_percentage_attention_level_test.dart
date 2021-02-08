// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("CirclePercentageAttentionLevel", () {
    test(
      "creates an instance with a default positive style if the given style is null",
      () {
        const attentionLevel = CirclePercentageAttentionLevel(positive: null);

        expect(attentionLevel, isNotNull);
      },
    );

    test(
      "creates an instance with a default negative style if the given style is null",
      () {
        const attentionLevel = CirclePercentageAttentionLevel(negative: null);

        expect(attentionLevel, isNotNull);
      },
    );

    test(
      "creates an instance with a default neutral style if the given style is null",
      () {
        const attentionLevel = CirclePercentageAttentionLevel(neutral: null);

        expect(attentionLevel, isNotNull);
      },
    );

    test(
      "creates an instance with a default inactive style if the given style is null",
      () {
        const attentionLevel = CirclePercentageAttentionLevel(inactive: null);

        expect(attentionLevel, isNotNull);
      },
    );

    test("creates an instance with the given styles", () {
      const positive = CirclePercentageStyle(valueColor: Colors.green);
      const negative = CirclePercentageStyle(valueColor: Colors.blue);
      const neutral = CirclePercentageStyle(valueColor: Colors.red);
      const inactive = CirclePercentageStyle(valueColor: Colors.black);

      const attentionLevel = CirclePercentageAttentionLevel(
        positive: positive,
        negative: negative,
        neutral: neutral,
        inactive: inactive,
      );

      expect(attentionLevel.positive, equals(positive));
      expect(attentionLevel.negative, equals(negative));
      expect(attentionLevel.neutral, equals(neutral));
      expect(attentionLevel.inactive, equals(inactive));
    });
  });
}
