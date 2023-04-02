#ifndef COMPUTE_H
#define COMPUTE_H

#ifdef _WIN32
#define FFI extern "C" __declspec(dllexport)
#pragma warning ( disable : 4310 )
#else
#define FFI extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

typedef struct BodyFfi
{
  double mass;
  double pos_x;
  double pos_y;
  double spin_x;
  double spin_y;
  double force;
} BodyFfi;

/// NOTE: when running 'dart run ffiget' the FFI #define must be removed

FFI void init(int shape,
          int nBodies,
          double mass_min, double mass_max,
          double pos_min_x, double pos_min_y,
          double pos_max_x, double pos_max_y,
          double spin_min_x, double spin_min_y,
          double spin_max_x, double spin_max_y);

FFI void setDeltaT(double deltaT);

FFI void addBody(double mass,
             double pos_x, double pos_y,
             double spin_x, double spin_y);

FFI void removeBodiesWithMassRange(double min, double max);

FFI BodyFfi* updateBodies(int *nBodies);

#endif