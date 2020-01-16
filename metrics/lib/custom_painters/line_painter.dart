import 'package:flutter/material.dart';
import 'package:metrics/utils/app_colors.dart';
import 'package:metrics/utils/scaling_info.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class LinePainter extends CustomPainter
{
  final double xAxis;
  final double yAxis;
  LinePainter(this.xAxis,this.yAxis);
   

  @override
  void paint(Canvas canvas, Size size) 
  {
    final Paint paint=Paint();
    paint.color = AppColor.greenColor;
    paint.strokeWidth = 7 * ScalingInfo.scaleY;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(Offset(xAxis,size.height), Offset(xAxis,-yAxis), paint);   
  }
  @override
  bool shouldRepaint(LinePainter oldDelegate) 
  {
   return xAxis != oldDelegate.xAxis || yAxis!=oldDelegate.yAxis;
  }

}