import 'dart:math';

import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';

/// The widget that represents the metric percent in a circular graph.
///
/// This widget will be as big as possible if no constraints are given by its parent.
/// Otherwise it will match its parent's size.
class CirclePercentage extends StatefulWidget {
  final String title;
  final double value;
  final EdgeInsets padding;
  final double strokeWidth;
  final Color valueColor;
  final Color strokeColor;
  final Color backgroundColor;
  final TextStyle titleStyle;
  final TextStyle valueStyle;
  final double valueStrokeWidth;

  /// Creates the circle graph.
  ///
  /// The [title] and [value] must not be null.
  ///
  /// [title] is the name of the displaying metric.
  /// [value] is the percent value of the metric.
  /// [padding] the padding of the [value] and [title] text inside the circle graph.
  /// [strokeWidth] the wight of the graph's stroke.
  /// [valueColor] the color of the part of the graph that represents the value.
  /// [strokeColor] the color of the graph's circle itself .
  /// [titleStyle] the [TextStyle] of the given [title].
  /// [valueStyle] the [TextStyle] of the percent text.
  /// [backgroundColor] is the color to fill the graph.
  const CirclePercentage({
    Key key,
    @required this.title,
    @required this.value,
    this.titleStyle,
    this.valueStyle,
    this.strokeWidth = 2.0,
    this.valueStrokeWidth = 5.0,
    this.padding = EdgeInsets.zero,
    this.valueColor,
    this.strokeColor,
    this.backgroundColor,
  })  : assert(value >= 0 && value <= 1),
        super(key: key);

  @override
  State createState() => _CirclePercentageState();
}

class _CirclePercentageState extends State<CirclePercentage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _controller.animateTo(widget.value);
    super.initState();
  }

  @override
  void didUpdateWidget(CirclePercentage oldWidget) {
    if (oldWidget.value != widget.value) {
      _controller.animateTo(widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final widgetThemeData =
        MetricsTheme.of(context).circlePercentagePrimaryTheme;
    final valueColor = _getValueColor(widgetThemeData);
    final titleStyle = widget.titleStyle ?? widgetThemeData.titleStyle;

    return LayoutBuilder(
      builder: (context, constraints) {
        final initialPadding = _getChildPadding(constraints);

        return Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return CustomPaint(
                  painter: CirclePercentageChartPainter._(
                    percent: _controller.value,
                    valueColor: valueColor,
                    strokeColor: _getStrokeColor(widgetThemeData),
                    backgroundColor: _getBackgroundColor(widgetThemeData),
                    strokeWidth: widget.strokeWidth,
                    valueStrokeWidth: widget.valueStrokeWidth,
                  ),
                  child: Padding(
                    padding: initialPadding + widget.padding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        DefaultTextStyle(
                          style: TextStyle(color: valueColor),
                          child: Expanded(
                            flex: 2,
                            child: ExpandableText(
                              '${(_controller.value * 100).toInt()}%',
                              style: widget.valueStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ExpandableText(
                            widget.title,
                            style: titleStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(MetricWidgetThemeData themeData) {
    return widget.backgroundColor ?? themeData.backgroundColor;
  }

  Color _getStrokeColor(MetricWidgetThemeData themeData) {
    return widget.strokeColor ?? themeData.accentColor;
  }

  Color _getValueColor(MetricWidgetThemeData themeData) {
    return widget.valueColor ?? themeData.primaryColor;
  }

  EdgeInsets _getChildPadding(BoxConstraints constraints) {
    final strokeWidth = widget.strokeWidth;

    final circleDiameter = min(constraints.maxWidth, constraints.maxHeight);

    final maxChildSize = (circleDiameter - strokeWidth) / 2 * sqrt(2);

    return EdgeInsets.all((circleDiameter - maxChildSize) / 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Paints a [CirclePercentage].
class CirclePercentageChartPainter extends CustomPainter {
  final double strokeWidth;
  final double valueStrokeWidth;
  final double percent;
  final Color valueColor;
  final Color strokeColor;
  final Color backgroundColor;

  CirclePercentageChartPainter._({
    this.percent,
    this.valueColor,
    this.strokeWidth,
    this.strokeColor,
    this.backgroundColor,
    this.valueStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final diameter = min(size.width, size.height);

    final circleCenter = Alignment.center.alongSize(size);
    final circleRadius = diameter / 2;

    if (backgroundColor != null) {
      paint.color = backgroundColor;

      canvas.drawCircle(circleCenter, circleRadius, paint);
    }

    paint.style = PaintingStyle.stroke;
    paint.color = strokeColor;

    canvas.drawCircle(circleCenter, circleRadius, paint);

    paint.color = valueColor;
    paint.strokeWidth = valueStrokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: circleCenter, radius: circleRadius),
      -pi / 2,
      2 * pi * percent,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CirclePercentageChartPainter oldCategory) {
    return percent != oldCategory.percent ||
        valueColor != oldCategory.valueColor ||
        strokeWidth != oldCategory.strokeWidth ||
        backgroundColor != oldCategory.backgroundColor ||
        valueStrokeWidth != oldCategory.valueStrokeWidth;
  }
}
