import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Letter I Tracing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: LetterTracingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LetterTracingScreen extends StatefulWidget {
  const LetterTracingScreen({super.key});

  @override
  _LetterTracingScreenState createState() => _LetterTracingScreenState();
}

class _LetterTracingScreenState extends State<LetterTracingScreen>
    with TickerProviderStateMixin {
  // Think of these as the "game state" variables
  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;

  // Path tracking - like a map of where the user should trace
  final PathTracker _pathTracker = PathTracker();

  // Current tracing state
  Offset? _currentFingerPosition;
  bool _isTracing = false;
  double _totalProgress = 0.0;

  // Visual feedback
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();

    // Setup celebration animation (like confetti when they finish)
    _celebrationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));

    // Initialize the letter "I" path
    _pathTracker.setupLetterI();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    // Check if they're starting at the correct arrow position
    if (_pathTracker.canStartTracing(details.localPosition, tolerance: 30.0)) {
      setState(() {
        _isTracing = true;
        _currentFingerPosition = details.localPosition;
      });
    } else {
      // Give feedback that they need to start at the arrow
      HapticFeedback.selectionClick();
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isTracing) return;

    setState(() {
      _currentFingerPosition = details.localPosition;

      // Check if finger is on the correct path (like staying inside the lines)
      bool isOnPath = _pathTracker.isPositionOnPath(details.localPosition,
          tolerance: 30.0 // Increased tolerance for thicker letter
          );

      if (isOnPath) {
        // Good! They're tracing correctly
        _pathTracker.updateProgress(details.localPosition);
        _totalProgress = _pathTracker.getOverallProgress();

        // Give them haptic feedback (like a gentle vibration)
        HapticFeedback.lightImpact();

        // Check if they completed the letter
        if (_pathTracker.isAllCompleted()) {
          _onLetterCompleted();
        }
      }
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _isTracing = false;
      _currentFingerPosition = null;
    });
  }

  void _onLetterCompleted() {
    setState(() {
      _showCelebration = true;
    });

    // Trigger celebration animation
    _celebrationController.forward();

    // Heavy haptic feedback for success
    HapticFeedback.heavyImpact();

    // Reset after celebration
    Future.delayed(Duration(seconds: 2), () {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7), // Light purple like in your image
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () {},
        ),
        title: Text(
          'SPIEL 2',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
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
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main tracing area
              GestureDetector(
                onPanStart: _handlePanStart,
                onPanUpdate: _handlePanUpdate,
                onPanEnd: _handlePanEnd,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: LetterIPainter(
                      pathTracker: _pathTracker,
                      currentPosition: _currentFingerPosition,
                      isTracing: _isTracing,
                      progress: _totalProgress,
                    ),
                  ),
                ),
              ),

              // Celebration overlay
              if (_showCelebration)
                AnimatedBuilder(
                  animation: _celebrationAnimation,
                  builder: (context, child) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green
                            .withOpacity(0.2 * _celebrationAnimation.value),
                      ),
                      child: Center(
                        child: Transform.scale(
                          scale: _celebrationAnimation.value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 80,
                                color: Colors.amber,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Great Job!',
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
        child: Icon(Icons.refresh),
      ),
    );
  }
}

// This is like the "instruction manual" for drawing letter I
class PathTracker {
  late List<PathSegment> _segments;
  late Path _fullPath;
  int _currentSegmentIndex = 0;

  void setupLetterI() {
    _segments = [];
    _fullPath = Path();

    // Letter "I" as a simple vertical line (top to bottom)
    PathSegment verticalLine = PathSegment(
      startPoint: Offset(150, 100),
      endPoint: Offset(150, 260),
      order: 1,
      direction: math.pi / 2,
      // Pointing down (90 degrees)
      isActive: true, // Start with this one active
    );

    _segments = [verticalLine];
    _currentSegmentIndex = 0;

    // Create the full path for visual reference - ONLY the vertical line
    _fullPath.moveTo(150, 100);
    _fullPath.lineTo(150, 260); // Single vertical line only
  }

  bool isPositionOnPath(Offset position, {required double tolerance}) {
    // Only check the currently active segment
    if (_currentSegmentIndex >= _segments.length) return false;

    PathSegment currentSegment = _segments[_currentSegmentIndex];

    // Check if they're starting near the arrow (start point)
    if (!currentSegment.isStarted) {
      double distanceToStart = (position - currentSegment.startPoint).distance;
      return distanceToStart <= tolerance;
    }

    // If already started, check if they're on the path
    double distance = _distanceToLineSegment(
        position, currentSegment.startPoint, currentSegment.endPoint);

    return distance <= tolerance;
  }

  bool canStartTracing(Offset position, {required double tolerance}) {
    // Check if user is near the start arrow of the current segment
    if (_currentSegmentIndex >= _segments.length) return false;

    PathSegment currentSegment = _segments[_currentSegmentIndex];
    double distanceToStart = (position - currentSegment.startPoint).distance;

    return distanceToStart <= tolerance;
  }

