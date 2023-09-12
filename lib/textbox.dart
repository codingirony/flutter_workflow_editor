import 'package:flutter/material.dart';
import 'data.dart';

class Textbox extends StatelessWidget {
  const Textbox({
    Key? key,
    required this.node,
    required this.selected,
  }) : super(key: key);

  final Node node;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    if (selected) {
      color = Colors.red;
    }
    String title = "${node.number}: ${node.title}";
    title = title.trim();
    return DefaultTextStyle(
        style: const TextStyle(decoration: TextDecoration.none),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
          ),
          padding: const EdgeInsets.all(3.0),
          width: 160,
          child: Text(title,
              style: TextStyle(fontFamily: 'Roboto mono', fontSize: 12, fontWeight: FontWeight.bold, color: color),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ));
  }
}
