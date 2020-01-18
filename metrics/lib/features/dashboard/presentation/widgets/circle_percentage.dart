import 'dart:math';

import 'package:flutter/material.dart';

class CirclePercentage extends StatefulWidget {
  final String title;
  final double value;
  final EdgeInsets padding;
  final double strokeWidth;
  final Color valueColor;
  final Color strokeColor;
  final TextStyle titleStyle;
  final TextStyle valueStyle;

  CirclePercentage({
    Key key,
    @required this.title,
    @required this.value,
    this.titleStyle,
    this.valueStyle,
    this.strokeWidth = 5.0,
    this.padding = EdgeInsets.zero,
    this.valueColor = Colors.blue,
    this.strokeColor = Colors.grey,
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
      duration: Duration(milliseconds: 2400),
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
  Widget build(context) {
    final strokeWidth = widget.strokeWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        EdgeInsets initialPadding = _getChildPadding(constraints);

        return Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return CustomPaint(
                  painter: _CirclePercentageChartPainter(
                    percent: _controller.value,
                    filledColor: widget.valueColor,
                    strokeColor: widget.strokeColor,
                    strokeWidth: strokeWidth,
                  ),
                  child: Padding(
                    padding: initialPadding + widget.padding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            child: Text(
                              '${(_controller.value * 100).toInt()}%',
                              style: widget.valueStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            child: Text(
                              widget.title,
                              style: widget.titleStyle,
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

  EdgeInsets _getChildPadding(BoxConstraints constraints) {
    final strokeWidth = widget.strokeWidth;

    final circleDiameter = min(constraints.maxWidth, constraints.maxHeight);

    final maxChildSize = (circleDiameter - strokeWidth) / 2 * sqrt(2);

    return EdgeInsets.all((circleDiameter - maxChildSize) / 2);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class _CirclePercentageChartPainter extends CustomPainter {
  final double strokeWidth;
  final double percent;
  final Color filledColor;
  final Color strokeColor;

  _CirclePercentageChartPainter({
    this.percent,
    this.filledColor,
    this.strokeWidth,
    this.strokeColor,
  });

  @override
  void paint(canvas, size) {
    final paint = Paint();
    paint
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final diameter = min(size.width, size.height);

    final circleCenter = Alignment.center.alongSize(size);
    final circleRadius = diameter / 2;

    canvas.drawCircle(circleCenter, circleRadius, paint);

    paint.color = filledColor;

    canvas.drawArc(
      Rect.fromCircle(center: circleCenter, radius: circleRadius),
      -pi / 2,
      2 * pi * percent,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePercentageChartPainter oldCategory) {
    return percent != oldCategory.percent ||
        filledColor != oldCategory.filledColor ||
        strokeWidth != oldCategory.strokeWidth;
  }
}
