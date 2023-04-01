import 'package:flutter_test/flutter_test.dart';
import 'package:n_body/n_body.dart';
import 'package:n_body/n_body_platform_interface.dart';
import 'package:n_body/n_body_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNBodyPlatform
    with MockPlatformInterfaceMixin
    implements NBodyPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NBodyPlatform initialPlatform = NBodyPlatform.instance;

  test('$MethodChannelNBody is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNBody>());
  });

  test('getPlatformVersion', () async {
    NBody nBodyPlugin = NBody();
    MockNBodyPlatform fakePlatform = MockNBodyPlatform();
    NBodyPlatform.instance = fakePlatform;

    expect(await nBodyPlugin.getPlatformVersion(), '42');
  });
}
