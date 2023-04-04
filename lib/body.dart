import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'draw_n_body.dart';

class Body {
  double mass;
  double posX;
  double posY;
  double spinX;
  double spinY;
  double force;

  Body({
    required this.mass,
    required this.posX,
    required this.posY,
    required this.spinX,
    required this.spinY,
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
      size.width * 0.25,
      size.height * 0.25,
      size.width * 0.75,
      size.height * 0.75,
    );
    for (int i = 0; i < nBodies; ++i) {
      double m = Random().nextDouble() * ((maxMass - minMass) + minMass);
      if (shape == BodiesShape.rectangle) {
        bodiesList.add(
          Body(
            mass: m,
            posX: range(rect.left, rect.left + rect.width),
            posY: range(rect.top, rect.top + rect.height),
            spinX: 0.0,
            spinY: 0.0,
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
        double sx = cos(angle - pi / 2) * (randRadius) * 10;
        double sy = sin(angle - pi / 2) * (randRadius) * 10;

        bodiesList.add(
          Body(
            mass: m,
            posX: px,
            posY: py,
            spinX: sx,
            spinY: sy,
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

    /// Using Float64List there is a great improvement in
    /// debug mode (2500 bodies, from 13 to 31 FPS), but
    /// in release mode both types gives me about 20 FPS!! (less then debug mode!)
    // List<double> accelX = List.generate(bodiesCount, (index) => 0.0);
    // List<double> accelY = List.generate(bodiesCount, (index) => 0.0);
    final accelX = Float64List(bodiesCount);
    final accelY = Float64List(bodiesCount);

    // calculate new velocity
    /// F = G(m1m2)/R^3 (for 3D)
    /// F = G(m1m2)/R^2 (for 2D)
    for (int i = 0; i < bodiesList.length; ++i) {
      bodiesList[i].force = 0.0;
      for (int j = i + 1; j < bodiesList.length; ++j) {
        distX = bodiesList[i].posX - bodiesList[j].posX;
        distY = bodiesList[i].posY - bodiesList[j].posY;
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
    for (int i = 0; i < bodiesCount; ++i) {
      bodiesList[i].spinX += accelX[i] * deltaT;
      bodiesList[i].spinY += accelY[i] * deltaT;

      bodiesList[i].posX += bodiesList[i].spinX * deltaT;
      bodiesList[i].posY += bodiesList[i].spinY * deltaT;
    }
  }
}
