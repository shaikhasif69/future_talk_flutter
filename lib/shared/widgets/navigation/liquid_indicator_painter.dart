import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Custom painter for creating liquid blob indicator animation
/// Creates smooth morphing blob that follows tab selection with premium aesthetics
class LiquidIndicatorPainter extends CustomPainter {
  /// Animation progress value (0.0 to 1.0)
  final double animationValue;
  
  /// Current selected tab position (0.0 to 1.0 across width)
  final double currentPosition;
  
  /// Previous selected tab position for smooth transition
  final double previousPosition;
  
  /// Width of each tab
  final double tabWidth;
  
  /// Total number of tabs
  final int tabCount;
  
  /// Custom colors for the blob
  final List<Color> blobColors;
  
  /// Blob intensity (affects size and glow)
  final double intensity;
  
  /// Whether to show glow effect
  final bool showGlow;

  LiquidIndicatorPainter({
    required this.animationValue,
    required this.currentPosition,
    required this.previousPosition,
    required this.tabWidth,
    required this.tabCount,
    this.blobColors = const [
      AppColors.sageGreen,
      AppColors.lavenderMist,
      AppColors.warmPeach,
    ],
    this.intensity = 1.0,
    this.showGlow = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawLiquidBlob(canvas, size);
    if (showGlow) {
      _drawGlowEffect(canvas, size);
    }
    _drawShimmerEffect(canvas, size);
  }

  void _drawLiquidBlob(Canvas canvas, Size size) {
    // Calculate blob position with smooth interpolation
    final lerpPosition = ui.lerpDouble(
      previousPosition, 
      currentPosition, 
      _easeOutCubic(animationValue),
    ) ?? currentPosition;
    
    final blobCenter = lerpPosition * size.width;
    final blobWidth = tabWidth * (0.7 + 0.3 * intensity);
    final blobHeight = size.height * (0.8 + 0.2 * intensity);
    
    // Create morphing path for liquid blob
    final path = _createLiquidPath(
      center: Offset(blobCenter, size.height * 0.5),
      width: blobWidth,
      height: blobHeight,
      morphFactor: animationValue,
    );
    
    // Create gradient paint
    final gradientPaint = Paint()
      ..shader = _createBlobGradient(
        center: Offset(blobCenter, size.height * 0.5),
        radius: blobWidth * 0.6,
      )
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    
    // Draw the liquid blob
    canvas.drawPath(path, gradientPaint);
    
    // Add subtle inner shadow
    _drawInnerShadow(canvas, path, blobCenter, size);
  }

  Path _createLiquidPath({
    required Offset center,
    required double width,
    required double height,
    required double morphFactor,
  }) {
    final path = Path();
    
    // Create organic blob shape with morphing animation
    final baseRadius = width * 0.5;
    final heightRadius = height * 0.5;
    
    // Organic blob control points
    final controlPoints = _generateOrganicControlPoints(
      center: center,
      baseRadius: baseRadius,
      heightRadius: heightRadius,
      morphFactor: morphFactor,
    );
    
    // Start path
    path.moveTo(controlPoints[0].dx, controlPoints[0].dy);
    
    // Create smooth curves through control points
    for (int i = 0; i < controlPoints.length; i++) {
      final current = controlPoints[i];
      final next = controlPoints[(i + 1) % controlPoints.length];
      final control1 = controlPoints[(i + 2) % controlPoints.length];
      
      // Create organic curves
      path.quadraticBezierTo(
        current.dx + (next.dx - current.dx) * 0.5,
        current.dy + (next.dy - current.dy) * 0.5,
        next.dx,
        next.dy,
      );
    }
    
    path.close();
    return path;
  }

  List<Offset> _generateOrganicControlPoints({
    required Offset center,
    required double baseRadius,
    required double heightRadius,
    required double morphFactor,
  }) {
    final points = <Offset>[];
    final pointCount = 8; // Number of control points for smooth blob
    
    for (int i = 0; i < pointCount; i++) {
      final angle = (i / pointCount) * 2 * math.pi;
      
      // Add organic variation to radius
      final radiusVariation = 0.15 * math.sin(morphFactor * 4 * math.pi + angle * 3);
      final currentRadius = baseRadius * (1.0 + radiusVariation);
      
      // Calculate point with height variation
      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + (heightRadius * (1.0 + radiusVariation * 0.5)) * math.sin(angle);
      
      points.add(Offset(x, y));
    }
    
    return points;
  }

  ui.Shader _createBlobGradient({
    required Offset center,
    required double radius,
  }) {
    return ui.Gradient.radial(
      center,
      radius,
      [
        blobColors[0].withOpacity(0.9),
        blobColors[1].withOpacity(0.7),
        blobColors[2].withOpacity(0.5),
        blobColors[0].withOpacity(0.2),
      ],
      [0.0, 0.3, 0.7, 1.0],
    );
  }

  void _drawInnerShadow(Canvas canvas, Path path, double blobCenter, Size size) {
    final shadowPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(blobCenter, size.height * 0.3),
        tabWidth * 0.3,
        [
          Colors.transparent,
          AppColors.softCharcoal.withOpacity(0.1),
          AppColors.softCharcoal.withOpacity(0.05),
        ],
        [0.0, 0.7, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.multiply;
    
    canvas.drawPath(path, shadowPaint);
  }

  void _drawGlowEffect(Canvas canvas, Size size) {
    final lerpPosition = ui.lerpDouble(
      previousPosition, 
      currentPosition, 
      _easeOutCubic(animationValue),
    ) ?? currentPosition;
    
    final glowCenter = Offset(
      lerpPosition * size.width,
      size.height * 0.5,
    );
    
    final glowRadius = tabWidth * (0.8 + 0.4 * intensity);
    
    // Outer glow
    final outerGlowPaint = Paint()
      ..shader = ui.Gradient.radial(
        glowCenter,
        glowRadius,
        [
          blobColors[0].withOpacity(0.3 * intensity),
          blobColors[1].withOpacity(0.2 * intensity),
          blobColors[0].withOpacity(0.1 * intensity),
          Colors.transparent,
        ],
        [0.0, 0.4, 0.7, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;
    
    canvas.drawCircle(glowCenter, glowRadius * 1.5, outerGlowPaint);
    
    // Inner glow
    final innerGlowPaint = Paint()
      ..shader = ui.Gradient.radial(
        glowCenter,
        glowRadius * 0.6,
        [
          blobColors[1].withOpacity(0.4 * intensity),
          blobColors[2].withOpacity(0.2 * intensity),
          Colors.transparent,
        ],
        [0.0, 0.6, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;
    
    canvas.drawCircle(glowCenter, glowRadius, innerGlowPaint);
  }

  void _drawShimmerEffect(Canvas canvas, Size size) {
    final lerpPosition = ui.lerpDouble(
      previousPosition, 
      currentPosition, 
      _easeOutCubic(animationValue),
    ) ?? currentPosition;
    
    final shimmerCenter = Offset(
      lerpPosition * size.width,
      size.height * 0.3,
    );
    
    // Animated shimmer sweep
    final shimmerOffset = (animationValue * 2 - 1) * tabWidth * 0.5;
    
    final shimmerPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(shimmerCenter.dx + shimmerOffset - 20, shimmerCenter.dy),
        Offset(shimmerCenter.dx + shimmerOffset + 20, shimmerCenter.dy),
        [
          Colors.transparent,
          AppColors.pearlWhite.withOpacity(0.6),
          AppColors.pearlWhite.withOpacity(0.3),
          Colors.transparent,
        ],
        [0.0, 0.3, 0.7, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay;
    
    // Draw shimmer line
    final shimmerPath = Path()
      ..moveTo(shimmerCenter.dx + shimmerOffset - 15, shimmerCenter.dy - 5)
      ..lineTo(shimmerCenter.dx + shimmerOffset + 15, shimmerCenter.dy - 5)
      ..lineTo(shimmerCenter.dx + shimmerOffset + 20, shimmerCenter.dy + 5)
      ..lineTo(shimmerCenter.dx + shimmerOffset - 10, shimmerCenter.dy + 5)
      ..close();
    
    canvas.drawPath(shimmerPath, shimmerPaint);
  }

  /// Smooth easing function for organic motion
  double _easeOutCubic(double t) {
    final t1 = t - 1;
    return 1 + t1 * t1 * t1;
  }

  @override
  bool shouldRepaint(LiquidIndicatorPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.currentPosition != currentPosition ||
           oldDelegate.previousPosition != previousPosition ||
           oldDelegate.intensity != intensity;
  }
}

/// Animated liquid indicator widget wrapper
class AnimatedLiquidIndicator extends StatefulWidget {
  /// Currently selected tab index
  final int selectedIndex;
  
  /// Total number of tabs
  final int tabCount;
  
  /// Width of the container
  final double width;
  
  /// Height of the indicator
  final double height;
  
  /// Custom colors for the liquid effect
  final List<Color>? colors;
  
  /// Animation intensity
  final double intensity;

  const AnimatedLiquidIndicator({
    super.key,
    required this.selectedIndex,
    required this.tabCount,
    required this.width,
    this.height = 6,
    this.colors,
    this.intensity = 1.0,
  });

  @override
  State<AnimatedLiquidIndicator> createState() => _AnimatedLiquidIndicatorState();
}

class _AnimatedLiquidIndicatorState extends State<AnimatedLiquidIndicator>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _animation;
  
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    
    _previousIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(AnimatedLiquidIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      setState(() {
        _previousIndex = oldWidget.selectedIndex;
      });
      
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: LiquidIndicatorPainter(
            animationValue: _animation.value,
            currentPosition: widget.selectedIndex / (widget.tabCount - 1),
            previousPosition: _previousIndex / (widget.tabCount - 1),
            tabWidth: widget.width / widget.tabCount,
            tabCount: widget.tabCount,
            blobColors: widget.colors ?? [
              AppColors.sageGreen,
              AppColors.lavenderMist,
              AppColors.warmPeach,
            ],
            intensity: widget.intensity,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}