import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/rendering_core.dart';

class CanvasWidget extends ConsumerStatefulWidget {
  const CanvasWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends ConsumerState<CanvasWidget> {
  final RenderingCore _renderingCore = RenderingCore();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      child: CustomPaint(
        painter: _CanvasPainter(_renderingCore),
        size: Size.infinite,
      ),
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    // Handle pan gesture and update canvas
  }
}

class _CanvasPainter extends CustomPainter {
  final RenderingCore renderingCore;

  _CanvasPainter(this.renderingCore);

  @override
  void paint(Canvas canvas, Size size) {
    renderingCore.render(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}