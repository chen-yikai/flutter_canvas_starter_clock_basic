import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double circleSize = 100;
    double topNotchSize = 50;

    final center = Offset(size.width /2, size.height/2);
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth =10
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
    ..color = Colors.orange
    ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width /2, size.height/2), circleSize, paint);
    canvas.drawLine(Offset(center.dx + topNotchSize /2, center.dy - circleSize - 20),Offset(center.dx - topNotchSize /2, center.dy - circleSize - 20) , linePaint);

    canvas.drawLine(Offset(center.dx - circleSize , center.dy), Offset(center.dx - circleSize + 20 , center.dy), linePaint);
    canvas.drawLine(Offset(center.dx +circleSize - 20 , center.dy ), Offset(center.dx + circleSize, center.dy), linePaint);
    canvas.drawLine(Offset(center.dx , center.dy + circleSize), Offset(center.dx ,center.dy + circleSize - 20), linePaint);
    canvas.drawLine(Offset(center.dx , center.dy - circleSize ), Offset(center.dx, center.dy -circleSize + 20), linePaint);
    canvas.drawLine(Offset(center.dx , center.dy), Offset(center.dx, center.dy), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}