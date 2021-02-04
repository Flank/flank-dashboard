// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

/// The widget that represents the percent in a circular graph.
///
/// If no constraints are given by the parent widget, it will be as big as possible.
/// Otherwise, it will match its parent's size.
class CirclePercentage extends StatefulWidget {
  /// A percent value.
  final double value;

  /// A padding of the [value] text inside the circle graph.
  final EdgeInsets padding;

  /// A wight of the graph's stroke.
  final double strokeWidth;

  /// A color of the part of the graph that represents the value.
  final Color valueColor;

  /// A color of the graph's circle itself.
  final Color strokeColor;

  /// A color used to fill the graph.
  final Color backgroundColor;

  /// A [TextStyle] of the percent text.
  final TextStyle valueStyle;

  /// A width of the value (filled) stroke.
  final double valueStrokeWidth;

  /// A [Widget] displayed instead of [value] if the [value] is `null`.
  final Widget placeholder;

  /// Creates the circle percentage graph.
  ///
  /// The [strokeWidth] default value is 2.0.
  /// The [valueColor] default value is [Colors.blue].
  /// The [strokeColor] default value is [Colors.grey].
  /// The [valueStrokeWidth] default value is 5.0.
  /// The [padding] default value is [EdgeInsets.zero].
  ///
  /// If the [value] is `null`, the [placeholder] is shown.
  /// If the [value] is out of range from 0.0 (inclusive) to 1.0 (inclusive),
  /// the value is clamped to be within this range.
  const CirclePercentage({
    Key key,
    this.value,
    this.placeholder,
    this.valueStyle,
    this.strokeWidth = 2.0,
    this.valueStrokeWidth = 5.0,
    this.padding = EdgeInsets.zero,
    Color valueColor,
    Color strokeColor,
    this.backgroundColor,
  })  : valueColor = valueColor ?? Colors.blue,
        strokeColor = strokeColor ?? Colors.grey,
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
      duration: const Duration(milliseconds: 2400),
      vsync: this,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final innerDiameter = _getInnerDiameter(constraints);

        return Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return CustomPaint(
                  painter: CirclePercentageChartPainter._(
                    percent: _controller.value,
                    valueColor: widget.valueColor,
                    strokeColor: widget.strokeColor,
                    backgroundColor: widget.backgroundColor,
                    strokeWidth: widget.strokeWidth,
                    valueStrokeWidth: widget.valueStrokeWidth,
                  ),
                  child: SizedBox(
                    height: innerDiameter,
                    width: innerDiameter,
                    child: ClipOval(
                      child: Padding(
                        padding: widget.padding,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: widget.value == null
                                    ? widget.placeholder ?? Container()
                                    : Center(
                                        child: Text(
                                          _getValueText(),
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: widget.valueStyle,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  /// Animates the [AnimationController] to the [CirclePercentage.value]
  /// if it is not null. Otherwise, resets the [AnimationController].
  void _animate() {
    if (widget.value != null) {
      _controller.animateTo(widget.value ?? 0.0);
    } else {
      _controller.reset();
    }
  }

  /// Gets the value text to display.
  String _getValueText() {
    final value = _controller.value * 100;
    return '${value.toInt()}%';
  }

  /// Gets the diameter of the inner circle of this graph.
  double _getInnerDiameter(BoxConstraints constraints) {
    final strokeWidth = widget.strokeWidth;
    final circleDiameter = min(constraints.maxWidth, constraints.maxHeight);

    return circleDiameter - strokeWidth;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Paints a [CirclePercentage].
class CirclePercentageChartPainter extends CustomPainter {
  /// The wight of the stroke to paint.
  final double strokeWidth;

  /// The width of the value (filled) stroke to paint.
  final double valueStrokeWidth;

  /// The value of filled circle percentage to paint.
  final double percent;

  /// The color of the filled circle percentage to paint.
  final Color valueColor;

  /// The color of the circle percentage stroke.
  final Color strokeColor;

  /// The background color of the circle percentage graph.
  final Color backgroundColor;

  /// Creates this circle percentage painter.
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
