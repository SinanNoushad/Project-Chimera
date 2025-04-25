import 'dart:ui';
import 'package:flutter/material.dart';

class SelectionTools {
  Path? _currentSelection;

  /// Gets the current active selection path
  Path? get currentSelection => _currentSelection;

  /// Creates a magic wand selection based on color similarity
  Future<Path> createMagicWandSelection(
    Offset startPoint,
    double tolerance,
  ) async {
    // Implement magic wand selection algorithm
    final newSelection = Path();
    // TODO: Implement magic wand selection logic
    
    // Update current selection
    _currentSelection = newSelection;
    return newSelection;
  }

  /// Creates a lasso selection from user input points
  Path createLassoSelection(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;
    
    path.moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    
    // Update current selection
    _currentSelection = path;
    return path;
  }

  /// Clears the current selection
  void clearSelection() {
    _currentSelection = null;
  }

  /// Modifies the current selection using boolean operations
  void modifySelection(Path newSelection, PathOperation operation) {
    if (_currentSelection == null) {
      _currentSelection = newSelection;
      return;
    }

    final modifiedPath = Path.combine(
      operation,
      _currentSelection!,
      newSelection,
    );
    _currentSelection = modifiedPath;
  }

  /// Checks if a point is inside the current selection
  bool isPointInSelection(Offset point) {
    if (_currentSelection == null) return false;
    return _currentSelection!.contains(point);
  }
}