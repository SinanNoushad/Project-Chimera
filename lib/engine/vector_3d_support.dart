import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';
import '../plugins/vector_3d/vector_3d_plugin.dart';
import 'package:flutter/material.dart';


class Vector3DSupport {
  final Vector3DPlugin _plugin = Vector3DPlugin();
  Matrix4 _viewMatrix = Matrix4.identity();
  Matrix4 _projectionMatrix = Matrix4.identity();

  Future<void> initialize() async {
    await _plugin.initialize();
  }

  /// Creates vector paths for 3D model edges
  Future<List<Path>> createVectorPaths(String modelPath) async {
    try {
      await _plugin.loadModel(modelPath);
      // Convert 3D model edges to 2D paths
      return <Path>[];
    } catch (e) {
      print('Failed to create vector paths: $e');
      return <Path>[];
    }
  }

  /// Updates view matrix for 3D rendering
  void updateViewMatrix(Vector3 eye, Vector3 target, Vector3 up) {
    _viewMatrix = makeViewMatrix(eye, target, up);
  }

  /// Projects texture onto 3D model
  Future<void> projectTexture(Image texture, Matrix4 transform) async {
    try {
      await _plugin.projectTexture(texture, transform);
    } catch (e) {
      print('Texture projection failed: $e');
    }
  }

  /// Converts 3D point to 2D screen space
  Vector2 projectPoint(Vector3 point) {
    final worldSpace = _viewMatrix.transformed3(point);
    final clipSpace = _projectionMatrix.transformed3(worldSpace);
    return Vector2(clipSpace.x, clipSpace.y);
  }
}