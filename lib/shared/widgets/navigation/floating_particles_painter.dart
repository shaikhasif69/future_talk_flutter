import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Advanced floating particles painter for premium navigation bar background
/// Creates organic, calming particle motion with depth and sophistication
class FloatingParticlesPainter extends CustomPainter {
  /// Animation progress value
  final double animationValue;
  
  /// Particles configuration
  final List<ParticleConfig> particles;
  
  /// Base color for particles
  final Color baseColor;
  
  /// Intensity of particle effects
  final double intensity;
  
  /// Whether to show connection lines between particles
  final bool showConnections;
  
  /// Size variation factor
  final double sizeVariation;

  FloatingParticlesPainter({
    required this.animationValue,
    required this.particles,
    this.baseColor = AppColors.sageGreen,
    this.intensity = 0.8,
    this.showConnections = false,
    this.sizeVariation = 0.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawParticles(canvas, size);
    
    if (showConnections) {
      _drawConnections(canvas, size);
    }
    
    _drawAmbientGlow(canvas, size);
  }

  void _drawParticles(Canvas canvas, Size size) {
    for (final particle in particles) {
      final position = _calculateParticlePosition(particle, size);
      final particleSize = _calculateParticleSize(particle);
      final opacity = _calculateParticleOpacity(particle);
      
      _drawSingleParticle(
        canvas, 
        position, 
        particleSize, 
        opacity,
        particle,
      );
    }
  }

  Offset _calculateParticlePosition(ParticleConfig particle, Size size) {
    // Base position with time-based movement
    final timeOffset = animationValue * 2 * math.pi;
    
    // Organic floating motion using multiple sine waves
    final xMovement = particle.amplitude.dx * math.sin(
      timeOffset * particle.frequency.dx + particle.phase.dx
    );
    
    final yMovement = particle.amplitude.dy * math.cos(
      timeOffset * particle.frequency.dy + particle.phase.dy
    );
    
    // Add subtle circular motion
    final circularOffset = particle.circularRadius * math.sin(
      timeOffset * particle.circularSpeed + particle.phase.dx
    );
    
    return Offset(
      (particle.basePosition.dx * size.width) + xMovement + circularOffset,
      (particle.basePosition.dy * size.height) + yMovement,
    );
  }

  double _calculateParticleSize(ParticleConfig particle) {
    final timeOffset = animationValue * 2 * math.pi;
    final sizeVariation = this.sizeVariation * math.sin(
      timeOffset * particle.sizeFrequency + particle.phase.dy
    );
    
    return particle.baseSize * (1.0 + sizeVariation) * intensity;
  }

  double _calculateParticleOpacity(ParticleConfig particle) {
    final timeOffset = animationValue * 2 * math.pi;
    final opacityVariation = 0.3 * math.sin(
      timeOffset * particle.opacityFrequency + particle.phase.dx
    );
    
    return (particle.baseOpacity + opacityVariation).clamp(0.0, 1.0) * intensity;
  }

  void _drawSingleParticle(
    Canvas canvas, 
    Offset position, 
    double size, 
    double opacity,
    ParticleConfig particle,
  ) {
    // Create gradient for depth effect
    final gradientPaint = Paint()
      ..shader = ui.Gradient.radial(
        position,
        size,
        [
          _getParticleColor(particle).withOpacity(opacity),
          _getParticleColor(particle).withOpacity(opacity * 0.7),
          _getParticleColor(particle).withOpacity(opacity * 0.3),
          Colors.transparent,
        ],
        [0.0, 0.4, 0.8, 1.0],
      )
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw main particle
    canvas.drawCircle(position, size, gradientPaint);
    
    // Add inner glow for premium effect
    final innerGlowPaint = Paint()
      ..shader = ui.Gradient.radial(
        position,
        size * 0.6,
        [
          AppColors.pearlWhite.withOpacity(opacity * 0.8),
          _getParticleColor(particle).withOpacity(opacity * 0.5),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;
    
    canvas.drawCircle(position, size * 0.7, innerGlowPaint);
    
    // Add subtle outer halo
    _drawParticleHalo(canvas, position, size, opacity, particle);
  }

  void _drawParticleHalo(
    Canvas canvas, 
    Offset position, 
    double size, 
    double opacity,
    ParticleConfig particle,
  ) {
    final haloPaint = Paint()
      ..shader = ui.Gradient.radial(
        position,
        size * 2,
        [
          _getParticleColor(particle).withOpacity(opacity * 0.2),
          _getParticleColor(particle).withOpacity(opacity * 0.1),
          Colors.transparent,
        ],
        [0.0, 0.6, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;
    
    canvas.drawCircle(position, size * 1.8, haloPaint);
  }

  Color _getParticleColor(ParticleConfig particle) {
    switch (particle.type) {
      case ParticleType.primary:
        return baseColor;
      case ParticleType.secondary:
        return AppColors.lavenderMist;
      case ParticleType.accent:
        return AppColors.warmPeach;
      case ParticleType.subtle:
        return AppColors.cloudBlue;
    }
  }

  void _drawConnections(Canvas canvas, Size size) {
    final connectionPaint = Paint()
      ..color = baseColor.withOpacity(0.1 * intensity)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Draw connections between nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final pos1 = _calculateParticlePosition(particles[i], size);
        final pos2 = _calculateParticlePosition(particles[j], size);
        
        final distance = (pos1 - pos2).distance;
        const maxConnectionDistance = 80.0;
        
        if (distance < maxConnectionDistance) {
          final connectionOpacity = (1.0 - distance / maxConnectionDistance) * 0.3;
          connectionPaint.color = baseColor.withOpacity(connectionOpacity * intensity);
          
          canvas.drawLine(pos1, pos2, connectionPaint);
        }
      }
    }
  }

  void _drawAmbientGlow(Canvas canvas, Size size) {
    // Create subtle ambient lighting effect
    final glowPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [
          baseColor.withOpacity(0.02 * intensity),
          AppColors.lavenderMist.withOpacity(0.01 * intensity),
          AppColors.warmPeach.withOpacity(0.015 * intensity),
          Colors.transparent,
        ],
        [0.0, 0.3, 0.6, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);
  }

  @override
  bool shouldRepaint(FloatingParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.intensity != intensity;
  }
}

/// Configuration class for individual particles
class ParticleConfig {
  /// Base position as percentage of container size (0.0 to 1.0)
  final Offset basePosition;
  
  /// Movement amplitude in pixels
  final Offset amplitude;
  
  /// Movement frequency multiplier
  final Offset frequency;
  
  /// Phase offset for varied motion
  final Offset phase;
  
  /// Base particle size
  final double baseSize;
  
  /// Base opacity
  final double baseOpacity;
  
  /// Size animation frequency
  final double sizeFrequency;
  
  /// Opacity animation frequency
  final double opacityFrequency;
  
  /// Circular motion radius
  final double circularRadius;
  
  /// Circular motion speed
  final double circularSpeed;
  
  /// Particle type for color variation
  final ParticleType type;

  const ParticleConfig({
    required this.basePosition,
    this.amplitude = const Offset(20, 15),
    this.frequency = const Offset(0.8, 1.2),
    this.phase = const Offset(0, 0),
    this.baseSize = 2.0,
    this.baseOpacity = 0.6,
    this.sizeFrequency = 0.5,
    this.opacityFrequency = 0.7,
    this.circularRadius = 5.0,
    this.circularSpeed = 0.3,
    this.type = ParticleType.primary,
  });
}

/// Particle type enumeration for color variation
enum ParticleType {
  primary,
  secondary,
  accent,
  subtle,
}

/// Factory class for creating particle configurations
class ParticleFactory {
  static List<ParticleConfig> createFloatingParticles({
    int count = 12,
    bool organicDistribution = true,
  }) {
    final particles = <ParticleConfig>[];
    final random = math.Random(42); // Fixed seed for consistent animation
    
    for (int i = 0; i < count; i++) {
      final progress = i / count;
      
      // Create organic distribution
      final baseX = organicDistribution 
        ? _organicDistribution(progress, random)
        : progress;
        
      final baseY = organicDistribution
        ? _organicDistribution(random.nextDouble(), random, isVertical: true)
        : random.nextDouble();
      
      particles.add(ParticleConfig(
        basePosition: Offset(baseX, baseY),
        amplitude: Offset(
          10 + random.nextDouble() * 20,
          8 + random.nextDouble() * 15,
        ),
        frequency: Offset(
          0.5 + random.nextDouble() * 0.8,
          0.7 + random.nextDouble() * 1.0,
        ),
        phase: Offset(
          random.nextDouble() * 2 * math.pi,
          random.nextDouble() * 2 * math.pi,
        ),
        baseSize: 1.5 + random.nextDouble() * 2,
        baseOpacity: 0.3 + random.nextDouble() * 0.4,
        sizeFrequency: 0.3 + random.nextDouble() * 0.5,
        opacityFrequency: 0.4 + random.nextDouble() * 0.6,
        circularRadius: 3 + random.nextDouble() * 8,
        circularSpeed: 0.2 + random.nextDouble() * 0.4,
        type: ParticleType.values[i % ParticleType.values.length],
      ));
    }
    
    return particles;
  }
  
  static double _organicDistribution(
    double value, 
    math.Random random, {
    bool isVertical = false,
  }) {
    // Create more natural, organic distribution
    final jitter = (random.nextDouble() - 0.5) * 0.3;
    final curve = math.sin(value * math.pi);
    
    if (isVertical) {
      // Concentrate particles more in center vertically
      return (0.3 + curve * 0.4 + jitter).clamp(0.1, 0.9);
    } else {
      // More spread horizontally
      return (value + jitter * 0.5).clamp(0.05, 0.95);
    }
  }
}

/// Animated floating particles widget
class AnimatedFloatingParticles extends StatefulWidget {
  /// Width of the container
  final double width;
  
  /// Height of the container
  final double height;
  
  /// Base color for particles
  final Color? baseColor;
  
  /// Number of particles
  final int particleCount;
  
  /// Animation intensity
  final double intensity;
  
  /// Whether to show particle connections
  final bool showConnections;

  const AnimatedFloatingParticles({
    super.key,
    required this.width,
    required this.height,
    this.baseColor,
    this.particleCount = 12,
    this.intensity = 0.8,
    this.showConnections = false,
  });

  @override
  State<AnimatedFloatingParticles> createState() => _AnimatedFloatingParticlesState();
}

class _AnimatedFloatingParticlesState extends State<AnimatedFloatingParticles>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late List<ParticleConfig> _particles;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 20), // Long duration for smooth, slow motion
      vsync: this,
    )..repeat();
    
    _particles = ParticleFactory.createFloatingParticles(
      count: widget.particleCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: FloatingParticlesPainter(
            animationValue: _controller.value,
            particles: _particles,
            baseColor: widget.baseColor ?? AppColors.sageGreen,
            intensity: widget.intensity,
            showConnections: widget.showConnections,
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