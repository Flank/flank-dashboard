import 'dart:math';

import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metric_widget_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';

/// The widget that represents the metric percent in a circular graph.
///
/// This widget will be as big as possible if no constraints are given by its parent.
/// Otherwise it will match its parent's size.
///
/// Applies the color theme from the [MetricsThemeData] following next rules, if no colors is passed:
/// * if [value] is 0 - applies the [MetricsThemeData.inactiveWidgetTheme]
/// * if [value] is from 0.1 (inclusive) to 0.5 (inclusive) - applies [MetricsThemeData.circlePercentageLowPercentTheme]
/// * if [value] is from 0.51 (inclusive) to 0.79 (inclusive) -- applies [MetricsThemeData.circlePercentageMediumPercentTheme]
/// * if [value] is grater or equals to 0.8 -- applies [MetricsThemeData.circlePercentageHighPercentTheme]
class CirclePercentage extends StatefulWidget {
  final double value;
  final EdgeInsets padding;
  final double strokeWidth;
  final Color valueColor;
  final Color strokeColor;
  final Color backgroundColor;
  final TextStyle valueStyle;
  final double valueStrokeWidth;

  /// Creates the circle graph.
  ///
  /// The [value] must must be from 0.0 (inclusive) to 1.0 (inclusive).
  ///
  /// [value] is the percent value of the metric.
  /// If [value] is null - the [DashboardStrings.noDataPlaceholder] will be displayed.
  /// [padding] the padding of the [value] text inside the circle graph.
  /// [strokeWidth] the wight of the graph's stroke. Defaults to 2.0.
  /// [valueColor] the color of the part of the graph that represents the value.
  /// If nothing is passed - the [MetricWidgetThemeData.primaryColor] will be used.
  /// [strokeColor] the color of the graph's circle itself.
  /// If nothing is passed - the [MetricWidgetThemeData.accentColor] will be used.
  /// [backgroundColor] is the color to fill the graph.
  /// If nothing is passed - the [MetricWidgetThemeData.backgroundColor] will be used.
  /// [valueStyle] the [TextStyle] of the percent text.
  /// [valueStrokeWidth] is the width of the value (filled) stroke. Defaults to 5.0.
  const CirclePercentage({
    Key key,
    @required this.value,
    this.valueStyle,
    this.strokeWidth = 2.0,
    this.valueStrokeWidth = 5.0,
    this.padding = EdgeInsets.zero,
    this.valueColor,
    this.strokeColor,
    this.backgroundColor,
  })  : assert(value == null || (value >= 0 && value <= 1)),
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

    _animate();
    super.initState();
  }

  @override
  void didUpdateWidget(CirclePercentage oldWidget) {
    if (oldWidget.value != widget.value) {
      _animate();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final widgetThemeData = _getWidgetTheme();

    return LayoutBuilder(
      builder: (context, constraints) {
        final initialPadding = _getChildPadding(constraints);
        final valueColor = _getValueColor(widgetThemeData);

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
                              _getValueText(),
                              style: widget.valueStyle ??
                                  widgetThemeData.textStyle,
                            ),
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

  /// Animates the [AnimationController] to the [widget.value] if it is not null.
  void _animate() {
    if (widget.value != null) {
      _controller.animateTo(widget.value);
    }
  }

  String _getValueText() {
    if (widget.value == null) return DashboardStrings.noDataPlaceholder;

    return '${(_controller.value * 100).toInt()}%';
  }

  /// Gets the [MetricWidgetThemeData] according to [widget.value].
  MetricWidgetThemeData _getWidgetTheme() {
    final metricsTheme = MetricsTheme.of(context);
    final inactiveTheme = metricsTheme.inactiveWidgetTheme;
    final percent = widget.value;

    if (percent == null) return inactiveTheme;

    if (percent >= 0.8) {
      return metricsTheme.circlePercentageHighPercentTheme;
    } else if (percent >= 0.51) {
      return metricsTheme.circlePercentageMediumPercentTheme;
    } else if (percent > 0.0) {
      return metricsTheme.circlePercentageLowPercentTheme;
    } else {
      return inactiveTheme;
    }
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

    if (percent == 0.0) return;

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
