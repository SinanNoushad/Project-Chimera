import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'vulkan_plugin_method_channel.dart';

abstract class VulkanPluginPlatform extends PlatformInterface {
  /// Constructs a VulkanPluginPlatform.
  VulkanPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static VulkanPluginPlatform _instance = MethodChannelVulkanPlugin();

  /// The default instance of [VulkanPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelVulkanPlugin].
  static VulkanPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VulkanPluginPlatform] when
  /// they register themselves.
  static set instance(VulkanPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
