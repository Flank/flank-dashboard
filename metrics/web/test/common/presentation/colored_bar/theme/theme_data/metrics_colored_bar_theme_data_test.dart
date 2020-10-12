import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/colored_bar/theme/theme_data/metrics_colored_bar_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("MetricsColoredBarThemeData", () {
    test(
      "creates a theme with default attention level if the given attention level is null",
      () {
        final theme = MetricsColoredBarThemeData(
          attentionLevel: null,
        );

        expect(theme.attentionLevel, isNotNull);
      },
    );

    test("creates a theme with the given attention level", () {
      const attentionLevel = MetricsColoredBarAttentionLevel(
        positive: MetricsColoredBarStyle(color: Colors.red),
      );

      final theme = MetricsColoredBarThemeData(
        attentionLevel: attentionLevel,
      );

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
