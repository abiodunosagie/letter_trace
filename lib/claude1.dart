import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

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
    setState(() {
      _isTracing = true;
      _currentFingerPosition = details.localPosition;
    });
  }
  
  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isTracing) return;
    
    setState(() {
      _currentFingerPosition = details.localPosition;
      
      // Check if finger is on the correct path (like staying inside the lines)
      bool isOnPath = _pathTracker.isPositionOnPath(
        details.localPosition, 
        tolerance: 25.0  // How close they need to be (in pixels)
      );
      
      if (isOnPath) {
        // Good! They're tracing correctly
        _pathTracker.updateProgress(details.localPosition);
        _totalProgress = _pathTracker.getOverallProgress();
        
        // Give them haptic feedback (like a gentle vibration)
        HapticFeedback.lightImpact();
        
        // Check if they completed the letter
        if (_totalProgress >= 0.95) { // 95% completion
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
              
              // Progress indicator (bottom left circle like in your image)
              Positioned(
                left: 20,
                bottom: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _totalProgress >= 0.95 ? Icons.check : Icons.touch_app,
                    color: Colors.white,
                    size: 24,
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
                        color: Colors.green.withOpacity(0.2 * _celebrationAnimation.value),
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
  
  void setupLetterI() {
    _segments = [];
    _fullPath = Path();
    
    // Letter "I" has 3 parts: top line, middle line, bottom line
    // Think of it like 3 separate drawing instructions
    
    // Top horizontal line
    PathSegment topLine = PathSegment(
      startPoint: Offset(100, 80),
      endPoint: Offset(200, 80),
      isCompleted: false,
    );
    
    // Middle vertical line  
    PathSegment middleLine = PathSegment(
      startPoint: Offset(150, 80),
      endPoint: Offset(150, 220),
      isCompleted: false,
    );
    
    // Bottom horizontal line
    PathSegment bottomLine = PathSegment(
      startPoint: Offset(100, 220),
      endPoint: Offset(200, 220),
      isCompleted: false,
    );
    
    _segments = [topLine, middleLine, bottomLine];
    
    // Create the full path for visual reference
    _fullPath.moveTo(100, 80);
    _fullPath.lineTo(200, 80);  // Top line
    _fullPath.moveTo(150, 80);
    _fullPath.lineTo(150, 220); // Middle line
    _fullPath.moveTo(100, 220);
    _fullPath.lineTo(200, 220); // Bottom line
  }
  
  bool isPositionOnPath(Offset position, {required double tolerance}) {
    // Check if the finger position is close enough to any segment
    for (var segment in _segments) {
      if (!segment.isCompleted) {
        double distance = _distanceToLineSegment(
          position, 
          segment.startPoint, 
          segment.endPoint
        );
        
        if (distance <= tolerance) {
          return true;
        }
      }
    }
    return false;
  }
  
  void updateProgress(Offset position) {
    // Find which segment they're currently tracing
    for (var segment in _segments) {
      if (!segment.isCompleted) {
        double distance = _distanceToLineSegment(
          position, 
          segment.startPoint, 
          segment.endPoint
        );
        
        if (distance <= 25.0) {
          // Calculate progress along this segment
          double segmentProgress = _calculateSegmentProgress(
            position, 
            segment.startPoint, 
            segment.endPoint
          );
          
          segment.progress = math.max(segment.progress, segmentProgress);
          
          // Mark as completed if they've traced most of it
          if (segment.progress >= 0.8) {
            segment.isCompleted = true;
          }
          break;
        }
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
  
  void reset() {
    for (var segment in _segments) {
      segment.progress = 0.0;
      segment.isCompleted = false;
    }
  }
  
  List<PathSegment> get segments => _segments;
  Path get fullPath => _fullPath;
  
  // Math helper: calculate distance from point to line segment
  double _distanceToLineSegment(Offset point, Offset lineStart, Offset lineEnd) {
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
  double _calculateSegmentProgress(Offset point, Offset lineStart, Offset lineEnd) {
    double totalLength = (lineEnd - lineStart).distance;
    if (totalLength == 0) return 1.0;
    
    // Project point onto line
    Offset lineVector = lineEnd - lineStart;
    Offset pointVector = point - lineStart;
    
    double dotProduct = pointVector.dx * lineVector.dx + pointVector.dy * lineVector.dy;
    double param = dotProduct / (totalLength * totalLength);
    
    return math.max(0.0, math.min(1.0, param));
  }
}

// This represents one part of the letter (like one line or curve)
class PathSegment {
  final Offset startPoint;
  final Offset endPoint;
  double progress;
  bool isCompleted;
  
  PathSegment({
    required this.startPoint,
    required this.endPoint,
    this.progress = 0.0,
    this.isCompleted = false,
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
    // Draw each segment of the letter "I"
    for (var segment in pathTracker.segments) {
      _drawSegment(canvas, segment);
    }
    
    // Draw the current finger position (like a cursor)
    if (currentPosition != null && isTracing) {
      _drawFingerIndicator(canvas, currentPosition!);
    }
    
    // Draw guidelines (light grid lines like notebook paper)
    _drawGuidelines(canvas, size);
  }
  
  void _drawSegment(Canvas canvas, PathSegment segment) {
    // Paint for the dotted outline (untraced part)
    Paint dottedPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    
    // Paint for the solid line (traced part)
    Paint solidPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    // Draw dotted outline for the whole segment
    Path dottedPath = Path();
    dottedPath.moveTo(segment.startPoint.dx, segment.startPoint.dy);
    dottedPath.lineTo(segment.endPoint.dx, segment.endPoint.dy);
    
    // Draw dotted line manually (Flutter doesn't have built-in dash)
    _drawDottedLine(canvas, segment.startPoint, segment.endPoint, dottedPaint);
    
    // Draw solid line for completed portion
    if (segment.progress > 0 || segment.isCompleted) {
      double drawProgress = segment.isCompleted ? 1.0 : segment.progress;
      
      Offset progressPoint = Offset(
        segment.startPoint.dx + (segment.endPoint.dx - segment.startPoint.dx) * drawProgress,
        segment.startPoint.dy + (segment.endPoint.dy - segment.startPoint.dy) * drawProgress,
      );
      
      Path solidPath = Path();
      solidPath.moveTo(segment.startPoint.dx, segment.startPoint.dy);
      solidPath.lineTo(progressPoint.dx, progressPoint.dy);
      
      canvas.drawPath(solidPath, solidPaint);
    }
  }
  
  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    double totalDistance = (end - start).distance;
    double dashLength = 10.0;
    double gapLength = 5.0;
    double dashGapLength = dashLength + gapLength;
    
    int dashCount = (totalDistance / dashGapLength).floor();
    
    for (int i = 0; i < dashCount; i++) {
      double startRatio = (i * dashGapLength) / totalDistance;
      double endRatio = ((i * dashGapLength) + dashLength) / totalDistance;
      
      Offset dashStart = Offset(
        start.dx + (end.dx - start.dx) * startRatio,
        start.dy + (end.dy - start.dy) * startRatio,
      );
      
      Offset dashEnd = Offset(
        start.dx + (end.dx - start.dx) * endRatio,
        start.dy + (end.dy - start.dy) * endRatio,
      );
      
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }
  
  void _drawFingerIndicator(Canvas canvas, Offset position) {
    // Draw a circle where their finger is
    Paint fingerPaint = Paint()
      ..color = Colors.blue.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(position, 15, fingerPaint);
    
    // Draw a white center
    Paint centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(position, 8, centerPaint);
  }
  
  void _drawGuidelines(Canvas canvas, Size size) {
    // Draw light horizontal lines like notebook paper
    Paint guidelinePaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    
    // Draw horizontal lines
    for (double y = 80; y <= 220; y += 35) {
      canvas.drawLine(
        Offset(50, y),
        Offset(250, y),
        guidelinePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint when state changes
  }
}