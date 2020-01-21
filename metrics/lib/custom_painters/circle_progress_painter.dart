import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:metrics/utils/app_colors.dart';
import 'package:metrics/utils/scaling_info.dart';

class CircleProgressPainter extends CustomPainter 
{
  final double percent;
  final Color color;

  CircleProgressPainter(this.percent, this.color);

  @override
  void paint(canvas, size) 
  {
    final paint = Paint();
    paint.color = AppColor.whiteColor0;
    paint.strokeWidth = 3 * ScalingInfo.scaleY;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 0, math.pi * 2, false, paint);
    paint.strokeWidth = 7 * ScalingInfo.scaleY;
    paint.color = color;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), -math.pi / 2, -2 * math.pi * percent, false, paint);
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldCategory) {
    return percent != oldCategory.percent || color != oldCategory.color;
  }
}
