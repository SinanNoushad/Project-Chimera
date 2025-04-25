import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart'; // Add this import for string conversions

// FFI signature typedefs
typedef InitializeNativeC = ffi.Int32 Function();
typedef InitializeNativeDart = int Function();

typedef ExecuteShaderNativeC = ffi.Int32 Function(
  ffi.Pointer<ffi.Int8>, // shaderId
  ffi.Pointer<ffi.Void>, // uniformsData
  ffi.Int32, // uniformsSize
);
typedef ExecuteShaderNativeDart = int Function(
  ffi.Pointer<ffi.Int8>, // shaderId
  ffi.Pointer<ffi.Void>, // uniformsData
  int, // uniformsSize
);

class ComputePlugin {
  late ffi.DynamicLibrary _nativeLib;
  late final InitializeNativeDart _initializeNative;
  late final ExecuteShaderNativeDart _executeShaderNative;
  bool _isInitialized = false;

  /// Initialize the compute plugin by loading the native library
  Future<void> initialize() async {
    try {
      // Load the appropriate library based on platform
      _nativeLib = ffi.DynamicLibrary.open(_getLibraryPath());
      
      // Bind native functions
      _initializeNative = _nativeLib
          .lookupFunction<InitializeNativeC, InitializeNativeDart>('initialize');
      
      _executeShaderNative = _nativeLib
          .lookupFunction<ExecuteShaderNativeC, ExecuteShaderNativeDart>('execute_shader');
      
      // Call native initialization
      final result = _initializeNative();
      if (result != 0) {
        throw Exception('Failed to initialize compute plugin');
      }
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load compute library: $e');
    }
  }

  /// Execute a compute shader with the given uniforms
  Future<void> executeShader(
    String shaderId,
    Map<String, dynamic> uniforms,
  ) async {
    if (!_isInitialized) {
      throw Exception('Compute plugin not initialized');
    }

    try {
      // Convert shaderId to native string using the proper method
      final shaderIdNative = shaderId.toNativeUtf8();
      
      // Convert uniforms to native format
      final uniformsData = _convertUniformsToNative(uniforms);
      
      // Execute shader
      final result = _executeShaderNative(
        shaderIdNative.cast<ffi.Int8>(),
        uniformsData,
        uniforms.length,
      );

      // Free the allocated native string
      calloc.free(shaderIdNative);

      // Check result
      if (result != 0) {
        throw Exception('Shader execution failed');
      }
    } catch (e) {
      throw Exception('Error executing shader: $e');
    }
  }

  /// Get the appropriate library name for the current platform
  String _getLibraryPath() {
    if (Platform.isWindows) {
      return 'compute.dll';
    } else if (Platform.isMacOS) {
      return 'libcompute.dylib';
    } else if (Platform.isLinux) {
      return 'libcompute.so';
    } else {
      throw Exception('Unsupported platform');
    }
  }

  /// Convert Dart uniforms map to native format
  ffi.Pointer<ffi.Void> _convertUniformsToNative(Map<String, dynamic> uniforms) {
    // TODO: Implement uniform conversion based on your specific needs
    // This is a placeholder that should be implemented based on your 
    // actual uniform data structure
    return ffi.nullptr;
  }

  /// Clean up resources
  void dispose() {
    if (_isInitialized) {
      // Add cleanup code if needed
      _isInitialized = false;
    }
  }
}