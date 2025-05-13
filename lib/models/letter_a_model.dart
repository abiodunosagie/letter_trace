import 'package:flutter/material.dart';

import 'letter_model.dart';

class LetterAModel implements LetterModel {
  @override
  String get letter => 'A';

  @override
  List<String> get strokeInstructions => [
        'Draw a diagonal line from bottom-left to top-center',
        'Draw a diagonal line from bottom-right to top-center',
        'Draw a horizontal line across the middle',
      ];

  @override
  int get strokeCount => 3;

  @override
  List<Path> get strokePaths => [
        _createLeftDiagonalPath(),
        _createRightDiagonalPath(),
        _createCrossbarPath(),
      ];

  @override
  double get pathTolerance => 60.0; // Same as 'R' for child-friendly tracing

  @override
  double get pathScale => 1.0;

  Offset _offset = Offset.zero;
  double _scale = 1.0;

  @override
  void positionPaths(Size size, Canvas canvas) {
    // Same scaling logic as 'R' to fit different screens
    _scale = size.height / 380.0;
    double letterWidth = 180.0 * _scale;
    double letterHeight = 280.0 * _scale;
    double dx = (size.width - letterWidth) / 2;
    double dy = size.height * 0.12;
    _offset = Offset(dx, dy);
    canvas.translate(dx, dy);
    canvas.scale(_scale);
  }

  Path _createLeftDiagonalPath() {
    final Path path = Path();
    path.moveTo(20, 240); // Bottom-left
    path.lineTo(90, 40); // Top-center
    return path;
  }

  Path _createRightDiagonalPath() {
    final Path path = Path();
    path.moveTo(160, 240); // Bottom-right
    path.lineTo(90, 40); // Top-center
    return path;
  }

  Path _createCrossbarPath() {
    final Path path = Path();
    path.moveTo(50, 140); // Left midpoint of left diagonal
    path.lineTo(130, 140); // Right midpoint of right diagonal
    return path;
  }

  @override
  Offset globalToLocal(Offset point) {
    double x = (point.dx - _offset.dx) / _scale;
    double y = (point.dy - _offset.dy) / _scale;
    return Offset(x, y);
  }
}
