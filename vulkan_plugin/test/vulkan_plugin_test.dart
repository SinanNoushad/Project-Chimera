import 'package:flutter_test/flutter_test.dart';
import 'package:vulkan_plugin/vulkan_plugin.dart';
import 'package:vulkan_plugin/vulkan_plugin_platform_interface.dart';
import 'package:vulkan_plugin/vulkan_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVulkanPluginPlatform
    with MockPlatformInterfaceMixin
    implements VulkanPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VulkanPluginPlatform initialPlatform = VulkanPluginPlatform.instance;

  test('$MethodChannelVulkanPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVulkanPlugin>());
  });

  test('getPlatformVersion', () async {
    VulkanPlugin vulkanPlugin = VulkanPlugin();
    MockVulkanPluginPlatform fakePlatform = MockVulkanPluginPlatform();
    VulkanPluginPlatform.instance = fakePlatform;

    expect(await vulkanPlugin.getPlatformVersion(), '42');
  });
}
