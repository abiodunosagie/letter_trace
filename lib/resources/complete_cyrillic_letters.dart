import 'dart:math';
import 'package:flutter/material.dart';
import 'complete_multilingual_letters.dart'; // Import the stroke types

// COMPLETE CYRILLIC ALPHABET (Russian, Ukrainian, Serbian)
class CyrillicLetterPaths {
  static final Map<String, LetterDefinition> _paths = {
    // === UPPERCASE CYRILLIC LETTERS ===
    'А': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(20, 240), Offset(90, 40)]),
        LetterStroke.line([Offset(160, 240), Offset(90, 40)]),
        LetterStroke.line([Offset(50, 140), Offset(130, 140)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву діагональ',
          'Намалюйте праву діагональ',
          'Намалюйте поперечку'
        ],
        'sr': [
          'Нацртајте леву дијагоналу',
          'Нацртајте десну дијагоналу',
          'Нацртајте попречну линију'
        ],
        'ru': [
          'Нарисуйте левую диагональ',
          'Нарисуйте правую диагональ',
          'Нарисуйте перекладину'
        ],
      },
    ),

    'а': LetterDefinition(
      strokes: [
        LetterStroke.arc(Offset(70, 160), 35, 0, 2 * pi),
        LetterStroke.line([Offset(105, 125), Offset(105, 220)]),
      ],
      instructions: {
        'uk': ['Намалюйте овал', 'Намалюйте вертикальну лінію'],
        'sr': ['Нацртајте овал', 'Нацртајте вертикалну линију'],
        'ru': ['Нарисуйте овал', 'Нарисуйте вертикальную линию'],
      },
    ),

    'Б': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(100, 40)]),
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.cubicCurve(Offset(30, 140), Offset(110, 140),
            Offset(110, 240), Offset(30, 240)), // Bottom D-shape
      ],
      instructions: {
        'uk': [
          'Намалюйте верхню лінію',
          'Намалюйте вертикальну лінію',
          'Намалюйте нижню частину'
        ],
        'sr': [
          'Нацртајте горњу линију',
          'Нацртајте вертикалну линију',
          'Нацртајте доњи део'
        ],
        'ru': [
          'Нарисуйте верхнюю линию',
          'Нарисуйте вертикальную линию',
          'Нарисуйте нижнюю часть'
        ],
      },
    ),

    'б': LetterDefinition(
      strokes: [
        LetterStroke.quadraticCurve(
            Offset(70, 40), Offset(30, 40), Offset(20, 100)),
        LetterStroke.arc(Offset(70, 160), 35, 0, 2 * pi),
      ],
      instructions: {
        'uk': ['Намалюйте верхню частину', 'Намалюйте овал'],
        'sr': ['Нацртајте горњи део', 'Нацртајте овал'],
        'ru': ['Нарисуйте верхнюю часть', 'Нарисуйте овал'],
      },
    ),

    'В': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.cubicCurve(Offset(30, 40), Offset(120, 40),
            Offset(120, 140), Offset(30, 140)), // Top D-shape
        LetterStroke.cubicCurve(Offset(30, 140), Offset(120, 140),
            Offset(120, 240), Offset(30, 240)), // Bottom D-shape
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню частину',
          'Намалюйте нижню частину'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте горњи део',
          'Нацртајте доњи део'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте верхнюю часть',
          'Нарисуйте нижнюю часть'
        ],
      },
    ),

    'в': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.cubicCurve(Offset(30, 120), Offset(80, 120),
            Offset(80, 170), Offset(30, 170)), // Top D-shape
        LetterStroke.cubicCurve(Offset(30, 170), Offset(90, 170),
            Offset(90, 220), Offset(30, 220)), // Bottom D-shape
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню частину',
          'Намалюйте нижню частину'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте горњи део',
          'Нацртајте доњи део'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте верхнюю часть',
          'Нарисуйте нижнюю часть'
        ],
      },
    ),

    'Г': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(30, 40), Offset(120, 40)]),
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію', 'Намалюйте верхню лінію'],
        'sr': ['Нацртајте вертикалну линију', 'Нацртајте горњу линију'],
        'ru': ['Нарисуйте вертикальную линию', 'Нарисуйте верхнюю линию'],
      },
    ),

    'г': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.line([Offset(30, 120), Offset(100, 120)]),
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію', 'Намалюйте верхню лінію'],
        'sr': ['Нацртајте вертикалну линију', 'Нацртајте горњу линију'],
        'ru': ['Нарисуйте вертикальную линию', 'Нарисуйте верхнюю линию'],
      },
    ),

    'Д': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 40), Offset(120, 40)]),
        LetterStroke.line([Offset(120, 40), Offset(140, 220)]),
        LetterStroke.line([Offset(140, 220), Offset(160, 220)]),
        LetterStroke.line([Offset(160, 220), Offset(160, 240)]),
        LetterStroke.line([Offset(160, 240), Offset(20, 240)]),
        LetterStroke.line([Offset(20, 240), Offset(20, 220)]),
        LetterStroke.line([Offset(20, 220), Offset(40, 220)]),
        LetterStroke.line([Offset(40, 220), Offset(40, 40)]),
      ],
      instructions: {
        'uk': ['Намалюйте букву Д'],
        'sr': ['Нацртајте слово Д'],
        'ru': ['Нарисуйте букву Д'],
      },
    ),

    'д': LetterDefinition(
      strokes: [
        LetterStroke.quadraticCurve(
            Offset(50, 120), Offset(50, 100), Offset(90, 100)),
        LetterStroke.line([Offset(90, 100), Offset(110, 120)]),
        LetterStroke.line([Offset(110, 120), Offset(110, 200)]),
        LetterStroke.line([Offset(110, 200), Offset(120, 200)]),
        LetterStroke.line([Offset(120, 200), Offset(120, 220)]),
        LetterStroke.line([Offset(120, 220), Offset(30, 220)]),
        LetterStroke.line([Offset(30, 220), Offset(30, 200)]),
        LetterStroke.line([Offset(30, 200), Offset(40, 200)]),
        LetterStroke.line([Offset(40, 200), Offset(40, 160)]),
        LetterStroke.line([Offset(40, 160), Offset(50, 160)]),
        LetterStroke.line([Offset(50, 160), Offset(50, 120)]),
      ],
      instructions: {
        'uk': ['Намалюйте букву д'],
        'sr': ['Нацртајте слово д'],
        'ru': ['Нарисуйте букву д'],
      },
    ),

    'Е': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(30, 40), Offset(120, 40)]),
        LetterStroke.line([Offset(30, 140), Offset(100, 140)]),
        LetterStroke.line([Offset(30, 240), Offset(120, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню лінію',
          'Намалюйте середню лінію',
          'Намалюйте нижню лінію'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте горњу линију',
          'Нацртајте средњу линију',
          'Нацртајте доњу линију'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте верхнюю линию',
          'Нарисуйте среднюю линию',
          'Нарисуйте нижнюю линию'
        ],
      },
    ),

    'е': LetterDefinition(
      strokes: [
        LetterStroke.arc(Offset(70, 160), 35, 0, pi),
        LetterStroke.line([Offset(35, 160), Offset(105, 160)]),
        LetterStroke.arc(Offset(70, 160), 35, pi, 2 * pi),
      ],
      instructions: {
        'uk': ['Намалюйте букву е з поперечкою'],
        'sr': ['Нацртајте слово е са попречном линијом'],
        'ru': ['Нарисуйте букву е с перекладиной'],
      },
    ),

    'Ё': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(30, 40), Offset(120, 40)]),
        LetterStroke.line([Offset(30, 140), Offset(100, 140)]),
        LetterStroke.line([Offset(30, 240), Offset(120, 240)]),
        LetterStroke.arc(Offset(65, 15), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(95, 15), 5, 0, 2 * pi),
      ],
      instructions: {
        'ru': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню лінію',
          'Намалюйте середню лінію',
          'Намалюйте нижню лінію',
          'Намалюйте ліву крапку',
          'Намалюйте праву крапку'
        ],
      },
    ),

    'ё': LetterDefinition(
      strokes: [
        LetterStroke.arc(Offset(70, 160), 35, 0, pi),
        LetterStroke.line([Offset(35, 160), Offset(105, 160)]),
        LetterStroke.arc(Offset(70, 160), 35, pi, 2 * pi),
        LetterStroke.arc(Offset(55, 85), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(85, 85), 5, 0, 2 * pi),
      ],
      instructions: {
        'ru': [
          'Намалюйте букву е',
          'Намалюйте ліву крапку',
          'Намалюйте праву крапку'
        ],
      },
    ),

    'Ж': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(80, 40), Offset(80, 240)]),
        LetterStroke.line([Offset(20, 40), Offset(80, 140)]),
        LetterStroke.line([Offset(80, 140), Offset(140, 40)]),
        LetterStroke.line([Offset(20, 240), Offset(80, 140)]),
        LetterStroke.line([Offset(80, 140), Offset(140, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхні діагоналі',
          'Намалюйте нижні діагоналі'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте горње дијагонале',
          'Нацртајте доње дијагонале'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте верхние диагонали',
          'Нарисуйте нижние диагонали'
        ],
      },
    ),

    'ж': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 120), Offset(70, 220)]),
        LetterStroke.line([Offset(20, 120), Offset(70, 170)]),
        LetterStroke.line([Offset(70, 170), Offset(120, 120)]),
        LetterStroke.line([Offset(20, 220), Offset(70, 170)]),
        LetterStroke.line([Offset(70, 170), Offset(120, 220)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхні діагоналі',
          'Намалюйте нижні діагоналі'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте горње дијагонале',
          'Нацртајте доње дијагонале'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте верхние диагонали',
          'Нарисуйте нижние диагонали'
        ],
      },
    ),

    'З': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(30, 60), Offset(120, 40), Offset(120, 100), Offset(80, 140)),
        LetterStroke.cubicCurve(Offset(80, 140), Offset(120, 180),
            Offset(120, 220), Offset(30, 220)),
      ],
      instructions: {
        'uk': ['Намалюйте верхню частину', 'Намалюйте нижню частину'],
        'sr': ['Нацртајте горњи део', 'Нацртајте доњи део'],
        'ru': ['Нарисуйте верхнюю часть', 'Нарисуйте нижнюю часть'],
      },
    ),

    'з': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(30, 130), Offset(100, 120),
            Offset(100, 140), Offset(70, 160)),
        LetterStroke.cubicCurve(Offset(70, 160), Offset(100, 180),
            Offset(100, 200), Offset(30, 200)),
      ],
      instructions: {
        'uk': ['Намалюйте верхню частину', 'Намалюйте нижню частину'],
        'sr': ['Нацртајте горњи део', 'Нацртајте доњи део'],
        'ru': ['Нарисуйте верхнюю часть', 'Нарисуйте нижнюю часть'],
      },
    ),

    'И': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 240), Offset(30, 40)]),
        LetterStroke.line([Offset(30, 240), Offset(120, 40)]),
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву лінію',
          'Намалюйте діагональ',
          'Намалюйте праву лінію'
        ],
        'sr': [
          'Нацртајте леву линију',
          'Нацртајте дијагоналу',
          'Нацртајте десну линију'
        ],
        'ru': [
          'Нарисуйте левую линию',
          'Нарисуйте диагональ',
          'Нарисуйте правую линию'
        ],
      },
    ),

    'и': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 220), Offset(30, 120)]),
        LetterStroke.line([Offset(30, 220), Offset(110, 120)]),
        LetterStroke.line([Offset(110, 120), Offset(110, 220)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву лінію',
          'Намалюйте діагональ',
          'Намалюйте праву лінію'
        ],
        'sr': [
          'Нацртајте леву линију',
          'Нацртајте дијагоналу',
          'Нацртајте десну линију'
        ],
        'ru': [
          'Нарисуйте левую линию',
          'Нарисуйте диагональ',
          'Нарисуйте правую линию'
        ],
      },
    ),

    'Й': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 240), Offset(30, 40)]),
        LetterStroke.line([Offset(30, 240), Offset(120, 40)]),
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
        LetterStroke.quadraticCurve(
            Offset(60, 15), Offset(75, 5), Offset(90, 15)),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву лінію',
          'Намалюйте діагональ',
          'Намалюйте праву лінію',
          'Намалюйте брівку'
        ],
        'sr': [
          'Нацртајте леву линију',
          'Нацртајте дијагоналу',
          'Нацртајте десну линију',
          'Нацртајте нагласак'
        ],
        'ru': [
          'Нарисуйте левую линию',
          'Нарисуйте диагональ',
          'Нарисуйте правую линию',
          'Нарисуйте краткую'
        ],
      },
    ),

    'й': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 220), Offset(30, 120)]),
        LetterStroke.line([Offset(30, 220), Offset(110, 120)]),
        LetterStroke.line([Offset(110, 120), Offset(110, 220)]),
        LetterStroke.quadraticCurve(
            Offset(55, 85), Offset(70, 75), Offset(85, 85)),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву лінію',
          'Намалюйте діагональ',
          'Намалюйте праву лінію',
          'Намалюйте брівку'
        ],
        'sr': [
          'Нацртајте леву линију',
          'Нацртајте дијагоналу',
          'Нацртајте десну линију',
          'Нацртајте нагласак'
        ],
        'ru': [
          'Нарисуйте левую линию',
          'Нарисуйте диагональ',
          'Нарисуйте правую линию',
          'Нарисуйте краткую'
        ],
      },
    ),

    'К': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(120, 40), Offset(30, 140)]),
        LetterStroke.line([Offset(30, 140), Offset(120, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню діагональ',
          'Намалюйте нижню діагональ'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте горњу дијагоналу',
          'Нацртајте доњу дијагоналу'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте верхнюю диагональ',
          'Нарисуйте нижнюю диагональ'
        ],
      },
    ),

    'к': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.line([Offset(100, 120), Offset(30, 170)]),
        LetterStroke.line([Offset(50, 190), Offset(100, 220)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню діагональ',
          'Намалюйте нижню діагональ'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте горњу дијагоналу',
          'Нацртајте доњу дијагоналу'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте верхнюю диагональ',
          'Нарисуйте нижнюю диагональ'
        ],
      },
    ),

    'Л': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 40), Offset(40, 220)]),
        LetterStroke.line([Offset(40, 220), Offset(20, 240)]),
        LetterStroke.line([Offset(40, 240), Offset(120, 240)]),
        LetterStroke.line([Offset(120, 240), Offset(120, 40)]),
      ],
      instructions: {
        'uk': ['Намалюйте ліву частину', 'Намалюйте праву частину'],
        'sr': ['Нацртајте леви део', 'Нацртајте десни део'],
        'ru': ['Нарисуйте левую часть', 'Нарисуйте правую часть'],
      },
    ),

    'л': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 120), Offset(40, 200)]),
        LetterStroke.line([Offset(40, 200), Offset(30, 220)]),
        LetterStroke.line([Offset(40, 220), Offset(100, 220)]),
        LetterStroke.line([Offset(100, 220), Offset(100, 120)]),
      ],
      instructions: {
        'uk': ['Намалюйте ліву частину', 'Намалюйте праву частину'],
        'sr': ['Нацртајте леви део', 'Нацртајте десни део'],
        'ru': ['Нарисуйте левую часть', 'Нарисуйте правую часть'],
      },
    ),

    'М': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(20, 240), Offset(20, 40)]),
        LetterStroke.line([Offset(20, 40), Offset(80, 140)]),
        LetterStroke.line([Offset(80, 140), Offset(140, 40)]),
        LetterStroke.line([Offset(140, 40), Offset(140, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву лінію',
          'Намалюйте ліву діагональ',
          'Намалюйте праву діагональ',
          'Намалюйте праву лінію'
        ],
        'sr': [
          'Нацртајте леву линију',
          'Нацртајте леву дијагоналу',
          'Нацртајте десну дијагоналу',
          'Нацртајте десну линију'
        ],
        'ru': [
          'Нарисуйте левую линию',
          'Нарисуйте левую диагональ',
          'Нарисуйте правую диагональ',
          'Нарисуйте правую линию'
        ],
      },
    ),

    'м': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(20, 120), Offset(20, 220)]),
        LetterStroke.arc(Offset(45, 140), 25, 3 * pi / 2, pi / 2),
        LetterStroke.line([Offset(70, 140), Offset(70, 220)]),
        LetterStroke.arc(Offset(95, 140), 25, 3 * pi / 2, pi / 2),
        LetterStroke.line([Offset(120, 140), Offset(120, 220)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву лінію',
          'Намалюйте першу дугу',
          'Намалюйте другу дугу'
        ],
        'sr': [
          'Нацртајте леву линију',
          'Нацртајте први лук',
          'Нацртајте други лук'
        ],
        'ru': [
          'Нарисуйте левую линию',
          'Нарисуйте первую дугу',
          'Нарисуйте вторую дугу'
        ],
      },
    ),

    'Н': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
        LetterStroke.line([Offset(30, 140), Offset(120, 140)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву вертикальну лінію',
          'Намалюйте праву вертикальну лінію',
          'Намалюйте поперечку'
        ],
        'sr': [
          'Нацртајте леву вертикалну линију',
          'Нацртајте десну вертикалну линију',
          'Нацртајте попречну линију'
        ],
        'ru': [
          'Нарисуйте левую вертикальную линию',
          'Нарисуйте правую вертикальную линию',
          'Нарисуйте перекладину'
        ],
      },
    ),

    'н': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.line([Offset(110, 120), Offset(110, 220)]),
        LetterStroke.line([Offset(30, 170), Offset(110, 170)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву вертикальну лінію',
          'Намалюйте праву вертикальну лінію',
          'Намалюйте поперечку'
        ],
        'sr': [
          'Нацртајте леву вертикалну линију',
          'Нацртајте десну вертикалну линију',
          'Нацртајте попречну линију'
        ],
        'ru': [
          'Нарисуйте левую вертикальную линию',
          'Нарисуйте правую вертикальную линию',
          'Нарисуйте перекладину'
        ],
      },
    ),

    'О': LetterDefinition(
      strokes: [
        LetterStroke.arc(Offset(80, 140), 50, 0, 2 * pi),
      ],
      instructions: {
        'uk': ['Намалюйте овал'],
        'sr': ['Нацртајте овал'],
        'ru': ['Нарисуйте овал'],
      },
    ),

    'о': LetterDefinition(
      strokes: [
        LetterStroke.arc(Offset(70, 170), 35, 0, 2 * pi),
      ],
      instructions: {
        'uk': ['Намалюйте овал'],
        'sr': ['Нацртајте овал'],
        'ru': ['Нарисуйте овал'],
      },
    ),

    'П': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(120, 40)]),
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте верхню лінію',
          'Намалюйте ліву вертикальну лінію',
          'Намалюйте праву вертикальну лінію'
        ],
        'sr': [
          'Нацртајте горњу линију',
          'Нацртајте леву вертикалну линију',
          'Нацртајте десну вертикалну линију'
        ],
        'ru': [
          'Нарисуйте верхнюю линию',
          'Нарисуйте левую вертикальную линию',
          'Нарисуйте правую вертикальную линию'
        ],
      },
    ),

    'п': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(110, 120)]),
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.line([Offset(110, 120), Offset(110, 220)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте верхню лінію',
          'Намалюйте ліву вертикальну лінію',
          'Намалюйте праву вертикальну лінію'
        ],
        'sr': [
          'Нацртајте горњу линију',
          'Нацртајте леву вертикалну линију',
          'Нацртајте десну вертикалну линију'
        ],
        'ru': [
          'Нарисуйте верхнюю линию',
          'Нарисуйте левую вертикальную линию',
          'Нарисуйте правую вертикальную линию'
        ],
      },
    ),

    'Р': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.cubicCurve(Offset(30, 40), Offset(120, 40),
            Offset(120, 140), Offset(30, 140)), // P-loop
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію', 'Намалюйте верхню частину'],
        'sr': ['Нацртајте вертикалну линију', 'Нацртајте горњи део'],
        'ru': ['Нарисуйте вертикальную линию', 'Нарисуйте верхнюю часть'],
      },
    ),

    'р': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 280)]),
        LetterStroke.arc(Offset(70, 160), 35, 3 * pi / 2, pi / 2),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію з виносним елементом',
          'Намалюйте дугу'
        ],
        'sr': ['Нацртајте вертикалну линију са продужетком', 'Нацртајте лук'],
        'ru': [
          'Нарисуйте вертикальную линию с выносным элементом',
          'Нарисуйте дугу'
        ],
      },
    ),

    'С': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(130, 60), Offset(30, 40), Offset(30, 240), Offset(130, 220)),
      ],
      instructions: {
        'uk': ['Намалюйте дугу С'],
        'sr': ['Нацртајте лук С'],
        'ru': ['Нарисуйте дугу С'],
      },
    ),

    'с': LetterDefinition(
      strokes: [
        LetterStroke.arc(Offset(70, 170), 35, -pi / 6, pi + pi / 6),
      ],
      instructions: {
        'uk': ['Намалюйте дугу с'],
        'sr': ['Нацртајте лук с'],
        'ru': ['Нарисуйте дугу с'],
      },
    ),

    'Т': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(130, 40)]),
        LetterStroke.line([Offset(80, 40), Offset(80, 240)]),
      ],
      instructions: {
        'uk': ['Намалюйте верхню лінію', 'Намалюйте вертикальну лінію'],
        'sr': ['Нацртајте горњу линију', 'Нацртајте вертикалну линију'],
        'ru': ['Нарисуйте верхнюю линию', 'Нарисуйте вертикальную линию'],
      },
    ),

    'т': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(110, 120)]),
        LetterStroke.line([Offset(70, 120), Offset(70, 220)]),
      ],
      instructions: {
        'uk': ['Намалюйте верхню лінію', 'Намалюйте вертикальну лінію'],
        'sr': ['Нацртајте горњу линију', 'Нацртајте вертикалну линију'],
        'ru': ['Нарисуйте верхнюю линию', 'Нарисуйте вертикальную линию'],
      },
    ),

    'У': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(70, 140)]),
        LetterStroke.line([Offset(130, 40), Offset(70, 140)]),
        LetterStroke.line([Offset(70, 140), Offset(60, 200)]),
        LetterStroke.quadraticCurve(
            Offset(60, 200), Offset(40, 240), Offset(20, 240)),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву діагональ',
          'Намалюйте праву діагональ з виносним елементом'
        ],
        'sr': [
          'Нацртајте леву дијагоналу',
          'Нацртајте десну дијагоналу са продужетком'
        ],
        'ru': [
          'Нарисуйте левую диагональ',
          'Нарисуйте правую диагональ с выносным элементом'
        ],
      },
    ),

    'у': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(60, 200)]),
        LetterStroke.line([Offset(110, 120), Offset(60, 200)]),
        LetterStroke.line([Offset(60, 200), Offset(50, 240)]),
        LetterStroke.quadraticCurve(
            Offset(50, 240), Offset(30, 280), Offset(10, 280)),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву діагональ',
          'Намалюйте праву діагональ з виносним елементом'
        ],
        'sr': [
          'Нацртајте леву дијагоналу',
          'Нацртајте десну дијагоналу са продужетком'
        ],
        'ru': [
          'Нарисуйте левую диагональ',
          'Нарисуйте правую диагональ с выносным элементом'
        ],
      },
    ),

    'Ф': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(80, 20), Offset(80, 260)]),
        LetterStroke.arc(Offset(80, 140), 50, 0, 2 * pi),
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію', 'Намалюйте овал'],
        'sr': ['Нацртајте вертикалну линију', 'Нацртајте овал'],
        'ru': ['Нарисуйте вертикальную линию', 'Нарисуйте овал'],
      },
    ),

    'ф': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 40), Offset(70, 280)]),
        LetterStroke.arc(Offset(70, 170), 35, 0, 2 * pi),
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію', 'Намалюйте овал'],
        'sr': ['Нацртајте вертикалну линију', 'Нацртајте овал'],
        'ru': ['Нарисуйте вертикальную линию', 'Нарисуйте овал'],
      },
    ),

    'Х': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(130, 240)]),
        LetterStroke.line([Offset(130, 40), Offset(30, 240)]),
      ],
      instructions: {
        'uk': ['Намалюйте першу діагональ', 'Намалюйте другу діагональ'],
        'sr': ['Нацртајте прву дијагоналу', 'Нацртајте другу дијагоналу'],
        'ru': ['Нарисуйте первую диагональ', 'Нарисуйте вторую диагональ'],
      },
    ),

    'х': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(110, 220)]),
        LetterStroke.line([Offset(110, 120), Offset(30, 220)]),
      ],
      instructions: {
        'uk': ['Намалюйте першу діагональ', 'Намалюйте другу діагональ'],
        'sr': ['Нацртајте прву дијагоналу', 'Нацртајте другу дијагоналу'],
        'ru': ['Нарисуйте первую диагональ', 'Нарисуйте вторую диагональ'],
      },
    ),

    'Ц': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
        LetterStroke.line([Offset(30, 240), Offset(140, 240)]),
        LetterStroke.line([Offset(140, 240), Offset(140, 260)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву вертикальну лінію',
          'Намалюйте праву вертикальну лінію',
          'Намалюйте нижню лінію з виносним елементом'
        ],
        'sr': [
          'Нацртајте леву вертикалну линију',
          'Нацртајте десну вертикалну линију',
          'Нацртајте доњу линију са продужетком'
        ],
        'ru': [
          'Нарисуйте левую вертикальную линию',
          'Нарисуйте правую вертикальную линию',
          'Нарисуйте нижнюю линию с выносным элементом'
        ],
      },
    ),

    'ц': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.line([Offset(100, 120), Offset(100, 220)]),
        LetterStroke.line([Offset(30, 220), Offset(120, 220)]),
        LetterStroke.line([Offset(120, 220), Offset(120, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву вертикальну лінію',
          'Намалюйте праву вертикальну лінію',
          'Намалюйте нижню лінію з виносним елементом'
        ],
        'sr': [
          'Нацртајте леву вертикалну линију',
          'Нацртајте десну вертикалну линију',
          'Нацртајте доњу линију са продужетком'
        ],
        'ru': [
          'Нарисуйте левую вертикальную линию',
          'Нарисуйте правую вертикальную линию',
          'Нарисуйте нижнюю линию с выносным элементом'
        ],
      },
    ),

    'Ч': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 140)]),
        LetterStroke.quadraticCurve(
            Offset(30, 140), Offset(80, 120), Offset(120, 140)),
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
      ],
      instructions: {
        'uk': ['Намалюйте ліву частину', 'Намалюйте праву вертикальну лінію'],
        'sr': ['Нацртајте леви део', 'Нацртајте десну вертикалну линију'],
        'ru': ['Нарисуйте левую часть', 'Нарисуйте правую вертикальную линию'],
      },
    ),

    'ч': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 170)]),
        LetterStroke.quadraticCurve(
            Offset(30, 170), Offset(60, 150), Offset(100, 170)),
        LetterStroke.line([Offset(100, 120), Offset(100, 220)]),
      ],
      instructions: {
        'uk': ['Намалюйте ліву частину', 'Намалюйте праву вертикальну лінію'],
        'sr': ['Нацртајте леви део', 'Нацртајте десну вертикалну линију'],
        'ru': ['Нарисуйте левую часть', 'Нарисуйте правую вертикальную линию'],
      },
    ),

    'Ш': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(80, 40), Offset(80, 240)]),
        LetterStroke.line([Offset(130, 40), Offset(130, 240)]),
        LetterStroke.line([Offset(30, 240), Offset(130, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте першу вертикальну лінію',
          'Намалюйте другу вертикальну лінію',
          'Намалюйте третю вертикальну лінію',
          'Намалюйте нижню лінію'
        ],
        'sr': [
          'Нацртајте прву вертикалну линију',
          'Нацртајте другу вертикалну линију',
          'Нацртајте трећу вертикалну линију',
          'Нацртајте доњу линију'
        ],
        'ru': [
          'Нарисуйте первую вертикальную линию',
          'Нарисуйте вторую вертикальную линию',
          'Нарисуйте третью вертикальную линию',
          'Нарисуйте нижнюю линию'
        ],
      },
    ),

    'ш': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.line([Offset(70, 120), Offset(70, 220)]),
        LetterStroke.line([Offset(110, 120), Offset(110, 220)]),
        LetterStroke.line([Offset(30, 220), Offset(110, 220)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте першу вертикальну лінію',
          'Намалюйте другу вертикальну лінію',
          'Намалюйте третю вертикальну лінію',
          'Намалюйте нижню лінію'
        ],
        'sr': [
          'Нацртајте прву вертикалну линију',
          'Нацртајте другу вертикалну линију',
          'Нацртајте трећу вертикалну линију',
          'Нацртајте доњу линију'
        ],
        'ru': [
          'Нарисуйте первую вертикальную линию',
          'Нарисуйте вторую вертикальную линию',
          'Нарисуйте третью вертикальную линию',
          'Нарисуйте нижнюю линию'
        ],
      },
    ),

    'Щ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(80, 40), Offset(80, 240)]),
        LetterStroke.line([Offset(130, 40), Offset(130, 240)]),
        LetterStroke.line([Offset(30, 240), Offset(150, 240)]),
        LetterStroke.line([Offset(150, 240), Offset(150, 260)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте першу вертикальну лінію',
          'Намалюйте другу вертикальну лінію',
          'Намалюйте третю вертикальну лінію',
          'Намалюйте нижню лінію з виносним елементом'
        ],
        'sr': [
          'Нацртајте прву вертикалну линију',
          'Нацртајте другу вертикалну линију',
          'Нацртајте трећу вертикалну линију',
          'Нацртајте доњу линију са продужетком'
        ],
        'ru': [
          'Нарисуйте первую вертикальную линию',
          'Нарисуйте вторую вертикальную линию',
          'Нарисуйте третью вертикальную линию',
          'Нарисуйте нижнюю линию с выносным элементом'
        ],
      },
    ),

    'щ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(25, 120), Offset(25, 220)]),
        LetterStroke.line([Offset(60, 120), Offset(60, 220)]),
        LetterStroke.line([Offset(95, 120), Offset(95, 220)]),
        LetterStroke.line([Offset(25, 220), Offset(115, 220)]),
        LetterStroke.line([Offset(115, 220), Offset(115, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте першу вертикальну лінію',
          'Намалюйте другу вертикальну лінію',
          'Намалюйте третю вертикальну лінію',
          'Намалюйте нижню лінію з виносним елементом'
        ],
        'sr': [
          'Нацртајте прву вертикалну линију',
          'Нацртајте другу вертикалну линију',
          'Нацртајте трећу вертикалну линију',
          'Нацртајте доњу линију са продужетком'
        ],
        'ru': [
          'Нарисуйте первую вертикальную линию',
          'Нарисуйте вторую вертикальную линию',
          'Нарисуйте третью вертикальную линию',
          'Нарисуйте нижнюю линию с выносным элементом'
        ],
      },
    ),

    'Ъ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(30, 40), Offset(60, 40)]),
        LetterStroke.cubicCurve(Offset(30, 140), Offset(100, 140),
            Offset(100, 240), Offset(30, 240)), // Bottom D-shape
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню лінію',
          'Намалюйте нижню частину'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте горњу линију',
          'Нацртајте доњи део'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте верхнюю линию',
          'Нарисуйте нижнюю часть'
        ],
      },
    ),

    'ъ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(50, 120)]),
        LetterStroke.line([Offset(40, 120), Offset(40, 220)]),
        LetterStroke.cubicCurve(Offset(40, 170), Offset(90, 170),
            Offset(90, 220), Offset(40, 220)), // Bottom D-shape
      ],
      instructions: {
        'uk': [
          'Намалюйте верхню лінію',
          'Намалюйте вертикальну лінію',
          'Намалюйте нижню частину'
        ],
        'sr': [
          'Нацртајте горњу линију',
          'Нацртајте вертикалну линију',
          'Нацртајте доњи део'
        ],
        'ru': [
          'Нарисуйте верхнюю линию',
          'Нарисуйте вертикальную линию',
          'Нарисуйте нижнюю часть'
        ],
      },
    ),

    'Ы': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.cubicCurve(Offset(30, 140), Offset(90, 140),
            Offset(90, 240), Offset(30, 240)), // Middle D-shape
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву вертикальну лінію',
          'Намалюйте середню частину',
          'Намалюйте праву вертикальну лінію'
        ],
        'sr': [
          'Нацртајте леву вертикалну линију',
          'Нацртајте средњи део',
          'Нацртајте десну вертикалну линију'
        ],
        'ru': [
          'Нарисуйте левую вертикальную линию',
          'Нарисуйте среднюю часть',
          'Нарисуйте правую вертикальную линию'
        ],
      },
    ),

    'ы': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.cubicCurve(Offset(30, 170), Offset(80, 170),
            Offset(80, 220), Offset(30, 220)), // Middle D-shape
        LetterStroke.line([Offset(110, 120), Offset(110, 220)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву вертикальну лінію',
          'Намалюйте середню частину',
          'Намалюйте праву вертикальну лінію'
        ],
        'sr': [
          'Нацртајте леву вертикалну линију',
          'Нацртајте средњи део',
          'Нацртајте десну вертикалну линију'
        ],
        'ru': [
          'Нарисуйте левую вертикальную линию',
          'Нарисуйте среднюю часть',
          'Нарисуйте правую вертикальную линию'
        ],
      },
    ),

    'Ь': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.cubicCurve(Offset(30, 140), Offset(100, 140),
            Offset(100, 240), Offset(30, 240)), // Bottom D-shape
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію', 'Намалюйте нижню частину'],
        'sr': ['Нацртајте вертикалну линију', 'Нацртајте доњи део'],
        'ru': ['Нарисуйте вертикальную линию', 'Нарисуйте нижнюю часть'],
      },
    ),

    'ь': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.cubicCurve(Offset(30, 170), Offset(80, 170),
            Offset(80, 220), Offset(30, 220)), // Bottom D-shape
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію', 'Намалюйте нижню частину'],
        'sr': ['Нацртајте вертикалну линију', 'Нацртајте доњи део'],
        'ru': ['Нарисуйте вертикальную линию', 'Нарисуйте нижнюю часть'],
      },
    ),

    'Э': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(130, 60),
            Offset(40, 40),
            Offset(40, 120),
            Offset(60, 140)), // Adjusted points for a better Э shape top
        LetterStroke.line([Offset(50, 140), Offset(120, 140)]), // Middle bar
        LetterStroke.cubicCurve(
            Offset(60, 140),
            Offset(120, 180),
            Offset(40, 240),
            Offset(130, 220)), // Adjusted points for a better Э shape bottom
      ],
      instructions: {
        'uk': [
          'Намалюйте верхню частину',
          'Намалюйте середню лінію',
          'Намалюйте нижню частину'
        ],
        'sr': [
          'Нацртајте горњи део',
          'Нацртајте средњу линију',
          'Нацртајте доњи део'
        ],
        'ru': [
          'Нарисуйте верхнюю часть',
          'Нарисуйте среднюю линию',
          'Нарисуйте нижнюю часть'
        ],
      },
    ),

    'э': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(Offset(30, 130), Offset(100, 120),
            Offset(100, 150), Offset(50, 170)), // Top curve
        LetterStroke.line([Offset(40, 170), Offset(90, 170)]), // Middle bar
        LetterStroke.cubicCurve(Offset(50, 170), Offset(100, 200),
            Offset(100, 220), Offset(30, 200)), // Bottom curve
      ],
      instructions: {
        'uk': [
          'Намалюйте верхню частину',
          'Намалюйте середню лінію',
          'Намалюйте нижню частину'
        ],
        'sr': [
          'Нацртајте горњи део',
          'Нацртајте средњу линију',
          'Нацртајте доњи део'
        ],
        'ru': [
          'Нарисуйте верхнюю часть',
          'Нарисуйте среднюю линию',
          'Нарисуйте нижнюю часть'
        ],
      },
    ),

    'Ю': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(30, 140), Offset(70, 140)]),
        LetterStroke.arc(Offset(120, 140), 50, 0, 2 * pi),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте поперечку',
          'Намалюйте овал'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте попречну линију',
          'Нацртајте овал'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте перекладину',
          'Нарисуйте овал'
        ],
      },
    ),

    'ю': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.line([Offset(30, 170), Offset(60, 170)]),
        LetterStroke.arc(Offset(90, 170), 35, 0, 2 * pi),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте поперечку',
          'Намалюйте овал'
        ],
        'sr': [
          'Нацртајте вертикалну линију',
          'Нацртајте попречну линију',
          'Нацртајте овал'
        ],
        'ru': [
          'Нарисуйте вертикальную линию',
          'Нарисуйте перекладину',
          'Нарисуйте овал'
        ],
      },
    ),

    'Я': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(50, 40), Offset(30, 40)]),
        LetterStroke.line([Offset(30, 40), Offset(30, 140)]),
        LetterStroke.line([Offset(30, 140), Offset(50, 140)]),
        LetterStroke.cubicCurve(Offset(50, 40), Offset(120, 40),
            Offset(120, 140), Offset(50, 140)), // P-like loop
        // LetterStroke.line([Offset(120, 40), Offset(120, 240)]), // This line seems to make a non-standard Я, commenting out
        LetterStroke.line([
          Offset(70, 140),
          Offset(30, 240)
        ]), // Leg, starting from mid-point of P-loop's right side
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву частину',
          'Намалюйте верхню дугу',
          'Намалюйте праву вертикальну лінію',
          'Намалюйте діагональ'
        ],
        'sr': [
          'Нацртајте леви део',
          'Нацртајте горњи лук',
          'Нацртајте десну вертикалну линију',
          'Нацртајте дијагоналу'
        ],
        'ru': [
          'Нарисуйте левую часть',
          'Нарисуйте верхнюю дугу',
          'Нарисуйте правую вертикальную линию',
          'Нарисуйте диагональ'
        ],
      },
    ),

    'я': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 120), Offset(30, 120)]),
        LetterStroke.line([Offset(30, 120), Offset(30, 170)]),
        LetterStroke.line([Offset(30, 170), Offset(40, 170)]),
        LetterStroke.cubicCurve(Offset(40, 120), Offset(100, 120),
            Offset(100, 170), Offset(40, 170)), // P-like loop
        // LetterStroke.line([Offset(100, 120), Offset(100, 220)]), // This line seems to make a non-standard я, commenting out
        LetterStroke.line([Offset(60, 170), Offset(30, 220)]), // Leg
      ],
      instructions: {
        'uk': [
          'Намалюйте ліву частину',
          'Намалюйте верхню дугу',
          'Намалюйте праву вертикальну лінію',
          'Намалюйте діагональ'
        ],
        'sr': [
          'Нацртајте леви део',
          'Нацртајте горњи лук',
          'Нацртајте десну вертикалну линију',
          'Нацртајте дијагоналу'
        ],
        'ru': [
          'Нарисуйте левую часть',
          'Нарисуйте верхнюю дугу',
          'Нарисуйте правую вертикальную линию',
          'Нарисуйте диагональ'
        ],
      },
    ),

    // === UKRAINIAN SPECIFIC LETTERS ===
    'І': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(80, 40), Offset(80, 240)]),
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію'],
      },
    ),

    'і': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 120), Offset(70, 220)]),
        LetterStroke.arc(Offset(70, 85), 8, 0, 2 * pi),
      ],
      instructions: {
        'uk': ['Намалюйте вертикальну лінію', 'Намалюйте крапку'],
      },
    ),

    'Ї': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(80, 40), Offset(80, 240)]),
        LetterStroke.arc(Offset(65, 15), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(95, 15), 5, 0, 2 * pi),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте ліву крапку',
          'Намалюйте праву крапку'
        ],
      },
    ),

    'ї': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(70, 120), Offset(70, 220)]),
        LetterStroke.arc(Offset(55, 85), 5, 0, 2 * pi),
        LetterStroke.arc(Offset(85, 85), 5, 0, 2 * pi),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте ліву крапку',
          'Намалюйте праву крапку'
        ],
      },
    ),

    'Є': LetterDefinition(
      strokes: [
        LetterStroke.cubicCurve(
            Offset(120, 60), Offset(30, 40), Offset(30, 240), Offset(120, 220)),
        LetterStroke.line([Offset(70, 140), Offset(120, 140)]),
      ],
      instructions: {
        'uk': ['Намалюйте дугу Є', 'Намалюйте середню лінію'],
      },
    ),

    'є': LetterDefinition(
      strokes: [
        LetterStroke.arc(Offset(70, 170), 35, -pi / 6, pi + pi / 6),
        LetterStroke.line([Offset(60, 170), Offset(100, 170)]),
      ],
      instructions: {
        'uk': ['Намалюйте дугу є', 'Намалюйте середню лінію'],
      },
    ),

    'Ґ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(30, 40), Offset(120, 40)]),
        LetterStroke.line([Offset(30, 15), Offset(50, 15)]),
        LetterStroke.line([Offset(50, 15), Offset(50, 35)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню лінію',
          'Намалюйте загачок'
        ],
      },
    ),

    'ґ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 220)]),
        LetterStroke.line([Offset(30, 120), Offset(100, 120)]),
        LetterStroke.line([Offset(30, 100), Offset(45, 100)]),
        LetterStroke.line([Offset(45, 100), Offset(45, 120)]),
      ],
      instructions: {
        'uk': [
          'Намалюйте вертикальну лінію',
          'Намалюйте верхню лінію',
          'Намалюйте загачок'
        ],
      },
    ),

    // === SERBIAN SPECIFIC LETTERS ===
    'Љ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(40, 40), Offset(40, 220)]),
        LetterStroke.line([Offset(40, 220), Offset(20, 240)]),
        LetterStroke.line([Offset(40, 240), Offset(80, 240)]),
        LetterStroke.quadraticCurve(
            Offset(80, 240), Offset(100, 220), Offset(100, 180)),
        LetterStroke.line([Offset(100, 180), Offset(120, 40)]),
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
      ],
      instructions: {
        'sr': ['Нацртајте леви део', 'Нацртајте десни део'],
      },
    ),

    'љ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 200)]),
        LetterStroke.line([Offset(30, 200), Offset(20, 220)]),
        LetterStroke.line([Offset(30, 220), Offset(60, 220)]),
        LetterStroke.quadraticCurve(
            Offset(60, 220), Offset(80, 200), Offset(80, 160)),
        LetterStroke.line([Offset(80, 160), Offset(100, 120)]),
        LetterStroke.line([Offset(100, 120), Offset(100, 220)]),
      ],
      instructions: {
        'sr': ['Нацртајте леви део', 'Нацртајте десни део'],
      },
    ),

    'Њ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 240)]),
        LetterStroke.line([Offset(30, 140), Offset(80, 140)]),
        LetterStroke.line([Offset(80, 40), Offset(80, 140)]),
        LetterStroke.line([Offset(80, 140), Offset(120, 40)]),
        LetterStroke.line([Offset(120, 40), Offset(120, 240)]),
      ],
      instructions: {
        'sr': [
          'Нацртајте леву вертикалну линију',
          'Нацртајте попречну линију',
          'Нацртајте десни део'
        ],
      },
    ),

    'њ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(25, 120), Offset(25, 220)]),
        LetterStroke.line([Offset(25, 170), Offset(65, 170)]),
        LetterStroke.line([Offset(65, 120), Offset(65, 170)]),
        LetterStroke.line([Offset(65, 170), Offset(95, 120)]),
        LetterStroke.line([Offset(95, 120), Offset(95, 220)]),
      ],
      instructions: {
        'sr': [
          'Нацртајте леву вертикалну линију',
          'Нацртајте попречну линију',
          'Нацртајте десни део'
        ],
      },
    ),

    'Ћ': LetterDefinition(
      strokes: [
        LetterStroke.quadraticCurve(
            Offset(50, 15),
            Offset(60, 5),
            Offset(70,
                15)), // Accent (can be kept quadratic or changed to cubic if needed)
        LetterStroke.line([Offset(60, 40), Offset(60, 200)]),
        LetterStroke.cubicCurve(Offset(60, 200), Offset(50, 230),
            Offset(20, 240), Offset(10, 230)), // Main curve and tail
      ],
      instructions: {
        'sr': ['Нацртајте акценат', 'Нацртајте криву линију'],
      },
    ),

    'ћ': LetterDefinition(
      strokes: [
        LetterStroke.quadraticCurve(
            Offset(45, 85), Offset(55, 75), Offset(65, 85)), // Accent
        LetterStroke.line([Offset(55, 120), Offset(55, 180)]),
        LetterStroke.cubicCurve(Offset(55, 180), Offset(45, 210),
            Offset(15, 220), Offset(5, 210)), // Main curve and tail
      ],
      instructions: {
        'sr': ['Нацртајте акценат', 'Нацртајте криву линију'],
      },
    ),

    'Ђ': LetterDefinition(
      strokes: [
        LetterStroke.quadraticCurve(
            Offset(30, 15), Offset(40, 5), Offset(50, 15)), // Accent
        LetterStroke.line([Offset(40, 40), Offset(40, 140)]),
        LetterStroke.cubicCurve(Offset(40, 140), Offset(70, 110),
            Offset(100, 120), Offset(110, 140)), // Top part of D
        LetterStroke.cubicCurve(
            Offset(110, 140),
            Offset(120, 180),
            Offset(80, 220),
            Offset(40, 190)), // Bottom part of D and connection
      ],
      instructions: {
        'sr': ['Нацртајте акценат', 'Нацртајте основни део'],
      },
    ),

    'ђ': LetterDefinition(
      strokes: [
        LetterStroke.quadraticCurve(
            Offset(35, 85), Offset(45, 75), Offset(55, 85)), // Accent
        LetterStroke.line([Offset(45, 120), Offset(45, 170)]),
        LetterStroke.cubicCurve(Offset(45, 170), Offset(70, 140),
            Offset(90, 150), Offset(95, 170)), // Top part of d
        LetterStroke.cubicCurve(
            Offset(95, 170),
            Offset(100, 200),
            Offset(70, 230),
            Offset(45, 200)), // Bottom part of d and connection
      ],
      instructions: {
        'sr': ['Нацртајте акценат', 'Нацртајте основни део'],
      },
    ),

    'Џ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 40), Offset(30, 200)]),
        LetterStroke.line([Offset(30, 200), Offset(40, 200)]),
        LetterStroke.line([Offset(40, 200), Offset(40, 240)]),
        LetterStroke.line([Offset(40, 240), Offset(120, 240)]),
        LetterStroke.line([Offset(120, 240), Offset(120, 200)]),
        LetterStroke.line([Offset(120, 200), Offset(130, 200)]),
        LetterStroke.line([Offset(130, 200), Offset(130, 40)]),
      ],
      instructions: {
        'sr': ['Нацртајте облик слова Џ са продужетком'],
      },
    ),

    'џ': LetterDefinition(
      strokes: [
        LetterStroke.line([Offset(30, 120), Offset(30, 180)]),
        LetterStroke.line([Offset(30, 180), Offset(40, 180)]),
        LetterStroke.line([Offset(40, 180), Offset(40, 220)]),
        LetterStroke.line([Offset(40, 220), Offset(100, 220)]),
        LetterStroke.line([Offset(100, 220), Offset(100, 180)]),
        LetterStroke.line([Offset(100, 180), Offset(110, 180)]),
        LetterStroke.line([Offset(110, 180), Offset(110, 120)]),
      ],
      instructions: {
        'sr': ['Нацртајте облик слова џ са продужетком'],
      },
    ),
  };

  static LetterDefinition? getLetter(String letter) => _paths[letter];
  static List<String> getAvailableLetters() => _paths.keys.toList();
}
