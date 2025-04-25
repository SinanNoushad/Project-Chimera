import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';

// FFI function signatures
typedef LoadModelNativeC = ffi.Int32 Function(
  ffi.Pointer<ffi.Int8>, // model path
);

typedef LoadModelNativeDart = int Function(
  ffi.Pointer<ffi.Int8>,
);

typedef ProjectTextureNativeC = ffi.Int32 Function(
  ffi.Pointer<ffi.Uint8>, // texture data
  ffi.Int32, // texture width
  ffi.Int32, // texture height
  ffi.Pointer<ffi.Float>, // projection matrix
);

typedef ProjectTextureNativeDart = int Function(
  ffi.Pointer<ffi.Uint8>,
  int,
  int,
  ffi.Pointer<ffi.Float>,
);

class Vector3DPlugin {
  late ffi.DynamicLibrary _nativeLib;
  late final LoadModelNativeDart _loadModelFunc;
  late final ProjectTextureNativeDart _projectTextureFunc;
  bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      _nativeLib = ffi.DynamicLibrary.open(_getLibraryPath());
      
      // Bind native functions
      _loadModelFunc = _nativeLib.lookupFunction<
        LoadModelNativeC,
        LoadModelNativeDart
      >('load_model');

      _projectTextureFunc = _nativeLib.lookupFunction<
        ProjectTextureNativeC,
        ProjectTextureNativeDart
      >('project_texture');

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize Vector3D plugin: $e');
    }
  }

  Future<void> loadModel(String path) async {
    if (!_isInitialized) {
      throw Exception('Vector3D plugin not initialized');
    }

    try {
      // Convert path to native string
      final nativePath = path.toNativeUtf8();

      // Call native function
      final result = _loadModelFunc(nativePath.cast<ffi.Int8>());

      // Free native string
      calloc.free(nativePath);

      if (result != 0) {
        throw Exception('Failed to load 3D model');
      }
    } catch (e) {
      throw Exception('Error loading model: $e');
    }
  }

  Future<void> projectTexture(
    Image texture,
    Matrix4 projection,
  ) async {
    if (!_isInitialized) {
      throw Exception('Vector3D plugin not initialized');
    }

    // Null check and conversion for texture dimensions
    final textureWidth = texture.width;
    final textureHeight = texture.height;
    
    if (textureWidth == null || textureHeight == null) {
      throw Exception('Invalid texture dimensions');
    }

    try {
      // Get texture data
      final textureData = await _getTextureData(texture);
      
      // Convert doubles to integers for the texture dimensions
      final width = textureWidth.toInt();
      final height = textureHeight.toInt();

      // Calculate buffer size using int multiplication
      final bufferSize = width * height * 4;

      // Allocate memory for texture data
      final nativeTextureData = calloc<ffi.Uint8>(bufferSize);
      nativeTextureData.asTypedList(bufferSize).setAll(0, textureData);

      // Convert projection matrix to native format
      final nativeMatrix = calloc<ffi.Float>(16);
      final matrixStorage = projection.storage;
      for (var i = 0; i < 16; i++) {
        nativeMatrix[i] = matrixStorage[i].toDouble();
      }

      // Call native function
      final result = _projectTextureFunc(
        nativeTextureData,
        width,
        height,
        nativeMatrix,
      );

      // Clean up
      calloc.free(nativeTextureData);
      calloc.free(nativeMatrix);

      if (result != 0) {
        throw Exception('Failed to project texture');
      }
    } catch (e) {
      throw Exception('Error projecting texture: $e');
    }
  }

  String _getLibraryPath() {
    if (Platform.isWindows) {
      return 'vector3d.dll';
    } else if (Platform.isMacOS) {
      return 'libvector3d.dylib';
    } else if (Platform.isLinux) {
      return 'libvector3d.so';
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<List<int>> _getTextureData(Image texture) async {
    // Implementation to extract raw RGBA data from the texture
    // This is a placeholder - implement based on your image format
    throw UnimplementedError('Texture data extraction not implemented');
  }

  void dispose() {
    if (_isInitialized) {
      // Add any necessary cleanup
      _isInitialized = false;
    }
  }
}