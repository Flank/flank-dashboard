import 'dart:math';

import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';
import 'package:metrics/features/dashboard/presentation/widgets/no_data_placeholder.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';

import '../../../../test_utils/testbed_page.dart';

void main() {
  testWidgets(
    "Can't create widget with null value",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _SparklineGraphTestbed(value: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can't create widget with null data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _SparklineGraphTestbed(data: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can't create widget with negative stroke width",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _SparklineGraphTestbed(
        strokeWidth: -1.0,
      ));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Displays the PlaceholderText widget if there is no data to display",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _SparklineGraphTestbed(
        data: [],
      ));

      expect(
        find.descendant(
            of: find.byType(SparklineGraph),
            matching: find.byType(NoDataPlaceholder)),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Displays the value text",
    (WidgetTester tester) async {
      const sparklineValue = 'value';

      await tester.pumpWidget(const _SparklineGraphTestbed(
        value: sparklineValue,
      ));

      expect(find.text(sparklineValue), findsOneWidget);
    },
  );

  testWidgets(
    "Creates the chart line from the given data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const _SparklineGraphTestbed());

      final lineChart = tester.widget<LineChart>(find.byType(LineChart));
      final chartLine = lineChart.lines.first;

      expect(
        chartLine.data,
        equals(_SparklineGraphTestbed.sparklineGraphTestData),
      );
    },
  );

  testWidgets(
    "Applies the stroke color to the graph",
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
    "Applies correct fill color",
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
    "Applies value padding",
    (WidgetTester tester) async {
      const value = 'value';
      const valuePadding = EdgeInsets.all(16.0);

      await tester.pumpWidget(const _SparklineGraphTestbed(
        value: value,
        valuePadding: valuePadding,
      ));

      final valuePaddingWidget = tester.widget<Padding>(
        find.byWidgetPredicate(
            (widget) => widget is Padding && widget.child is ExpandableText),
      );

      expect(valuePaddingWidget.padding, valuePadding);
    },
  );

  testWidgets(
    "Applies graph padding",
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
    "Applies the value text style to value text",
    (WidgetTester tester) async {
      const value = 'value';
      const valueStyle = TextStyle(color: Colors.red);

      await tester.pumpWidget(const _SparklineGraphTestbed(
        value: value,
        valueStyle: valueStyle,
      ));

      final valueWidget = tester.widget<Text>(find.text(value));

      expect(valueWidget.style, valueStyle);
    },
  );

  testWidgets(
    "Applies curve type to graph curve",
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
    "Applies the stroke width to chart line",
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
    "Applies colors from the theme",
    (WidgetTester tester) async {
      const primaryColor = Colors.orange;
      const accentColor = Colors.orangeAccent;

      const theme = MetricsThemeData(
        metricWidgetTheme: MetricWidgetThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
        ),
      );

      await tester.pumpWidget(const _SparklineGraphTestbed(theme: theme));

      final lineChartWidget = tester.widget<LineChart>(find.byType(LineChart));
      final chartLine = lineChartWidget.lines.first;

      expect(chartLine.stroke.color, primaryColor);
      expect(chartLine.fill.color, accentColor);
    },
  );

  testWidgets(
    "Draws the graph even if one of the graph data axes length is 0",
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
    "Can draw the graph with only one point",
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
    "Correctly calculates the chart axes bounds",
    (WidgetTester tester) async {
      const minAxisValue = 1;
      const maxAxisValue = 8;

      const sparklineData = [
        Point(2, 3),
        Point(minAxisValue, maxAxisValue),
        Point(4, minAxisValue),
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
      final yAxis = chartLine.yAxis as ChartAxis<num>;

      final xValues = sparklineData.map((point) => point.x).toList();
      final xAxisSpan = xAxis.spanFn(xValues);
      final yValues = sparklineData.map((point) => point.y).toList();
      final yAxisSpan = yAxis.spanFn(yValues);

      expect(xAxisSpan.min, minAxisValue);
      expect(xAxisSpan.max, maxAxisValue);
      expect(yAxisSpan.min, minAxisValue);
      expect(yAxisSpan.max, maxAxisValue);
    },
  );
}

class _SparklineGraphTestbed extends StatelessWidget {
  static const sparklineGraphTestData = [
    Point(1, 5),
    Point(2, 7),
    Point(3, 1),
    Point(4, 4),
    Point(5, 8),
    Point(6, 3),
  ];

  final String value;
  final List<Point> data;
  final Color strokeColor;
  final Color fillColor;
  final EdgeInsets graphPadding;
  final EdgeInsets valuePadding;
  final TextStyle valueStyle;
  final LineCurve curveType;
  final double strokeWidth;
  final MetricsThemeData theme;

  const _SparklineGraphTestbed({
    this.value = '10',
    this.data = sparklineGraphTestData,
    this.valuePadding = const EdgeInsets.all(32.0),
    this.graphPadding = EdgeInsets.zero,
    this.strokeWidth = 2.0,
    this.theme = const MetricsThemeData(),
    this.strokeColor,
    this.fillColor,
    this.valueStyle,
    this.curveType,
  });

  @override
  Widget build(BuildContext context) {
    return TestbedPage(
      metricsThemeData: theme,
      body: SparklineGraph(
        data: data,
        value: value,
        strokeColor: strokeColor,
        graphPadding: graphPadding,
        valuePadding: valuePadding,
        valueStyle: valueStyle,
        curveType: curveType,
        strokeWidth: strokeWidth,
        fillColor: fillColor,
      ),
    );
  }
}
