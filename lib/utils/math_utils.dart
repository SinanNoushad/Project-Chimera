import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';

class MathUtils {
  /// Creates a perspective transform matrix
  static Matrix4 createPerspectiveMatrix(
    double fov,
    double aspect,
    double near,
    double far,
  ) {
    return Matrix4.perspective(fov, aspect, near, far);
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
}