  void updateProgress(Offset position) {
    if (_currentSegmentIndex >= _segments.length) return;

    PathSegment currentSegment = _segments[_currentSegmentIndex];

    // If not started yet, check if they're near the start arrow
    if (!currentSegment.isStarted) {
      if (canStartTracing(position, tolerance: 30.0)) {
        currentSegment.isStarted = true;
      } else {
        return; // Can't trace until they start at the arrow
      }
    }

    // Calculate progress along this segment
    double segmentProgress = _calculateSegmentProgress(
        position, currentSegment.startPoint, currentSegment.endPoint);

    // Only allow forward progress (no going backwards)
    currentSegment.progress =
        math.max(currentSegment.progress, segmentProgress);

    // Mark as completed if they've traced most of it
    if (currentSegment.progress >= 0.85) {
      currentSegment.isCompleted = true;
      currentSegment.isActive = false;

      // Move to next segment
      _currentSegmentIndex++;
      if (_currentSegmentIndex < _segments.length) {
        _segments[_currentSegmentIndex].isActive = true;
      }
    }
  }

  double getOverallProgress() {
    double totalProgress = 0.0;
    for (var segment in _segments) {
      totalProgress += segment.isCompleted ? 1.0 : segment.progress;
    }
    return totalProgress / _segments.length;
  }

  PathSegment? getCurrentSegment() {
    if (_currentSegmentIndex >= _segments.length) return null;
    return _segments[_currentSegmentIndex];
  }

  bool isAllCompleted() {
    return _currentSegmentIndex >= _segments.length;
  }

  void reset() {
    _currentSegmentIndex = 0;
    for (int i = 0; i < _segments.length; i++) {
      _segments[i].progress = 0.0;
      _segments[i].isCompleted = false;
      _segments[i].isActive = (i == 0); // Only first segment is active
      _segments[i].isStarted = false;
    }
  }

  List<PathSegment> get segments => _segments;

  Path get fullPath => _fullPath;

  // Math helper: calculate distance from point to line segment
  double _distanceToLineSegment(
      Offset point, Offset lineStart, Offset lineEnd) {
    double A = point.dx - lineStart.dx;
    double B = point.dy - lineStart.dy;
    double C = lineEnd.dx - lineStart.dx;
    double D = lineEnd.dy - lineStart.dy;

    double dot = A * C + B * D;
    double lenSq = C * C + D * D;
    double param = -1;

    if (lenSq != 0) {
      param = dot / lenSq;
    }

    double xx, yy;

    if (param < 0) {
      xx = lineStart.dx;
      yy = lineStart.dy;
    } else if (param > 1) {
      xx = lineEnd.dx;
      yy = lineEnd.dy;
    } else {
      xx = lineStart.dx + param * C;
      yy = lineStart.dy + param * D;
    }

    double dx = point.dx - xx;
    double dy = point.dy - yy;
    return math.sqrt(dx * dx + dy * dy);
  }

  // Calculate how far along a line segment the point is
  double _calculateSegmentProgress(
      Offset point, Offset lineStart, Offset lineEnd) {
    double totalLength = (lineEnd - lineStart).distance;
    if (totalLength == 0) return 1.0;

    // Project point onto line
    Offset lineVector = lineEnd - lineStart;
    Offset pointVector = point - lineStart;

    double dotProduct =
        pointVector.dx * lineVector.dx + pointVector.dy * lineVector.dy;
    double param = dotProduct / (totalLength * totalLength);

    return math.max(0.0, math.min(1.0, param));
  }
}

// This represents one part of the letter (like one line or curve)
class PathSegment {
  final Offset startPoint;
  final Offset endPoint;
  final int order; // Which step in the sequence (1, 2, 3...)
  final double direction; // Arrow direction in radians
  double progress;
  bool isCompleted;
  bool isActive; // Is this the current segment to trace?
  bool isStarted; // Has user started tracing this segment?

  PathSegment({
    required this.startPoint,
    required this.endPoint,
    required this.order,
    required this.direction,
    this.progress = 0.0,
    this.isCompleted = false,
    this.isActive = false,
    this.isStarted = false,
  });
}

// This is the "artist" that draws everything on screen
class LetterIPainter extends CustomPainter {
  final PathTracker pathTracker;
  final Offset? currentPosition;
  final bool isTracing;
  final double progress;

