import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:n_body/body.dart';

import 'draw_n_body.dart';

/// Using a Record instead of [Body] class, performaces decreased
/// probably because a whole record object should be assigned for a single
/// parameter change?
typedef BodyType = ({
  double mass,
  double posX,
  double posY,
  double spinX,
  double spinY,
  double force,
});

typedef Accel = (double x, double y);

class NBodyRecords {
  final int nBodies;
  final Size size;

  NBodyRecords(this.nBodies, this.size);

  /// gravitational constant
  final double G = 6.6743e-11;

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

    // calculate new velocity
    /// F = G(m1m2)/R^3 (for 3D)
    /// F = G(m1m2)/R^2 (for 2D)

    /// Using Record. Seems that using a List of records, doesn't improve
    /// performaces. I think List is still a reference type hence
    /// less performat, while Float64List a list natively a value data type.
    /// Or maybe because I can't set a single record param but I neec to make
    /// a whole record assignement to change it (see `accel[i] =` below).
    /// In the `records` branch I also tried to use [bodiesList] as
    /// a list of records
    List<Accel> accel = List.generate(bodiesList.length, (index) => (0.0, 0.0));

    for (int i = 0; i < bodiesCount; ++i) {
      bodiesList[i].force = 0.0;
      for (int j = i + 1; j < bodiesCount; ++j) {
        distX = bodiesList[i].posX - bodiesList[j].posX;
        distY = bodiesList[i].posY - bodiesList[j].posY;
        dist = sqrt(distX * distX + distY * distY);

        fI = bodiesList[j].mass / (dist * dist);
        fJ = bodiesList[i].mass / (dist * dist);

        accel[i] = (accel[i].$1 - (distX * fI), accel[i].$2 - (distY * fI));
        accel[j] = (accel[j].$1 + (distX * fJ), accel[j].$2 + (distY * fJ));

        bodiesList[i].force += fJ;
        bodiesList[j].force += fI;
      }

      bodiesList[i].force /= bodiesCount * 10;
    }

    /// calculate new position
    for (int i = 0; i < bodiesCount; ++i) {
      bodiesList[i].spinX += accel[i].$1 * deltaT;
      bodiesList[i].spinY += accel[i].$2 * deltaT;

      bodiesList[i].posX += bodiesList[i].spinX * deltaT;
      bodiesList[i].posY += bodiesList[i].spinY * deltaT;
    }
  }
}
