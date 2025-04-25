import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/rendering_core.dart';
import '../providers/tool_provider.dart';

// Add this provider
final renderingCoreProvider = Provider((ref) => RenderingCore());

// Add the CanvasPainter class
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

class CanvasWidget extends ConsumerStatefulWidget {
  const CanvasWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends ConsumerState<CanvasWidget> {
  late RenderingCore _renderingCore;

  @override
  void initState() {
    super.initState();
    _renderingCore = ref.read(renderingCoreProvider);
  }

  @override
  Widget build(BuildContext context) {
    final toolState = ref.watch(drawingToolProvider);
    
    return Stack(
      children: [
        // Canvas Area
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onPanStart: _handlePanStart,
                onPanUpdate: _handlePanUpdate,
                onPanEnd: _handlePanEnd,
                child: CustomPaint(
                  painter: _CanvasPainter(_renderingCore),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                ),
              );
            },
          ),
        ),
        
        // Tool Controls
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _buildToolbar(toolState),
              const SizedBox(height: 16),
              _buildColorPicker(toolState),
              const SizedBox(height: 16),
              _buildStrokeWidth(toolState),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(DrawingToolState toolState) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildToolButton(
            icon: Icons.edit,
            isSelected: toolState.currentTool == DrawingTool.pen,
            onPressed: () => ref.read(drawingToolProvider.notifier).setTool(DrawingTool.pen),
          ),
          const SizedBox(height: 8),
          _buildToolButton(
            icon: Icons.brush,
            isSelected: toolState.currentTool == DrawingTool.marker,
            onPressed: () => ref.read(drawingToolProvider.notifier).setTool(DrawingTool.marker),
          ),
          const SizedBox(height: 8),
          _buildToolButton(
            icon: Icons.auto_fix_high,
            isSelected: toolState.currentTool == DrawingTool.eraser,
            onPressed: () => ref.read(drawingToolProvider.notifier).setTool(DrawingTool.eraser),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildColorPicker(DrawingToolState toolState) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          for (final color in toolState.recentColors)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: GestureDetector(
                onTap: () => ref.read(drawingToolProvider.notifier).setColor(color),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: toolState.currentColor == color
                          ? Colors.blue
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () => _showColorPicker(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStrokeWidth(DrawingToolState toolState) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.line_weight),
          SizedBox(
            height: 100,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: toolState.strokeWidth,
                min: 1,
                max: 20,
                onChanged: (value) =>
                    ref.read(drawingToolProvider.notifier).setStrokeWidth(value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    // TODO: Implement color picker dialog
    // For now, show a simple color picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...Colors.primaries.map((color) => GestureDetector(
                onTap: () {
                  ref.read(drawingToolProvider.notifier).setColor(color);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePanStart(DragStartDetails details) {
    final toolState = ref.read(drawingToolProvider);
    _renderingCore.startStroke(
      details.localPosition,
      color: toolState.currentColor,
      width: toolState.strokeWidth,
      tool: toolState.currentTool,
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _renderingCore.addPoint(details.localPosition);
    setState(() {});
  }

  void _handlePanEnd(DragEndDetails details) {
    _renderingCore.endStroke();
  }
}