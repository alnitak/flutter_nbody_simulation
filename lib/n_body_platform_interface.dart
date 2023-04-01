import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'n_body_method_channel.dart';

abstract class NBodyPlatform extends PlatformInterface {
  /// Constructs a NBodyPlatform.
  NBodyPlatform() : super(token: _token);

  static final Object _token = Object();

  static NBodyPlatform _instance = MethodChannelNBody();

  /// The default instance of [NBodyPlatform] to use.
  ///
  /// Defaults to [MethodChannelNBody].
  static NBodyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NBodyPlatform] when
  /// they register themselves.
  static set instance(NBodyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
