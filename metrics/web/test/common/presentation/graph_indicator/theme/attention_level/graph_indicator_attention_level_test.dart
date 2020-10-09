import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

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
      const normal = GraphIndicatorStyle(innerColor: Colors.blue);
      const secondary = GraphIndicatorStyle(innerColor: Colors.yellow);
      const negative = GraphIndicatorStyle(innerColor: Colors.red);
      final attentionLevel = GraphIndicatorAttentionLevel(
        positive: normal,
        neutral: secondary,
        negative: negative,
      );

      expect(attentionLevel.positive, equals(normal));
      expect(attentionLevel.neutral, equals(secondary));
      expect(attentionLevel.negative, equals(negative));
    });
  });
}
