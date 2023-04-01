import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:n_body/n_body_method_channel.dart';

void main() {
  MethodChannelNBody platform = MethodChannelNBody();
  const MethodChannel channel = MethodChannel('n_body');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
