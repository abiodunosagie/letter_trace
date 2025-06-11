import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Letter C Tracing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: const LetterTracingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LetterTracingScreen extends StatefulWidget {
  const LetterTracingScreen({super.key});

  @override
  LetterTracingScreenState createState() => LetterTracingScreenState();
}

class LetterTracingScreenState extends State<LetterTracingScreen>
    with TickerProviderStateMixin {
  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final PathTracker _pathTracker = PathTracker();

  Offset? _currentFingerPosition;
  bool _isTracing = false;
  double _totalProgress = 0.0;
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pathTracker.setupLetterC();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    if (_pathTracker.canStartDragging(details.localPosition, tolerance: 30.0)) {
      setState(() {
        _isTracing = true;
        _currentFingerPosition = details.localPosition;
        _pathTracker.startDragging();
      });
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isTracing) return;

    Offset previousArrowPosition = _pathTracker.currentArrowPosition;

    setState(() {
      _currentFingerPosition = details.localPosition;
      _pathTracker.updateArrowPosition(details.localPosition);
      _totalProgress = _pathTracker.getOverallProgress();

      bool arrowMoved =
          (_pathTracker.currentArrowPosition - previousArrowPosition).distance >
              1.0;

      if (arrowMoved) {
        HapticFeedback.lightImpact();
      } else {
        if (DateTime.now().millisecondsSinceEpoch % 200 < 50) {
          HapticFeedback.selectionClick();
        }
      }

      if (_pathTracker.isCompleted()) {
        _onLetterCompleted();
      }
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _isTracing = false;
      _currentFingerPosition = null;
      _pathTracker.stopDragging();
    });
  }

  void _onLetterCompleted() {
    setState(() {
      _showCelebration = true;
    });

    _celebrationController.forward();
    HapticFeedback.heavyImpact();

    Future.delayed(const Duration(seconds: 2), () {
      _resetLetter();
    });
  }

  void _resetLetter() {
    setState(() {
      _showCelebration = false;
      _totalProgress = 0.0;
      _pathTracker.reset();
    });
    _celebrationController.reset();
    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () {},
        ),
        title: const Text(
          'TRACE LETTER C',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(
                right: 16.0), // Added .0 for consistency with EdgeInsets
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              // Removed const as Text('🍎') might not be const depending on Flutter version/lints
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('3', style: TextStyle(color: Colors.white)),
                SizedBox(width: 4),
                Text('🍎', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ), // Consider replacing with Colors.black.withAlpha((0.1 * 255).round()) if withOpacity is flagged elsewhere
            ],
          ),
          child: Stack(
            children: [
              GestureDetector(
                onPanStart: _handlePanStart,
                onPanUpdate: _handlePanUpdate,
                onPanEnd: _handlePanEnd,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: LetterCPainter(
                      pathTracker: _pathTracker,
                      currentPosition: _currentFingerPosition,
                      isTracing: _isTracing,
                      progress: _totalProgress,
                      pulseAnimation: _pulseAnimation,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _totalProgress >= 0.95 ? Colors.green : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _totalProgress >= 0.95
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : const Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              if (_showCelebration)
                AnimatedBuilder(
                  animation: _celebrationAnimation,
                  builder: (context, child) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withAlpha(
                            (0.2 * _celebrationAnimation.value * 255).round()),
                      ),
                      child: Center(
                        child: Transform.scale(
                          scale: _celebrationAnimation.value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 80,
                                color: Colors.amber,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Perfect C!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetLetter,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class PathTracker {
  late Path _fullPath;
  late double _totalLength;
  double _currentDistance = 0.0;
  bool _isCompleted = false;
  bool _isDragging = false;
  bool _isStarted = false;
  bool _isOnPath = true;
  late Offset _currentArrowPosition;
  late double _currentTangentAngle;

  void setupLetterC() {
    _fullPath = _createLetterCPath();
    _totalLength = _computePathLength(_fullPath);
    _resetArrowPosition();
  }

  Path _createLetterCPath() {
    final path = Path();
    const center = Offset(150, 150);
    final radius = 60.0; // Made non-const to allow access to center.dx/dy

    // Start at upper left (135 degrees - in second quadrant)
    final startAngle = -3 * math.pi / 4; // 135 degrees
    final startX = center.dx + radius * math.cos(startAngle);
    final startY = center.dy + radius * math.sin(startAngle);

    path.moveTo(startX, startY);

    // Draw a 180-degree arc clockwise to lower left (same horizontal level)
    // This creates a C that opens to the right
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, // Starting angle: 135 degrees (upper left)
      math.pi, // Sweep angle: 180 degrees clockwise
      false,
    );

    return path;
  }

  double _computePathLength(Path path) {
    final metrics = path.computeMetrics();
    return metrics.fold(0.0, (sum, metric) => sum + metric.length);
  }

  void _resetArrowPosition() {
    final tangent = _getTangentAtDistance(0.0);
    _currentArrowPosition = tangent.position;
    _currentTangentAngle = math.atan2(tangent.vector.dy, tangent.vector.dx);
  }

  Tangent _getTangentAtDistance(double distance) {
    final metrics = _fullPath.computeMetrics();
    for (final metric in metrics) {
      if (distance <= metric.length) {
        return metric.getTangentForOffset(distance)!;
      }
      distance -= metric.length;
    }
    return _fullPath.computeMetrics().first.getTangentForOffset(0.0)!;
  }

  bool canStartDragging(Offset position, {required double tolerance}) {
    return (position - _currentArrowPosition).distance <= tolerance;
  }

  void updateArrowPosition(Offset fingerPosition) {
    if (!_isDragging) return;

    // Check distance to current arrow position
    double distanceToCurrentArrow =
        (fingerPosition - _currentArrowPosition).distance;
    if (distanceToCurrentArrow > 35.0) {
      _isOnPath = false;
      return;
    }

    // Find closest point on path to finger
    double closestDistance = double.infinity;
    double closestPathDistance = _currentDistance;

    // Sample points along the path near current position
    for (double d = math.max(0, _currentDistance - 20);
        d <= math.min(_totalLength, _currentDistance + 20);
        d += 2) {
      final tangent = _getTangentAtDistance(d);
      final distanceToFinger = (tangent.position - fingerPosition).distance;
      if (distanceToFinger < closestDistance) {
        closestDistance = distanceToFinger;
        closestPathDistance = d;
      }
    }

    // Validate movement
    double progressDiff =
        (closestPathDistance - _currentDistance) / _totalLength;

    // Only allow forward movement or small corrections backward
    if (progressDiff >= -0.02 && progressDiff <= 0.05) {
      _isOnPath = true;
      _currentDistance = closestPathDistance;
      final tangent = _getTangentAtDistance(_currentDistance);
      _currentArrowPosition = tangent.position;
      _currentTangentAngle = math.atan2(tangent.vector.dy, tangent.vector.dx);

      // Check for completion
      if (_currentDistance / _totalLength >= 0.95) {
        _isCompleted = true;
        // Snap to end
        final endTangent = _getTangentAtDistance(_totalLength);
        _currentArrowPosition = endTangent.position;
        _currentTangentAngle =
            math.atan2(endTangent.vector.dy, endTangent.vector.dx);
      }
    } else {
      _isOnPath = false;
    }
  }

  void startDragging() {
    _isDragging = true;
    _isStarted = true;
  }

  void stopDragging() {
    _isDragging = false;
  }

  double getOverallProgress() {
    return _currentDistance / _totalLength;
  }

  bool isCompleted() {
    return _isCompleted;
  }

  void reset() {
    _currentDistance = 0.0;
    _isCompleted = false;
    _isDragging = false;
    _isStarted = false;
    _isOnPath = true;
    _resetArrowPosition();
  }

  Path get fullPath => _fullPath;
  Offset get currentArrowPosition => _currentArrowPosition;
  double get currentTangentAngle => _currentTangentAngle;
  bool get isDragging => _isDragging;
  bool get isOnPath => _isOnPath;
  bool get isStarted => _isStarted;
}

class LetterCPainter extends CustomPainter {
  final PathTracker pathTracker;
  final Offset? currentPosition;
  final bool isTracing;
  final double progress;
  final Animation<double> pulseAnimation;

  LetterCPainter({
    required this.pathTracker,
    this.currentPosition,
    required this.isTracing,
    required this.progress,
    required this.pulseAnimation,
  }) : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    _drawLetterC(canvas);

    if (currentPosition != null && isTracing) {
      _drawFingerIndicator(canvas, currentPosition!);
    }

    _drawGuidelines(canvas, size);
  }

  void _drawLetterC(Canvas canvas) {
    // Draw the entire C path as dotted line
    Paint dottedPaint = Paint()
      ..color = Colors.blue.withAlpha((0.4 * 255).round())
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    _drawDottedPath(canvas, pathTracker.fullPath, dottedPaint);

    // Draw the traced portion of C
    if (progress > 0) {
      Paint solidPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      Path tracedPath = _extractSubPath(pathTracker.fullPath, progress);
      canvas.drawPath(tracedPath, solidPaint);
    }

    // Draw starting position indicator
    if (progress < 0.1) {
      final startTangent =
          pathTracker.fullPath.computeMetrics().first.getTangentForOffset(0.0)!;
      _drawStartingPositionIndicator(canvas, startTangent.position);
    }

    // Draw the zipper pull
    if (!pathTracker.isCompleted()) {
      _drawZipperPull(canvas);
    }

    // Draw center letter indicator
    _drawCenterLetter(canvas);
  }

  Path _extractSubPath(Path path, double progress) {
    final metrics = path.computeMetrics();
    double totalLength = 0.0;
    Path subPath = Path();

    for (final metric in metrics) {
      totalLength = metric.length;
      subPath = metric.extractPath(0, totalLength * progress);
      break;
    }

    return subPath;
  }

  void _drawDottedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      final pathLength = metric.length;
      double dashLength = 10.0;
      double gapLength = 5.0;
      double dashGapLength = dashLength + gapLength;
      int dashCount = (pathLength / dashGapLength).floor();

      for (int i = 0; i < dashCount; i++) {
        final start = i * dashGapLength;
        final end = start + dashLength;
        if (end > pathLength) break;

        final dashPath = metric.extractPath(start, end);
        canvas.drawPath(dashPath, paint);
      }
    }
  }

  void _drawZipperPull(Canvas canvas) {
    Offset pullPosition = pathTracker.currentArrowPosition;

    // Determine color based on state
    Color pullColor;
    if (!pathTracker.isOnPath && pathTracker.isDragging) {
      pullColor = Colors.red;
    } else if (pathTracker.isDragging) {
      pullColor = Colors.orange;
    } else {
      pullColor = Colors.blue;
    }

    // Draw zipper pull body
    Paint pullBodyPaint = Paint()
      ..color = pullColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pullPosition, 18, pullBodyPaint);

    // Draw inner circle
    Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pullPosition, 12, innerPaint);

    // Draw arrow in direction of tangent
    double arrowSize = 8;
    Offset arrowDirection = Offset(
      math.cos(pathTracker.currentTangentAngle),
      math.sin(pathTracker.currentTangentAngle),
    );

    Path arrowPath = Path();
    Offset tip = Offset(
      pullPosition.dx + arrowDirection.dx * arrowSize,
      pullPosition.dy + arrowDirection.dy * arrowSize,
    );

    Offset base1 = Offset(
      pullPosition.dx - arrowDirection.dx * 4 + arrowDirection.dy * 6,
      pullPosition.dy - arrowDirection.dy * 4 - arrowDirection.dx * 6,
    );

    Offset base2 = Offset(
      pullPosition.dx - arrowDirection.dx * 4 - arrowDirection.dy * 6,
      pullPosition.dy - arrowDirection.dy * 4 + arrowDirection.dx * 6,
    );

    arrowPath.moveTo(tip.dx, tip.dy);
    arrowPath.lineTo(base1.dx, base1.dy);
    arrowPath.lineTo(base2.dx, base2.dy);
    arrowPath.close();

    Paint arrowPaint = Paint()
      ..color = pullColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(arrowPath, arrowPaint);

    // Draw warning if off path
    if (!pathTracker.isOnPath && pathTracker.isDragging) {
      Paint warningPaint = Paint()
        ..color =
            Colors.red.withAlpha((0.8 * pulseAnimation.value * 255).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;

      canvas.drawCircle(
          pullPosition, 30 + (10 * pulseAnimation.value), warningPaint);

      // Draw "X" symbol
      Paint xPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      double xSize = 8;
      canvas.drawLine(
        Offset(pullPosition.dx - xSize, pullPosition.dy - xSize),
        Offset(pullPosition.dx + xSize, pullPosition.dy + xSize),
        xPaint,
      );
      canvas.drawLine(
        Offset(pullPosition.dx + xSize, pullPosition.dy - xSize),
        Offset(pullPosition.dx - xSize, pullPosition.dy + xSize),
        xPaint,
      );
    }
    // Pulsing effect when idle
    else if (!pathTracker.isDragging) {
      Paint pulsePaint = Paint()
        ..color =
            Colors.blue.withAlpha((0.3 * pulseAnimation.value * 255).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawCircle(
          pullPosition, 25 + (5 * pulseAnimation.value), pulsePaint);
    }

    // Draw hint text
    if (!pathTracker.isStarted) {
      _drawHintText(canvas, pullPosition, "Drag along C path!");
    } else if (!pathTracker.isOnPath && pathTracker.isDragging) {
      _drawHintText(canvas, pullPosition, "Follow the path!");
    }
  }

  void _drawStartingPositionIndicator(Canvas canvas, Offset position) {
    Paint startIndicatorPaint = Paint()
      ..color = Colors.green.withAlpha((0.3 * 255).round())
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 8, startIndicatorPaint);

    // Draw "START" text
    TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: "START",
        style: TextStyle(
          color: Colors.green,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(position.dx - textPainter.width / 2, position.dy - 25),
    );
  }

  void _drawCenterLetter(Canvas canvas) {
    // Find center of the path
    final bounds = pathTracker.fullPath.getBounds();
    final center = Offset(
      bounds.left + bounds.width / 2,
      bounds.top + bounds.height / 2,
    );

    Paint backgroundPaint = Paint()
      ..color = progress >= 0.95 ? Colors.green : Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 20, backgroundPaint);

    TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: 'C',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  void _drawHintText(Canvas canvas, Offset position, String text) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Position text above the zipper pull
    Offset textPosition = Offset(
      position.dx - textPainter.width / 2,
      position.dy - 40,
    );

    // Draw background
    Paint backgroundPaint = Paint()
      ..color = Colors.white.withAlpha((0.8 * 255).round())
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          textPosition.dx - 4,
          textPosition.dy - 2,
          textPainter.width + 8,
          textPainter.height + 4,
        ),
        const Radius.circular(4),
      ),
      backgroundPaint,
    );

    textPainter.paint(canvas, textPosition);
  }

  void _drawFingerIndicator(Canvas canvas, Offset position) {
    Color fingerColor = pathTracker.isOnPath ? Colors.blue : Colors.red;

    Paint fingerPaint = Paint()
      ..color = fingerColor.withAlpha((0.7 * 255).round())
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 15, fingerPaint);

    Paint centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 8, centerPaint);

    if (!pathTracker.isOnPath) {
      Paint warningPaint = Paint()
        ..color = Colors.red.withAlpha((0.5 * 255).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawCircle(position, 20, warningPaint);
    }
  }

  void _drawGuidelines(Canvas canvas, Size size) {
    Paint guidelinePaint = Paint()
      ..color = Colors.grey.withAlpha((0.2 * 255).round())
      ..strokeWidth = 1;

    // Center crosshairs
    canvas.drawLine(
      Offset(size.width / 2, 50),
      Offset(size.width / 2, size.height - 50),
      guidelinePaint,
    );

    canvas.drawLine(
      Offset(50, size.height / 2),
      Offset(size.width - 50, size.height / 2),
      guidelinePaint,
    );

    // Draw C-specific guides
    Paint cGuidePaint = Paint()
      ..color = Colors.blue.withAlpha((0.1 * 255).round())
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const center = Offset(150, 150);
    const radius = 60.0;

    // Draw reference circle
    canvas.drawCircle(center, radius, cGuidePaint);

    // Draw angle markers for the new C shape
    // Start position (135 degrees)
    canvas.drawLine(
      center,
      Offset(center.dx + radius * math.cos(-3 * math.pi / 4),
          center.dy + radius * math.sin(-3 * math.pi / 4)),
      cGuidePaint,
    );

    // End position (315 degrees / -45 degrees)
    canvas.drawLine(
      center,
      Offset(center.dx + radius * math.cos(math.pi / 4),
          center.dy + radius * math.sin(math.pi / 4)),
      cGuidePaint,
    );

    // Left side (180 degrees)
    canvas.drawLine(
      center,
      Offset(center.dx + radius * math.cos(math.pi),
          center.dy + radius * math.sin(math.pi)),
      cGuidePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
