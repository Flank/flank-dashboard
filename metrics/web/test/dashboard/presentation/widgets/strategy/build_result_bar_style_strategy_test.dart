import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/colored_bar/theme/theme_data/metrics_colored_bar_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsColoredBarAppearanceStrategy", () {
    const positiveStyle = MetricsColoredBarStyle(color: Colors.yellow);
    const negativeStyle = MetricsColoredBarStyle(color: Colors.red);
    const neutralStyle = MetricsColoredBarStyle(color: Colors.grey);
    const theme = MetricsThemeData(
      metricsColoredBarTheme: MetricsColoredBarThemeData(
        attentionLevel: MetricsColoredBarAttentionLevel(
          positive: positiveStyle,
          negative: negativeStyle,
          neutral: neutralStyle,
        ),
      ),
    );
    const themeStrategy = BuildResultBarAppearanceStrategy();

    test(
      ".getWidgetAppearance() returns the neutral style if the given build status is null",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(theme, null);

        expect(actualStyle, equals(neutralStyle));
      },
    );

    test(
      ".getWidgetAppearance() returns the positive style if the given build status is successful",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.successful,
        );

        expect(actualStyle, equals(positiveStyle));
      },
    );

    test(
      ".getWidgetAppearance() returns the negative style if the given build status is failed",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.failed,
        );

        expect(actualStyle, equals(negativeStyle));
      },
    );

    test(
      ".getWidgetAppearance() returns the negative style if the given build status is cancelled",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.cancelled,
        );

        expect(actualStyle, equals(neutralStyle));
      },
    );
  });
}
