import 'dart:math';

import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';
import 'package:metrics/features/dashboard/presentation/widgets/no_data_placeholder.dart';

/// The widget with sparkline that represents metric.
///
/// If no constraints are given by the parent of this widget,
/// it fills all the available space.
class SparklineGraph extends StatelessWidget {
  static const _minChartAxisLength = 1;

  final String value;
  final List<Point> data;
  final Color strokeColor;
  final Color fillColor;
  final EdgeInsets graphPadding;
  final EdgeInsets valuePadding;
  final TextStyle valueStyle;
  final LineCurve curveType;
  final double strokeWidth;

  /// Creates the [SparklineGraph] widget.
  ///
  /// The [value] and [data] must not be null.
  /// The [strokeWidth] must be positive.
  ///
  /// [value] is the value string of this graph.
  /// [data] is the class to present the line of this graph.
  /// [curveType] defines the drawing type for the curve.
  /// [strokeColor] is the color of this graph's line.
  /// If [strokeColor] is null, the [MetricWidgetThemeData.primaryColor] is used.
  /// [fillColor] is the color this graph is filled with.
  /// If [fillColor] is null, the [MetricWidgetThemeData.accentColor] is used.
  /// [graphPadding] is a padding of this graph.
  /// [strokeWidth] is the width of this graph's stroke.
  /// [valuePadding] is a padding of the [value] text.
  /// [valueStyle] is the [TextStyle] of the [value] text.
  /// If [valueStyle] is null, the [MetricWidgetThemeData.textStyle] is used.
  const SparklineGraph({
    Key key,
    @required this.value,
    @required this.data,
    this.curveType = LineCurves.linear,
    this.strokeColor,
    this.fillColor,
    this.graphPadding = EdgeInsets.zero,
    this.strokeWidth = 4.0,
    this.valuePadding = const EdgeInsets.all(4.0),
    this.valueStyle,
  })  : assert(value != null),
        assert(data != null),
        assert(strokeWidth >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);
    final graphData = data.toList();
    final widgetThemeData = metricsTheme.metricWidgetTheme;

    if (graphData.isEmpty) return const NoDataPlaceholder();

    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: valuePadding,
            child: ExpandableText(
              value,
              style: valueStyle ?? widgetThemeData.textStyle,
            ),
          ),
        ),
        Expanded(
          child: LineChart(
            chartPadding: graphPadding,
            lines: [
              Line<Point, num, num>(
                data: graphData,
                xFn: (point) => point.x,
                yFn: (point) => point.y,
                curve: curveType,
                marker: const MarkerOptions(paint: null),
                stroke: PaintOptions.stroke(
                  color: strokeColor ?? widgetThemeData.primaryColor,
                  strokeWidth: strokeWidth,
                ),
                fill: PaintOptions.fill(
                  color: fillColor ?? widgetThemeData.accentColor,
                ),
                xAxis: _createChartAxis(),
                yAxis: _createChartAxis(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Creates the [ChartAxis].
  ChartAxis<num> _createChartAxis() {
    return ChartAxis(
      spanFn: _createSpan,
      tickGenerator: const FixedTickGenerator<num>(ticks: []),
      paint: null,
    );
  }

  /// Creates the [DoubleSpan] for axes.
  ///
  /// The [DoubleSpan] represents the visible range of the axis.
  DoubleSpan _createSpan(List<num> data) {
    if (data == null || data.isEmpty) return null;

    double min = data.first.toDouble();
    double max = data.first.toDouble();

    for (final value in data) {
      if (min > value) min = value.toDouble();
      if (max < value) max = value.toDouble();
    }

    final axisLength = max - min;
    if (axisLength < _minChartAxisLength) {
      max += _minChartAxisLength - axisLength;
    }

    return DoubleSpan(min, max);
  }
}
