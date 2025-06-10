import 'dart:math';
import 'package:flutter/material.dart';

// Different stroke types for proper curve handling
enum StrokeType { line, quadraticCurve, cubicCurve, arc }

// Letter stroke with proper curve support
class LetterStroke {
  final List<Offset> points;
  final StrokeType type;
  final List<Offset>? controlPoints;

  const LetterStroke({
    required this.points,
    this.type = StrokeType.line,
    this.controlPoints,
  });

  // Helper constructors
  static LetterStroke line(List<Offset> points) {
    return LetterStroke(points: points, type: StrokeType.line);
  }

  static LetterStroke quadraticCurve(Offset start, Offset control, Offset end) {
    return LetterStroke(
      points: [start, end],
      type: StrokeType.quadraticCurve,
      controlPoints: [control],
    );
  }

  static LetterStroke cubicCurve(
      Offset start, Offset control1, Offset control2, Offset end) {
    return LetterStroke(
      points: [start, end],
      type: StrokeType.cubicCurve,
      controlPoints: [control1, control2],
    );
  }

  static LetterStroke arc(
      Offset center, double radius, double startAngle, double endAngle) {
    List<Offset> arcPoints = [];
    int segments = 30; // Increased for smoother curves

    for (int i = 0; i <= segments; i++) {
      double angle = startAngle + (endAngle - startAngle) * i / segments;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      arcPoints.add(Offset(x, y));
    }

    return LetterStroke(points: arcPoints, type: StrokeType.arc);
  }

  // Convert to Flutter Path with proper curves
  Path toPath() {
    Path path = Path();
    if (points.isEmpty) return path;

    path.moveTo(points.first.dx, points.first.dy);

    switch (type) {
      case StrokeType.line:
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        break;

      case StrokeType.quadraticCurve:
        if (controlPoints != null && controlPoints!.isNotEmpty) {
          path.quadraticBezierTo(
            controlPoints![0].dx,
            controlPoints![0].dy,
            points.last.dx,
            points.last.dy,
          );
        }
        break;

      case StrokeType.cubicCurve:
        if (controlPoints != null && controlPoints!.length >= 2) {
          path.cubicTo(
            controlPoints![0].dx,
            controlPoints![0].dy,
            controlPoints![1].dx,
            controlPoints![1].dy,
            points.last.dx,
            points.last.dy,
          );
        }
        break;

      case StrokeType.arc:
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        break;
    }

    return path;
  }
}

// Letter definition
class LetterDefinition {
  final List<LetterStroke> strokes;
  final Map<String, List<String>> instructions; // Language -> instructions
  final double tolerance;

  const LetterDefinition({
    required this.strokes,
    required this.instructions,
    this.tolerance = 60.0,
  });
}

