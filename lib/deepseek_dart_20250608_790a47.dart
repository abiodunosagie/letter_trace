import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class LetterPathDatabase {
  static final Map<String, Path> _paths = {};

  static Future<void> initialize() async {
    const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    for (final letter in letters.split('')) {
      final rawPath = await getLetterPath(letter);
      final normalized = _normalizePath(rawPath);
      _paths[letter] = _simplifyPath(normalized);
    }
  }

  static Path getPath(String letter) => _paths[letter] ?? Path();
}

Future<Path> getLetterPath(String letter, {double size = 300}) async {
  final textStyle = TextStyle(
    fontSize: size,
    fontFamily: 'PrintClearly',
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  final TextPainter painter = TextPainter(
    text: TextSpan(text: letter, style: textStyle),
    textDirection: TextDirection.ltr,
  )..layout();

  final recorder = ui.PictureRecorder();
  // FIXED: Use correct Rect constructor instead of & operator
  final canvas =
      Canvas(recorder, Rect.fromLTWH(0, 0, painter.width, painter.height));
  painter.paint(canvas, Offset.zero);

  final picture = recorder.endRecording();
  final image =
      await picture.toImage(painter.width.toInt(), painter.height.toInt());
  return extractPathFromImage(image);
}

Future<Path> extractPathFromImage(ui.Image image) async {
  final byteData = await image.toByteData();
  if (byteData == null) return Path();

  final pixels = byteData.buffer.asUint8List();
  final width = image.width;
  final height = image.height;
  final path = Path();
  const threshold = 128;

  // Find all black pixels (assuming black text on transparent background)
  final points = <Offset>[];
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final index = (y * width + x) * 4;
      final r = pixels[index];
      final g = pixels[index + 1];
      final b = pixels[index + 2];
      final luminance = (0.2126 * r + 0.7152 * g + 0.0722 * b);

      if (luminance < threshold) {
        points.add(Offset(x.toDouble(), y.toDouble()));
      }
    }
  }

  // Create path from detected points
  if (points.isNotEmpty) {
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      if ((points[i] - points[i - 1]).distance < 5) {
        path.lineTo(points[i].dx, points[i].dy);
      } else {
        path.moveTo(points[i].dx, points[i].dy);
      }
    }
  }

  return path;
}

Path _normalizePath(Path path) {
  final bounds = path.getBounds();
  if (bounds.size.isEmpty) return path;

  final scale = 100 / math.max(bounds.width, bounds.height);
  final matrix = Matrix4.identity()
    ..translate(-bounds.left, -bounds.top)
    ..scale(scale, scale);

  return path.transform(matrix.storage);
}

Path _simplifyPath(Path input, {double tolerance = 1.0}) {
  final metrics = input.computeMetrics();
  final newPath = Path();

  for (final metric in metrics) {
    final points = <Offset>[];
    for (double t = 0; t <= 1; t += 0.02) {
      final tangent = metric.getTangentForOffset(t * metric.length);
      if (tangent != null) points.add(tangent.position);
    }

    if (points.isNotEmpty) {
      final simplified = _rdp(points, tolerance);
      newPath.moveTo(simplified[0].dx, simplified[0].dy);
      for (int i = 1; i < simplified.length; i++) {
        newPath.lineTo(simplified[i].dx, simplified[i].dy);
      }
    }
  }

  return newPath;
}

double _perpendicularDistance(Offset point, Offset lineStart, Offset lineEnd) {
  if (lineStart == lineEnd) return (point - lineStart).distance;

  final area = (lineEnd.dx - lineStart.dx) * (lineStart.dy - point.dy) -
      (lineStart.dx - point.dx) * (lineEnd.dy - lineStart.dy);
  final lineLength = math.sqrt(math.pow(lineEnd.dx - lineStart.dx, 2) +
      math.pow(lineEnd.dy - lineStart.dy, 2));

  return area.abs() / lineLength;
}

List<Offset> _rdp(List<Offset> points, double epsilon) {
  if (points.length < 3) return points;

  double maxDistance = 0;
  int index = 0;

  for (int i = 1; i < points.length - 1; i++) {
    final distance =
        _perpendicularDistance(points[i], points.first, points.last);

    if (distance > maxDistance) {
      maxDistance = distance;
      index = i;
    }
  }

  if (maxDistance > epsilon) {
    final left = _rdp(points.sublist(0, index + 1), epsilon);
    final right = _rdp(points.sublist(index), epsilon);
    return [...left, ...right.sublist(1)];
  }

  return [points.first, points.last];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LetterPathDatabase.initialize();
  runApp(const LetterTracingApp());
}

class LetterTracingApp extends StatelessWidget {
  const LetterTracingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: LetterPainter(letter: 'A'),
          ),
        ),
      ),
    );
  }
}

class LetterPainter extends CustomPainter {
  final String letter;

  LetterPainter({required this.letter});

  @override
  void paint(Canvas canvas, Size size) {
    final path = LetterPathDatabase.getPath(letter);
    final bounds = path.getBounds();

    if (bounds.size.isEmpty) return;

    final scale = size.width / bounds.width * 0.8;

    canvas.translate(
      (size.width - bounds.width * scale) / 2,
      (size.height - bounds.height * scale) / 2,
    );
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LetterPainter oldDelegate) => oldDelegate.letter != letter;
}
