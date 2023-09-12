import 'package:flutter/material.dart';
import 'arrowbox.dart';
import 'data.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class NodeLineBox extends StatelessWidget {
  const NodeLineBox({required this.fromNode, required this.toNode, super.key});

  final Node fromNode;
  final Node toNode;

  final double nodeWidth = 160.0;
  final double nodeHalf = 80.0;

  @override
  Widget build(BuildContext context) {
    final List<Offset> points = selectPoints(fromNode, toNode);
    final pt0 = points[0];
    final pt1 = points[1];
    final dist = pt1 - pt0;

    return Positioned(
        top: pt0.dy,
        left: pt0.dx,
        child: ArrowBox(
          width: dist.dx,
          height: dist.dy,
        ));
  }

  List<Offset> selectPoints(Node node0, Node node1) {
    final pts0 = nodeConnectionPoints(node0);
    final pts1 = nodeConnectionPoints(node1);
    final center0 = pts0[0];
    final center1 = pts1[0];
    final diff = center1 - center0;
    final mid0 = pts0[1].dx;
    final mid1 = pts1[1].dx;
    final bot0 = pts0[1].dy;
    final bot1 = pts1[1].dy;

    // NOTE: Box sides are A = top, C = bottom, B = right, D = left

    // NOTE: comparePoints B and D are always the first and last points
    //       see comparePoints for why
    if (diff.dx > 0) {
      // right
      if (diff.dy > 0) {
        // right down C0 B0 D1 A1
        double angle = 45 * math.pi / 180;
        return comparePoints(
            Offset(node0.x + nodeWidth, mid0), // B0
            Offset(node0.x + nodeHalf, bot0), // C0
            Offset(node1.x + nodeHalf, node1.y.toDouble()), // A1
            Offset(node1.x.toDouble(), mid1), // D1
            angle);
      } else {
        // right up B0 A0 C1 D1
        double angle = 45 * math.pi / 180;
        return comparePoints(
            Offset(node0.x + nodeWidth, mid0), // B0
            Offset(node0.x + nodeHalf, node0.y.toDouble()), // A0
            Offset(node1.x + nodeHalf, bot1), // C1
            Offset(node1.x.toDouble(), mid1), // D1
            angle);
      }
    } else {
      // left
      if (diff.dy > 0) {
        // left down D0 C0 A1 B1
        double angle = 135 * math.pi / 180;
        return comparePoints(
            Offset(node0.x.toDouble(), mid0), // D0
            Offset(node0.x + nodeHalf, bot0), // C0
            Offset(node1.x + nodeHalf, node1.y.toDouble()), // A1
            Offset(node1.x + nodeWidth, mid1), // B1
            angle);
      } else {
        // left up A0 D0 B1 C1
        double angle = 135 * math.pi / 180;
        return comparePoints(
            Offset(node0.x.toDouble(), mid0), // D0
            Offset(node0.x + nodeHalf, node0.y.toDouble()), // A0
            Offset(node1.x + nodeHalf, bot1), // C1
            Offset(node1.x + nodeWidth, mid1), // B1
            angle);
      }
    }
  }

  double angleBetween(Offset a, Offset b) {
    return math.atan2(b.dy - a.dy, b.dx - a.dx).abs();
  }

  List<Offset> comparePoints(Offset a0, Offset a1, Offset b0, Offset b1, double diagonal) {
    final anglea0b0 = angleBetween(a0, b0);
    final anglea0b1 = angleBetween(a0, b1);
    final anglea1b0 = angleBetween(a1, b0);
    final anglea1b1 = angleBetween(a1, b1);

    // NOTE: When boxes are side by side, the angles are very close
    //       the convention is that a0 and b1 are either B or D side
    if ((anglea0b1 - anglea0b0).abs() < 0.2 &&
        (anglea0b1 - anglea1b0).abs() < 0.2 &&
        (anglea0b1 - anglea1b1).abs() < 0.2) {
      return [a0, b1];
    }

    // NOTE: select angle closest to 45 degrees
    double diff00 = (anglea0b0 - diagonal).abs();
    double diff10 = (anglea1b0 - diagonal).abs();
    double diff01 = (anglea0b1 - diagonal).abs();
    double diff11 = (anglea1b1 - diagonal).abs();
    if (diff00 < diff10 && diff00 < diff01 && diff00 < diff11) {
      return [a0, b0];
    } else if (diff10 < diff00 && diff10 < diff01 && diff10 < diff11) {
      return [a1, b0];
    } else if (diff01 < diff00 && diff01 < diff10 && diff01 < diff11) {
      return [a0, b1];
    } else {
      return [a1, b1];
    }
  }

  /// Calculate the width and height of the text in pixels
  Size calcTextSize(String text) {
    const style = TextStyle(fontFamily: 'Roboto mono', fontSize: 12, fontWeight: FontWeight.bold);
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
      // textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  /// Calculate the connection points for the node
  List<Offset> nodeConnectionPoints(Node node) {
    String title = "${node.number}: ${node.title}";
    title = title.trim();
    final size = calcTextSize(title);
    // 152 = 160 - 8 OR width minus padding
    // 36 = 2 * 14 + 8 OR twice font height + padding
    double mid = size.width > 152 ? 18 : 11; // two lines of text?
    double height = size.width > 152 ? 36 : 22; // two lines of text?
    return [
      Offset(node.x + nodeHalf, node.y + mid), // center
      Offset(node.y + mid, node.y + height) // mid and bottom
    ];
  }
}
