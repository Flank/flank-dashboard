import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/colored_bar.dart';
import 'package:metrics/common/presentation/colored_bar/theme/attention_level/metrics_colored_bar_attention_level.dart';
import 'package:metrics/common/presentation/colored_bar/theme/style/metrics_colored_bar_style.dart';
import 'package:metrics/common/presentation/colored_bar/theme/theme_data/metrics_colored_bar_theme_data.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';

import '../../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group('MetricsColoredBar', () {
    const metricsTheme = MetricsThemeData(
      metricsColoredBarTheme: MetricsColoredBarThemeData(
        attentionLevel: MetricsColoredBarAttentionLevel(
          neutral: MetricsColoredBarStyle(
            color: Colors.orange,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );

    final coloredBarFinder = find.byType(ColoredBar);
    final containerFinder = find.ancestor(
      of: coloredBarFinder,
      matching: find.byType(Container),
    );

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
      "throws an AssertionError if the given isHovered is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(isHovered: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "delegates given height to the colored bar",
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
      "applies background color from metrics colored bar style when the metrics colored bar is hovered",
      (WidgetTester tester) async {
        final theme = metricsTheme.metricsColoredBarTheme;
        final expectedColor = theme.attentionLevel.neutral.backgroundColor;

        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(
            theme: metricsTheme,
            isHovered: true,
          ),
        );

        final containerWidget = tester.widget<Container>(containerFinder);

        expect(containerWidget.color, equals(expectedColor));
      },
    );

    testWidgets(
      "does not apply background color if the metrics colored bar is not hovered",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(
            theme: metricsTheme,
            isHovered: false,
          ),
        );

        final containerWidget = tester.widget<Container>(containerFinder);

        expect(containerWidget.color, isNull);
      },
    );

    testWidgets(
      "applies color from the metrics colored bar style to the colored bar",
      (WidgetTester tester) async {
        final theme = metricsTheme.metricsColoredBarTheme;
        final expectedColor = theme.attentionLevel.neutral.color;

        await tester.pumpWidget(
          const _MetricsColoredBarTestbed(
            theme: metricsTheme,
          ),
        );

        final coloredBar = tester.widget<ColoredBar>(coloredBarFinder);

        expect(coloredBar.color, equals(expectedColor));
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsColoredBar] widget.
class _MetricsColoredBarTestbed extends StatelessWidget {
  /// An appearance strategy to apply to this bar.
  final BuildResultBarAppearanceStrategy strategy;

  /// A value to display by this bar.
  final BuildStatus buildStatus;

  /// A height of this bar.
  final double height;

  /// Indicates whether this widget is hovered.
  final bool isHovered;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData theme;

  /// Creates an instance of the [_GraphIndicatorTestbed].
  ///
  /// The [theme] defaults to an empty [MetricsThemeData] instance.
  /// The [strategy] defaults to an empty
  /// [BuildResultBarAppearanceStrategy] instance.
  /// The [isHovered] defaults to a `false`.
  /// The [buildStatus] defaults to a [BuildStatus.cancelled].
  const _MetricsColoredBarTestbed({
    Key key,
    this.theme = const MetricsThemeData(),
    this.strategy = const BuildResultBarAppearanceStrategy(),
    this.isHovered = false,
    this.buildStatus = BuildStatus.cancelled,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: MetricsColoredBar<BuildStatus>(
        strategy: strategy,
        height: height,
        isHovered: isHovered,
        value: buildStatus,
      ),
    );
  }
}
