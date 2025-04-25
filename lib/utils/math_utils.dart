import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart';

class MathUtils {
  /// Creates a perspective transform matrix
  static Matrix4 createPerspectiveMatrix(
    double fov,
    double aspect,
    double near,
    double far,
  ) {
    // Convert FOV from degrees to radians
    final fovRadians = fov * (math.pi / 180.0);
    
    final matrix = Matrix4.zero();
    final tanHalfFov = math.tan(fovRadians / 2.0);
    
    // Build perspective matrix
    matrix.setEntry(0, 0, 1.0 / (aspect * tanHalfFov));
    matrix.setEntry(1, 1, 1.0 / tanHalfFov);
    matrix.setEntry(2, 2, -(far + near) / (far - near));
    matrix.setEntry(2, 3, -1.0);
    matrix.setEntry(3, 2, -(2.0 * far * near) / (far - near));
    
    return matrix;
  }

  /// Creates a view matrix looking at a target point
  static Matrix4 createLookAtMatrix(
    Vector3 eye,
    Vector3 target,
    Vector3 up,
  ) {
    final matrix = Matrix4.identity();
    
    final zAxis = (eye - target).normalized();
    final xAxis = up.cross(zAxis).normalized();
    final yAxis = zAxis.cross(xAxis);
    
    matrix.setEntry(0, 0, xAxis.x);
    matrix.setEntry(1, 0, xAxis.y);
    matrix.setEntry(2, 0, xAxis.z);
    matrix.setEntry(0, 1, yAxis.x);
    matrix.setEntry(1, 1, yAxis.y);
    matrix.setEntry(2, 1, yAxis.z);
    matrix.setEntry(0, 2, zAxis.x);
    matrix.setEntry(1, 2, zAxis.y);
    matrix.setEntry(2, 2, zAxis.z);
    matrix.setEntry(3, 0, -xAxis.dot(eye));
    matrix.setEntry(3, 1, -yAxis.dot(eye));
    matrix.setEntry(3, 2, -zAxis.dot(eye));
    
    return matrix;
  }

  /// Interpolates between two values with easing
  static double lerp(
    double start,
    double end,
    double t,
    Curve curve,
  ) {
    return start + (end - start) * curve.transform(t);
  }
  
  /// Converts degrees to radians
  static double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }
  
  /// Converts radians to degrees
  static double radiansToDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }
}