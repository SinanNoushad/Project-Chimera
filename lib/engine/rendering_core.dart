import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/color_management.dart';

class RenderingCore {
  final PictureRecorder _recorder;
  final Canvas _canvas;
  final ColorManagement _colorManager;
  
  RenderingCore() : 
    _recorder = PictureRecorder(),
    _canvas = Canvas(_recorder),
    _colorManager = ColorManagement();

  /// Creates a new tile buffer for efficient rendering
  void createTileBuffer(Rect bounds) {
    _canvas.save();
    _canvas.clipRect(bounds);
  }

  /// Handles layer compositing with different blend modes
  void compositeLayer(Picture picture, BlendMode blendMode) {
    _canvas.saveLayer(null, Paint()..blendMode = blendMode);
    _canvas.drawPicture(picture);
    _canvas.restore();
  }

  /// Renders the current state to the provided canvas
  void render(Canvas canvas, Size size) {
    final picture = _recorder.endRecording();
    canvas.drawPicture(picture);
  }
}