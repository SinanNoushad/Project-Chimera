class Constants {
  // Canvas constants
  static const double DEFAULT_BRUSH_SIZE = 10.0;
  static const int DEFAULT_CANVAS_WIDTH = 2048;
  static const int DEFAULT_CANVAS_HEIGHT = 2048;
  static const int TILE_SIZE = 256;

  // Color constants
  static const int COLOR_DEPTH = 16; // bits per channel
  static const double MAX_PRESSURE = 1.0;
  
  // Performance constants
  static const int TARGET_FPS = 120;
  static const Duration FRAME_BUDGET = Duration(microseconds: 8333); // ~120fps
}