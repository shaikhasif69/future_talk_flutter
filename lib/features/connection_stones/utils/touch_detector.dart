import 'dart:async';
import 'package:flutter/material.dart';
import '../models/touch_interaction_model.dart';

/// Advanced touch detector for connection stones
/// Distinguishes between different types of touches: tap, long press, double tap
class TouchDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final Function(TouchType, TouchLocation?)? onTouch;
  final Duration longPressDuration;
  final Duration doubleTapThreshold;
  final bool enableHapticFeedback;

  const TouchDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.onTouch,
    this.longPressDuration = const Duration(milliseconds: 800),
    this.doubleTapThreshold = const Duration(milliseconds: 300),
    this.enableHapticFeedback = true,
  });

  @override
  State<TouchDetector> createState() => _TouchDetectorState();
}

class _TouchDetectorState extends State<TouchDetector>
    with TickerProviderStateMixin {
  Timer? _longPressTimer;
  Timer? _doubleTapTimer;
  bool _isLongPressActivated = false;
  bool _isPotentialDoubleTap = false;
  TouchLocation? _lastTouchLocation;
  
  late AnimationController _pressAnimationController;
  late AnimationController _rippleAnimationController;
  late Animation<double> _pressAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _pressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _rippleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Create animations
    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    _doubleTapTimer?.cancel();
    _pressAnimationController.dispose();
    _rippleAnimationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _isLongPressActivated = false;
    
    // Store touch location for ripple effect
    _lastTouchLocation = TouchLocation(
      x: details.localPosition.dx,
      y: details.localPosition.dy,
    );
    
    // Start press animation
    _pressAnimationController.forward();
    
    // Start long press timer
    _longPressTimer = Timer(widget.longPressDuration, () {
      if (mounted && !_isLongPressActivated) {
        _isLongPressActivated = true;
        _handleLongPress();
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
    // Cancel long press timer
    _longPressTimer?.cancel();
    
    // Reset press animation
    _pressAnimationController.reverse();
    
    // If long press was activated, don't handle tap
    if (_isLongPressActivated) {
      return;
    }
    
    // Handle potential double tap
    if (_isPotentialDoubleTap) {
      _handleDoubleTap();
      return;
    }
    
    // Set up potential double tap
    _isPotentialDoubleTap = true;
    _doubleTapTimer = Timer(widget.doubleTapThreshold, () {
      if (mounted && _isPotentialDoubleTap) {
        _isPotentialDoubleTap = false;
        _handleSingleTap();
      }
    });
  }

  void _onTapCancel() {
    _longPressTimer?.cancel();
    _pressAnimationController.reverse();
    _isLongPressActivated = false;
  }

  void _handleSingleTap() {
    _startRippleAnimation();
    widget.onTap?.call();
    widget.onTouch?.call(TouchType.quickTouch, _lastTouchLocation);
  }

  void _handleLongPress() {
    _startRippleAnimation();
    widget.onLongPress?.call();
    widget.onTouch?.call(TouchType.longPress, _lastTouchLocation);
  }

  void _handleDoubleTap() {
    _isPotentialDoubleTap = false;
    _doubleTapTimer?.cancel();
    _startRippleAnimation();
    widget.onDoubleTap?.call();
    widget.onTouch?.call(TouchType.doubleTap, _lastTouchLocation);
  }

  void _startRippleAnimation() {
    _rippleAnimationController.reset();
    _rippleAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pressAnimation, _rippleAnimation]),
      builder: (context, child) {
        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Transform.scale(
            scale: _pressAnimation.value,
            child: Stack(
              children: [
                widget.child,
                if (_rippleAnimation.value > 0) _buildRippleEffect(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRippleEffect() {
    if (_lastTouchLocation == null) return const SizedBox.shrink();
    
    return Positioned(
      left: _lastTouchLocation!.x - (_lastTouchLocation!.size / 2),
      top: _lastTouchLocation!.y - (_lastTouchLocation!.size / 2),
      child: IgnorePointer(
        child: Container(
          width: _lastTouchLocation!.size * _rippleAnimation.value * 4,
          height: _lastTouchLocation!.size * _rippleAnimation.value * 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 
              (1 - _rippleAnimation.value) * 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

/// Advanced stone touch detector with stone-specific behaviors
class StoneTouchDetector extends StatelessWidget {
  final Widget child;
  final Function(TouchType, TouchLocation?)? onStoneTouch;
  final VoidCallback? onStoneDetails;
  final bool isReceiving;
  final bool isSending;
  final Color rippleColor;

  const StoneTouchDetector({
    super.key,
    required this.child,
    this.onStoneTouch,
    this.onStoneDetails,
    this.isReceiving = false,
    this.isSending = false,
    this.rippleColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Don't allow touches if already in an active state
    if (isReceiving || isSending) {
      return child;
    }

    return TouchDetector(
      onTap: onStoneDetails,
      onLongPress: () => onStoneTouch?.call(TouchType.longPress, null),
      onDoubleTap: () => onStoneTouch?.call(TouchType.doubleTap, null),
      onTouch: onStoneTouch,
      child: child,
    );
  }
}

/// Heart touch pattern detector for special romantic touches
class HeartTouchDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onHeartTouch;
  final Color heartColor;

  const HeartTouchDetector({
    super.key,
    required this.child,
    this.onHeartTouch,
    this.heartColor = Colors.red,
  });

  @override
  State<HeartTouchDetector> createState() => _HeartTouchDetectorState();
}

class _HeartTouchDetectorState extends State<HeartTouchDetector>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimation;
  bool _isDrawingHeart = false;
  List<Offset> _touchPoints = [];

  @override
  void initState() {
    super.initState();
    
    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _heartAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heartAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _isDrawingHeart = true;
    _touchPoints = [details.localPosition];
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDrawingHeart) {
      setState(() {
        _touchPoints.add(details.localPosition);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _isDrawingHeart = false;
    
    // Check if the drawn pattern resembles a heart
    if (_isHeartPattern(_touchPoints)) {
      _heartAnimationController.reset();
      _heartAnimationController.forward();
      widget.onHeartTouch?.call();
    }
    
    // Clear touch points after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _touchPoints.clear();
        });
      }
    });
  }

  bool _isHeartPattern(List<Offset> points) {
    // Simplified heart pattern detection
    // In a real implementation, you'd use more sophisticated pattern matching
    if (points.length < 10) return false;
    
    // Check for general heart-like movement
    // This is a basic implementation - you could make it much more sophisticated
    final firstPoint = points.first;
    final lastPoint = points.last;
    final midPoint = points[points.length ~/ 2];
    
    // Basic checks for heart shape
    return (lastPoint.dy > firstPoint.dy) && 
           (midPoint.dx != firstPoint.dx) &&
           points.length > 15;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _heartAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              widget.child,
              if (_touchPoints.isNotEmpty) _buildHeartTrail(),
              if (_heartAnimation.value > 0) _buildHeartEffect(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeartTrail() {
    return CustomPaint(
      painter: HeartTrailPainter(
        points: _touchPoints,
        color: widget.heartColor.withValues(alpha: 0.6),
      ),
      size: Size.infinite,
    );
  }

  Widget _buildHeartEffect() {
    return Center(
      child: Transform.scale(
        scale: _heartAnimation.value,
        child: Opacity(
          opacity: 1 - _heartAnimation.value,
          child: Icon(
            Icons.favorite,
            color: widget.heartColor,
            size: 100,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for heart trail effect
class HeartTrailPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  HeartTrailPainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HeartTrailPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}