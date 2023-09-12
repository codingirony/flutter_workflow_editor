import 'package:flutter/material.dart';
import 'dart:math' as math;

class ArrowBox extends StatelessWidget {
  const ArrowBox({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  // these can be negative indicating the direction of the arrow
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: const TextStyle(decoration: TextDecoration.none),
        child: CustomPaint(
          size: Size(width.abs(), height.abs()),
          painter: ArrowPainter(width: width, height: height),
        ));
  }
}

class ArrowPainter extends CustomPainter {
  /// Paints a diagonal line from rectangle origin to size with an arrow head
  const ArrowPainter({required this.width, required this.height});

  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(0, 0), Offset(width, height), paint);

    // draw arrowhead
    final paintArrow = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final angle = math.atan2(height, width);
    const arrowSize = 15;
    const arrowAngle = arrowSize * math.pi / 180;

    final path = Path();
    path.moveTo(width - arrowSize * math.cos(angle - arrowAngle), height - arrowSize * math.sin(angle - arrowAngle));
    path.lineTo(width, height);
    path.lineTo(width - arrowSize * math.cos(angle + arrowAngle), height - arrowSize * math.sin(angle + arrowAngle));
    path.close();
    canvas.drawPath(path, paintArrow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
