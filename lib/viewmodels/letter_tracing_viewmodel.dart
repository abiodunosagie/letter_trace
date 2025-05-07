import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/letter_model.dart';
import '../models/stroke_result_model.dart';

class LetterTracingViewModel extends ChangeNotifier {
  final LetterModel letter;
  Size? _lastSize;

  // Current state
  int _currentStrokeIndex = 0;
  final List<List<Offset>> _strokes = [];
  final List<StrokeResult?> _strokeResults = [];
  bool _isDrawing = false;
  bool _isCompleted = false;
  bool _isSuccess = false;

  // Constructor
  LetterTracingViewModel({required this.letter}) {
    // Initialize the strokes and results arrays
    for (int i = 0; i < letter.strokeCount; i++) {
      _strokes.add([]);
      _strokeResults.add(null);
    }
  }

  // Getters
  int get currentStrokeIndex => _currentStrokeIndex;

  List<List<Offset>> get strokes => _strokes;

  List<StrokeResult?> get strokeResults => _strokeResults;

  bool get isDrawing => _isDrawing;

  bool get isCompleted => _isCompleted;

  bool get isSuccess => _isSuccess;

  String get currentInstruction => _isCompleted
      ? _isSuccess
          ? "Hooray! You did it!"
          : "Let's try again!"
      : letter.strokeInstructions[_currentStrokeIndex];

  // Set canvas size when available
  void setCanvasSize(Size size) {
    _lastSize = size;
  }

  // Methods
  void startStroke(Offset position) {
    if (_isCompleted || _currentStrokeIndex >= letter.strokeCount) return;

    _isDrawing = true;

    // Convert screen position to local path coordinates
    final localPoint = letter.globalToLocal(position);

    _strokes[_currentStrokeIndex] = [localPoint];
    notifyListeners();
  }

  void updateStroke(Offset position) {
    if (!_isDrawing ||
        _isCompleted ||
        _currentStrokeIndex >= letter.strokeCount) return;

    // Convert screen position to local path coordinates
    final localPoint = letter.globalToLocal(position);

    // Add point only if it's sufficiently different from the last point
    // to avoid too many points which can cause performance issues
    if (_strokes[_currentStrokeIndex].isEmpty ||
        (_strokes[_currentStrokeIndex].last - localPoint).distance > 2.0) {
      _strokes[_currentStrokeIndex].add(localPoint);
      notifyListeners();
    }
  }

  void endStroke() {
    if (!_isDrawing) return;

    _isDrawing = false;

    // Validate the stroke only if enough points were drawn
    if (_strokes[_currentStrokeIndex].length >= 5) {
      StrokeResult result = _validateStroke();
      _strokeResults[_currentStrokeIndex] = result;

      if (result.isValid) {
        // Move to next stroke
        _currentStrokeIndex++;

        // Check if all strokes are completed
        if (_currentStrokeIndex >= letter.strokeCount) {
          _isCompleted = true;
          _isSuccess =
              _strokeResults.every((result) => result?.isValid ?? false);
        }
      }
    } else {
      // Not enough points to validate, consider invalid
      _strokeResults[_currentStrokeIndex] = StrokeResult.invalid(0.0);
    }

    notifyListeners();
  }

  void resetTracing() {
    _currentStrokeIndex = 0;
    for (int i = 0; i < letter.strokeCount; i++) {
      _strokes[i] = [];
      _strokeResults[i] = null;
    }
    _isDrawing = false;
    _isCompleted = false;
    _isSuccess = false;
    notifyListeners();
  }

  // Private methods
  StrokeResult _validateStroke() {
    // Get the current path
    final Path expectedPath = letter.strokePaths[_currentStrokeIndex];

    // Get points along the path for coverage validation
    List<Offset> pathPoints = _getPathPoints(expectedPath);

    // Count points that are on or near the path
    int pointsOnPath = 0;
    int totalPoints = _strokes[_currentStrokeIndex].length;

    // Check how many user points are near the path
    for (final point in _strokes[_currentStrokeIndex]) {
      if (_isPointNearPath(point, expectedPath)) {
        pointsOnPath++;
      }
    }

    // Calculate accuracy of user's stroke
    final double accuracy = pointsOnPath / totalPoints;

    // Check if the user covered enough of the expected path
    int pathCoverage = 0;
    for (final pathPoint in pathPoints) {
      if (_isAnyUserPointNear(pathPoint, _strokes[_currentStrokeIndex])) {
        pathCoverage++;
      }
    }

    // Calculate how much of the path was covered (crucial for completeness)
    final double coverageRatio = pathCoverage / pathPoints.length;

    // For stroke 1 (vertical line), 70% coverage is required
    // For stroke 2 (curve and diagonal), 80% coverage is required for both parts
    double requiredCoverage = _currentStrokeIndex == 0 ? 0.7 : 0.8;

    // Need both reasonable accuracy and good coverage to be valid
    if (accuracy > 0.45 && coverageRatio > requiredCoverage) {
      return StrokeResult.valid(accuracy);
    } else {
      return StrokeResult.invalid(accuracy);
    }
  }

  // Get points along the path to check for coverage
  List<Offset> _getPathPoints(Path path) {
    List<Offset> points = [];
    final ui.PathMetrics metrics = path.computeMetrics();

    for (final metric in metrics) {
      // Sample points along the path
      for (double t = 0.0; t <= metric.length; t += 5.0) {
        final tangent = metric.getTangentForOffset(t);
        if (tangent != null) {
          points.add(tangent.position);
        }
      }
    }

    return points;
  }

  // Check if any user point is near this path point
  bool _isAnyUserPointNear(Offset pathPoint, List<Offset> userPoints) {
    double threshold = letter.pathTolerance;

    for (final userPoint in userPoints) {
      if ((userPoint - pathPoint).distance < threshold) {
        return true;
      }
    }

    return false;
  }

  bool _isPointNearPath(Offset point, Path path) {
    // Create a virtual path metric to measure distances
    final ui.PathMetrics metrics = path.computeMetrics();

    // Use the tolerance from the letter model
    final double threshold = letter.pathTolerance;

    // Check all segments of the path
    for (final metric in metrics) {
      // Sample points very densely for better path detection
      // Especially important for young children with less precise motor control
      for (double t = 0.0; t <= metric.length; t += 0.5) {
        // Sample twice as frequently for better coverage
        final tangent = metric.getTangentForOffset(t);
        if (tangent != null) {
          final pathPoint = tangent.position;
          final distance = (point - pathPoint).distance;
          if (distance < threshold) {
            return true;
          }
        }
      }
    }

    return false;
  }
}
