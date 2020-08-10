import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/attention_level/circle_percentage_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/theme_data/circle_percentage_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("CirclePercentageTheme", () {
    test(
      "creates a theme with a default attention level if the given attention level is null",
      () {
        final theme = CirclePercentageThemeData(attentionLevel: null);

        expect(theme.attentionLevel, isNotNull);
      },
    );

    test("creates a theme with the given attention level", () {
      final attentionLevel = CirclePercentageAttentionLevel(
        positive: CirclePercentageStyle(strokeColor: Colors.red),
      );

      final theme = CirclePercentageThemeData(attentionLevel: attentionLevel);

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
