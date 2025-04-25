import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

enum DrawingTool {
  pen,
  eraser,
  marker
}

class DrawingToolState {
  final DrawingTool currentTool;
  final Color currentColor;
  final double strokeWidth;
  final List<Color> recentColors;

  DrawingToolState({
    this.currentTool = DrawingTool.pen,
    this.currentColor = Colors.black,
    this.strokeWidth = 2.0,
    List<Color>? recentColors,
  }) : recentColors = recentColors ?? [
          Colors.black,
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
        ];

  DrawingToolState copyWith({
    DrawingTool? currentTool,
    Color? currentColor,
    double? strokeWidth,
    List<Color>? recentColors,
  }) {
    return DrawingToolState(
      currentTool: currentTool ?? this.currentTool,
      currentColor: currentColor ?? this.currentColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      recentColors: recentColors ?? this.recentColors,
    );
  }
}

class DrawingToolNotifier extends StateNotifier<DrawingToolState> {
  DrawingToolNotifier() : super(DrawingToolState());

  void setTool(DrawingTool tool) {
    state = state.copyWith(currentTool: tool);
  }

  void setColor(Color color) {
    final recentColors = List<Color>.from(state.recentColors);
    if (!recentColors.contains(color)) {
      recentColors.insert(0, color);
      if (recentColors.length > 5) {
        recentColors.removeLast();
      }
    }
    state = state.copyWith(
      currentColor: color,
      recentColors: recentColors,
    );
  }

  void setStrokeWidth(double width) {
    state = state.copyWith(strokeWidth: width);
  }
}

final drawingToolProvider = StateNotifierProvider<DrawingToolNotifier, DrawingToolState>((ref) {
  return DrawingToolNotifier();
});