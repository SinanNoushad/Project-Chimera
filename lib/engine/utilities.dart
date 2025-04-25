import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

class Utilities {
  final List<Command> _undoStack = [];
  final List<Command> _redoStack = [];
  final List<ui.Image> _timelapseFrames = [];

  /// Adds a command to the undo stack
  void executeCommand(Command command) {
    command.execute();
    _undoStack.add(command);
    _redoStack.clear();
  }

  /// Undoes the last command
  void undo() {
    if (_undoStack.isEmpty) return;
    
    final command = _undoStack.removeLast();
    command.undo();
    _redoStack.add(command);
  }

  /// Redoes the last undone command
  void redo() {
    if (_redoStack.isEmpty) return;
    
    final command = _redoStack.removeLast();
    command.execute();
    _undoStack.add(command);
  }

  /// Captures a frame for the time-lapse recording
  void captureTimelapseFrame(ui.Image frame) {
    _timelapseFrames.add(frame);
  }

  /// Exports the project to various formats
  Future<Uint8List> exportProject(ExportFormat format) async {
    switch (format) {
      case ExportFormat.psd:
        return _exportToPSD();
      case ExportFormat.png:
        return _exportToPNG();
      case ExportFormat.tiff:
        return _exportToTIFF();
    }
  }

  Future<Uint8List> _exportToPSD() async {
    // Implement PSD export
    return Uint8List(0);
  }

  Future<Uint8List> _exportToPNG() async {
    // Implement PNG export
    return Uint8List(0);
  }

  Future<Uint8List> _exportToTIFF() async {
    // Implement TIFF export
    return Uint8List(0);
  }
}

abstract class Command {
  void execute();
  void undo();
}

enum ExportFormat {
  psd,
  png,
  tiff,
}