// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/colored_bar/strategy/metrics_colored_bar_appearance_strategy.dart';
import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/colored_bar/theme/theme_data/metrics_colored_bar_theme_data.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group('MetricsColoredBar', () {
    const metricsTheme = MetricsThemeData(
      metricsColoredBarTheme: MetricsColoredBarThemeData(
        attentionLevel: MetricsColoredBarAttentionLevel(
          neutral: MetricsColoredBarStyle(
            color: Colors.orange,
            hoverColor: Colors.white,
          ),
        ),
      ),
    );

    final coloredBarFinder = find.byType(ColoredBar);

    testWidgets(
      "throws an AssertionError if the given strategy is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(strategy: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given is hovered is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(isHovered: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given height to the colored bar",
      (WidgetTester tester) async {
        const height = 10.0;
        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(
            height: height,
          ),
        );

        final coloredBar = tester.widget<ColoredBar>(coloredBarFinder);

        expect(coloredBar.height, equals(height));
      },
    );

    testWidgets(
      "applies a width from the dimension config to the colored bar",
      (WidgetTester tester) async {
        const expectedWidth = DimensionsConfig.graphBarWidth;

        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(
            theme: metricsTheme,
          ),
        );

        final coloredBar = tester.widget<ColoredBar>(coloredBarFinder);

        expect(coloredBar.width, equals(expectedWidth));
      },
    );

    testWidgets(
      "applies a hover color from the style returned from strategy when the metrics colored bar is hovered",
      (WidgetTester tester) async {
        final theme = metricsTheme.metricsColoredBarTheme;
        final expectedColor = theme.attentionLevel.neutral.hoverColor;

        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(
            theme: metricsTheme,
            isHovered: true,
          ),
        );

        final coloredBar = tester.widget<ColoredBar>(coloredBarFinder);

        expect(coloredBar.color, equals(expectedColor));
      },
    );

    testWidgets(
      "applies a color from the style returned from strategy to the colored bar if the metrics colored bar is not hovered",
      (WidgetTester tester) async {
        final theme = metricsTheme.metricsColoredBarTheme;
        final expectedColor = theme.attentionLevel.neutral.color;

        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(
            theme: metricsTheme,
            isHovered: false,
          ),
        );

        final coloredBar = tester.widget<ColoredBar>(coloredBarFinder);

        expect(coloredBar.color, equals(expectedColor));
      },
    );
  });
}

/// A stub implementation for the [MetricsColoredBarAppearanceStrategy] to use
/// in tests. Always returns the [MetricsColoredBarAttentionLevel.neutral]
/// style from the theme.
class _MetricsColoredBarAppearanceStrategyStub
    extends MetricsColoredBarAppearanceStrategy<int> {
  /// Creates a new instance of the [_MetricsColoredBarAppearanceStrategyStub].
  const _MetricsColoredBarAppearanceStrategyStub();

  @override
  MetricsColoredBarStyle getWidgetAppearance(MetricsThemeData themeData, __) {
    return themeData.metricsColoredBarTheme.attentionLevel.neutral;
  }
}

/// A testbed widget, used to test the [MetricsColoredBar] widget.
class _MetricsColoredBarTestbed extends StatelessWidget {
  /// An appearance strategy to apply to this bar.
  final MetricsColoredBarAppearanceStrategy<int> strategy;

  /// A value to display by this bar.
  final int value;

  /// A height of this bar.
  final double height;

  /// Indicates whether this widget is hovered.
  final bool isHovered;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates an instance of the [_MetricsColoredBarTestbed].
  ///
  /// The [theme] defaults to an empty [MetricsThemeData] instance.
  /// The [strategy] defaults to the
  /// [_MetricsColoredBarAppearanceStrategyStub] instance.
  /// The [isHovered] defaults to a `false`.
  /// The [value] defaults to `1`.
  const _MetricsColoredBarTestbed({
    Key key,
    this.theme = const MetricsThemeData(),
    this.strategy = const _MetricsColoredBarAppearanceStrategyStub(),
    this.isHovered = false,
    this.value = 1,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: MetricsColoredBar<int>(
        strategy: strategy,
        height: height,
        isHovered: isHovered,
        value: value,
      ),
    );
  }
}
