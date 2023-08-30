import 'dart:ffi' as ffi;
import 'dart:io';

import 'body_ffi.dart';

/// Controller that expose FFI
class NBodyController {
  static NBodyController? _instance;

  factory NBodyController() => _instance ??= NBodyController._();

  NBodyController._();

  late final NBodyFfi nbodyFfi;

  initializeNBody() {
    ffi.DynamicLibrary nativeLib = Platform.isAndroid
        ? ffi.DynamicLibrary.open("libn_body_plugin.so")
        : (Platform.isWindows
            ? ffi.DynamicLibrary.open("n_body_plugin.dll")
            : ffi.DynamicLibrary.process());
    nbodyFfi = NBodyFfi.fromLookup(nativeLib.lookup);
  }
}
