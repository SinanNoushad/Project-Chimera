import 'dart:ui';
import 'package:flutter/material.dart';

class Layer {
  final String id;
  final String name;
  final BlendMode blendMode;
  final double opacity;
  final Picture? content;

  Layer({
    required this.id,
    required this.name,
    this.blendMode = BlendMode.srcOver,
    this.opacity = 1.0,
    this.content,
  });
}

class LayerManager {
  final List<Layer> _layers = [];
  
  void addLayer(Layer layer) {
    _layers.add(layer);
  }

  void removeLayer(String id) {
    _layers.removeWhere((layer) => layer.id == id);
  }

  void compositeAllLayers(Canvas canvas) {
    for (final layer in _layers) {
      canvas.saveLayer(
        null,
        Paint()
          ..blendMode = layer.blendMode
          ..opacity = layer.opacity,
      );
      if (layer.content != null) {
        canvas.drawPicture(layer.content!);
      }
      canvas.restore();
    }
  }
}