  LetterIPainter({
    required this.pathTracker,
    this.currentPosition,
    required this.isTracing,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw guidelines first (behind the letter)
    //_drawGuidelines(canvas, size);

    // Draw the single vertical line segment
    for (var segment in pathTracker.segments) {
      _drawSegment(canvas, segment);
    }

    // Draw the current finger position
    if (currentPosition != null && isTracing) {
      _drawFingerIndicator(canvas, currentPosition!);
    }
  }

  void _drawSegment(Canvas canvas, PathSegment segment) {
    // Paint for the background line (light blue)
    Paint backgroundPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 40
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt; // Changed to butt to avoid rounded ends

    // Paint for the traced line (solid blue)
    Paint tracedPaint = Paint()
      ..color = segment.isCompleted ? Colors.green : Colors.blue
      ..strokeWidth = 40
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt; // Changed to butt to avoid rounded ends

    // Draw the full line in light blue (untraced part)
    canvas.drawLine(segment.startPoint, segment.endPoint, backgroundPaint);

    // Draw thick blue dashed line in the middle of the letter
    _drawMiddleDashedLine(canvas, segment);

    // Draw solid line for completed portion
    if (segment.progress > 0 || segment.isCompleted) {
      double drawProgress = segment.isCompleted ? 1.0 : segment.progress;

      Offset progressPoint = Offset(
        segment.startPoint.dx +
            (segment.endPoint.dx - segment.startPoint.dx) * drawProgress,
        segment.startPoint.dy +
            (segment.endPoint.dy - segment.startPoint.dy) * drawProgress,
      );

      canvas.drawLine(segment.startPoint, progressPoint, tracedPaint);
    }

    // Draw directional arrow for active segment
    if (segment.isActive && !segment.isCompleted && !segment.isStarted) {
      _drawStartIndicator(canvas, segment);
    }
  }

  void _drawMiddleDashedLine(Canvas canvas, PathSegment segment) {
    // Paint for the dashes
    final Paint dashedPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Compute the X position halfway between start and end
    final double middleX = (segment.startPoint.dx + segment.endPoint.dx) / 2;

    // We'll dash along the vertical span of the segment
    final double startY = segment.startPoint.dy;
    final double endY = segment.endPoint.dy;

    // Dash configuration
    const double dashHeight = 6;
    const double dashSpace = 4;

    double currentY = startY;
    while (currentY < endY) {
      final double nextY = math.min(currentY + dashHeight, endY);
      // Draw a vertical dash from (middleX, currentY) to (middleX, nextY)
      canvas.drawLine(
        Offset(middleX, currentY),
        Offset(middleX, nextY),
        dashedPaint,
      );
      currentY += dashHeight + dashSpace;
    }
  }

  void _drawStartIndicator(Canvas canvas, PathSegment segment) {
    // Tweak these to taste
    final double circleRadius = 20; // was 25
    final double shaftHalfLength = 6; // was 10
    final double arrowHeadHalfWidth = 8; // was 8
    final double arrowHeadHeight = 8; // was 12

    // Draw smaller blue circle
    Paint circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(segment.startPoint, circleRadius, circlePaint);

    // Shaft of the arrow
    Paint shaftPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(segment.startPoint.dx, segment.startPoint.dy - shaftHalfLength),
      Offset(segment.startPoint.dx, segment.startPoint.dy + shaftHalfLength),
      shaftPaint,
    );

    // Arrowhead (triangle)
    Paint headFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path head = Path()
      ..moveTo(segment.startPoint.dx - arrowHeadHalfWidth,
          segment.startPoint.dy + (shaftHalfLength - 2))
      ..lineTo(segment.startPoint.dx + arrowHeadHalfWidth,
          segment.startPoint.dy + (shaftHalfLength - 2))
      ..lineTo(segment.startPoint.dx,
          segment.startPoint.dy + (shaftHalfLength - 2) + arrowHeadHeight)
      ..close();
    canvas.drawPath(head, headFill);
  }

  void _drawFingerIndicator(Canvas canvas, Offset position) {
    // Draw a circle where their finger is
    Paint fingerPaint = Paint()
      ..color = Colors.blue.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 20, fingerPaint);

    // Draw a white center
    Paint centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 10, centerPaint);
  }

  // void _drawGuidelines(Canvas canvas, Size size) {
  //   // Draw horizontal dashed line through the middle of the letter
  //   Paint guidelinePaint = Paint()
  //     ..color = Colors.grey.withOpacity(0.2)
  //     ..strokeWidth = 2
  //     ..style = PaintingStyle.stroke;
  //
  //   // Calculate middle Y position (halfway between start and end of letter)
  //   double middleY = 180; // Middle of the letter
  //
  //   // Create dashed line effect
  //   double dashWidth = 10;
  //   double dashSpace = 5;
  //   double currentX = 80; // Start a bit before the letter
  //   double endX = 220; // End a bit after the letter
  //
  //   while (currentX < endX) {
  //     canvas.drawLine(
  //         Offset(currentX, middleY),
  //         Offset(math.min(currentX + dashWidth, endX), middleY),
  //         guidelinePaint);
  //     currentX += dashWidth + dashSpace;
  //   }
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint when state changes
  }
}
