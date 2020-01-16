import 'package:flutter/material.dart';
import 'package:metrics/utils/app_colors.dart';

class GraphPainter extends CustomPainter
{
  double percent=1.0;

  @override
  void paint(Canvas canvas, Size size) 
  {
    Path path = Path();
    Paint paint = Paint();
    path.lineTo(0, size.height*0.50); 
  path.quadraticBezierTo(size.width*0.10, size.height*0.80, size.width*0.15, size.height*0.60);
  path.quadraticBezierTo(size.width*0.20, size.height*0.45, size.width*0.27, size.height*0.60);
  path.quadraticBezierTo(size.width*0.45, size.height, size.width*0.50, size.height*0.80);
  path.quadraticBezierTo(size.width*0.55, size.height*0.45, size.width*0.75, size.height*0.75);
  path.quadraticBezierTo(size.width*0.85, size.height*0.93, size.width, size.height*0.60);
  path.lineTo(size.width, 0);
  path.close();
  paint.color = AppColor.themeColor;
  canvas.drawPath(path, paint); 
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) 
  {   
    return false;
  }
}

