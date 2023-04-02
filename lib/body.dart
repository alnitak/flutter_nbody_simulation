import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

import 'draw_n_body.dart';

class Body {
  double mass;
  Vector2 pos;
  Vector2 spin;
  double force;

  Body({
    required this.mass,
    required this.pos,
    required this.spin,
    required this.force,
  });
}

enum BodiesShape {
  rectangle,
  circle,
}

class NBody {
  final int nBodies;
  final Size size;

  NBody(this.nBodies, this.size);

  /// gravitational constant
  final double G = 6.6743e-11;

  late int nIsolates;

  List<Body> bodiesList = [];

  double range(double min, double max) {
    return min + (Random().nextDouble() * (max - min));
  }

  /// fill [bodiesList] with bodies with a random mass
  init(BodiesShape shape) {
    bodiesList.clear();
    Rect rect = Rect.fromLTRB(
      size.width * 0.25, size.height * 0.25,
      size.width * 0.75, size.height * 0.75,
    );
    for (int i = 0; i < nBodies; ++i) {
      double m = Random().nextDouble() * ((maxMass - minMass) + minMass);
      if (shape == BodiesShape.rectangle) {
        bodiesList.add(
          Body(
            mass: m,
            pos: Vector2(
              range(rect.left, rect.left + rect.width),
              range(rect.top, rect.top + rect.height),
            ),
            spin: Vector2.zero(),
            force: 0.0,
          ),
        );
      } else {
        double radiusX = rect.width / 2;
        double radiusY = rect.height / 2;
        double circleRadius = min(radiusX, radiusY);
        double randRadius = range(0, circleRadius);
        double angle = range(-pi, pi);

        /// position
        double px = rect.left + radiusX + cos(angle) * randRadius;
        double py = rect.top + radiusY + sin(angle) * randRadius;

        /// spin
        double sx = cos(angle - pi/2) * (randRadius) * 10;
        double sy = sin(angle - pi/2) * (randRadius) * 10;

        bodiesList.add(
          Body(
            mass: m,
            pos: Vector2(px, py),
            spin: Vector2(sx, sy),
            force: 0.0,
          ),
        );
      }
    }
  }

  /// calculate new velocities and positions
  /// Not using Vector2 to be the same as C side
  updateParams() {
    double distX = 0;
    double distY = 0;
    double dist = 0;
    double fI = 0;
    double fJ = 0;
    int bodiesCount = bodiesList.length;
    List<double> accelX = List.generate(bodiesCount, (index) => 0.0);
    List<double> accelY = List.generate(bodiesCount, (index) => 0.0);

    // calculate new velocity
    /// F = G(m1m2)/R^3 (for 3D)
    /// F = G(m1m2)/R^2 (for 2D)
    for (int i = 0; i < bodiesList.length; ++i)
    {
        bodiesList[i].force = 0.0;
        for (int j = i + 1; j < bodiesList.length; ++j)
        {
            distX = bodiesList[i].pos.x - bodiesList[j].pos.x;
            distY = bodiesList[i].pos.y - bodiesList[j].pos.y;
            dist = sqrt(distX * distX + distY * distY);

            fI = bodiesList[j].mass / (dist * dist);
            fJ = bodiesList[i].mass / (dist * dist);

            accelX[i] -= distX * fI;
            accelY[i] -= distY * fI;

            accelX[j] += distX * fJ;
            accelY[j] += distY * fJ;

            bodiesList[i].force += fJ;
            bodiesList[j].force += fI;
        }

        bodiesList[i].force /= bodiesCount * 10;
    }
    // std::cout << "FORCE  " << bodiesList[0].force << std::endl;

    /// calculate new position
    for (int i = 0; i < bodiesCount; ++i)
    {
        bodiesList[i].spin.x += accelX[i] * deltaT;
        bodiesList[i].spin.y += accelY[i] * deltaT;

        bodiesList[i].pos.x += bodiesList[i].spin.x * deltaT;
        bodiesList[i].pos.y += bodiesList[i].spin.y * deltaT;
    }
  }
}
