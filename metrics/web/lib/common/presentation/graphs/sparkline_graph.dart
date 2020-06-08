import 'dart:math';

import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';

/// The widget with sparkline that represents metric.
///
/// If no constraints are given by the parent of this widget,
/// it fills all the available space.
class SparklineGraph extends StatelessWidget {
  /// The minimal length of this graph axis.
  static const int _minChartAxisLength = 1;

  /// The class to present the line of this graph.
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

  /// Creates the [SparklineGraph] widget.
  ///
  /// The [data] must not be `null`.
  /// The [strokeWidth] must be non-null and positive.
  ///
  /// The [strokeColor] default value is [Colors.blue].
  /// The [curveType] default value is [LineCurves.linear].
  /// The [graphPadding] default value is [EdgeInsets.zero].
  /// If [fillColor] is `null`, the [Colors.lightBlue] is used.
  const SparklineGraph({
    Key key,
    @required this.data,
    this.curveType = LineCurves.linear,
    this.strokeColor,
    this.fillColor,
    this.graphPadding = EdgeInsets.zero,
    this.strokeWidth = 4.0,
  })  : assert(data != null),
        assert(strokeWidth != null && strokeWidth >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final graphData = data.toList();
    final _strokeColor = strokeColor ?? Colors.blue;
    final _fillColor = fillColor ?? Colors.lightBlue;

    return LineChart(
      chartPadding: graphPadding,
      lines: [
        Line<Point, num, num>(
          data: graphData,
          xFn: (point) => point.x,
          yFn: (point) => point.y,
          curve: curveType,
          marker: const MarkerOptions(paint: null),
          stroke: PaintOptions.stroke(
            color: _strokeColor,
            strokeWidth: strokeWidth,
          ),
          fill: PaintOptions.fill(
            color: _fillColor,
          ),
          xAxis: _createChartAxis(),
          yAxis: _createChartAxis(),
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
