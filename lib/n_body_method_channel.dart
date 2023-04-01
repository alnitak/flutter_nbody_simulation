import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'n_body_platform_interface.dart';

/// An implementation of [NBodyPlatform] that uses method channels.
class MethodChannelNBody extends NBodyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('n_body');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
