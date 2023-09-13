import 'package:flutter/material.dart';
import 'node_line_box.dart';
import 'textbox.dart';
import 'data.dart';

class WorkflowGraph extends StatefulWidget {
  const WorkflowGraph({
    Key? key,
    this.width,
    this.height,
    required this.nodes,
    required this.changeSelection,
    required this.onNodeDoubleTap,
    required this.onBackgroundDoubleTap,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Map<String, Node> nodes;
  final void Function(String? id) changeSelection;
  final void Function(Node node) onNodeDoubleTap;
  final void Function(Offset pos) onBackgroundDoubleTap;

  @override
  State<WorkflowGraph> createState() => _WorkflowGraphState();
}

class _WorkflowGraphState extends State<WorkflowGraph> {
  static const double letterWidth = 1275 - 300; // one inch margin on 150 dpi
  static const double letterHeight = 1650 - 300;

  // static const double letterWidth = 2550 - 600; // one inch margin on 300 dpi
  // static const double letterHeight = 3300 - 600;
  final TransformationController _trans = TransformationController();

  Offset _atPos = Offset.zero;
  final GlobalKey _key = GlobalKey();
  // Offset _start = Offset.zero;
  Offset _delta = Offset.zero;
  String? _selected;

  Offset getOffset() {
    final vec = _trans.value.getTranslation();
    double x = vec[0];
    double y = vec[1];
    if (x > 0) {
      x = 0;
    }
    if (y > 0) {
      y = 0;
    }
    return Offset(x.abs().roundToDouble(), y.abs().roundToDouble());
  }

  Offset getPosition() {
    final box = _key.currentContext?.findRenderObject() as RenderBox;
    final local = box.globalToLocal(_atPos);
    final off = getOffset();
    double x = (local.dx + off.dx).roundToDouble();
    double y = (local.dy + off.dy).roundToDouble();
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    var nodes = widget.nodes;

    return Listener(
        onPointerDown: (details) {
          _atPos = details.position;
        },
        onPointerUp: (details) {
          _delta = details.position - _atPos;
        },
        child: Container(
          key: _key,
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: InteractiveViewer(
              transformationController: _trans,
              constrained: false,
              child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      _selected = null;
                      widget.onBackgroundDoubleTap(getPosition()); // create node
                    });
                  },
                  onTap: () {
                    setState(() {
                      _selected = null;
                    });
                  },
                  child: Stack(children: [
                    Container(
                        width: letterWidth + 6,
                        height: letterHeight + 6,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyan, width: 3),
                        ),
                        child: CustomPaint(
                            size: const Size(letterWidth + 6, letterHeight + 6), painter: BacgroundPaint())),
                    for (final node in nodes.values)
                      Positioned(
                          top: topPos(node),
                          left: leftPos(node),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectNode(node.id);
                                  widget.changeSelection(_selected); // update selection
                                });
                              },
                              onDoubleTap: () {
                                setState(() {
                                  widget.onNodeDoubleTap(node); // notify selection
                                });
                              },
                              child: Draggable(
                                data: node,
                                feedback: Textbox(node: node, selected: (_selected != null && _selected == node.id)),
                                child: Textbox(node: node, selected: (_selected != null && _selected == node.id)),
                                onDragEnd: (details) {
                                  setState(() {
                                    setNodePosition(node, _delta);
                                  });
                                },
                              ))),
                    for (final node in nodes.values)
                      for (final id in node.next) NodeLineBox(fromNode: node, toNode: nodes[id]!),
                  ]))),
        ));
  }

  ValueKey<String> keyFor(Node node0, Node node1) {
    return ValueKey<String>(node0.id + node1.id);
  }

  void selectNode(String to) {
    if (_selected == null) {
      _selected = to;
      return;
    }
    if (_selected == to) {
      _selected = null;
      return;
    }
    var selNode = widget.nodes[_selected];
    if (selNode == null) {
      _selected = null;
      return;
    }
    var list = selNode.next;
    if (list.contains(to)) {
      list.remove(to);
      _selected = null;
      return;
    }
    list += [to];
    selNode.next = list;
    _selected = null;
  }

  double leftPos(Node node) {
    const max = letterWidth - 185;
    if (node.x < 0) {
      node.x = 0;
    }
    if (node.x > max) {
      node.x = max as int;
    }
    return node.x.toDouble();
  }

  double topPos(Node node) {
    const max = letterHeight - 60;
    if (node.y < 0) {
      node.y = 0;
    }
    if (node.y > max) {
      node.y = max as int;
    }
    return node.y.toDouble();
  }

  void setNodePosition(Node node, Offset delta) {
    node.y += delta.dy.round();
    node.x += delta.dx.round();
  }
}

class BacgroundPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.cyan.withOpacity(0.33);

    const heightLine = 150; // pixels per inch
    const widthLine = 150; // pixels per inch

    for (int i = 1; i < height; i++) {
      if (i % heightLine == 0) {
        Path linePath = Path();
        linePath.addRect(Rect.fromLTRB(0, i.toDouble(), width, (i + 2).toDouble()));
        canvas.drawPath(linePath, paint);
      }
    }
    for (int i = 1; i < width; i++) {
      if (i % widthLine == 0) {
        Path linePath = Path();
        linePath.addRect(Rect.fromLTRB(i.toDouble(), 0, (i + 2).toDouble(), height));
        canvas.drawPath(linePath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
