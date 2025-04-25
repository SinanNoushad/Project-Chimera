import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/color_management.dart';

class RenderingCore {
  late final PictureRecorder _recorder;
  late final Canvas _canvas;
  final ColorManagement _colorManager;
  
  RenderingCore() 
    : _colorManager = ColorManagement() {
    _recorder = PictureRecorder();
    _canvas = Canvas(_recorder);
  }

  /// Creates a new tile buffer for efficient rendering
  void createTileBuffer(Rect bounds) {
    _canvas.save();
    _canvas.clipRect(bounds);
  }

  /// Handles layer compositing with different blend modes
  void compositeLayer(Picture picture, BlendMode blendMode, {Color? tintColor}) {
    final paint = Paint()..blendMode = blendMode;
    
    if (tintColor != null) {
      // Convert tint color to 16-bit color depth for better precision
      final adjustedColor = _colorManager.convertTo16Bit(tintColor);
      // Convert to appropriate color space (e.g., Display P3 for wider gamut displays)
      final displayColor = _colorManager.convertColorSpace(adjustedColor, ColorSpace.displayP3);
      
      paint.colorFilter = ColorFilter.mode(
        displayColor,
        BlendMode.srcIn
      );
    }
    
    _canvas.saveLayer(null, paint);
    _canvas.drawPicture(picture);
    _canvas.restore();
  }

  /// Renders the current state to the provided canvas
  void render(Canvas canvas, Size size) {
    final picture = _recorder.endRecording();
    canvas.drawPicture(picture);
  }
}