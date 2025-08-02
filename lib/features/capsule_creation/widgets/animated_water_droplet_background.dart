import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Premium animated water droplet background for Capsule Creation screens
/// Creates floating water droplet/bubble particles flowing upwards
class AnimatedWaterDropletBackground extends StatefulWidget {
  final int particleCount;
  final Duration animationDuration;
  final bool enableGradientShift;

  const AnimatedWaterDropletBackground({
    super.key,
    this.particleCount = 8,
    this.animationDuration = const Duration(seconds: 12),
    this.enableGradientShift = true,
  });

  @override
  State<AnimatedWaterDropletBackground> createState() => _AnimatedWaterDropletBackgroundState();
}

class _AnimatedWaterDropletBackgroundState extends State<AnimatedWaterDropletBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late List<WaterDroplet> _droplets;

  @override
  void initState() {
    super.initState();
    
    // Initialize particle animation controller
    _particleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    // Initialize gradient animation controller
    _gradientController = AnimationController(
      duration: const Duration(minutes: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Generate random water droplets
    _generateDroplets();
  }

  void _generateDroplets() {
    _droplets = List.generate(widget.particleCount, (index) {
      return WaterDroplet(
        startX: math.Random().nextDouble(),
        startY: 1.2, // Start below screen
        endX: math.Random().nextDouble(),
        endY: -0.3, // End above screen
        size: 3.0 + math.Random().nextDouble() * 6.0,
        opacity: 0.08 + math.Random().nextDouble() * 0.15,
        animationDelay: math.Random().nextDouble(),
        driftAmount: 30.0 + math.Random().nextDouble() * 60.0,
        color: _getRandomDropletColor(),
        speed: 0.8 + math.Random().nextDouble() * 0.4, // Variable speed
      );
    });
  }

  Color _getRandomDropletColor() {
    final colors = [
      AppColors.sageGreen,
      AppColors.lavenderMist,
      AppColors.cloudBlue,
      AppColors.warmPeach,
      AppColors.dustyRose,
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Subtle gradient background shift
        if (widget.enableGradientShift)
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFFF7F5F3),
                        const Color(0xFFF9F7F5),
                        _gradientController.value * 0.3,
                      )!,
                      Color.lerp(
                        const Color(0xFFFEFEFE),
                        const Color(0xFFF7F5F3),
                        _gradientController.value * 0.2,
                      )!,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              );
            },
          ),

        // Floating water droplets
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: WaterDropletPainter(
                droplets: _droplets,
                progress: _particleController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
      ],
    );
  }
}

/// Represents a single water droplet particle
class WaterDroplet {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double size;
  final double opacity;
  final double animationDelay;
  final double driftAmount;
  final double speed;
  final Color color;

  const WaterDroplet({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.size,
    required this.opacity,
    required this.animationDelay,
    required this.driftAmount,
    required this.speed,
    required this.color,
  });
}

/// Custom painter for water droplets with organic floating movement
class WaterDropletPainter extends CustomPainter {
  final List<WaterDroplet> droplets;
  final double progress;

  WaterDropletPainter({
    required this.droplets,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final droplet in droplets) {
      // Calculate delayed progress for staggered animation
      final adjustedProgress = ((progress * droplet.speed - droplet.animationDelay) % 1.0);
      final delayedProgress = adjustedProgress.clamp(0.0, 1.0);
      
      if (delayedProgress <= 0.0) continue;

      // Calculate position with organic floating movement
      final baseX = size.width * (droplet.startX + 
          (droplet.endX - droplet.startX) * delayedProgress);
      final baseY = size.height * (droplet.startY + 
          (droplet.endY - droplet.startY) * delayedProgress);

      // Add organic drift using multiple sine waves for more natural movement
      final driftX = math.sin(delayedProgress * math.pi * 3) * droplet.driftAmount * 0.4 +
                    math.cos(delayedProgress * math.pi * 2.3) * droplet.driftAmount * 0.2;
      final driftY = math.cos(delayedProgress * math.pi * 2.7) * droplet.driftAmount * 0.15 +
                    math.sin(delayedProgress * math.pi * 1.8) * droplet.driftAmount * 0.1;

      final x = baseX + driftX;
      final y = baseY + driftY;

      // Skip if outside visible area
      if (x < -droplet.size || x > size.width + droplet.size ||
          y < -droplet.size || y > size.height + droplet.size) {
        continue;
      }

      // Calculate opacity with smooth fade in/out
      double currentOpacity = droplet.opacity;
      if (delayedProgress < 0.15) {
        currentOpacity *= delayedProgress / 0.15; // Fade in
      } else if (delayedProgress > 0.85) {
        currentOpacity *= (1.0 - delayedProgress) / 0.15; // Fade out
      }

      // Create water droplet shape with subtle glow
      _paintWaterDroplet(canvas, Offset(x, y), droplet.size, droplet.color, currentOpacity);
    }
  }

  void _paintWaterDroplet(Canvas canvas, Offset center, double size, Color color, double opacity) {
    // Main droplet body (circle)
    final mainPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, size * 0.8, mainPaint);

    // Subtle inner highlight for water effect
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity * 0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - size * 0.2, center.dy - size * 0.2),
      size * 0.3,
      highlightPaint,
    );

    // Outer glow for floating effect
    final glowPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawCircle(center, size * 1.2, glowPaint);

    // Subtle water ripple effect
    final ripplePaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, size * 1.5, ripplePaint);
  }

  @override
  bool shouldRepaint(WaterDropletPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}