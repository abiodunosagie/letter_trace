import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: CustomPaint(
          painter: AlphabetPainter(),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}

class AlphabetPainter extends CustomPainter {
  final double letterSpacing = 40;
  final double startX = 20;
  final double startY = 100;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 26; i++) {
      double x = startX + (i % 13) * letterSpacing * 1.5;
      double y = startY + (i ~/ 13) * 80;
      drawLetter(canvas, paint, String.fromCharCode(65 + i), Offset(x, y));
    }
  }

  void drawLetter(Canvas canvas, Paint paint, String letter, Offset offset) {
    switch (letter) {
      case 'A':
        _drawA(canvas, paint, offset);
        break;
      case 'B':
        _drawB(canvas, paint, offset);
        break;
      case 'C':
        _drawC(canvas, paint, offset);
        break;
      case 'D':
        _drawD(canvas, paint, offset);
        break;
      case 'E':
        _drawE(canvas, paint, offset);
        break;
      case 'F':
        _drawF(canvas, paint, offset);
        break;
      case 'G':
        _drawG(canvas, paint, offset);
        break;
      case 'H':
        _drawH(canvas, paint, offset);
        break;
      case 'I':
        _drawI(canvas, paint, offset);
        break;
      case 'J':
        _drawJ(canvas, paint, offset);
        break;
      case 'K':
        _drawK(canvas, paint, offset);
        break;
      case 'L':
        _drawL(canvas, paint, offset);
        break;
      case 'M':
        _drawM(canvas, paint, offset);
        break;
      case 'N':
        _drawN(canvas, paint, offset);
        break;
      case 'O':
        _drawO(canvas, paint, offset);
        break;
      case 'P':
        _drawP(canvas, paint, offset);
        break;
      case 'Q':
        _drawQ(canvas, paint, offset);
        break;
      case 'R':
        _drawR(canvas, paint, offset);
        break;
      case 'S':
        _drawS(canvas, paint, offset);
        break;
      case 'T':
        _drawT(canvas, paint, offset);
        break;
      case 'U':
        _drawU(canvas, paint, offset);
        break;
      case 'V':
        _drawV(canvas, paint, offset);
        break;
      case 'W':
        _drawW(canvas, paint, offset);
        break;
      case 'X':
        _drawX(canvas, paint, offset);
        break;
      case 'Y':
        _drawY(canvas, paint, offset);
        break;
      case 'Z':
        _drawZ(canvas, paint, offset);
        break;
    }
  }

  void _drawA(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy + 40)
      ..lineTo(o.dx + 10, o.dy)
      ..lineTo(o.dx + 20, o.dy + 40)
      ..moveTo(o.dx + 5, o.dy + 20)
      ..lineTo(o.dx + 15, o.dy + 20);
    canvas.drawPath(path, paint);
  }

  void _drawB(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..moveTo(o.dx, o.dy)
      ..quadraticBezierTo(o.dx + 15, o.dy + 5, o.dx, o.dy + 20)
      ..moveTo(o.dx, o.dy + 20)
      ..quadraticBezierTo(o.dx + 15, o.dy + 25, o.dx, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawC(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx + 15, o.dy)
      ..quadraticBezierTo(o.dx, o.dy + 20, o.dx + 15, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawD(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..quadraticBezierTo(o.dx + 20, o.dy + 20, o.dx, o.dy);
    canvas.drawPath(path, paint);
  }

  void _drawE(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx + 15, o.dy)
      ..lineTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..lineTo(o.dx + 15, o.dy + 40)
      ..moveTo(o.dx, o.dy + 20)
      ..lineTo(o.dx + 10, o.dy + 20);
    canvas.drawPath(path, paint);
  }

  void _drawF(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx + 15, o.dy)
      ..moveTo(o.dx, o.dy + 20)
      ..lineTo(o.dx + 10, o.dy + 20);
    canvas.drawPath(path, paint);
  }

  void _drawG(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx + 15, o.dy)
      ..quadraticBezierTo(o.dx, o.dy + 20, o.dx + 15, o.dy + 40)
      ..lineTo(o.dx + 5, o.dy + 40)
      ..moveTo(o.dx + 10, o.dy + 25)
      ..lineTo(o.dx + 20, o.dy + 25);
    canvas.drawPath(path, paint);
  }

  void _drawH(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..moveTo(o.dx + 20, o.dy)
      ..lineTo(o.dx + 20, o.dy + 40)
      ..moveTo(o.dx, o.dy + 20)
      ..lineTo(o.dx + 20, o.dy + 20);
    canvas.drawPath(path, paint);
  }

  void _drawI(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx + 10, o.dy)
      ..lineTo(o.dx + 10, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawJ(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx + 20, o.dy)
      ..lineTo(o.dx + 20, o.dy + 30)
      ..quadraticBezierTo(o.dx + 10, o.dy + 45, o.dx, o.dy + 30);
    canvas.drawPath(path, paint);
  }

  void _drawK(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..moveTo(o.dx, o.dy + 20)
      ..lineTo(o.dx + 20, o.dy)
      ..moveTo(o.dx, o.dy + 20)
      ..lineTo(o.dx + 20, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawL(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..lineTo(o.dx + 20, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawM(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy + 40)
      ..lineTo(o.dx, o.dy)
      ..lineTo(o.dx + 10, o.dy + 20)
      ..lineTo(o.dx + 20, o.dy)
      ..lineTo(o.dx + 20, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawN(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy + 40)
      ..lineTo(o.dx, o.dy)
      ..lineTo(o.dx + 20, o.dy + 40)
      ..lineTo(o.dx + 20, o.dy);
    canvas.drawPath(path, paint);
  }

  void _drawO(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..addOval(
          Rect.fromCircle(center: Offset(o.dx + 10, o.dy + 20), radius: 10));
    canvas.drawPath(path, paint);
  }

  void _drawP(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..moveTo(o.dx, o.dy)
      ..quadraticBezierTo(o.dx + 15, o.dy + 5, o.dx, o.dy + 20);
    canvas.drawPath(path, paint);
  }

  void _drawQ(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..addOval(
          Rect.fromCircle(center: Offset(o.dx + 10, o.dy + 20), radius: 10))
      ..moveTo(o.dx + 15, o.dy + 25)
      ..lineTo(o.dx + 20, o.dy + 30);
    canvas.drawPath(path, paint);
  }

  void _drawR(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..moveTo(o.dx, o.dy)
      ..quadraticBezierTo(o.dx + 15, o.dy + 5, o.dx, o.dy + 20)
      ..lineTo(o.dx + 20, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawS(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx + 15, o.dy)
      ..quadraticBezierTo(o.dx, o.dy + 10, o.dx + 15, o.dy + 20)
      ..quadraticBezierTo(o.dx + 30, o.dy + 30, o.dx + 15, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawT(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx + 10, o.dy)
      ..lineTo(o.dx + 10, o.dy + 40)
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx + 20, o.dy);
    canvas.drawPath(path, paint);
  }

  void _drawU(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx, o.dy + 30)
      ..quadraticBezierTo(o.dx + 10, o.dy + 50, o.dx + 20, o.dy + 30)
      ..lineTo(o.dx + 20, o.dy);
    canvas.drawPath(path, paint);
  }

  void _drawV(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx + 10, o.dy + 40)
      ..lineTo(o.dx + 20, o.dy);
    canvas.drawPath(path, paint);
  }

  void _drawW(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx + 5, o.dy + 40)
      ..lineTo(o.dx + 10, o.dy + 20)
      ..lineTo(o.dx + 15, o.dy + 40)
      ..lineTo(o.dx + 20, o.dy);
    canvas.drawPath(path, paint);
  }

  void _drawX(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx + 20, o.dy + 40)
      ..moveTo(o.dx + 20, o.dy)
      ..lineTo(o.dx, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawY(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx + 10, o.dy + 20)
      ..lineTo(o.dx + 20, o.dy)
      ..moveTo(o.dx + 10, o.dy + 20)
      ..lineTo(o.dx + 10, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  void _drawZ(Canvas canvas, Paint paint, Offset o) {
    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..lineTo(o.dx + 20, o.dy)
      ..lineTo(o.dx, o.dy + 40)
      ..lineTo(o.dx + 20, o.dy + 40);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
