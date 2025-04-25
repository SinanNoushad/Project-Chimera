
import 'vulkan_plugin_platform_interface.dart';

class VulkanPlugin {
  Future<String?> getPlatformVersion() {
    return VulkanPluginPlatform.instance.getPlatformVersion();
  }
}
