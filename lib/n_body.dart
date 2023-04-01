
import 'n_body_platform_interface.dart';

class NBody {
  Future<String?> getPlatformVersion() {
    return NBodyPlatform.instance.getPlatformVersion();
  }
}
