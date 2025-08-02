import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Premium animated background for Capsule Garden with floating particles
/// Creates a serene, nature-inspired experience with subtle movement
class AnimatedGardenBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Duration animationDuration;
  final bool enableGradientShift;

  const AnimatedGardenBackground({
    super.key,
    required this.child,
    this.particleCount = 15,
    this.animationDuration = const Duration(seconds: 8),
    this.enableGradientShift = true,
  });

  @override
  State<AnimatedGardenBackground> createState() => _AnimatedGardenBackgroundState();
}

class _AnimatedGardenBackgroundState extends State<AnimatedGardenBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late List<FloatingParticle> _particles;

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
      duration: const Duration(minutes: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Generate random particles
    _generateParticles();
  }

  void _generateParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      return FloatingParticle(
        startX: math.Random().nextDouble(),
        startY: math.Random().nextDouble() + 1.0, // Start below screen
        endX: math.Random().nextDouble(),
        endY: -0.2, // End above screen
        size: 2.0 + math.Random().nextDouble() * 4.0,
        opacity: 0.1 + math.Random().nextDouble() * 0.3,
        animationDelay: math.Random().nextDouble(),
        driftAmount: 50.0 + math.Random().nextDouble() * 100.0,
        color: _getRandomParticleColor(),
      );
    });
  }

  Color _getRandomParticleColor() {
    final colors = [
      AppColors.sageGreen,
      AppColors.lavenderMist,
      AppColors.warmPeach,
      AppColors.cloudBlue,
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
        // Animated gradient background
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.enableGradientShift
                      ? [
                          Color.lerp(
                            AppColors.warmCream,
                            AppColors.warmCreamAlt,
                            _gradientController.value,
                          )!,
                          Color.lerp(
                            AppColors.pearlWhite,
                            AppColors.warmCream,
                            _gradientController.value * 0.5,
                          )!,
                        ]
                      : [AppColors.warmCream, AppColors.pearlWhite],
                  stops: const [0.0, 1.0],
                ),
              ),
            );
          },
        ),

        // Floating particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: FloatingParticlesPainter(
                particles: _particles,
                progress: _particleController.value,
              ),
              size: Size.infinite,
            );
          },
        ),

        // Content
        widget.child,
      ],
    );
  }
}

/// Represents a single floating particle
class FloatingParticle {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double size;
  final double opacity;
  final double animationDelay;
  final double driftAmount;
  final Color color;

  const FloatingParticle({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.size,
    required this.opacity,
    required this.animationDelay,
    required this.driftAmount,
    required this.color,
  });
}

/// Custom painter for floating particles with organic movement
class FloatingParticlesPainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final double progress;

  FloatingParticlesPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Calculate delayed progress for staggered animation
      final delayedProgress = ((progress - particle.animationDelay) % 1.0).clamp(0.0, 1.0);
      
      if (delayedProgress <= 0.0) continue;

      // Calculate position with organic drift
      final baseX = size.width * (particle.startX + 
          (particle.endX - particle.startX) * delayedProgress);
      final baseY = size.height * (particle.startY + 
          (particle.endY - particle.startY) * delayedProgress);

      // Add organic drift using sine waves
      final driftX = math.sin(delayedProgress * math.pi * 2) * particle.driftAmount * 0.3;
      final driftY = math.cos(delayedProgress * math.pi * 1.5) * particle.driftAmount * 0.1;

      final x = baseX + driftX;
      final y = baseY + driftY;

      // Calculate opacity with fade in/out
      double currentOpacity = particle.opacity;
      if (delayedProgress < 0.1) {
        currentOpacity *= delayedProgress / 0.1; // Fade in
      } else if (delayedProgress > 0.9) {
        currentOpacity *= (1.0 - delayedProgress) / 0.1; // Fade out
      }

      // Paint particle with glow effect
      final paint = Paint()
        ..color = particle.color.withOpacity(currentOpacity)
        ..style = PaintingStyle.fill;

      // Draw main particle
      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );

      // Draw subtle glow
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(currentOpacity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

      canvas.drawCircle(
        Offset(x, y),
        particle.size * 1.5,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(FloatingParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Breathing animation widget for garden header
class BreathingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scaleAmount;

  const BreathingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 4),
    this.scaleAmount = 0.02,
  });

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0 - widget.scaleAmount,
      end: 1.0 + widget.scaleAmount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Organic growth animation for capsules
class OrganicGrowthAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool shouldAnimate;

  const OrganicGrowthAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.shouldAnimate = true,
  });

  @override
  State<OrganicGrowthAnimation> createState() => _OrganicGrowthAnimationState();
}

class _OrganicGrowthAnimationState extends State<OrganicGrowthAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.shouldAnimate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(OrganicGrowthAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldAnimate != oldWidget.shouldAnimate) {
      if (widget.shouldAnimate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}