import 'package:flutter/material.dart';
import 'data.dart';
import 'workflow_graph.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static const String title = 'Cirrus360 Edgware';
  static const String homeRoute = "edgware";

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        home: const WorkflowPage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blueAccent,
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
      );
}

class WorkflowPage extends StatelessWidget {
  const WorkflowPage({super.key});

  @override
  Widget build(BuildContext context) {
    Workflow workflow = workflows[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coding Irony: Workflow Page'),
      ),
      body: Center(
        child: WorkflowGraph(
          nodes: workflow.nodes,
          onBackgroundDoubleTap: (pos) => print('--- double tapped on $pos'), // bupkiss
          onNodeDoubleTap: (node) => print('--- double tapped on $node'), // TODO: take me to records page
          changeSelection: (sel) {
            // print('selected $sel'); // bupkiss
          },
        ),
      ),
    );
  }
}
