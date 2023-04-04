import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';

import 'body.dart';
import 'n_body_ffi.dart';

class BodyPainter extends CustomPainter {
  final List<Body> bodiesList;

  BodyPainter({
    required this.bodiesList,
  });

  /// the force from 0 to [a] has a gradient color
  /// the force >[a] has another gradient
  final a = 0.3;
  final b = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    for (int i = 0; i < bodiesList.length; ++i) {
      if (bodiesList[i].mass <= 20000) {
        /// draw bodies
        if (bodiesList[i].force <= a) {
          paint.color = Color.lerp(
              Colors.redAccent, Colors.yellowAccent, bodiesList[i].force / a)!;
        } else {
          paint.color = Color.lerp(
              Colors.yellowAccent, Colors.white, bodiesList[i].force / b)!;
        }
        canvas.drawCircle(
          Offset(bodiesList[i].posX, bodiesList[i].posY),
          (10 * bodiesList[i].mass) / 20000,
          paint,
        );
      } else {
        if (bodiesList[i].mass == 80000) {
          /// draw stars with mass=80000
          paint.color = Colors.yellowAccent;
        } else {
          /// draw black holes with mass=10M
          paint.color = Colors.black;
        }
        canvas.drawCircle(
          Offset(bodiesList[i].posX, bodiesList[i].posY),
          8,
          paint,
        );
        paint.color = Colors.white70;
      }
    }
  }

  @override
  bool shouldRepaint(covariant BodyPainter oldDelegate) {
    return true;
  }
}

class BodyPainterFfi extends CustomPainter {
  final ffi.Pointer<BodyFfi> bodiesList;
  final ffi.Pointer<ffi.Int> nBodies;

  BodyPainterFfi({
    required this.bodiesList,
    required this.nBodies,
  });

  /// the force from 0 to [a] has a gradient color
  /// the force >[a] has another gradient
  final a = 0.3;
  final b = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    for (int i = 0; i < nBodies.value; ++i) {
      if (bodiesList[i].mass <= 20000) {
        /// draw bodies
        if (bodiesList[i].force <= a) {
          paint.color = Color.lerp(
              Colors.redAccent, Colors.yellowAccent, bodiesList[i].force / a)!;
        } else {
          paint.color = Color.lerp(
              Colors.yellowAccent, Colors.white, bodiesList[i].force / b)!;
        }
        canvas.drawCircle(
          Offset(bodiesList[i].pos_x, bodiesList[i].pos_y),
          (10 * bodiesList[i].mass) / 20000,
          paint,
        );
      } else {
        if (bodiesList[i].mass == 80000) {
          /// draw stars with mass=80000
          paint.color = Colors.yellowAccent;
        } else {
          /// draw black holes with mass=10M
          paint.color = Colors.black;
        }
        canvas.drawCircle(
          Offset(bodiesList[i].pos_x, bodiesList[i].pos_y),
          8,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant BodyPainterFfi oldDelegate) {
    return true;
  }
}
