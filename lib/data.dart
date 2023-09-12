import 'package:flutter/material.dart';

List<Workflow> workflows = [
  Workflow(id: 'workflow_001', title: 'Workflow 1', nodes: {
    'xxx 1a': Node.fromJson(nodes['xxx 1a']),
    'xxx 1b': Node.fromJson(nodes['xxx 1b']),
    'xxx 2': Node.fromJson(nodes['xxx 2']),
    'xxx 3c': Node.fromJson(nodes['xxx 3c']),
  }),
  Workflow(id: 'workflow_002', title: 'Workflow 2', nodes: {
    'xxx 1a': Node.fromJson(nodes['xxx 1a']),
    'xxx 1b': Node.fromJson(nodes['xxx 1b']),
    'xxx 2': Node.fromJson(nodes['xxx 2']),
    'xxx 3c': Node.fromJson(nodes['xxx 3c']),
  }),
  Workflow(id: 'workflow_003', title: 'Workflow 3', nodes: {
    'xxx 1a': Node.fromJson(nodes['xxx 1a']),
    'xxx 1b': Node.fromJson(nodes['xxx 1b']),
    'xxx 2': Node.fromJson(nodes['xxx 2']),
    'xxx 3c': Node.fromJson(nodes['xxx 3c']),
  }),
];

Map<String, dynamic> nodes = {
  "xxx 1a": {
    "x": 300,
    "y": 100,
    "next": ["xxx 2"],
    "id": "xxx 1a",
    "number": "1a",
    "title": "Cattle Receiving and Holding - and more text that means nothing"
  },
  "xxx 1b": {"x": 100, "y": 250, "id": "xxx 1b", "number": "1b", "title": "Receive and Store Packaging Materials"},
  "xxx 2": {
    "x": 250,
    "y": 350,
    "next": ["xxx 1b"],
    "id": "xxx 2",
    "number": "2",
    "title": "Stunning"
  },
  "xxx 3c": {
    "x": 100,
    "y": 150,
    "next": ["xxx 1a"],
    "id": "xxx 3c",
    "number": "3c",
    "title": "abc def ghi jkl mno pqr v|"
  }
};

class Workflow with ChangeNotifier {
  final String id;
  String title;
  Map<String, Node> nodes;

  Workflow({required this.id, required this.title, required this.nodes});

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      id: json['id'],
      title: json['title'],
      nodes: json['nodes'],
    );
  }

  void addNode(Node node) {
    nodes[node.id] = node;
    notifyListeners();
  }

  void removeNode(Node node) {
    nodes.remove(node.id);
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return (other is Workflow) && other.title == title;
  }

  @override
  int get hashCode => super.hashCode;
}

class Node with ChangeNotifier {
  final String id;
  String number;
  String title;
  int x;
  int y;
  List<String> next;

  Node({
    required this.id,
    required this.number,
    required this.title,
    required this.x,
    required this.y,
    required this.next,
  });

  void addNext(String nextId) {
    next.add(nextId);
    notifyListeners();
  }

  void removeNext(String nextId) {
    next.remove(nextId);
    notifyListeners();
  }

  void setTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void setNumber(String newNumber) {
    number = newNumber;
    notifyListeners();
  }

  void setPosition(int newX, int newY) {
    x = newX;
    y = newY;
    notifyListeners();
  }

  factory Node.fromJson(Map<String, dynamic> json) {
    if (json['next'] == null) json['next'] = List<String>.empty();
    return Node(
      id: json['id'],
      number: json['number'],
      title: json['title'],
      x: json['x'],
      y: json['y'],
      next: json['next'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'x': x,
      'y': y,
      'next': next,
    };
  }
}
