import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chimera/ui/canvas_widget.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ChimeraApp(),
    ),
  );
}

class ChimeraApp extends StatelessWidget {
  const ChimeraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Chimera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const ChimeraHome(),
    );
  }
}

class ChimeraHome extends StatelessWidget {
  const ChimeraHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Chimera'),
      ),
      body: const CanvasWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}