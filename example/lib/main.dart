import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:n_body/body.dart';
import 'package:n_body/draw_n_body.dart';
import 'package:n_body/n_body_controller.dart';

/// using Dart:ffi if true or Dart
final useFfiProvider = StateProvider<bool>((ref) => false);

/// using Float64List 
final useFloat64Provider = StateProvider<bool>((ref) => true);

/// using Records
final useRecordsProvider = StateProvider<bool>((ref) => false);

/// number of bodies
final bodiesCountProvider = StateProvider<int>((ref) => 500);

/// min random mass
final minMassProvider = StateProvider<double>((ref) => minMass);

/// max random mass
final maxMassProvider = StateProvider<double>((ref) => maxMass);

/// delta time
final deltaTimeProvider = StateProvider<double>((ref) => 0.001);

/// FPS
final fpsProvider = StateProvider<double>((ref) => 0.0);

/// BodiesShape
final bodiesShapeProvider =
    StateProvider<BodiesShape>((ref) => BodiesShape.circle);

void main() {
  NBodyController().initializeNBody();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key});

  Timer? timer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int nBodies = ref.watch(bodiesCountProvider);
    bool isFfi = ref.watch(useFfiProvider);
    bool isFloat64 = ref.watch(useFloat64Provider);
    bool isRecords = ref.watch(useRecordsProvider);
    ref.watch(minMassProvider);
    ref.watch(maxMassProvider);
    BodiesShape shape = ref.watch(bodiesShapeProvider);

    /// use ffi, Float64List or Records drawing widget
    Widget drawNBodyWidget;
    if (isFfi) {
      drawNBodyWidget = DrawNBodyFfi(
        key: UniqueKey(),
        nBodies: nBodies,
        shape: shape,
        onFps: (fps) {
          Future(() {
            ref.read(fpsProvider.notifier).update((state) => (state + fps) / 2);
          });
        },
      );
    } else {
      if (isRecords) {
        drawNBodyWidget = DrawNBodyRecords(
          key: UniqueKey(),
          nBodies: nBodies,
          shape: shape,
          onFps: (fps) {
            Future(() {
              ref
                  .read(fpsProvider.notifier)
                  .update((state) => (state + fps) / 2);
            });
          },
        );
      } else {
        drawNBodyWidget = DrawNBody(
          key: UniqueKey(),
          nBodies: nBodies,
          shape: shape,
          onFps: (fps) {
            Future(() {
              ref
                  .read(fpsProvider.notifier)
                  .update((state) => (state + fps) / 2);
            });
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('N-Body simulation'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: drawNBodyWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// use FFI
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isFloat64,
                        onChanged: (value) {
                          ref
                              .read(useRecordsProvider.notifier)
                              .update((state) => false);
                          ref
                              .read(useFfiProvider.notifier)
                              .update((state) => false);
                          ref
                              .read(useFloat64Provider.notifier)
                              .update((state) => true);
                        },
                      ),
                      const Text('use FloatList '),
                      Checkbox(
                        value: isRecords,
                        onChanged: (value) {
                          ref
                              .read(useRecordsProvider.notifier)
                              .update((state) => true);
                          ref
                              .read(useFfiProvider.notifier)
                              .update((state) => false);
                          ref
                              .read(useFloat64Provider.notifier)
                              .update((state) => false);
                        },
                      ),
                      const Text('use Records '),
                      Checkbox(
                        value: isFfi,
                        onChanged: (value) {
                          ref
                              .read(useRecordsProvider.notifier)
                              .update((state) => false);
                          ref
                              .read(useFfiProvider.notifier)
                              .update((state) => true);
                          ref
                              .read(useFloat64Provider.notifier)
                              .update((state) => false);
                        },
                      ),
                      const Text('use FFI     '),
                      Consumer(
                        builder: (_, ref, __) {
                          double fps = ref.watch(fpsProvider);
                          return Text('${fps.toStringAsFixed(2)} FPS');
                        },
                      ),
                    ],
                  ),

                  /// sliders
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      /// bodies count and delta time
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            /// bodies count
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('bodies count: $nBodies'),
                                Expanded(
                                  child: Slider(
                                      value: ref
                                          .read(bodiesCountProvider)
                                          .toDouble(),
                                      min: 2,
                                      max: 3500,
                                      divisions: 70,
                                      onChanged: (value) {
                                        timer?.cancel();
                                        timer = Timer(
                                            const Duration(microseconds: 300),
                                            () {
                                          ref
                                              .read(
                                                  bodiesCountProvider.notifier)
                                              .update((state) => value.toInt());
                                        });
                                      }),
                                ),
                              ],
                            ),

                            /// delta time
                            Consumer(builder: (context, ref, _) {
                              double deltaTime = ref.watch(deltaTimeProvider);
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                      'delta time: ${deltaT.toStringAsFixed(5)}'),
                                  Expanded(
                                    child: Slider(
                                        value: deltaTime,
                                        min: 0.0001,
                                        max: 0.01,
                                        onChanged: (value) {
                                          ref
                                              .read(deltaTimeProvider.notifier)
                                              .update((state) => value);
                                          deltaT = value;
                                          if (isFfi) {
                                            NBodyController()
                                                .nbodyFfi
                                                .setDeltaT(deltaT);
                                          }
                                        }),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),

                      /// min and max random mass
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            /// min random mass
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('min mass: ${minMass.toInt()}'),
                                Expanded(
                                  child: Slider(
                                      value: minMass,
                                      min: 100,
                                      max: 20000,
                                      onChanged: (value) {
                                        timer?.cancel();
                                        timer = Timer(
                                            const Duration(microseconds: 300),
                                            () {
                                          ref
                                              .read(minMassProvider.notifier)
                                              .update((state) => value);
                                          minMass = value;
                                        });
                                      }),
                                ),
                              ],
                            ),

                            /// max random mass
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('max mass: ${maxMass.toInt()}'),
                                Expanded(
                                  child: Slider(
                                      value: maxMass,
                                      min: 100,
                                      max: 20000,
                                      onChanged: (value) {
                                        timer?.cancel();
                                        timer = Timer(
                                            const Duration(microseconds: 300),
                                            () {
                                          ref
                                              .read(maxMassProvider.notifier)
                                              .update((state) => value);
                                          maxMass = value;
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// shape
                  Row(
                    children: [
                      Consumer(
                        builder: (_, ref, __) {
                          BodiesShape shape = ref.watch(bodiesShapeProvider);
                          return Checkbox(
                            value: shape == BodiesShape.rectangle,
                            onChanged: (value) {
                              if (value!) {
                                ref
                                    .read(bodiesShapeProvider.notifier)
                                    .update((state) => BodiesShape.rectangle);
                              }
                            },
                          );
                        },
                      ),
                      const Text('rectangle     '),
                      Consumer(
                        builder: (_, ref, __) {
                          BodiesShape shape = ref.watch(bodiesShapeProvider);
                          return Checkbox(
                            value: shape == BodiesShape.circle,
                            onChanged: (value) {
                              if (value!) {
                                ref
                                    .read(bodiesShapeProvider.notifier)
                                    .update((state) => BodiesShape.circle);
                              }
                            },
                          );
                        },
                      ),
                      const Text('circle     '),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
