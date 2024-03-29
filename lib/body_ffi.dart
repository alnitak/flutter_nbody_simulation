// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Bindings to NBody
class NBodyFfi {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NBodyFfi(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NBodyFfi.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// NOTE: when running 'dart run ffiget' the FFI #define must be removed
  void init(
    int shape,
    int nBodies,
    double mass_min,
    double mass_max,
    double pos_min_x,
    double pos_min_y,
    double pos_max_x,
    double pos_max_y,
    double spin_min_x,
    double spin_min_y,
    double spin_max_x,
    double spin_max_y,
  ) {
    return _init(
      shape,
      nBodies,
      mass_min,
      mass_max,
      pos_min_x,
      pos_min_y,
      pos_max_x,
      pos_max_y,
      spin_min_x,
      spin_min_y,
      spin_max_x,
      spin_max_y,
    );
  }

  late final _initPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int,
              ffi.Int,
              ffi.Double,
              ffi.Double,
              ffi.Double,
              ffi.Double,
              ffi.Double,
              ffi.Double,
              ffi.Double,
              ffi.Double,
              ffi.Double,
              ffi.Double)>>('init');
  late final _init = _initPtr.asFunction<
      void Function(int, int, double, double, double, double, double, double,
          double, double, double, double)>();

  void setDeltaT(
    double deltaT,
  ) {
    return _setDeltaT(
      deltaT,
    );
  }

  late final _setDeltaTPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Double)>>('setDeltaT');
  late final _setDeltaT = _setDeltaTPtr.asFunction<void Function(double)>();

  void addBody(
    double mass,
    double pos_x,
    double pos_y,
    double spin_x,
    double spin_y,
  ) {
    return _addBody(
      mass,
      pos_x,
      pos_y,
      spin_x,
      spin_y,
    );
  }

  late final _addBodyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Double, ffi.Double, ffi.Double, ffi.Double,
              ffi.Double)>>('addBody');
  late final _addBody = _addBodyPtr
      .asFunction<void Function(double, double, double, double, double)>();

  void removeBodiesWithMassRange(
    double min,
    double max,
  ) {
    return _removeBodiesWithMassRange(
      min,
      max,
    );
  }

  late final _removeBodiesWithMassRangePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Double, ffi.Double)>>(
          'removeBodiesWithMassRange');
  late final _removeBodiesWithMassRange =
      _removeBodiesWithMassRangePtr.asFunction<void Function(double, double)>();

  ffi.Pointer<BodyFfi> updateBodies(
    ffi.Pointer<ffi.Int> nBodies,
  ) {
    return _updateBodies(
      nBodies,
    );
  }

  late final _updateBodiesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<BodyFfi> Function(ffi.Pointer<ffi.Int>)>>('updateBodies');
  late final _updateBodies = _updateBodiesPtr
      .asFunction<ffi.Pointer<BodyFfi> Function(ffi.Pointer<ffi.Int>)>();
}

final class BodyFfi extends ffi.Struct {
  @ffi.Double()
  external double mass;

  @ffi.Double()
  external double pos_x;

  @ffi.Double()
  external double pos_y;

  @ffi.Double()
  external double spin_x;

  @ffi.Double()
  external double spin_y;

  @ffi.Double()
  external double force;
}
