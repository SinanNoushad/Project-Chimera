import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/brush_engine.dart';

class BrushUI extends ConsumerStatefulWidget {
  const BrushUI({Key? key}) : super(key: key);

  @override
  ConsumerState<BrushUI> createState() => _BrushUIState();
}

class _BrushUIState extends ConsumerState<BrushUI> {
  double _size = 10.0;
  double _opacity = 1.0;
  double _hardness = 0.5;
  BlendMode _blendMode = BlendMode.srcOver;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey[900],
      child: Column(
        children: [
          _buildBrushHeader(),
          _buildBrushSettings(),
          _buildBrushPreview(),
        ],
      ),
    );
  }

  Widget _buildBrushHeader() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Brush Settings',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBrushSettings() {
    return Column(
      children: [
        _buildSlider('Size', _size, 1.0, 100.0, (value) {
          setState(() => _size = value);
        }),
        _buildSlider('Opacity', _opacity, 0.0, 1.0, (value) {
          setState(() => _opacity = value);
        }),
        _buildSlider('Hardness', _hardness, 0.0, 1.0, (value) {
          setState(() => _hardness = value);
        }),
        _buildBlendModeSelector(),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildBlendModeSelector() {
    return DropdownButton<BlendMode>(
      value: _blendMode,
      items: BlendMode.values.map((mode) {
        return DropdownMenuItem(
          value: mode,
          child: Text(mode.toString()),
        );
      }).toList(),
      onChanged: (mode) {
        if (mode != null) {
          setState(() => _blendMode = mode);
        }
      },
    );
  }

  Widget _buildBrushPreview() {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: CustomPaint(
        painter: BrushPreviewPainter(
          size: _size,
          opacity: _opacity,
          hardness: _hardness,
        ),
      ),
    );
  }
}

class BrushPreviewPainter extends CustomPainter {
  final double size;
  final double opacity;
  final double hardness;

  BrushPreviewPainter({
    required this.size,
    required this.opacity,
    required this.hardness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Implement brush preview painting
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}