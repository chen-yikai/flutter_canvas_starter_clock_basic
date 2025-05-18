import 'dart:math';
import 'package:flutter/material.dart';

class CanvasPainter extends CustomPainter {
  final int seconds;

  CanvasPainter({required this.seconds});

  @override
  void paint(Canvas canvas, Size size) {
    double circleSize = 100;
    double topNotchSize = 50;

    final center = Offset(size.width / 2, size.height / 2);
    var point = Offset(center.dx, center.dy);
    final paint = Paint()
      ..color = const Color(0xffFF784B)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = const Color(0xffFF784B)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    final handlePaint = Paint()
      ..color = const Color(0xffFF784B)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), circleSize, paint);
    canvas.drawLine(
        Offset(center.dx + topNotchSize / 2, center.dy - circleSize - 20),
        Offset(center.dx - topNotchSize / 2, center.dy - circleSize - 20),
        linePaint);

    canvas.drawLine(Offset(center.dx - circleSize, center.dy),
        Offset(center.dx - circleSize + 20, center.dy), linePaint);
    canvas.drawLine(Offset(center.dx + circleSize - 20, center.dy),
        Offset(center.dx + circleSize, center.dy), linePaint);
    canvas.drawLine(Offset(center.dx, center.dy + circleSize),
        Offset(center.dx, center.dy + circleSize - 20), linePaint);
    canvas.drawLine(Offset(center.dx, center.dy - circleSize),
        Offset(center.dx, center.dy - circleSize + 20), linePaint);


    canvas.drawLine(point, center, linePaint);

    double secondsHandLength = circleSize * 0.6;
    double secondsAngle = (seconds * 6 - 90) * pi / 180;
    Offset secondsHandEnd = Offset(
      center.dx + secondsHandLength * cos(secondsAngle),
      center.dy + secondsHandLength * sin(secondsAngle),
    );

    canvas.drawLine(center, secondsHandEnd, handlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}