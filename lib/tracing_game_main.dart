import 'package:flutter/material.dart';
import 'package:tracing_game/tracing_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tracing Game'),
        ),
        body: Column(
          // spacing: 3,
          children: [
            Expanded(
              child: TracingCharsGame(
                showAnchor: true,
                traceShapeModel: [
                  TraceCharsModel(chars: [
                    TraceCharModel(
                        char: 'X',
                        traceShapeOptions: const TraceShapeOptions(
                            innerPaintColor: Colors.orange)),
                    TraceCharModel(
                        char: 'r',
                        traceShapeOptions: const TraceShapeOptions(
                            innerPaintColor: Colors.orange)),
                    TraceCharModel(
                        char: '2',
                        traceShapeOptions: const TraceShapeOptions(
                            innerPaintColor: Colors.orange)),
                    // TraceCharModel(
                    //     // German characters
                    //     char: 'Ä',
                    //     traceShapeOptions: const TraceShapeOptions(
                    //         innerPaintColor: Colors.blue)),
                    // TraceCharModel(
                    //     char: 'ö',
                    //     traceShapeOptions: const TraceShapeOptions(
                    //         innerPaintColor: Colors.blue)),
                    // TraceCharModel(
                    //     char: 'ß',
                    //     traceShapeOptions: const TraceShapeOptions(
                    //         innerPaintColor: Colors.blue)),
                    // TraceCharModel(
                    //     // Czech characters
                    //     char:
                    //         'Č', // Will use DynamicLetterModel if not predefined
                    //     traceShapeOptions: const TraceShapeOptions(
                    //         innerPaintColor: Colors.purple)),
                    // TraceCharModel(
                    //     char:
                    //         'ř', // Will use DynamicLetterModel if not predefined
                    //     traceShapeOptions: const TraceShapeOptions(
                    //         innerPaintColor: Colors.purple)),
                    // TraceCharModel(
                    //     char:
                    //         'ě', // Will use DynamicLetterModel if not predefined
                    //     traceShapeOptions: const TraceShapeOptions(
                    //         innerPaintColor: Colors.purple)),
                  ])
                ],
                onTracingUpdated: (int currentTracingIndex) async {
                  print('/////onTracingUpdated:$currentTracingIndex');
                },
                onGameFinished: (int screenIndex) async {
                  print('/////onGameFinished:$screenIndex');
                },
                onCurrentTracingScreenFinished: (int currentScreenIndex) async {
                  print(
                      '/////onCurrentTracingScreenFinished:$currentScreenIndex');
                },
              ),
            ),
            Expanded(
              child: TracingGeometricShapesGame(
                traceGeoMetricShapeModels: [
                  TraceGeoMetricShapeModel(shapes: [
                    MathShapeWithOption(
                        shape: MathShapes.circle,
                        traceShapeOptions: const TraceShapeOptions(
                            innerPaintColor: Colors.orange)),
                    MathShapeWithOption(
                        shape: MathShapes.triangle1,
                        traceShapeOptions: const TraceShapeOptions(
                            innerPaintColor: Colors.orange))
                  ]),
                  TraceGeoMetricShapeModel(shapes: [
                    MathShapeWithOption(
                        shape: MathShapes.triangle3,
                        traceShapeOptions: const TraceShapeOptions(
                            innerPaintColor: Colors.orange)),
                    MathShapeWithOption(
                        shape: MathShapes.triangle2,
                        traceShapeOptions: const TraceShapeOptions(
                            innerPaintColor: Colors.orange))
                  ]),
                ],
              ),
            ),
            // Expanded(
            //   child: TracingWordGame(
            //     words: [
            //       TraceWordModel(
            //           word: 'I Love',
            //           traceShapeOptions:
            //               const TraceShapeOptions(indexColor: Colors.green)),
            //       TraceWordModel(
            //           word: 'Trace',
            //           traceShapeOptions:
            //               const TraceShapeOptions(indexColor: Colors.green))
            //     ],
            //     onTracingUpdated: (int currentTracingIndex) async {
            //       print('/////onTracingUpdated:$currentTracingIndex');
            //     },
            //     onGameFinished: (int screenIndex) async {
            //       print('/////onGameFinished:$screenIndex');
            //     },
            //     onCurrentTracingScreenFinished: (int currentScreenIndex) async {
            //       print(
            //           '/////onCurrentTracingScreenFinished:$currentScreenIndex');
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
