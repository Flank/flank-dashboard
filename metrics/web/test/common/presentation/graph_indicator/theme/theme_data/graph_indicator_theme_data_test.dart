import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/theme_data/graph_indicator_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GraphIndicatorThemeData", () {
    test(
      "creates a theme with default attention level if the given attention level is null",
      () {
        final theme = GraphIndicatorThemeData(
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

      final theme = GraphIndicatorThemeData(
        attentionLevel: attentionLevel,
      );

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
