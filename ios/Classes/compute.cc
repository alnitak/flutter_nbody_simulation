#include "compute.h"
#include "nbody.h"

#include <iostream>
#include <cstdlib>
#include <math.h>

NBody nBody;


void init(int shape,
          int nBodies,
          double mass_min, double mass_max,
          double pos_min_x, double pos_min_y, double pos_min_z,
          double pos_max_x, double pos_max_y, double pos_max_z,
          double spin_min_x, double spin_min_y, double spin_min_z,
          double spin_max_x, double spin_max_y, double spin_max_z)
{
    nBody.bodiesList.clear();
    for (int i = 0; i < nBodies; ++i)
    {
        nBody.addRandomBody(
            (BodyShape)shape,
            mass_min, mass_max,
            pos_min_x, pos_min_y, pos_min_z,
            pos_max_x, pos_max_y, pos_max_z,
            spin_min_x, spin_min_y, spin_min_z,
            spin_max_x, spin_max_y, spin_max_z );
    }
}

void setDeltaT(double deltaT) { nBody.setDeltaT(deltaT); }

void addBody(double mass,
             double pos_x, double pos_y, double pos_z,
             double spin_x, double spin_y, double spin_z)
{
    nBody.addBody(mass,
                  pos_x, pos_y, pos_z,
                  spin_x, spin_y, spin_z);
}

void removeBodiesWithMassRange(double min, double max)
{
    nBody.removeBodiesWithMassRange(min, max);
}

BodyFfi* updateBodies(int *nBodies)
{
    nBody.updateBodies();

    *nBodies = (int)nBody.bodiesList.size();
    return nBody.bodiesList.data();
}