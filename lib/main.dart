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
      theme: ThemeData.dark(),
      home: const CanvasWidget(),
    );
  }
}