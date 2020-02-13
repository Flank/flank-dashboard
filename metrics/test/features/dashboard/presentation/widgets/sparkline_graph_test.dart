import 'dart:math';

import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';
import 'package:metrics/features/dashboard/presentation/widgets/sparkline_graph.dart';

void main() {
  testWidgets(
    "Can't create widget with null title or value",
    (WidgetTester tester) async {
      await tester.pumpWidget(const SparklineGraphTestbed(title: null));

      expect(tester.takeException(), isA<AssertionError>());

      await tester.pumpWidget(const SparklineGraphTestbed(value: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can't create widget with null data",
    (WidgetTester tester) async {
      await tester.pumpWidget(const SparklineGraphTestbed(data: null));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets(
    "Can't create widget with negative stroke width",
    (WidgetTester tester) async {
      await tester.pumpWidget(const SparklineGraphTestbed(
        strokeWidth: -1.0,
      ));

      expect(tester.takeException(), isA<AssertionError>());
    },
  );

  testWidgets("Displays the title and value", (WidgetTester tester) async {
    const sparklineTitle = 'Metrics title';
    const sparklineValue = 'value';

    await tester.pumpWidget(const SparklineGraphTestbed(
      title: sparklineTitle,
      value: sparklineValue,
    ));

    expect(find.text(sparklineTitle), findsOneWidget);
    expect(find.text(sparklineValue), findsOneWidget);
  });

  testWidgets(
    'Creates the chart line from given data',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SparklineGraphTestbed());

      final lineChart = tester.widget<LineChart>(find.byType(LineChart));
      final chartLine = lineChart.lines.first;

      expect(
        chartLine.data,
        equals(SparklineGraphTestbed.sparklineGraphTestData),
      );
    },
  );

  testWidgets(
    'Creates SparklineGraph with proper line and gradient colors',
    (WidgetTester tester) async {
      const strokeColor = Colors.orange;
      final gradientColor = strokeColor.withOpacity(0.5);
      await tester.pumpWidget(SparklineGraphTestbed(
        strokeColor: strokeColor,
        gradientColor: gradientColor,
      ));

      final chartWidget = tester.widget<LineChart>(find.byType(LineChart));
      final chartLine = chartWidget.lines.first;

      expect(chartLine.fill.gradient.colors, contains(gradientColor));
      expect(chartLine.stroke.color, strokeColor);
    },
  );

  testWidgets(
    'Applies correct backdround color',
    (WidgetTester tester) async {
      const backgroundColor = Colors.orange;

      await tester.pumpWidget(const SparklineGraphTestbed(
        backgroundColor: backgroundColor,
      ));

      final chartCard = tester.widget<Card>(find.byType(Card));

      expect(chartCard.color, backgroundColor);
    },
  );

  testWidgets(
    'Applies padding to title and description',
    (WidgetTester tester) async {
      const padding = EdgeInsets.all(16.0);

      await tester.pumpWidget(const SparklineGraphTestbed(
        padding: padding,
      ));

      final Padding paddingWidget = tester.widget(
        find.byWidgetPredicate(
          (widget) => widget is Padding && widget.child is Column,
        ),
      );

      expect(paddingWidget.padding, equals(padding));
    },
  );

  testWidgets(
    'Applies border shape to background card widget',
    (WidgetTester tester) async {
      final borderRadius = BorderRadius.circular(14.0);

      await tester.pumpWidget(SparklineGraphTestbed(
        borderShape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ));

      final card = tester.widget<Card>(find.byType(Card));
      final borderShape = card.shape as RoundedRectangleBorder;

      expect(borderShape.borderRadius, borderRadius);
    },
  );

  testWidgets(
    'Applies value padding',
    (WidgetTester tester) async {
      const value = 'value';
      const valuePadding = EdgeInsets.all(16.0);

      await tester.pumpWidget(const SparklineGraphTestbed(
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
    'Applies graph padding',
    (WidgetTester tester) async {
      const chartPadding = EdgeInsets.all(8.0);

      await tester.pumpWidget(const SparklineGraphTestbed(
        graphPadding: chartPadding,
      ));

      final graph = tester.widget<LineChart>(find.byType(LineChart));

      expect(graph.chartPadding, chartPadding);
    },
  );

  testWidgets(
    "Applies the text styles to texts",
    (WidgetTester tester) async {
      const title = 'title';
      const value = 'value';
      const titleStyle = TextStyle(color: Colors.green);
      const valueStyle = TextStyle(color: Colors.red);

      await tester.pumpWidget(const SparklineGraphTestbed(
        title: title,
        value: value,
        titleStyle: titleStyle,
        valueStyle: valueStyle,
      ));

      final titleWidget = tester.widget<Text>(find.text(title));
      final valueWidget = tester.widget<Text>(find.text(value));

      expect(titleWidget.style, titleStyle);
      expect(valueWidget.style, valueStyle);
    },
  );

  testWidgets(
    "Applies curve type to graph curve",
    (WidgetTester tester) async {
      const curveType = LineCurves.linear;

      await tester.pumpWidget(const SparklineGraphTestbed(
        curveType: curveType,
      ));

      final chartWidget = tester.widget<LineChart>(find.byType(LineChart));
      final line = chartWidget.lines.first;

      expect(line.curve, curveType);
    },
  );

  testWidgets(
    'Applies the stroke width to chart line',
    (WidgetTester tester) async {
      const strokeWidth = 1.5;

      await tester.pumpWidget(const SparklineGraphTestbed(
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
      const backgroundColor = Colors.grey;

      const theme = MetricsThemeData(
        spakrlineTheme: MetricWidgetThemeData(
            primaryColor: primaryColor,
            accentColor: accentColor,
            backgroundColor: backgroundColor),
      );

      await tester.pumpWidget(const SparklineGraphTestbed(theme: theme));

      final graphCardWidget = tester.widget<Card>(find.byType(Card));
      final lineChartWidget = tester.widget<LineChart>(find.byType(LineChart));
      final chartLine = lineChartWidget.lines.first;

      expect(graphCardWidget.color, backgroundColor);
      expect(chartLine.stroke.color, primaryColor);
      expect(chartLine.fill.gradient.colors.first, accentColor);
    },
  );
}

class SparklineGraphTestbed extends StatelessWidget {
  static const sparklineGraphTestData = [
    Point(1, 5),
    Point(2, 7),
    Point(3, 1),
    Point(4, 4),
    Point(5, 8),
    Point(6, 3),
  ];

  final String title;
  final String value;
  final List<Point> data;
  final Color strokeColor;
  final Color gradientColor;
  final Color backgroundColor;
  final EdgeInsets graphPadding;
  final ShapeBorder borderShape;
  final EdgeInsets valuePadding;
  final EdgeInsets padding;
  final TextStyle titleStyle;
  final TextStyle valueStyle;
  final LineCurve curveType;
  final double strokeWidth;
  final MetricsThemeData theme;

  const SparklineGraphTestbed({
    this.title = 'Metrics',
    this.value = '10',
    this.data = sparklineGraphTestData,
    this.valuePadding = const EdgeInsets.all(32.0),
    this.padding = const EdgeInsets.all(8.0),
    this.graphPadding = EdgeInsets.zero,
    this.strokeWidth = 2.0,
    this.theme = const MetricsThemeData(),
    this.strokeColor,
    this.gradientColor,
    this.borderShape,
    this.backgroundColor,
    this.titleStyle,
    this.valueStyle,
    this.curveType,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsTheme(
          data: theme,
          child: SparklineGraph(
            title: title,
            data: data,
            value: value,
            strokeColor: strokeColor,
            gradientColor: gradientColor,
            backgroundColor: backgroundColor,
            graphPadding: graphPadding,
            borderShape: borderShape,
            valuePadding: valuePadding,
            padding: padding,
            titleStyle: titleStyle,
            valueStyle: valueStyle,
            curveType: curveType,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}
