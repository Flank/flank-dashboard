// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/sparkline_graph.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("SparklineGraph", () {
    const minAxisValue = 1;
    const maxAxisValue = 8;

    testWidgets(
      "throws an AssertionError if the given stroke width is null",
      (WidgetTester tester) async {
        await tester
            .pumpWidget(const _SparklineGraphTestbed(strokeWidth: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given stroke width is negative",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _SparklineGraphTestbed(
          strokeWidth: -1.0,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given data is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _SparklineGraphTestbed(data: null));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "can be created with an empty data",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _SparklineGraphTestbed(
          data: [],
        ));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      "creates the chart line from the given data",
      (WidgetTester tester) async {
        const sparklineGraphTestData = [
          Point(1, 5),
          Point(2, 7),
          Point(3, 1),
        ];

        await tester.pumpWidget(const _SparklineGraphTestbed(
          data: sparklineGraphTestData,
        ));

        final lineChart = tester.widget<LineChart>(find.byType(LineChart));
        final chartLine = lineChart.lines.first;

        expect(
          chartLine.data,
          equals(sparklineGraphTestData),
        );
      },
    );

    testWidgets(
      "applies the stroke color to the graph",
      (WidgetTester tester) async {
        const strokeColor = Colors.orange;
        await tester.pumpWidget(const _SparklineGraphTestbed(
          strokeColor: strokeColor,
        ));

        final chartWidget = tester.widget<LineChart>(find.byType(LineChart));
        final chartLine = chartWidget.lines.first;

        expect(chartLine.stroke.color, strokeColor);
      },
    );

    testWidgets(
      "applies the given fill color to the graph",
      (WidgetTester tester) async {
        const fillColor = Colors.orange;

        await tester.pumpWidget(const _SparklineGraphTestbed(
          fillColor: fillColor,
        ));

        final chartWidget = tester.widget<LineChart>(find.byType(LineChart));
        final chartLine = chartWidget.lines.first;
        final graphFillColor = chartLine.fill.color;

        expect(graphFillColor, fillColor);
      },
    );

    testWidgets(
      "applies graph padding",
      (WidgetTester tester) async {
        const chartPadding = EdgeInsets.all(8.0);

        await tester.pumpWidget(const _SparklineGraphTestbed(
          graphPadding: chartPadding,
        ));

        final graph = tester.widget<LineChart>(find.byType(LineChart));

        expect(graph.chartPadding, chartPadding);
      },
    );

    testWidgets(
      "applies curve type to graph lines",
      (WidgetTester tester) async {
        const curveType = LineCurves.linear;

        await tester.pumpWidget(const _SparklineGraphTestbed(
          curveType: curveType,
        ));

        final chartWidget = tester.widget<LineChart>(find.byType(LineChart));
        final line = chartWidget.lines.first;

        expect(line.curve, curveType);
      },
    );

    testWidgets(
      "applies the stroke width to the chart line",
      (WidgetTester tester) async {
        const strokeWidth = 1.5;

        await tester.pumpWidget(const _SparklineGraphTestbed(
          strokeWidth: strokeWidth,
        ));

        final chartWidget = tester.widget<LineChart>(find.byType(LineChart));
        final chartLine = chartWidget.lines.first;

        expect(chartLine.stroke.strokeWidth, strokeWidth);
      },
    );

    testWidgets(
      "draws the graph even if one of the graph data axes length is 0",
      (WidgetTester tester) async {
        const graphData = [
          Point(1, 5),
          Point(2, 5),
        ];

        await tester.pumpWidget(const _SparklineGraphTestbed(
          data: graphData,
        ));

        expect(find.byType(SparklineGraph), findsOneWidget);
      },
    );

    testWidgets(
      "can draw the graph with only one point",
      (WidgetTester tester) async {
        const graphData = [
          Point(1, 5),
        ];

        await tester.pumpWidget(const _SparklineGraphTestbed(
          data: graphData,
        ));

        expect(find.byType(SparklineGraph), findsOneWidget);
      },
    );

    testWidgets(
      "creates X-axis in bounds from min to max X coordinate value",
      (WidgetTester tester) async {
        const sparklineData = [
          Point(2, 3),
          Point(minAxisValue, 7),
          Point(4, 9),
          Point(maxAxisValue, 7),
          Point(3, 8),
        ];

        await tester.pumpWidget(const _SparklineGraphTestbed(
          data: sparklineData,
        ));
        await tester.pumpAndSettle();

        final chartWidget = tester.widget<LineChart>(find.byType(LineChart));
        final chartLine = chartWidget.lines.first;

        final xAxis = chartLine.xAxis as ChartAxis<num>;

        final xValues = sparklineData.map((point) => point.x).toList();
        final xAxisSpan = xAxis.spanFn(xValues);

        expect(xAxisSpan.min, equals(minAxisValue));
        expect(xAxisSpan.max, equals(maxAxisValue));
      },
    );

    testWidgets(
      "creates Y-axis in bounds from min to max Y coordinate value taking into account the stroke width",
      (WidgetTester tester) async {
        const strokeWidth = 8.0;
        const relativeStrokeWidth =
            (maxAxisValue - minAxisValue) / strokeWidth / 2;

        const expectedYAxisMin = minAxisValue - relativeStrokeWidth;
        const expectedYAxisMax = maxAxisValue + relativeStrokeWidth;

        const sparklineData = [
          Point(2, 3),
          Point(1, minAxisValue),
          Point(4, 7),
          Point(5, maxAxisValue),
          Point(3, 6),
        ];

        await tester.pumpWidget(const _SparklineGraphTestbed(
          data: sparklineData,
          strokeWidth: strokeWidth,
        ));

        await tester.pumpAndSettle();

        final chartWidget = tester.widget<LineChart>(find.byType(LineChart));
        final chartLine = chartWidget.lines.first;

        final yAxis = chartLine.yAxis as ChartAxis<num>;

        final yValues = sparklineData.map((point) => point.y).toList();
        final yAxisSpan = yAxis.spanFn(yValues);

        expect(yAxisSpan.min, equals(expectedYAxisMin));
        expect(yAxisSpan.max, equals(expectedYAxisMax));
      },
    );
  });
}

