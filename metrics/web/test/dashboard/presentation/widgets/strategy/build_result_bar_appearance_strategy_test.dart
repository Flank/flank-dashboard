// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/colored_bar/theme/theme_data/metrics_colored_bar_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_appearance_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultBarAppearanceStrategy", () {
    const theme = MetricsThemeData(
      metricsColoredBarTheme: MetricsColoredBarThemeData(
        attentionLevel: MetricsColoredBarAttentionLevel(
          positive: MetricsColoredBarStyle(color: Colors.yellow),
          negative: MetricsColoredBarStyle(color: Colors.red),
          neutral: MetricsColoredBarStyle(color: Colors.grey),
        ),
      ),
    );
    const themeStrategy = BuildResultBarAppearanceStrategy();

    test(
      ".getWidgetAppearance() returns the null if the given build status is null",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(theme, null);

        expect(actualStyle, isNull);
      },
    );

    test(
      ".getWidgetAppearance() returns the positive style if the given build status is successful",
      () {
        final style = theme.metricsColoredBarTheme.attentionLevel.positive;
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.successful,
        );

        expect(actualStyle, equals(style));
      },
    );

    test(
      ".getWidgetAppearance() returns the negative style if the given build status is failed",
      () {
        final style = theme.metricsColoredBarTheme.attentionLevel.negative;
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.failed,
        );

        expect(actualStyle, equals(style));
      },
    );

    test(
      ".getWidgetAppearance() returns the neutral style if the given build status is unknown",
      () {
        final style = theme.metricsColoredBarTheme.attentionLevel.neutral;
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.unknown,
        );

        expect(actualStyle, equals(style));
      },
    );
  });
}
