import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:n_body/body.dart';
import 'package:n_body/n_body_ffi.dart';
import 'package:n_body/simulation_painter.dart';
import 'package:vector_math/vector_math.dart';

import 'n_body_controller.dart';

/// delta time
double deltaT = 0.001;

/// min and max mass range
double minMass = 1000.0;
double maxMass = 6000.0;

/// calculate fps
final stopwatch = Stopwatch();
int framesCount = 0;

/// Widget to draw bodies using Flutter
///
class DrawNBody extends StatefulWidget {
  final int nBodies;
  final Function(double fps) onFps;
  final BodiesShape shape;

  const DrawNBody({
    Key? key,
    required this.nBodies,
    required this.onFps,
    required this.shape,
  }) : super(key: key);

  @override
  State<DrawNBody> createState() => _DrawNBodyState();
}

class _DrawNBodyState extends State<DrawNBody> {
  NBody? body;
  late bool canBuild;

  @override
  initState() {
    super.initState();
    canBuild = false;
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!canBuild) {
        if (body == null) {
          body = NBody(widget.nBodies, MediaQuery.of(context).size);
          body?.init(widget.shape);
          stopwatch.start();
        }
        canBuild = true;
      } else {
        body?.updateParams();
        framesCount++;
        if (stopwatch.elapsedMilliseconds > 1000) {
          widget.onFps(framesCount.toDouble());
          framesCount = 0;
          stopwatch.reset();
        }
      }
      setState(() {});
    });

    if (!canBuild) return const SizedBox.shrink();


    /// left mouse button = create body with 80000 mass
    /// right mouse button = clear added bodies
    /// center mouse button = create black hole
    return GestureDetector(
      onTapDown: (details) {
        body!.bodiesList.add(
          Body(
            mass: 80000.0,
            pos: Vector2(details.localPosition.dx, details.localPosition.dy),
            spin: Vector2.zero(),
            force: 0.0,
          ),
        );
      },
      onSecondaryTapDown: (details) {
        while (body!.bodiesList.length > widget.nBodies) {
          body!.bodiesList.removeLast();
        }
      },
      onTertiaryTapDown: (details) {
        body!.bodiesList.add(
          Body(
            mass: 10000000.0,
            pos: Vector2(details.localPosition.dx, details.localPosition.dy),
            spin: Vector2.zero(),
            force: 0.0,
          ),
        );
      },
      child: CustomPaint(
        painter: BodyPainter(bodiesList: body!.bodiesList),
      ),
    );
  }
}

/// Widget to draw bodies using FFI
/// 
class DrawNBodyFfi extends StatefulWidget {
  final int nBodies;
  final Function(double fps) onFps;
  final BodiesShape shape;

  const DrawNBodyFfi({
    Key? key,
    required this.nBodies,
    required this.onFps,
    required this.shape,
  }) : super(key: key);

  @override
  State<DrawNBodyFfi> createState() => _DrawNBodyFfiState();
}

class _DrawNBodyFfiState extends State<DrawNBodyFfi> {
  late bool canBuild;
  late ffi.Pointer<BodyFfi> bodies;
  late ffi.Pointer<ffi.Int> nBodies;

  @override
  initState() {
    super.initState();
    bodies = calloc<BodyFfi>(ffi.sizeOf<BodyFfi>());
    nBodies = calloc<ffi.Int>(1);
    canBuild = false;
  }

  @override
  dispose() {
    // calloc.free(bodies);
    calloc.free(nBodies);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// at the 1st frame init bodies
      if (!canBuild) {
        double w = MediaQuery.of(context).size.width;
        double h = MediaQuery.of(context).size.height;
        NBodyController().nbodyFfi.init(
          widget.shape.index,
          widget.nBodies,
          minMass,
          maxMass,
          w * 0.25, h * 0.25,
          w * 0.75, h * 0.75,
          0, 0,
          0, 0,
        );
        NBodyController().nbodyFfi.setDeltaT(deltaT);
        stopwatch.start();
        canBuild = true;
      }
      else {
        bodies = NBodyController().nbodyFfi.updateBodies(nBodies);
        framesCount++;
        if (stopwatch.elapsedMilliseconds > 1000) {
          widget.onFps(framesCount.toDouble());
          framesCount = 0;
          stopwatch.reset();
        }
      }
      setState(() {});
    });

    if (!canBuild) return const SizedBox.shrink();

    /// left mouse button = create body with 80000 mass
    /// right mouse button = clear added bodies
    /// center mouse button = create black hole
    return GestureDetector(
      onTapDown: (details) {
        NBodyController().nbodyFfi.addBody(80000.0, details.localPosition.dx,
            details.localPosition.dy, 0, 0);
      },
      onSecondaryTapDown: (details) {
        NBodyController().nbodyFfi.removeBodiesWithMassRange(10001, 10000000);
      },
      onTertiaryTapDown: (details) {
        NBodyController().nbodyFfi.addBody(10000000.0, details.localPosition.dx,
            details.localPosition.dy, 0, 0);
      },
      child: CustomPaint(
        painter: BodyPainterFfi(bodiesList: bodies, nBodies: nBodies),
      ),
    );
  }
}
