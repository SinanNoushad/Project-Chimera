import 'dart:ui';
import 'package:flutter/material.dart';
import '../providers/tool_provider.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final DrawingTool tool;
  
  Stroke({
    required this.color,
    required this.width,
    required this.tool,
    List<Offset>? points,
  }) : points = points ?? [];

  void addPoint(Offset point) {
    points.add(point);
  }
}

class RenderingCore {
  final List<Stroke> _strokes = [];
  Stroke? _currentStroke;

  void startStroke(Offset point, {
    required Color color,
    required double width,
    required DrawingTool tool,
  }) {
    _currentStroke = Stroke(
      color: color,
      width: width,
      tool: tool,
    );
    _currentStroke!.addPoint(point);
  }

  void addPoint(Offset point) {
    _currentStroke?.addPoint(point);
  }

  void endStroke() {
    if (_currentStroke != null) {
      _strokes.add(_currentStroke!);
      _currentStroke = null;
    }
  }

  void render(Canvas canvas, Size size) {
    // Draw background
    final Paint backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Draw grid
    _drawGrid(canvas, size);

    // Draw all completed strokes
    for (final stroke in _strokes) {
      _drawStroke(canvas, stroke);
    }

    // Draw current stroke if any
    if (_currentStroke != null) {
      _drawStroke(canvas, _currentStroke!);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  void _drawStroke(Canvas canvas, Stroke stroke) {
    if (stroke.points.isEmpty) return;

    final Paint paint = Paint()
      ..color = stroke.tool == DrawingTool.eraser ? Colors.white : stroke.color
      ..strokeWidth = stroke.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (stroke.tool == DrawingTool.marker) {
      paint.strokeWidth = stroke.width * 2;
      paint.color = stroke.color.withOpacity(0.5);
    }

    final path = Path();
    path.moveTo(stroke.points[0].dx, stroke.points[0].dy);

    if (stroke.points.length < 3) {
      // Draw point or line
      if (stroke.points.length == 1) {
        canvas.drawPoints(PointMode.points, [stroke.points[0]], paint);
      } else {
        canvas.drawLine(stroke.points[0], stroke.points[1], paint);
      }
    } else {
      // Draw smooth curve through points
      for (int i = 1; i < stroke.points.length - 1; i++) {
        final p0 = stroke.points[i - 1];
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];

        final controlPoint1 = Offset(
          p1.dx - (p2.dx - p0.dx) / 4,
          p1.dy - (p2.dy - p0.dy) / 4,
        );
        final controlPoint2 = Offset(
          p1.dx + (p2.dx - p0.dx) / 4,
          p1.dy + (p2.dy - p0.dy) / 4,
        );

        path.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          controlPoint2.dx, controlPoint2.dy,
          p1.dx, p1.dy,
        );
      }
    }

    canvas.drawPath(path, paint);
  }

  void clear() {
    _strokes.clear();
    _currentStroke = null;
  }

  bool get canUndo => _strokes.isNotEmpty;

  void undo() {
    if (canUndo) {
      _strokes.removeLast();
    }
  }
}