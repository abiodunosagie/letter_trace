import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:letter_trace/models/letter_model.dart';

class DynamicLetterModel implements LetterModel {
  final String _letter;
  late final List<Path> _strokePaths;
  late final double _pathTolerance;

  Offset _offset = Offset.zero;
  double _scale = 1.0;

  DynamicLetterModel(String letter) : _letter = letter.toUpperCase() {
    _strokePaths = _createGenericLetter();
    _pathTolerance = 60.0;
  }

  @override
  String get letter => _letter;

  @override
  List<Path> get strokePaths => _strokePaths;

  @override
  List<String> get strokeInstructions =>
      ['Trace the letter $_letter']; // Fixed: Provide default instruction

  @override
  int get strokeCount => _strokePaths.length;

  @override
  double get pathTolerance => _pathTolerance;

  @override
  double get pathScale => 1.0;

  // Universal path generation - works for ANY letter!
  List<Path> _createGenericLetter() {
    Path letterPath = _convertAnyTextToPath(_letter);
    Path simplifiedPath = _simplifyForTracing(letterPath);
    return [simplifiedPath];
  }

  Path _convertAnyTextToPath(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 120, // Reduced size
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    return _extractOutlineFromRenderedText(textPainter);
  }

  Path _extractOutlineFromRenderedText(TextPainter textPainter) {
    final size = textPainter.size;

    // Use controlled, smaller coordinates
    double left = 10;
    double top = 20;
    double right = left + (size.width * 0.8);
    double bottom = top + (size.height * 0.8);

    List<Offset> outlinePoints =
        _generateSmartOutline(left, top, right, bottom, _letter);

    Path path = Path();
    if (outlinePoints.isNotEmpty) {
      path.moveTo(outlinePoints.first.dx, outlinePoints.first.dy);
      for (int i = 1; i < outlinePoints.length; i++) {
        path.lineTo(outlinePoints[i].dx, outlinePoints[i].dy);
      }
    }

    return path;
  }

  List<Offset> _generateSmartOutline(
      double left, double top, double right, double bottom, String letter) {
    List<Offset> points = [];
    double width = right - left;
    double height = bottom - top;
    double centerX = left + width / 2;
    double centerY = top + height / 2;

    // Generate reasonable outline points for any letter

    // Top curve
    points.add(Offset(left + width * 0.1, top + height * 0.2));
    points.add(Offset(centerX, top + height * 0.1));
    points.add(Offset(right - width * 0.1, top + height * 0.2));

    // Right side
    points.add(Offset(right - width * 0.05, centerY));

    // Bottom curve
    points.add(Offset(right - width * 0.1, bottom - height * 0.2));
    points.add(Offset(centerX, bottom - height * 0.1));
    points.add(Offset(left + width * 0.1, bottom - height * 0.2));

    // Left side
    points.add(Offset(left + width * 0.05, centerY));

    // Add connecting stroke back to start
    points.add(Offset(left + width * 0.1, top + height * 0.2));

    return points;
  }

  Path _simplifyForTracing(Path path) {
    List<Offset> points = _pathToPoints(path);

    // Remove points too close together
    List<Offset> cleanPoints = [];
    double minDistance = 8.0; // Smaller minimum distance

    if (points.isNotEmpty) {
      cleanPoints.add(points.first);

      for (int i = 1; i < points.length; i++) {
        double distance = _calculateDistance(points[i], cleanPoints.last);
        if (distance >= minDistance) {
          cleanPoints.add(points[i]);
        }
      }
    }

    // Convert back to path
    Path simplifiedPath = Path();
    if (cleanPoints.isNotEmpty) {
      simplifiedPath.moveTo(cleanPoints.first.dx, cleanPoints.first.dy);
      for (int i = 1; i < cleanPoints.length; i++) {
        simplifiedPath.lineTo(cleanPoints[i].dx, cleanPoints[i].dy);
      }
    }

    return simplifiedPath;
  }

  List<Offset> _pathToPoints(Path path) {
    List<Offset> points = [];
    PathMetrics pathMetrics = path.computeMetrics();

    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        Tangent? tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          points.add(tangent.position);
        }
        distance += 2.0; // Denser points for smoother path
      }
    }

    return points;
  }

  double _calculateDistance(Offset p1, Offset p2) {
    return sqrt(((p1.dx - p2.dx) * (p1.dx - p2.dx) +
        (p1.dy - p2.dy) * (p1.dy - p2.dy)));
  }

  @override
  void positionPaths(Size size, Canvas canvas) {
    // More conservative scaling to prevent overflow
    _scale = (size.height / 280.0).clamp(0.5, 3.0);
    double letterWidth = 120.0 * _scale;
    double letterHeight = 180.0 * _scale;
    double dx = (size.width - letterWidth) / 2;
    double dy = (size.height - letterHeight) / 2;
    _offset = Offset(dx, dy);
    canvas.translate(dx, dy);
    canvas.scale(_scale);
  }

  @override
  Offset globalToLocal(Offset point) {
    double x = (point.dx - _offset.dx) / _scale;
    double y = (point.dy - _offset.dy) / _scale;
    return Offset(x, y);
  }
}
