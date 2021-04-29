// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/sparkline_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/sparkline/theme_data/sparkline_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("PerformanceSparklineGraph", () {
    const performanceMetricValue = Duration(minutes: 1);
    final performanceMetric = PerformanceSparklineViewModel(
      performance: UnmodifiableListView([const Point(1, 2), const Point(3, 4)]),
      value: performanceMetricValue,
    );

    const fillColor = Colors.blue;
    const strokeColor = Colors.grey;
    const textStyle = TextStyle(color: strokeColor);

    const metricsTheme = MetricsThemeData(
      performanceSparklineTheme: SparklineThemeData(
        fillColor: fillColor,
        strokeColor: strokeColor,
        textStyle: textStyle,
      ),
    );

    testWidgets(
      "throws an AssertionError if the given performance sparkline is null",
      (tester) async {
        await tester.pumpWidget(const _PerformanceSparklineGraphTestbed(
          performanceSparkline: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the value text",
      (tester) async {
        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
        ));

        expect(
          find.text(CommonStrings.duration(performanceMetricValue)),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "delegates the data display to the SparklineGraph",
      (tester) async {
        const performance = [Point(1, 2), Point(3, 4)];
        final performanceMetric = PerformanceSparklineViewModel(
          performance: UnmodifiableListView(performance),
        );

        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
        ));

        final sparklineGraph = tester.widget<SparklineGraph>(
          find.byType(SparklineGraph),
        );

        expect(sparklineGraph.data, equals(performance));
      },
    );

    testWidgets(
      "displays the no data placeholder if the given performance metric is empty",
      (tester) async {
        final performanceMetric = PerformanceSparklineViewModel(
          performance: UnmodifiableListView([]),
        );

        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
        ));

        expect(
          find.byType(NoDataPlaceholder),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "applies the text style from the metrics theme to the value text",
      (tester) async {
        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final valueText = tester.widget<Text>(
            find.text(CommonStrings.duration(performanceMetricValue)));

        expect(valueText.style, equals(textStyle));
      },
    );

    testWidgets(
      "applies the stroke color from the metrics theme to the sparkline graph's stroke color",
      (tester) async {
        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final sparklineGraph = tester.widget<SparklineGraph>(
          find.byType(SparklineGraph),
        );

        expect(sparklineGraph.strokeColor, equals(strokeColor));
      },
    );

    testWidgets(
      "applies the fill color metrics theme to the sparkline graph's fill color",
      (tester) async {
        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final sparklineGraph = tester.widget<SparklineGraph>(
          find.byType(SparklineGraph),
        );

        expect(sparklineGraph.fillColor, equals(fillColor));
      },
    );

    testWidgets(
      "displays the styled container if the performance list contains a single value",
      (tester) async {
        final performanceMetric = PerformanceSparklineViewModel(
          performance: UnmodifiableListView([const Point(1, 2)]),
        );

        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final finder = find.descendant(
          of: find.byType(PerformanceSparklineGraph),
          matching: find.byType(Container),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the fill color from the metrics theme to the container's color",
      (tester) async {
        final performanceMetric = PerformanceSparklineViewModel(
          performance: UnmodifiableListView([const Point(1, 2)]),
        );

        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, equals(fillColor));
      },
    );

    testWidgets(
      "applies the stroke color from the metrics theme to the container's border",
      (tester) async {
        final performanceMetric = PerformanceSparklineViewModel(
          performance: UnmodifiableListView([const Point(1, 2)]),
        );

        await tester.pumpWidget(_PerformanceSparklineGraphTestbed(
          performanceSparkline: performanceMetric,
          metricsTheme: metricsTheme,
        ));

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.border.top.color, equals(strokeColor));
      },
    );
  });
}

/// A testbed class needed to test the [PerformanceSparklineGraph] widget.
class _PerformanceSparklineGraphTestbed extends StatelessWidget {
  /// A [PerformanceSparklineViewModel] to display.
  final PerformanceSparklineViewModel performanceSparkline;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData metricsTheme;

  /// Creates a [_PerformanceSparklineGraphTestbed] with the given [performanceSparkline].
  const _PerformanceSparklineGraphTestbed({
    Key key,
    this.performanceSparkline,
    this.metricsTheme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsTheme,
      body: PerformanceSparklineGraph(
        performanceSparkline: performanceSparkline,
      ),
    );
  }
}
