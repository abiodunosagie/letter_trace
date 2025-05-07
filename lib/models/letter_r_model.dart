import 'package:flutter/material.dart';

import 'letter_model.dart';

class LetterRModel implements LetterModel {
  @override
  String get letter => 'R';

  @override
  List<String> get strokeInstructions => [
        'Draw the straight line down from top to bottom',
        'Now draw the curved top and diagonal leg of R'
      ];

  @override
  int get strokeCount => 2;

  // Store paths in standard form without any transformations
  @override
  List<Path> get strokePaths => [
        _createVerticalStrokePath(),
        _createCurveAndDiagonalPath(),
      ];

  @override
  double get pathTolerance =>
      60.0; // Much higher tolerance for child-friendly tracing

  @override
  double get pathScale => 1.0;

  // The offset used to center the letter in the drawing area
  Offset _offset = Offset.zero;

  // The scaling factor for different screen sizes
  double _scale = 1.0;

  @override
  void positionPaths(Size size, Canvas canvas) {
    // Calculate scaling based on canvas height
    _scale = size.height / 380.0; // Larger base height for better visibility

    // Calculate the position to center the letter
    double letterWidth = 180.0 * _scale; // Wider letter for easier tracing
    double letterHeight = 280.0 * _scale; // Approximate height of letter R

    // Center horizontally and position closer to top for better visibility
    double dx = (size.width - letterWidth) / 2;
    double dy = size.height * 0.12; // Moved up slightly

    // Save the offset for coordinate conversion
    _offset = Offset(dx, dy);

    // Apply transformation to the canvas
    canvas.translate(dx, dy);
    canvas.scale(_scale);
  }

  // Create the path for the first stroke (vertical line)
  Path _createVerticalStrokePath() {
    final Path path = Path();

    // Starting from top to bottom
    path.moveTo(50, 40); // Start at top
    path.lineTo(50, 240); // Draw down to bottom

    return path;
  }

  // Create the path for the second stroke (curved top and diagonal leg)
  Path _createCurveAndDiagonalPath() {
    final Path path = Path();

    // Start at the top of the vertical line
    path.moveTo(50, 40);

    // Draw the curved head of the R with smoother curves
    path.cubicTo(
        90,
        40, // control point 1
        140,
        40, // control point 2
        140,
        80 // end point
        );

    path.cubicTo(
        140,
        120, // control point 1
        100,
        140, // control point 2
        50,
        140 // end point
        );

    // Move to where the diagonal leg starts and create a separate path segment
    // This is crucial to ensure we can check if both parts of the stroke are complete
    path.moveTo(50, 140);
    path.lineTo(80, 140);
    path.lineTo(140, 240);

    return path;
  }

  // Convert screen point to path coordinate system
  @override
  Offset globalToLocal(Offset point) {
    // First, translate by the offset
    double x = (point.dx - _offset.dx) / _scale;
    double y = (point.dy - _offset.dy) / _scale;

    return Offset(x, y);
  }
}