// COMPLETE LATIN ALPHABET (English + German) - IMPROVED
class LatinLetterPaths {
  static final Map<String, LetterDefinition> _paths = {
    // === UPPERCASE LATIN LETTERS ===
    'A': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 240), Offset(100, 40)]),
        LetterStroke.line([Offset(150, 240), Offset(100, 40)]),
        LetterStroke.line([Offset(75, 140), Offset(125, 140)]),
      ],
      instructions: {
        'en': ['Draw left diagonal', 'Draw right diagonal', 'Draw crossbar'],
        'de': [
          'Zeichne linke Diagonale',
          'Zeichne rechte Diagonale',
          'Zeichne Querstrich'
        ],
      },
    ),

    'B': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke(
          points: [Offset(50, 40), Offset(100, 140)],
          type: StrokeType.cubicCurve,
          controlPoints: [
            Offset(50, 40),
            Offset(100, 40),
            Offset(130, 40),
            Offset(150, 60),
            Offset(150, 90),
            Offset(150, 120),
            Offset(130, 140),
            Offset(100, 140)
          ],
        ),
        LetterStroke(
          points: [Offset(50, 140), Offset(110, 240)],
          type: StrokeType.cubicCurve,
          controlPoints: [
            Offset(50, 140),
            Offset(110, 140),
            Offset(140, 140),
            Offset(160, 165),
            Offset(160, 190),
            Offset(160, 215),
            Offset(140, 240),
            Offset(110, 240)
          ],
        ),
      ],
      instructions: {
        'en': ['Draw vertical line', 'Draw top bump', 'Draw bottom bump'],
        'de': [
          'Zeichne senkrechte Linie',
          'Zeichne oberen Bogen',
          'Zeichne unteren Bogen'
        ],
      },
    ),

    'C': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(140, 70), Offset(110, 40), Offset(60, 40), Offset(40, 90)),
        LetterStroke.cubicCurve(
            Offset(40, 90), Offset(30, 120), Offset(30, 160), Offset(40, 190)),
        LetterStroke.cubicCurve(Offset(40, 190), Offset(60, 240),
            Offset(110, 240), Offset(140, 210)),
      ],
      instructions: {
        'en': ['Draw the C curve from top to bottom'],
        'de': ['Zeichne den C-Bogen von oben nach unten'],
      },
    ),

    'D': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke(
          points: [Offset(50, 40), Offset(50, 240)],
          type: StrokeType.cubicCurve,
          controlPoints: [
            Offset(50, 40),
            Offset(100, 40),
            Offset(140, 40),
            Offset(160, 80),
            Offset(160, 140),
            Offset(160, 200),
            Offset(140, 240),
            Offset(100, 240)
          ],
        ),
      ],
      instructions: {
        'en': ['Draw vertical line', 'Draw curved side'],
        'de': ['Zeichne senkrechte Linie', 'Zeichne gebogene Seite'],
      },
    ),

    'E': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke.line([Offset(50, 40), Offset(130, 40)]),
        LetterStroke.line([Offset(50, 140), Offset(110, 140)]),
        LetterStroke.line([Offset(50, 240), Offset(130, 240)]),
      ],
      instructions: {
        'en': ['Vertical line', 'Top line', 'Middle line', 'Bottom line'],
        'de': [
          'Senkrechte Linie',
          'Obere Linie',
          'Mittlere Linie',
          'Untere Linie'
        ],
      },
    ),

    'F': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke.line([Offset(50, 40), Offset(130, 40)]),
        LetterStroke.line([Offset(50, 140), Offset(110, 140)]),
      ],
      instructions: {
        'en': ['Vertical line', 'Top line', 'Middle line'],
        'de': ['Senkrechte Linie', 'Obere Linie', 'Mittlere Linie'],
      },
    ),

    'G': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(140, 70), Offset(110, 40), Offset(60, 40), Offset(40, 90)),
        LetterStroke.cubicCurve(
            Offset(40, 90), Offset(30, 120), Offset(30, 160), Offset(40, 190)),
        LetterStroke.cubicCurve(Offset(40, 190), Offset(60, 240),
            Offset(110, 240), Offset(140, 210)),
        LetterStroke.line([Offset(140, 210), Offset(140, 140)]),
        LetterStroke.line([Offset(140, 140), Offset(90, 140)]),
      ],
      instructions: {
        'en': ['Draw C curve', 'Draw horizontal line'],
        'de': ['Zeichne C-Bogen', 'Zeichne waagerechte Linie'],
      },
    ),

    'H': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke.line([Offset(130, 40), Offset(130, 240)]),
        LetterStroke.line([Offset(50, 140), Offset(130, 140)]),
      ],
      instructions: {
        'en': ['Left line', 'Right line', 'Cross bar'],
        'de': ['Linke Linie', 'Rechte Linie', 'Querstrich'],
      },
    ),

    'I': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(60, 40), Offset(120, 40)]),
        LetterStroke.line([Offset(90, 40), Offset(90, 240)]),
        LetterStroke.line([Offset(60, 240), Offset(120, 240)]),
      ],
      instructions: {
        'en': ['Top line', 'Vertical line', 'Bottom line'],
        'de': ['Obere Linie', 'Senkrechte Linie', 'Untere Linie'],
      },
    ),

    'J': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 40), Offset(130, 40)]),
        LetterStroke.line([Offset(100, 40), Offset(100, 180)]),
        LetterStroke.cubicCurve(Offset(100, 180), Offset(100, 210),
            Offset(80, 240), Offset(50, 240)),
        LetterStroke.cubicCurve(
            Offset(50, 240), Offset(30, 240), Offset(20, 220), Offset(20, 200)),
      ],
      instructions: {
        'en': ['Top line', 'Draw down and curve at bottom'],
        'de': ['Obere Linie', 'Nach unten zeichnen und am Ende biegen'],
      },
    ),

    'K': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke.line([Offset(130, 40), Offset(50, 140)]),
        LetterStroke.line([Offset(50, 140), Offset(130, 240)]),
      ],
      instructions: {
        'en': ['Vertical line', 'Top diagonal', 'Bottom diagonal'],
        'de': ['Senkrechte Linie', 'Obere Diagonale', 'Untere Diagonale'],
      },
    ),

    'L': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke.line([Offset(50, 240), Offset(130, 240)]),
      ],
      instructions: {
        'en': ['Vertical line', 'Bottom line'],
        'de': ['Senkrechte Linie', 'Untere Linie'],
      },
    ),

    'M': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 240), Offset(40, 40)]),
        LetterStroke.line([Offset(40, 40), Offset(90, 140)]),
        LetterStroke.line([Offset(90, 140), Offset(140, 40)]),
        LetterStroke.line([Offset(140, 40), Offset(140, 240)]),
      ],
      instructions: {
        'en': ['Left line', 'Left diagonal', 'Right diagonal', 'Right line'],
        'de': [
          'Linke Linie',
          'Linke Diagonale',
          'Rechte Diagonale',
          'Rechte Linie'
        ],
      },
    ),

    'N': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 240), Offset(50, 40)]),
        LetterStroke.line([Offset(50, 40), Offset(130, 240)]),
        LetterStroke.line([Offset(130, 240), Offset(130, 40)]),
      ],
      instructions: {
        'en': ['Left line', 'Diagonal', 'Right line'],
        'de': ['Linke Linie', 'Diagonale', 'Rechte Linie'],
      },
    ),

    'O': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(130, 140), Offset(130, 80), Offset(110, 40), Offset(90, 40)),
        LetterStroke.cubicCurve(
            Offset(90, 40), Offset(70, 40), Offset(50, 80), Offset(50, 140)),
        LetterStroke.cubicCurve(
            Offset(50, 140), Offset(50, 200), Offset(70, 240), Offset(90, 240)),
        LetterStroke.cubicCurve(Offset(90, 240), Offset(110, 240),
            Offset(130, 200), Offset(130, 140)),
      ],
      instructions: {
        'en': ['Draw the oval in one smooth motion'],
        'de': ['Zeichne das Oval in einer fließenden Bewegung'],
      },
    ),

    'P': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke(
          points: [Offset(50, 40), Offset(50, 140)],
          type: StrokeType.cubicCurve,
          controlPoints: [
            Offset(50, 40),
            Offset(100, 40),
            Offset(130, 40),
            Offset(150, 60),
            Offset(150, 90),
            Offset(150, 120),
            Offset(130, 140),
            Offset(100, 140)
          ],
        ),
      ],
      instructions: {
        'en': ['Vertical line', 'P bump'],
        'de': ['Senkrechte Linie', 'P-Bogen'],
      },
    ),

    'Q': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(130, 140), Offset(130, 80), Offset(110, 40), Offset(90, 40)),
        LetterStroke.cubicCurve(
            Offset(90, 40), Offset(70, 40), Offset(50, 80), Offset(50, 140)),
        LetterStroke.cubicCurve(
            Offset(50, 140), Offset(50, 200), Offset(70, 240), Offset(90, 240)),
        LetterStroke.cubicCurve(Offset(90, 240), Offset(110, 240),
            Offset(130, 200), Offset(130, 140)),
        LetterStroke.line([Offset(110, 190), Offset(140, 250)]),
      ],
      instructions: {
        'en': ['Draw oval', 'Draw tail'],
        'de': ['Zeichne Oval', 'Zeichne Schwanz'],
      },
    ),

    'R': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 240)]),
        LetterStroke(
          points: [Offset(50, 40), Offset(50, 140)],
          type: StrokeType.cubicCurve,
          controlPoints: [
            Offset(50, 40),
            Offset(90, 40),
            Offset(140, 40),
            Offset(140, 80),
            Offset(140, 120),
            Offset(100, 140),
            Offset(50, 140)
          ],
        ),
        LetterStroke.line([Offset(80, 140), Offset(140, 240)]),
      ],
      instructions: {
        'en': ['Vertical line', 'R bump', 'Diagonal leg'],
        'de': ['Senkrechte Linie', 'R-Bogen', 'Diagonaler Strich'],
      },
    ),

    'S': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(130, 70), Offset(110, 40), Offset(70, 40), Offset(50, 60)),
        LetterStroke.cubicCurve(
            Offset(50, 60), Offset(40, 80), Offset(40, 100), Offset(60, 120)),
        LetterStroke.cubicCurve(Offset(60, 120), Offset(80, 140),
            Offset(100, 140), Offset(120, 160)),
        LetterStroke.cubicCurve(Offset(120, 160), Offset(140, 180),
            Offset(140, 200), Offset(130, 220)),
        LetterStroke.cubicCurve(Offset(130, 220), Offset(110, 240),
            Offset(70, 240), Offset(50, 210)),
      ],
      instructions: {
        'en': [
          'Draw the S curve from top to bottom',
          'Draw the S curve from top to bottom',
          'Draw the S curve from top to bottom',
          'Draw the S curve from top to bottom',
          'Draw the S curve from top to bottom',
        ],
        'de': [
          'Zeichne die S-Kurve von oben nach unten',
          'Zeichne die S-Kurve von oben nach unten',
          'Zeichne die S-Kurve von oben nach unten',
          'Zeichne die S-Kurve von oben nach unten',
          'Zeichne die S-Kurve von oben nach unten',
        ],
      },
    ),

    'T': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 40), Offset(140, 40)]),
        LetterStroke.line([Offset(90, 40), Offset(90, 240)]),
      ],
      instructions: {
        'en': ['Top line', 'Vertical line'],
        'de': ['Obere Linie', 'Senkrechte Linie'],
      },
    ),

    'U': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 180)]),
        LetterStroke.cubicCurve(
            Offset(50, 180), Offset(50, 220), Offset(70, 240), Offset(90, 240)),
        LetterStroke.cubicCurve(Offset(90, 240), Offset(110, 240),
            Offset(130, 220), Offset(130, 180)),
        LetterStroke.line([Offset(130, 180), Offset(130, 40)]),
      ],
      instructions: {
        'en': ['Draw U shape from left to right'],
        'de': ['Zeichne U-Form von links nach rechts'],
      },
    ),

    'V': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 40), Offset(90, 240)]),
        LetterStroke.line([Offset(140, 40), Offset(90, 240)]),
      ],
      instructions: {
        'en': ['Left diagonal', 'Right diagonal'],
        'de': ['Linke Diagonale', 'Rechte Diagonale'],
      },
    ),

    'W': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(20, 40), Offset(45, 240)]),
        LetterStroke.line([Offset(45, 240), Offset(80, 140)]),
        LetterStroke.line([Offset(80, 140), Offset(115, 240)]),
        LetterStroke.line([Offset(115, 240), Offset(140, 40)]),
      ],
      instructions: {
        'en': ['Left line', 'Left up', 'Right up', 'Right line'],
        'de': ['Linke Linie', 'Links hoch', 'Rechts hoch', 'Rechte Linie'],
      },
    ),

    'X': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 40), Offset(140, 240)]),
        LetterStroke.line([Offset(140, 40), Offset(40, 240)]),
      ],
      instructions: {
        'en': ['First diagonal', 'Second diagonal'],
        'de': ['Erste Diagonale', 'Zweite Diagonale'],
      },
    ),

    'Y': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 40), Offset(90, 140)]),
        LetterStroke.line([Offset(140, 40), Offset(90, 140)]),
        LetterStroke.line([Offset(90, 140), Offset(90, 240)]),
      ],
      instructions: {
        'en': ['Left diagonal', 'Right diagonal', 'Vertical line'],
        'de': ['Linke Diagonale', 'Rechte Diagonale', 'Senkrechte Linie'],
      },
    ),

    'Z': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 40), Offset(140, 40)]),
        LetterStroke.line([Offset(140, 40), Offset(40, 240)]),
        LetterStroke.line([Offset(40, 240), Offset(140, 240)]),
      ],
      instructions: {
        'en': ['Top line', 'Diagonal', 'Bottom line'],
        'de': ['Obere Linie', 'Diagonale', 'Untere Linie'],
      },
    ),

    // === LOWERCASE LATIN LETTERS ===
    'a': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(105, 140), Offset(105, 120),
            Offset(90, 120), Offset(70, 125)),
        LetterStroke.cubicCurve(
            Offset(70, 125), Offset(50, 130), Offset(35, 145), Offset(35, 160)),
        LetterStroke.cubicCurve(
            Offset(35, 160), Offset(35, 175), Offset(50, 190), Offset(70, 195)),
        LetterStroke.cubicCurve(Offset(70, 195), Offset(90, 200),
            Offset(105, 200), Offset(105, 180)),
        LetterStroke.line([Offset(105, 125), Offset(105, 220)]),
      ],
      instructions: {
        'en': ['Draw oval', 'Draw line'],
        'de': ['Zeichne Oval', 'Zeichne Linie'],
      },
    ),

    'b': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 220)]),
        LetterStroke.cubicCurve(Offset(50, 140), Offset(70, 120),
            Offset(90, 120), Offset(105, 140)),
        LetterStroke.cubicCurve(Offset(105, 140), Offset(105, 160),
            Offset(105, 180), Offset(105, 195)),
        LetterStroke.cubicCurve(Offset(105, 195), Offset(90, 200),
            Offset(70, 200), Offset(50, 180)),
      ],
      instructions: {
        'en': ['Draw line', 'Draw bump'],
        'de': ['Zeichne Linie', 'Zeichne Bogen'],
      },
    ),

    'c': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(105, 140), Offset(90, 120),
            Offset(65, 120), Offset(50, 140)),
        LetterStroke.cubicCurve(
            Offset(50, 140), Offset(35, 160), Offset(35, 180), Offset(50, 195)),
        LetterStroke.cubicCurve(Offset(50, 195), Offset(65, 210),
            Offset(90, 210), Offset(105, 190)),
      ],
      instructions: {
        'en': ['Draw c curve'],
        'de': ['Zeichne c-Bogen'],
      },
    ),

    'd': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(105, 40), Offset(105, 220)]),
        LetterStroke.cubicCurve(Offset(105, 140), Offset(90, 120),
            Offset(70, 120), Offset(50, 140)),
        LetterStroke.cubicCurve(
            Offset(50, 140), Offset(35, 160), Offset(35, 180), Offset(50, 195)),
        LetterStroke.cubicCurve(Offset(50, 195), Offset(70, 210),
            Offset(90, 210), Offset(105, 190)),
      ],
      instructions: {
        'en': ['Draw line', 'Draw oval'],
        'de': ['Zeichne Linie', 'Zeichne Oval'],
      },
    ),

    'e': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(35, 160), Offset(105, 160)]),
        LetterStroke.cubicCurve(Offset(105, 160), Offset(105, 140),
            Offset(90, 120), Offset(70, 125)),
        LetterStroke.cubicCurve(
            Offset(70, 125), Offset(50, 130), Offset(35, 145), Offset(35, 160)),
        LetterStroke.cubicCurve(
            Offset(35, 160), Offset(35, 175), Offset(50, 190), Offset(70, 195)),
        LetterStroke.cubicCurve(Offset(70, 195), Offset(90, 200),
            Offset(105, 185), Offset(105, 170)),
      ],
      instructions: {
        'en': ['Draw cross line', 'Draw curves'],
        'de': ['Zeichne Querlinie', 'Zeichne Kurven'],
      },
    ),

    'f': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 60), Offset(70, 220)]),
        LetterStroke.cubicCurve(
            Offset(70, 60), Offset(70, 40), Offset(85, 30), Offset(100, 30)),
        LetterStroke.line([Offset(50, 120), Offset(90, 120)]),
      ],
      instructions: {
        'en': ['Draw vertical line with curve at top', 'Cross bar'],
        'de': ['Zeichne senkrechte Linie mit Kurve oben', 'Querstrich'],
      },
    ),

    'g': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(105, 140), Offset(105, 120),
            Offset(90, 120), Offset(70, 125)),
        LetterStroke.cubicCurve(
            Offset(70, 125), Offset(50, 130), Offset(35, 145), Offset(35, 160)),
        LetterStroke.cubicCurve(
            Offset(35, 160), Offset(35, 175), Offset(50, 190), Offset(70, 195)),
        LetterStroke.cubicCurve(Offset(70, 195), Offset(90, 200),
            Offset(105, 200), Offset(105, 180)),
        LetterStroke.line([Offset(105, 125), Offset(105, 250)]),
        LetterStroke.cubicCurve(Offset(105, 250), Offset(105, 270),
            Offset(80, 280), Offset(50, 280)),
        LetterStroke.cubicCurve(
            Offset(50, 280), Offset(30, 280), Offset(20, 270), Offset(20, 260)),
      ],
      instructions: {
        'en': ['Draw oval', 'Draw line', 'Draw tail'],
        'de': ['Zeichne Oval', 'Zeichne Linie', 'Zeichne Schwanz'],
      },
    ),

    'h': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 220)]),
        LetterStroke.cubicCurve(Offset(50, 140), Offset(70, 120),
            Offset(90, 120), Offset(105, 140)),
        LetterStroke.line([Offset(105, 140), Offset(105, 220)]),
      ],
      instructions: {
        'en': ['Draw line', 'Draw curve', 'Draw right line'],
        'de': ['Zeichne Linie', 'Zeichne Bogen', 'Zeichne rechte Linie'],
      },
    ),

    'i': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 120), Offset(70, 220)]),
        LetterStroke.arc(Offset(70, 85), 8, 0, 2 * pi),
      ],
      instructions: {
        'en': ['Draw line', 'Draw dot'],
        'de': ['Zeichne Linie', 'Zeichne Punkt'],
      },
    ),

    'j': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 120), Offset(70, 250)]),
        LetterStroke.cubicCurve(
            Offset(70, 250), Offset(70, 270), Offset(50, 280), Offset(30, 280)),
        LetterStroke.cubicCurve(
            Offset(30, 280), Offset(15, 280), Offset(10, 270), Offset(10, 260)),
        LetterStroke.arc(Offset(70, 85), 8, 0, 2 * pi),
      ],
      instructions: {
        'en': ['Draw line', 'Draw curve', 'Draw dot'],
        'de': ['Zeichne Linie', 'Zeichne Bogen', 'Zeichne Punkt'],
      },
    ),

    'k': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 220)]),
        LetterStroke.line([Offset(100, 120), Offset(50, 170)]),
        LetterStroke.line([Offset(50, 170), Offset(100, 220)]),
      ],
      instructions: {
        'en': ['Draw line', 'Top diagonal', 'Bottom diagonal'],
        'de': ['Zeichne Linie', 'Obere Diagonale', 'Untere Diagonale'],
      },
    ),

    'l': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 40), Offset(70, 220)]),
      ],
      instructions: {
        'en': ['Draw line'],
        'de': ['Zeichne Linie'],
      },
    ),

    'm': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.cubicCurve(
            Offset(30, 140), Offset(45, 120), Offset(60, 120), Offset(70, 140)),
        LetterStroke.line([Offset(70, 140), Offset(70, 220)]),
        LetterStroke.cubicCurve(Offset(70, 140), Offset(85, 120),
            Offset(100, 120), Offset(110, 140)),
        LetterStroke.line([Offset(110, 140), Offset(110, 220)]),
      ],
      instructions: {
        'en': [
          'Left line',
          'First hump',
          'Middle line',
          'Second hump',
          'Right line'
        ],
        'de': [
          'Linke Linie',
          'Erster Bogen',
          'Mittlere Linie',
          'Zweiter Bogen',
          'Rechte Linie'
        ],
      },
    ),

    'n': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 120), Offset(50, 220)]),
        LetterStroke.cubicCurve(Offset(50, 140), Offset(70, 120),
            Offset(90, 120), Offset(105, 140)),
        LetterStroke.line([Offset(105, 140), Offset(105, 220)]),
      ],
      instructions: {
        'en': ['Left line', 'Curve', 'Right line'],
        'de': ['Linke Linie', 'Bogen', 'Rechte Linie'],
      },
    ),

    'o': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(105, 160), Offset(105, 140),
            Offset(90, 125), Offset(70, 125)),
        LetterStroke.cubicCurve(
            Offset(70, 125), Offset(50, 125), Offset(35, 140), Offset(35, 160)),
        LetterStroke.cubicCurve(
            Offset(35, 160), Offset(35, 180), Offset(50, 195), Offset(70, 195)),
        LetterStroke.cubicCurve(Offset(70, 195), Offset(90, 195),
            Offset(105, 180), Offset(105, 160)),
      ],
      instructions: {
        'en': ['Draw oval'],
        'de': ['Zeichne Oval'],
      },
    ),

    'p': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 120), Offset(50, 280)]),
        LetterStroke.cubicCurve(Offset(50, 140), Offset(70, 120),
            Offset(90, 120), Offset(105, 140)),
        LetterStroke.cubicCurve(Offset(105, 140), Offset(105, 160),
            Offset(105, 180), Offset(105, 195)),
        LetterStroke.cubicCurve(Offset(105, 195), Offset(90, 200),
            Offset(70, 200), Offset(50, 180)),
      ],
      instructions: {
        'en': ['Draw line with descender', 'Draw bump'],
        'de': ['Zeichne Linie mit Unterlänge', 'Zeichne Bogen'],
      },
    ),

    'q': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(105, 120), Offset(105, 280)]),
        LetterStroke.cubicCurve(Offset(105, 140), Offset(90, 120),
            Offset(70, 120), Offset(50, 140)),
        LetterStroke.cubicCurve(
            Offset(50, 140), Offset(35, 160), Offset(35, 180), Offset(50, 195)),
        LetterStroke.cubicCurve(Offset(50, 195), Offset(70, 210),
            Offset(90, 210), Offset(105, 190)),
      ],
      instructions: {
        'en': ['Draw line with descender', 'Draw oval'],
        'de': ['Zeichne Linie mit Unterlänge', 'Zeichne Oval'],
      },
    ),

    'r': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 120), Offset(50, 220)]),
        LetterStroke.cubicCurve(
            Offset(50, 140), Offset(65, 120), Offset(80, 120), Offset(90, 135)),
      ],
      instructions: {
        'en': ['Draw line', 'Draw curve'],
        'de': ['Zeichne Linie', 'Zeichne Bogen'],
      },
    ),

    's': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(100, 135), Offset(85, 120),
            Offset(60, 120), Offset(45, 135)),
        LetterStroke.cubicCurve(
            Offset(45, 135), Offset(35, 145), Offset(35, 155), Offset(45, 165)),
        LetterStroke.cubicCurve(
            Offset(45, 165), Offset(60, 175), Offset(80, 175), Offset(95, 185)),
        LetterStroke.cubicCurve(Offset(95, 185), Offset(105, 195),
            Offset(105, 205), Offset(95, 215)),
        LetterStroke.cubicCurve(
            Offset(95, 215), Offset(80, 225), Offset(60, 225), Offset(45, 210)),
      ],
      instructions: {
        'en': [
          'Draw S curve from top to bottom',
          'Draw S curve from top to bottom',
          'Draw S curve from top to bottom',
          'Draw S curve from top to bottom',
          'Draw S curve from top to bottom'
        ],
        'de': [
          'Zeichne S-Kurve von oben nach unten',
          'Zeichne S-Kurve von oben nach unten',
          'Zeichne S-Kurve von oben nach unten',
          'Zeichne S-Kurve von oben nach unten',
        ],
      },
    ),

    't': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(60, 60), Offset(60, 200)]),
        LetterStroke.cubicCurve(
            Offset(60, 200), Offset(60, 215), Offset(70, 220), Offset(85, 220)),
        LetterStroke.line([Offset(40, 120), Offset(85, 120)]),
      ],
      instructions: {
        'en': ['Draw line', 'Draw curve', 'Cross bar'],
        'de': ['Zeichne Linie', 'Zeichne Bogen', 'Querstrich'],
      },
    ),

    'u': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 120), Offset(50, 180)]),
        LetterStroke.cubicCurve(
            Offset(50, 180), Offset(50, 200), Offset(65, 210), Offset(80, 210)),
        LetterStroke.cubicCurve(Offset(80, 210), Offset(95, 210),
            Offset(105, 200), Offset(105, 180)),
        LetterStroke.line([Offset(105, 180), Offset(105, 120)]),
        LetterStroke.line([Offset(105, 140), Offset(105, 220)]),
      ],
      instructions: {
        'en': ['Draw u curve', 'Draw right line'],
        'de': ['Zeichne u-Bogen', 'Zeichne rechte Linie'],
      },
    ),

    'v': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 120), Offset(70, 220)]),
        LetterStroke.line([Offset(100, 120), Offset(70, 220)]),
      ],
      instructions: {
        'en': ['Left diagonal', 'Right diagonal'],
        'de': ['Linke Diagonale', 'Rechte Diagonale'],
      },
    ),

    'w': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(20, 120), Offset(40, 220)]),
        LetterStroke.line([Offset(40, 220), Offset(60, 160)]),
        LetterStroke.line([Offset(60, 160), Offset(80, 220)]),
        LetterStroke.line([Offset(80, 220), Offset(100, 120)]),
      ],
      instructions: {
        'en': ['Left line', 'Left up', 'Right up', 'Right line'],
        'de': ['Linke Linie', 'Links hoch', 'Rechts hoch', 'Rechte Linie'],
      },
    ),

    'x': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 120), Offset(100, 220)]),
        LetterStroke.line([Offset(100, 120), Offset(40, 220)]),
      ],
      instructions: {
        'en': ['First diagonal', 'Second diagonal'],
        'de': ['Erste Diagonale', 'Zweite Diagonale'],
      },
    ),

    'y': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 120), Offset(70, 200)]),
        LetterStroke.line([Offset(100, 120), Offset(70, 200)]),
        LetterStroke.line([Offset(70, 200), Offset(60, 250)]),
        LetterStroke.cubicCurve(
            Offset(60, 250), Offset(55, 270), Offset(40, 280), Offset(20, 280)),
      ],
      instructions: {
        'en': ['Left diagonal', 'Right diagonal', 'Descender', 'Curve'],
        'de': ['Linke Diagonale', 'Rechte Diagonale', 'Unterlänge', 'Bogen'],
      },
    ),

    'z': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 120), Offset(100, 120)]),
        LetterStroke.line([Offset(100, 120), Offset(40, 220)]),
        LetterStroke.line([Offset(40, 220), Offset(100, 220)]),
      ],
      instructions: {
        'en': ['Top line', 'Diagonal', 'Bottom line'],
        'de': ['Obere Linie', 'Diagonale', 'Untere Linie'],
      },
    ),

    // === GERMAN SPECIFIC LETTERS ===
    'Ä': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 240), Offset(100, 40)]),
        LetterStroke.line([Offset(150, 240), Offset(100, 40)]),
        LetterStroke.line([Offset(75, 140), Offset(125, 140)]),
        LetterStroke.arc(Offset(80, 15), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(120, 15), 5, 0, 2 * pi),
      ],
      instructions: {
        'de': [
          'Linke Diagonale',
          'Rechte Diagonale',
          'Querstrich',
          'Linker Umlaut',
          'Rechter Umlaut'
        ],
        'en': [
          'Left diagonal',
          'Right diagonal',
          'Crossbar',
          'Left umlaut',
          'Right umlaut'
        ],
      },
    ),

    'ä': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(105, 140), Offset(105, 120),
            Offset(90, 120), Offset(70, 125)),
        LetterStroke.cubicCurve(
            Offset(70, 125), Offset(50, 130), Offset(35, 145), Offset(35, 160)),
        LetterStroke.cubicCurve(
            Offset(35, 160), Offset(35, 175), Offset(50, 190), Offset(70, 195)),
        LetterStroke.cubicCurve(Offset(70, 195), Offset(90, 200),
            Offset(105, 200), Offset(105, 180)),
        LetterStroke.line([Offset(105, 125), Offset(105, 220)]),
        LetterStroke.arc(Offset(60, 85), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(90, 85), 5, 0, 2 * pi),
      ],
      instructions: {
        'de': [
          'Zeichne Oval',
          'Zeichne Linie',
          'Linker Umlaut',
          'Rechter Umlaut'
        ],
        'en': ['Draw oval', 'Draw line', 'Left umlaut', 'Right umlaut'],
      },
    ),

    'Ö': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(130, 140), Offset(130, 80), Offset(110, 40), Offset(90, 40)),
        LetterStroke.cubicCurve(
            Offset(90, 40), Offset(70, 40), Offset(50, 80), Offset(50, 140)),
        LetterStroke.cubicCurve(
            Offset(50, 140), Offset(50, 200), Offset(70, 240), Offset(90, 240)),
        LetterStroke.cubicCurve(Offset(90, 240), Offset(110, 240),
            Offset(130, 200), Offset(130, 140)),
        LetterStroke.arc(Offset(70, 15), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(110, 15), 5, 0, 2 * pi),
      ],
      instructions: {
        'de': ['Zeichne Oval', 'Linker Umlaut', 'Rechter Umlaut'],
        'en': ['Draw oval', 'Left umlaut', 'Right umlaut'],
      },
    ),

    'ö': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(105, 160), Offset(105, 140),
            Offset(90, 125), Offset(70, 125)),
        LetterStroke.cubicCurve(
            Offset(70, 125), Offset(50, 125), Offset(35, 140), Offset(35, 160)),
        LetterStroke.cubicCurve(
            Offset(35, 160), Offset(35, 180), Offset(50, 195), Offset(70, 195)),
        LetterStroke.cubicCurve(Offset(70, 195), Offset(90, 195),
            Offset(105, 180), Offset(105, 160)),
        LetterStroke.arc(Offset(60, 85), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(90, 85), 5, 0, 2 * pi),
      ],
      instructions: {
        'de': ['Zeichne Oval', 'Linker Umlaut', 'Rechter Umlaut'],
        'en': ['Draw oval', 'Left umlaut', 'Right umlaut'],
      },
    ),

    'Ü': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 180)]),
        LetterStroke.cubicCurve(
            Offset(50, 180), Offset(50, 220), Offset(70, 240), Offset(90, 240)),
        LetterStroke.cubicCurve(Offset(90, 240), Offset(110, 240),
            Offset(130, 220), Offset(130, 180)),
        LetterStroke.line([Offset(130, 180), Offset(130, 40)]),
        LetterStroke.arc(Offset(70, 15), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(110, 15), 5, 0, 2 * pi),
      ],
      instructions: {
        'de': ['Zeichne U-Form', 'Linker Umlaut', 'Rechter Umlaut'],
        'en': ['Draw U shape', 'Left umlaut', 'Right umlaut'],
      },
    ),

    'ü': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 120), Offset(50, 180)]),
        LetterStroke.cubicCurve(
            Offset(50, 180), Offset(50, 200), Offset(65, 210), Offset(80, 210)),
        LetterStroke.cubicCurve(Offset(80, 210), Offset(95, 210),
            Offset(105, 200), Offset(105, 180)),
        LetterStroke.line([Offset(105, 180), Offset(105, 120)]),
        LetterStroke.line([Offset(105, 140), Offset(105, 220)]),
        LetterStroke.arc(Offset(60, 85), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(90, 85), 5, 0, 2 * pi),
      ],
      instructions: {
        'de': [
          'Zeichne u-Bogen',
          'Rechte Linie',
          'Linker Umlaut',
          'Rechter Umlaut'
        ],
        'en': ['Draw u curve', 'Right line', 'Left umlaut', 'Right umlaut'],
      },
    ),

    'ß': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(50, 220)]),
        LetterStroke.cubicCurve(
            Offset(50, 40), Offset(80, 30), Offset(100, 40), Offset(100, 60)),
        LetterStroke.cubicCurve(
            Offset(100, 60), Offset(100, 80), Offset(85, 100), Offset(70, 120)),
        LetterStroke.cubicCurve(Offset(70, 120), Offset(90, 140),
            Offset(110, 160), Offset(110, 180)),
        LetterStroke.cubicCurve(Offset(110, 180), Offset(110, 200),
            Offset(90, 220), Offset(70, 220)),
      ],
      instructions: {
        'de': ['Senkrechte Linie', 'Oberer Bogen', 'Unterer Bogen'],
        'en': ['Vertical line', 'Top curve', 'Bottom curve'],
      },
    ),
  };

  static LetterDefinition? getLetter(String letter) => _paths[letter];
  static List<String> getAvailableLetters() => _paths.keys.toList();
}
