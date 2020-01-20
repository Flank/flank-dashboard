import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:metrics/chart/chart.dart';
import 'package:metrics/utils/app_helper.dart';

class ChartPainter extends CustomPainter {
  Chart _chart;
  List<Color> _backgroundColors;
  List<Color> _foregroundColors;

  ChartPainter(Chart chart, List<Color> backgroundColors, List<Color> foregroundColors)
      : _chart = chart,      
        _backgroundColors = backgroundColors,
        _foregroundColors = foregroundColors,
        super(repaint: Listenable.merge([chart]));

  double dataY(List<double> values, int index) {
    final y = ((values[index] - _chart.rangeStart) / _chart.rangeEnd);
    return y;
  }

  void paintChartData(Chart chart, int dataSetIndex, List<Color> backgroundColors, List<Color> foregroundColors,
      ui.Canvas canvas, Size size) {
    final range = chart.domainEnd - chart.domainStart;
    final dataOffset = (int index) {
      final x = ((index.toDouble() - chart.domainStart) / range) * size.width + 28;
      final y = dataY(chart.dataSets[dataSetIndex].values, index) * size.height;
      return Offset(x, y);
    };

    final path = Path();
    final start = chart.domainStart;
    final end = chart.domainEnd;

    Offset offset0;
    if (start.floor() > 0) {
      offset0 = dataOffset(start.floor() - 1);
      path.moveTo(offset0.dx, offset0.dy);
    } else {
      offset0 = dataOffset(0);
      path.moveTo(0, offset0.dy);
    }

    for (int i = start.floor(); i < end.ceil(); ++i) {
      var offset1 = dataOffset(i);
      path.cubicTo(lerp(offset0.dx, offset1.dx, 0.5), offset0.dy, lerp(offset0.dx, offset1.dx, 0.5), offset1.dy,
          offset1.dx, offset1.dy);
      offset0 = offset1;
    }

    if (end.ceil() < chart.maxDomain.floor()) {
      var offset1 = dataOffset(end.ceil());
      path.cubicTo(lerp(offset0.dx, offset1.dx, 0.5), offset0.dy, lerp(offset0.dx, offset1.dx, 0.5), offset1.dy,
          offset1.dx, offset1.dy);
      offset0 = offset1;
    } else {
      var offset1 = dataOffset(end.ceil() - 1);
      path.lineTo(size.width, offset1.dy);
      offset0 = offset1;
    }

    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..shader = ui.Gradient.linear(
            Offset(0, 0),
            Offset(size.width, 0),
            foregroundColors,
          ));

    path.lineTo(size.width, -size.height);
    path.lineTo(0,-size.height/2);
   
    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..shader = ui.Gradient.linear(
            Offset(0, size.height),
            Offset(0, 0),
            backgroundColors,
            [
              0.5,
              1,
            ],
          ));
  }

  @override
  void paint(canvas, size) {
    canvas.translate(0.0, size.height);
    canvas.scale(1.0, -1.0);

    for (int i = 0; i < _chart.dataSets.length; ++i) {
      paintChartData(_chart, i, _backgroundColors.sublist(i * 2, i * 2 + 2),
          _foregroundColors.sublist(i * 2, i * 2 + 2), canvas, size);
    }

    
  }

  @override
  bool shouldRepaint(ChartPainter oldPainter) {
    return true;
  }
}