/// A testbed class required to test the [SparklineGraph].
class _SparklineGraphTestbed extends StatelessWidget {
  /// A test data required for testing the [SparklineGraph].
  static const sparklineGraphTestData = [
    Point(1, 5),
    Point(2, 7),
    Point(3, 1),
    Point(4, 4),
    Point(5, 8),
    Point(6, 3),
  ];

  /// A data to be displayed.
  final List<Point> data;

  /// The color of this graph's line.
  final Color strokeColor;

  /// The color this graph is filled with.
  final Color fillColor;

  /// A padding of this graph.
  final EdgeInsets graphPadding;

  /// Defines the drawing type for the curve.
  final LineCurve curveType;

  /// The width of this graph's stroke.
  final double strokeWidth;

  /// Creates the [_SparklineGraphTestbed].
  ///
  /// If [data] is not specified, the [sparklineGraphTestData] is used.
  /// If [graphPadding] is not specified, the [EdgeInsets.zero] is used.
  /// If [strokeWidth] is not specified, the `2.0` is used.
  const _SparklineGraphTestbed({
    this.data = sparklineGraphTestData,
    this.graphPadding = EdgeInsets.zero,
    this.strokeWidth = 2.0,
    this.strokeColor,
    this.fillColor,
    this.curveType,
  });

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: SparklineGraph(
        data: data,
        strokeColor: strokeColor,
        graphPadding: graphPadding,
        curveType: curveType,
        strokeWidth: strokeWidth,
        fillColor: fillColor,
      ),
    );
  }
}
