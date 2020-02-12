import 'dart:math';

import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';

/// The widget with sparkline that represents metric.
///
/// This widget will fill all available space if no constraints given
/// by it's parent.
class SparklineGraph extends StatelessWidget {
  static const _gradientColorStops = [0.0, 0.9];

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

  /// Creates the [SparklineGraph] widget.
  ///
  /// The [title], [value] and [data] should not be null
  /// and the [strokeWidth] should be positive.
  ///
  /// [title] is the title of the this graph.
  /// [value] is the value string of this graph.
  /// [data] is the class to present the line of this graph.
  /// [curveType] defines the drawing type for the curve.
  /// [strokeColor] is the color of the graph's line.
  /// [gradientColor] is the color of the gradient under the graph line.
  /// [backgroundColor] if the background color of the this widget.
  /// [graphPadding] is the graph padding.
  /// [borderShape] the shape of card border.
  /// [valuePadding] padding of the [value] text.
  /// [padding] padding of the [value] and [title].
  /// [strokeWidth] is the width of the graph's stroke.
  const SparklineGraph({
    Key key,
    @required this.title,
    @required this.value,
    @required this.data,
    this.curveType = LineCurves.monotone,
    this.strokeColor,
    this.gradientColor,
    this.graphPadding = const EdgeInsets.symmetric(vertical: 48.0),
    this.strokeWidth = 2.0,
    this.valuePadding = const EdgeInsets.all(32.0),
    this.padding = const EdgeInsets.all(8.0),
    this.borderShape,
    this.backgroundColor,
    this.titleStyle,
    this.valueStyle,
  })  : assert(title != null),
        assert(value != null),
        assert(data != null),
        assert(strokeWidth >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetThemeData = MetricsTheme.of(context).spakrlineTheme;
    final gradientStartColor = gradientColor ?? widgetThemeData?.accentColor;

    return Card(
      color: backgroundColor ?? widgetThemeData.backgroundColor,
      shape: borderShape,
      child: Stack(
        children: <Widget>[
          LineChart(
            chartPadding: graphPadding,
            lines: [
              Line<Point, num, num>(
                data: data,
                xFn: (point) => point.x,
                yFn: (point) => point.y,
                curve: curveType,
                marker: const MarkerOptions(paint: null),
                stroke: PaintOptions.stroke(
                  color: strokeColor ?? widgetThemeData.primaryColor,
                  strokeWidth: strokeWidth,
                ),
                fill: PaintOptions.fill(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: _gradientColorStops,
                    colors: [
                      gradientStartColor,
                      gradientStartColor?.withOpacity(0.0),
                    ],
                  ),
                ),
                xAxis: _createChartAxis(),
                yAxis: _createChartAxis(),
              ),
            ],
          ),
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ExpandableText(
                    title,
                    style: titleStyle,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: valuePadding,
                          child: ExpandableText(
                            value,
                            style: valueStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  /// Creates the [DoubleSpan] for axises.
  ///
  /// The [DoubleSpan] represents the visible range of the axis.
  DoubleSpan _createSpan(List<num> data) {
    if (data == null || data.isEmpty) return null;

    final sortedData = data.toList()..sort();
    return DoubleSpan(sortedData.first.toDouble(), sortedData.last.toDouble());
  }
}
