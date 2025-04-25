import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vulkan_plugin_platform_interface.dart';

/// An implementation of [VulkanPluginPlatform] that uses method channels.
class MethodChannelVulkanPlugin extends VulkanPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vulkan_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
