import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

import 'draw_n_body.dart';

class Body {
  double mass;
  Vector3 pos;
  Vector3 velocity;
  double force;

  Body({
    required this.mass,
    required this.pos,
    required this.velocity,
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
            pos: Vector3(
              range(rect.left, rect.left + rect.width),
              range(rect.top, rect.top + rect.height),
              0.0,
            ),
            velocity: Vector3.zero(),
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
            pos: Vector3(px, py, 0.0),
            velocity: Vector3(sx, sy, 0.0),
            force: 0.0,
          ),
        );
      }
    }
  }

  /// calculate new velocities and positions
  updateParams() {
    double dist = 0;
    double Fi = 0;
    double Fj = 0;
    List<Vector3> accel =
        List.generate(bodiesList.length, (index) => Vector3.zero());

    /// calculate velocity
    /// F = G(m1m2)/R^2
    for (int i = 0; i < bodiesList.length; ++i) {
      for (int j = i + 1; j < bodiesList.length; ++j) {
        dist = bodiesList[i].pos.distanceTo(bodiesList[j].pos);
        Fi = bodiesList[j].mass / (dist * dist);
        Fj = bodiesList[i].mass / (dist * dist);
        accel[i] -= (bodiesList[i].pos - bodiesList[j].pos) * Fi;
        accel[j] += (bodiesList[i].pos - bodiesList[j].pos) * Fj;
        bodiesList[i].force += Fj;
        bodiesList[j].force += Fi;
      }
      bodiesList[i].force /= bodiesList.length * 10;
    }

    /// calculate position
    for (int i = 0; i < bodiesList.length; ++i) {
      bodiesList[i].velocity += accel[i] * deltaT;
      bodiesList[i].pos += bodiesList[i].velocity * deltaT;
    }
  }
}
