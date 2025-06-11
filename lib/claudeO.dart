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
      title: 'Letter O Tracing',
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
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  // Path tracking - like a circular zipper track
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
    
    // Setup pulse animation for zipper pull
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Initialize the letter "O" path
    _pathTracker.setupLetterO();
  }
  
  @override
  void dispose() {
    _celebrationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  void _handlePanStart(DragStartDetails details) {
    // Check if they're grabbing the arrow (zipper pull)
    if (_pathTracker.canStartDragging(details.localPosition, tolerance: 30.0)) {
      setState(() {
        _isTracing = true;
        _currentFingerPosition = details.localPosition;
        _pathTracker.startDragging();
      });
      
      // Haptic feedback when they grab the zipper
      HapticFeedback.mediumImpact();
    } else {
      // Give feedback that they need to grab the arrow
      HapticFeedback.selectionClick();
    }
  }
  
  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isTracing) return;
    
    setState(() {
      _currentFingerPosition = details.localPosition;
      
      // Update arrow position (move the zipper pull around the circle)
      _pathTracker.updateArrowPosition(details.localPosition);
      _totalProgress = _pathTracker.getOverallProgress();
      
      // Give haptic feedback as they drag (like zipper teeth)
      HapticFeedback.lightImpact();
      
      // Check if they completed the letter
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
    _pulseController.repeat(reverse: true); // Restart pulsing animation
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
                    painter: LetterOPainter(
                      pathTracker: _pathTracker,
                      currentPosition: _currentFingerPosition,
                      isTracing: _isTracing,
                      progress: _totalProgress,
                      pulseAnimation: _pulseAnimation,
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
                    color: _totalProgress >= 0.95 ? Colors.green : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _totalProgress >= 0.95 
                        ? Icon(Icons.check, color: Colors.white, size: 24)
                        : Text(
                            'O',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                                'Perfect Circle!',
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

// This is like the "instruction manual" for drawing letter O (circular zipper)
class PathTracker {
  late CircularPathSegment _segment;
  late Path _fullPath;
  
  void setupLetterO() {
    // Letter "O" is a single circular path
    // Think of it like one continuous circular zipper track
    
    Offset center = Offset(150, 150); // Center of the circle
    double radius = 60.0; // Size of the circle
    
    _segment = CircularPathSegment(
      center: center,
      radius: radius,
      startAngle: -math.pi / 2, // Start at top (12 o'clock)
      isActive: true,
    );
    
    // Create the full circular path
    _fullPath = Path();
    _fullPath.addOval(Rect.fromCircle(center: center, radius: radius));
  }
  
  bool canStartDragging(Offset position, {required double tolerance}) {
    // Check if user is near the arrow (zipper pull) to start dragging
    double distanceToArrow = (position - _segment.currentArrowPosition).distance;
    return distanceToArrow <= tolerance;
  }
  
  void updateArrowPosition(Offset fingerPosition) {
    if (!_segment.isDragging) return;
    
    // Find the closest point on the circle to the finger position
    Offset vectorToFinger = fingerPosition - _segment.center;
    double distanceToCenter = vectorToFinger.distance;
    
    if (distanceToCenter == 0) return;
    
    // Project finger onto the circle (normalize and scale to radius)
    Offset normalizedVector = Offset(
      vectorToFinger.dx / distanceToCenter,
      vectorToFinger.dy / distanceToCenter,
    );
    
    Offset projectedPoint = Offset(
      _segment.center.dx + normalizedVector.dx * _segment.radius,
      _segment.center.dy + normalizedVector.dy * _segment.radius,
    );
    
    // Calculate angle from center to projected point
    double currentAngle = math.atan2(
      projectedPoint.dy - _segment.center.dy,
      projectedPoint.dx - _segment.center.dx,
    );
    
    // Calculate how far around the circle we've gone
    double angleProgress = _calculateAngleProgress(_segment.startAngle, currentAngle);
    
    // Only allow forward progress (clockwise movement)
    if (angleProgress > _segment.progress) {
      _segment.progress = angleProgress;
      _segment.currentArrowPosition = projectedPoint;
      _segment.currentAngle = currentAngle;
      
      // Mark as completed if we've gone most of the way around
      if (_segment.progress >= 0.90) { // 90% of full circle
        _segment.isCompleted = true;
      }
    }
  }
  
  // Calculate progress around the circle (0.0 to 1.0)
  double _calculateAngleProgress(double startAngle, double currentAngle) {
    double angleDiff = currentAngle - startAngle;
    
    // Normalize to positive angle (0 to 2π)
    while (angleDiff < 0) {
      angleDiff += 2 * math.pi;
    }
    while (angleDiff > 2 * math.pi) {
      angleDiff -= 2 * math.pi;
    }
    
    // Convert to progress (0.0 to 1.0)
    return angleDiff / (2 * math.pi);
  }
  
  void startDragging() {
    _segment.isDragging = true;
    _segment.isStarted = true;
  }
  
  void stopDragging() {
    _segment.isDragging = false;
  }
  
  double getOverallProgress() {
    return _segment.isCompleted ? 1.0 : _segment.progress;
  }
  
  bool isCompleted() {
    return _segment.isCompleted;
  }
  
  void reset() {
    _segment.progress = 0.0;
    _segment.isCompleted = false;
    _segment.isDragging = false;
    _segment.isStarted = false;
    _segment.currentAngle = _segment.startAngle;
    
    // Reset arrow to start position (top of circle)
    _segment.currentArrowPosition = Offset(
      _segment.center.dx + _segment.radius * math.cos(_segment.startAngle),
      _segment.center.dy + _segment.radius * math.sin(_segment.startAngle),
    );
  }
  
  CircularPathSegment get segment => _segment;
  Path get fullPath => _fullPath;
}

// This represents the circular path for letter O
class CircularPathSegment {
  final Offset center;
  final double radius;
  final double startAngle; // Starting angle in radians
  double progress; // How much is completed (0.0 to 1.0)
  bool isCompleted;
  bool isActive;
  bool isStarted;
  bool isDragging;
  double currentAngle; // Current angle position
  Offset currentArrowPosition; // Current position of the zipper pull
  
  CircularPathSegment({
    required this.center,
    required this.radius,
    required this.startAngle,
    this.progress = 0.0,
    this.isCompleted = false,
    this.isActive = false,
    this.isStarted = false,
    this.isDragging = false,
  }) : currentAngle = startAngle,
       currentArrowPosition = Offset(
         center.dx + radius * math.cos(startAngle),
         center.dy + radius * math.sin(startAngle),
       );
}

// This is the "artist" that draws everything on screen
class LetterOPainter extends CustomPainter {
  final PathTracker pathTracker;
  final Offset? currentPosition;
  final bool isTracing;
  final double progress;
  final Animation<double> pulseAnimation;
  
  LetterOPainter({
    required this.pathTracker,
    this.currentPosition,
    required this.isTracing,
    required this.progress,
    required this.pulseAnimation,
  }) : super(repaint: pulseAnimation);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Draw the circular letter "O"
    _drawCircularSegment(canvas, pathTracker.segment);
    
    // Draw the current finger position (like a cursor) only when dragging
    if (currentPosition != null && isTracing) {
      _drawFingerIndicator(canvas, currentPosition!);
    }
    
    // Draw guidelines (light grid lines like notebook paper)
    _drawGuidelines(canvas, size);
  }
  
  void _drawCircularSegment(Canvas canvas, CircularPathSegment segment) {
    // Different colors based on segment state
    Color segmentColor = segment.isCompleted ? Colors.green : Colors.blue;
    double opacity = segment.isActive ? 0.8 : 0.3;
    
    // Paint for the dotted outline (untraced part - the circular zipper track)
    Paint dottedPaint = Paint()
      ..color = segmentColor.withOpacity(opacity * 0.4)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    
    // Paint for the solid line (traced part - closed zipper)
    Paint solidPaint = Paint()
      ..color = segmentColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    // Draw dotted circle outline (like circular zipper track)
    _drawDottedCircle(canvas, segment.center, segment.radius, dottedPaint);
    
    // Draw solid arc for completed portion (closed zipper)
    if (segment.progress > 0 || segment.isCompleted) {
      double sweepAngle = segment.progress * 2 * math.pi;
      
      Path solidPath = Path();
      solidPath.addArc(
        Rect.fromCircle(center: segment.center, radius: segment.radius),
        segment.startAngle,
        sweepAngle,
      );
      
      canvas.drawPath(solidPath, solidPaint);
    }
    
    // Draw the circular zipper pull (arrow) at current position
    if (segment.isActive && !segment.isCompleted) {
      _drawCircularZipperPull(canvas, segment);
    }
    
    // Draw step number in center
    _drawCenterNumber(canvas, segment);
  }
  
  void _drawDottedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    // Draw dotted circle manually
    double circumference = 2 * math.pi * radius;
    double dashLength = 10.0;
    double gapLength = 5.0;
    double dashGapLength = dashLength + gapLength;
    
    int dashCount = (circumference / dashGapLength).floor();
    
    for (int i = 0; i < dashCount; i++) {
      double startAngle = (i * dashGapLength / radius) - math.pi / 2;
      double endAngle = ((i * dashGapLength + dashLength) / radius) - math.pi / 2;
      
      Path dashPath = Path();
      dashPath.addArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
      );
      
      canvas.drawPath(dashPath, paint);
    }
  }
  
  void _drawCircularZipperPull(Canvas canvas, CircularPathSegment segment) {
    // Draw the zipper pull at the current position on the circle
    Offset pullPosition = segment.currentArrowPosition;
    
    // Calculate tangent direction for the arrow (perpendicular to radius)
    double tangentAngle = segment.currentAngle + math.pi / 2; // 90 degrees ahead
    Offset tangentDirection = Offset(math.cos(tangentAngle), math.sin(tangentAngle));
    
    // Main zipper pull body (larger circle)
    Paint pullBodyPaint = Paint()
      ..color = segment.isDragging ? Colors.orange : Colors.red
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    
    canvas.drawCircle(pullPosition, 18, pullBodyPaint);
    
    // Inner circle (handle)
    Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(pullPosition, 12, innerPaint);
    
    // Arrow shape inside pointing in tangent direction
    Paint arrowPaint = Paint()
      ..color = segment.isDragging ? Colors.orange : Colors.red
      ..style = PaintingStyle.fill;
    
    // Create arrow pointing in movement direction
    Path arrowPath = Path();
    double arrowSize = 8;
    
    // Arrow tip
    Offset tip = Offset(
      pullPosition.dx + tangentDirection.dx * arrowSize,
      pullPosition.dy + tangentDirection.dy * arrowSize,
    );
    
    // Arrow base
    Offset base1 = Offset(
      pullPosition.dx - tangentDirection.dx * 4 + tangentDirection.dy * 6,
      pullPosition.dy - tangentDirection.dy * 4 - tangentDirection.dx * 6,
    );
    
    Offset base2 = Offset(
      pullPosition.dx - tangentDirection.dx * 4 - tangentDirection.dy * 6,
      pullPosition.dy - tangentDirection.dy * 4 + tangentDirection.dx * 6,
    );
    
    arrowPath.moveTo(tip.dx, tip.dy);
    arrowPath.lineTo(base1.dx, base1.dy);
    arrowPath.lineTo(base2.dx, base2.dy);
    arrowPath.close();
    
    canvas.drawPath(arrowPath, arrowPaint);
    
    // Pulsating effect when not being dragged (to attract attention)
    if (!segment.isDragging) {
      Paint pulsePaint = Paint()
        ..color = Colors.red.withOpacity(0.3 * pulseAnimation.value)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      
      canvas.drawCircle(pullPosition, 25 + (5 * pulseAnimation.value), pulsePaint);
    }
    
    // Draw touch hint text
    if (!segment.isStarted && segment.isActive) {
      _drawHintText(canvas, pullPosition, "Drag around!");
    }
  }
  
  void _drawCenterNumber(Canvas canvas, CircularPathSegment segment) {
    // Draw step number in center of circle
    Paint numberBackgroundPaint = Paint()
      ..color = segment.isCompleted ? Colors.green : 
                 segment.isActive ? Colors.blue : Colors.grey
      ..style = PaintingStyle.fill;
    
    // Draw circle background for number
    canvas.drawCircle(segment.center, 20, numberBackgroundPaint);
    
    // Draw letter text
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'O',
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
      Offset(
        segment.center.dx - textPainter.width / 2,
        segment.center.dy - textPainter.height / 2,
      ),
    );
  }
  
  void _drawHintText(Canvas canvas, Offset position, String text) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // Draw text above the zipper pull
    Offset textPosition = Offset(
      position.dx - textPainter.width / 2,
      position.dy - 40,
    );
    
    // Draw background for text
    Paint backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          textPosition.dx - 4,
          textPosition.dy - 2,
          textPainter.width + 8,
          textPainter.height + 4,
        ),
        Radius.circular(4),
      ),
      backgroundPaint,
    );
    
    textPainter.paint(canvas, textPosition);
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
    // Draw light horizontal and vertical lines like notebook paper
    Paint guidelinePaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    
    // Draw center crosshairs
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
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint when state changes
  }
}