import 'package:flutter/material.dart';

abstract class LetterModel {
  // The letter being traced
  String get letter;

  // The instruction messages for each stroke
  List<String> get strokeInstructions;

  // The number of strokes required to complete the letter
  int get strokeCount;

  // The paths for each stroke
  List<Path> get strokePaths;

  // The tolerance for considering a point close to the path
  double get pathTolerance;

  // The scale factor for paths (to adjust to different screen sizes)
  double get pathScale;

  // Position paths properly on the screen
  void positionPaths(Size size, Canvas canvas);

  // Convert screen/global coordinates to local path coordinates
  Offset globalToLocal(Offset point);
}
