import 'package:flutter/material.dart';

import '../../models/letter_model.dart';
import '../../models/stroke_result_model.dart';

class LetterPainter extends CustomPainter {
  final LetterModel letterModel;
  final List<List<Offset>> strokes;
  final List<StrokeResult?> strokeResults;
  final int currentStrokeIndex;
  final Size canvasSize;

  LetterPainter({
    required this.letterModel,
    required this.strokes,
    required this.strokeResults,
    required this.currentStrokeIndex,
    required this.canvasSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Save the canvas state before transformations
    canvas.save();

    // Position the paths appropriately for this screen size
    letterModel.positionPaths(size, canvas);

    // Paint for letter outline (future strokes) - child-friendly guide
    final Paint outlinePaint = Paint()
      ..color = Colors.grey.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0 // Much thicker stroke for clearer guide
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Paint for the active path - child-friendly visibility
    final Paint activePaint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0 // Thicker stroke to match child's drawing
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Paint for completed valid path - maintain thick stroke
    final Paint validPaint = Paint()
      ..color = Colors.green.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0 // Keep thick stroke for completed strokes
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Paint for completed invalid path - maintain thick stroke
    final Paint invalidPaint = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0 // Keep thick stroke for completed strokes
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Paint for user strokes - perfectly matching active path
    final Paint strokePaint = Paint()
      ..color = Colors.blue
          .withOpacity(0.9) // Slightly more opaque for better visibility
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 20.0; // Exactly match the active path width

    // Draw all letter paths
    final List<Path> paths = letterModel.strokePaths;
    for (int i = 0; i < paths.length; i++) {
      if (i < currentStrokeIndex) {
        // Past strokes
        final bool isValid = strokeResults[i]?.isValid ?? false;
        canvas.drawPath(paths[i], isValid ? validPaint : invalidPaint);
      } else if (i == currentStrokeIndex) {
        // Current stroke
        canvas.drawPath(paths[i], activePaint);
      } else {
        // Future strokes
        canvas.drawPath(paths[i], outlinePaint);
      }
    }

    // Draw user strokes - must be in the same coordinate system as the paths
    for (int i = 0; i < strokes.length; i++) {
      if (strokes[i].isNotEmpty) {
        final Path userPath = Path();
        userPath.moveTo(strokes[i][0].dx, strokes[i][0].dy);

        for (int j = 1; j < strokes[i].length; j++) {
          userPath.lineTo(strokes[i][j].dx, strokes[i][j].dy);
        }

        canvas.drawPath(userPath, strokePaint);
      }
    }

    // Restore the canvas to its original state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
