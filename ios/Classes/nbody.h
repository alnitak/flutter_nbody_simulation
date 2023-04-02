#ifndef NBODY_H
#define NBODY_H

#include "compute.h"

#include <vector>

#define RANGE(MIN, MAX) (MIN + ((((double)rand() / (double)RAND_MAX)) * (MAX - MIN)))

enum BodyShape {
  RECTANGLE,
  CIRCLE
};

class NBody
{

public:
  NBody();

  double deltaT;

  /// gravitational constant
  const double G;

  std::vector<BodyFfi> bodiesList;

  void setDeltaT(double dt) { deltaT = dt; }

  void addRandomBody(BodyShape shape,
                     double mass_min, double mass_max,
                     double pos_min_x, double pos_min_y, 
                     double pos_max_x, double pos_max_y, 
                     double spin_min_x, double spin_min, 
                     double spin_max_x, double spin_max_y);

  void addBody(double mass,
                    double pos_x, double pos_y,
                    double spin_x, double spin_y);

  void removeBodiesWithMassRange(double min, double max);

  void updateBodies();
};

#endif