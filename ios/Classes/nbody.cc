#include "nbody.h"

#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <math.h>


NBody::NBody() : deltaT(0.01), G(6.6743e-11){};


/// 
void NBody::addRandomBody(BodyShape shape,
                          double mass_min, double mass_max,
                          double pos_min_x, double pos_min_y, double pos_min_z,
                          double pos_max_x, double pos_max_y, double pos_max_z,
                          double spin_min_x, double spin_min_y, double spin_min_z,
                          double spin_max_x, double spin_max_y, double spin_max_z)
{
    if (shape == RECTANGLE) {
        addBody(
            RANGE(mass_min, mass_max),

            RANGE(pos_min_x, pos_max_x),
            RANGE(pos_min_y, pos_max_y),
            RANGE(pos_min_z, pos_max_z),

            RANGE(spin_min_x, spin_max_x),
            RANGE(spin_min_y, spin_max_y),
            RANGE(spin_min_z, spin_max_z));
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
        
        addBody(
            RANGE(mass_min, mass_max),
            px, py, 0.0,
            sx, sy, 0
        );
    }
}

void NBody::addBody(double mass,
                    double pos_x, double pos_y, double pos_z,
                    double spin_x, double spin_y, double spin_z)
{
    // std::cout << "mass: " << mass << "  pos: " << pos << std::endl;
    bodiesList.push_back(
        BodyFfi{mass, pos_x, pos_y, pos_z, spin_x, spin_y, spin_z});
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
    double dist = 0;
    double Fi = 0;
    double Fj = 0;
    int bodiesCount = (int)bodiesList.size();
    std::vector<double> accel_x(bodiesCount);
    std::vector<double> accel_y(bodiesCount);
    std::vector<double> accel_z(bodiesCount);

    for (int i = 0; i < bodiesList.size(); ++i)
    {
        accel_x[i] = 0;
        accel_y[i] = 0;
        accel_z[i] = 0;
    }

    // calculate new velocity
    /// F = G(m1m2)/R^2
    for (int i = 0; i < bodiesList.size(); ++i)
        bodiesList[i].force = 0.0;

    for (int i = 0; i < bodiesList.size(); ++i)
    {
        for (int j = i + 1; j < bodiesList.size(); ++j)
        {
            dist = sqrt(
                ((bodiesList[j].pos_x - bodiesList[i].pos_x) * (bodiesList[j].pos_x - bodiesList[i].pos_x)) +
                ((bodiesList[j].pos_y - bodiesList[i].pos_y) * (bodiesList[j].pos_y - bodiesList[i].pos_y)) +
                ((bodiesList[j].pos_z - bodiesList[i].pos_z) * (bodiesList[j].pos_z - bodiesList[i].pos_z)));

            Fi = bodiesList[j].mass / (dist * dist);
            Fj = bodiesList[i].mass / (dist * dist);

            accel_x[i] -= (bodiesList[i].pos_x - bodiesList[j].pos_x) * Fi;
            accel_y[i] -= (bodiesList[i].pos_y - bodiesList[j].pos_y) * Fi;
            accel_z[i] -= (bodiesList[i].pos_z - bodiesList[j].pos_z) * Fi;

            accel_x[j] += (bodiesList[i].pos_x - bodiesList[j].pos_x) * Fj;
            accel_y[j] += (bodiesList[i].pos_y - bodiesList[j].pos_y) * Fj;
            accel_z[j] += (bodiesList[i].pos_z - bodiesList[j].pos_z) * Fj;

            bodiesList[i].force += Fj;
            bodiesList[j].force += Fi;
        }

        bodiesList[i].force /= bodiesList.size() * 10;
    }
    // std::cout << "FORCE  " << bodiesList[0].force << std::endl;

    /// calculate new position
    for (int i = 0; i < bodiesList.size(); ++i)
    {
        bodiesList[i].spin_x += accel_x[i] * deltaT;
        bodiesList[i].spin_y += accel_y[i] * deltaT;
        bodiesList[i].spin_z += accel_z[i] * deltaT;

        bodiesList[i].pos_x += bodiesList[i].spin_x * deltaT;
        bodiesList[i].pos_y += bodiesList[i].spin_y * deltaT;
        bodiesList[i].pos_z += bodiesList[i].spin_z * deltaT;
    }
}