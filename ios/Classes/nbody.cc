#include "nbody.h"

#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <math.h>

#ifndef M_PI
    #define M_PI 3.14159265358979323846
    #define M_PI_2 1.57079632679489661923
#endif


NBody::NBody() : deltaT(0.01), G(6.6743e-11){};


/// 
void NBody::addRandomBody(BodyShape shape,
                          double mass_min, double mass_max,
                          double pos_min_x, double pos_min_y,
                          double pos_max_x, double pos_max_y,
                          double spin_min_x, double spin_min_y,
                          double spin_max_x, double spin_max_y)
{
    if (shape == RECTANGLE) {
        addBody(
            RANGE(mass_min, mass_max),

            RANGE(pos_min_x, pos_max_x),
            RANGE(pos_min_y, pos_max_y),

            RANGE(spin_min_x, spin_max_x),
            RANGE(spin_min_y, spin_max_y));
    } else {
        double radius_x = (pos_max_x - pos_min_x) / 2;
        double radius_y = (pos_max_y - pos_min_y) / 2;
        double circle_radius = std::min(radius_x, radius_y);
        double rand_radius = RANGE(0, circle_radius);
        double angle = RANGE(-M_PI, M_PI);

        /// position
        double px = pos_min_x + radius_x + cos(angle) * rand_radius;
        double py = pos_min_y + radius_y + sin(angle) * rand_radius;

        /// spin
        double sx = cos(angle - M_PI_2) * (rand_radius) * 10;
        double sy = sin(angle - M_PI_2) * (rand_radius) * 10;
        
        addBody(RANGE(mass_min, mass_max), px, py,  sx, sy);
    }
}

void NBody::addBody(double mass,
                    double pos_x, double pos_y,
                    double spin_x, double spin_y)
{
    // std::cout << "mass: " << mass << "  pos: " << pos << std::endl;
    bodiesList.push_back(
        BodyFfi{mass, pos_x, pos_y, spin_x, spin_y});
}

void NBody::removeBodiesWithMassRange(double min, double max)
{
    bodiesList.erase(std::remove_if(
                         bodiesList.begin(), bodiesList.end(),
                         [&min, &max](const BodyFfi &b)
                         {
                             return b.mass >= min && b.mass <= max;
                         }),
                     bodiesList.end());
}

void NBody::updateBodies()
{
    double distX = 0;
    double distY = 0;
    double dist = 0;
    double fI = 0;
    double fJ = 0;
    int bodiesCount = (int)bodiesList.size();
    std::vector<double> accel_x(bodiesCount);
    std::vector<double> accel_y(bodiesCount);

    std::fill(accel_x.begin(), accel_x.end(), 0);
    std::fill(accel_y.begin(), accel_y.end(), 0);

    // calculate new velocity
    /// F = G(m1m2)/R^3 (for 3D)
    /// F = G(m1m2)/R^2 (for 2D)
    for (int i = 0; i < bodiesCount; ++i)
    {
        bodiesList[i].force = 0.0;
        for (int j = i + 1; j < bodiesCount; ++j)
        {
            distX = bodiesList[i].pos_x - bodiesList[j].pos_x;
            distY = bodiesList[i].pos_y - bodiesList[j].pos_y;
            dist = sqrt(distX * distX + distY * distY);

            fI = bodiesList[j].mass / (dist * dist);
            fJ = bodiesList[i].mass / (dist * dist);

            accel_x[i] -= distX * fI;
            accel_y[i] -= distY * fI;

            accel_x[j] += distX * fJ;
            accel_y[j] += distY * fJ;

            bodiesList[i].force += fJ;
            bodiesList[j].force += fI;
        }

        bodiesList[i].force /= bodiesCount * 10;
    }
    // std::cout << "FORCE  " << bodiesList[0].force << std::endl;

    /// calculate new position
    for (int i = 0; i < bodiesCount; ++i)
    {
        bodiesList[i].spin_x += accel_x[i] * deltaT;
        bodiesList[i].spin_y += accel_y[i] * deltaT;

        bodiesList[i].pos_x += bodiesList[i].spin_x * deltaT;
        bodiesList[i].pos_y += bodiesList[i].spin_y * deltaT;
    }
}