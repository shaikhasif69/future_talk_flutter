import 'dart:math';
import 'package:flutter/material.dart';

/// Magical floating comfort particles that create ambient atmosphere
class FloatingComfortParticles extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double minSize;
  final double maxSize;
  final Duration animationDuration;
  final double opacity;
  final bool enableGlow;

  const FloatingComfortParticles({
    super.key,
    this.particleCount = 12,
    this.particleColor = const Color(0xFFD4A5A5),
    this.minSize = 2.0,
    this.maxSize = 6.0,
    this.animationDuration = const Duration(seconds: 15),
    this.opacity = 0.4,
    this.enableGlow = true,
  });

  @override
  State<FloatingComfortParticles> createState() => _FloatingComfortParticlesState();
}

class _FloatingComfortParticlesState extends State<FloatingComfortParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ComfortParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();
    
    _initializeParticles();
  }

  void _initializeParticles() {
    _particles.clear();
    
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(ComfortParticle(
        id: i,
        size: widget.minSize + _random.nextDouble() * (widget.maxSize - widget.minSize),
        startX: _random.nextDouble(),
        endX: _random.nextDouble(),
        speed: 0.8 + _random.nextDouble() * 0.4, // Speed variation
        delay: _random.nextDouble() * 0.8, // Stagger start times
        horizontalDrift: (_random.nextDouble() - 0.5) * 0.3, // Side-to-side movement
        pulseSpeed: 1.0 + _random.nextDouble() * 2.0, // Pulse variation
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: _particles.map((particle) {
                  return _buildParticle(particle, constraints);
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildParticle(ComfortParticle particle, BoxConstraints constraints) {
    final progress = (_controller.value * particle.speed + particle.delay) % 1.0;
    final opacity = _calculateOpacity(progress);
    
    if (opacity <= 0.0) {
      return const SizedBox.shrink();
    }
    
    final x = _calculateXPosition(particle, progress, constraints.maxWidth);
    final y = _calculateYPosition(progress, constraints.maxHeight, particle.size);
    
    return Positioned(
      left: x,
      bottom: y,
      child: _buildParticleWidget(particle, opacity),
    );
  }

  Widget _buildParticleWidget(ComfortParticle particle, double opacity) {
    final pulseProgress = (_controller.value * particle.pulseSpeed) % 1.0;
    final pulseScale = 1.0 + (0.2 * (1 + pulseProgress) / 2);
    
    return Transform.scale(
      scale: pulseScale,
      child: Container(
        width: particle.size,
        height: particle.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.particleColor.withOpacity(widget.opacity * opacity),
          boxShadow: widget.enableGlow ? [
            BoxShadow(
              color: widget.particleColor.withOpacity(widget.opacity * opacity * 0.5),
              blurRadius: particle.size * 2,
              spreadRadius: particle.size * 0.5,
            ),
          ] : null,
        ),
      ),
    );
  }

  double _calculateOpacity(double progress) {
    if (progress < 0.1) {
      return progress * 10; // Fade in
    } else if (progress > 0.9) {
      return (1 - progress) * 10; // Fade out
    } else {
      return 1.0; // Full opacity
    }
  }

  double _calculateXPosition(ComfortParticle particle, double progress, double screenWidth) {
    final baseX = particle.startX + (particle.endX - particle.startX) * progress;
    final drift = particle.horizontalDrift * sin(progress * pi * 2);
    return (baseX + drift) * screenWidth - particle.size / 2;
  }

  double _calculateYPosition(double progress, double screenHeight, double particleSize) {
    return -particleSize + (screenHeight + particleSize * 2) * progress;
  }
}

/// Data class for individual comfort particles
class ComfortParticle {
  final int id;
  final double size;
  final double startX;
  final double endX;
  final double speed;
  final double delay;
  final double horizontalDrift;
  final double pulseSpeed;

  ComfortParticle({
    required this.id,
    required this.size,
    required this.startX,
    required this.endX,
    required this.speed,
    required this.delay,
    required this.horizontalDrift,
    required this.pulseSpeed,
  });
}

/// Heart-shaped comfort particles for special moments
class FloatingHeartParticles extends StatefulWidget {
  final int heartCount;
  final Color heartColor;
  final double minSize;
  final double maxSize;
  final Duration animationDuration;

  const FloatingHeartParticles({
    super.key,
    this.heartCount = 8,
    this.heartColor = const Color(0xFFD4A5A5),
    this.minSize = 12.0,
    this.maxSize = 20.0,
    this.animationDuration = const Duration(seconds: 10),
  });

  @override
  State<FloatingHeartParticles> createState() => _FloatingHeartParticlesState();
}

class _FloatingHeartParticlesState extends State<FloatingHeartParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<HeartParticle> _hearts = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();
    
    _initializeHearts();
  }

  void _initializeHearts() {
    for (int i = 0; i < widget.heartCount; i++) {
      _hearts.add(HeartParticle(
        size: widget.minSize + _random.nextDouble() * (widget.maxSize - widget.minSize),
        startX: _random.nextDouble(),
        delay: _random.nextDouble(),
        rotationSpeed: (_random.nextDouble() - 0.5) * 4, // Rotation variation
        pulsePhase: _random.nextDouble() * pi * 2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: _hearts.map((heart) {
                  return _buildHeart(heart, constraints);
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeart(HeartParticle heart, BoxConstraints constraints) {
    final progress = (_controller.value + heart.delay) % 1.0;
    final opacity = _calculateOpacity(progress);
    
    if (opacity <= 0.0) {
      return const SizedBox.shrink();
    }
    
    final x = heart.startX * constraints.maxWidth - heart.size / 2;
    final y = -heart.size + (constraints.maxHeight + heart.size * 2) * progress;
    
    final rotation = _controller.value * heart.rotationSpeed;
    final pulseScale = 1.0 + 0.3 * sin(_controller.value * 3 + heart.pulsePhase);
    
    return Positioned(
      left: x,
      bottom: y,
      child: Transform.rotate(
        angle: rotation,
        child: Transform.scale(
          scale: pulseScale,
          child: Opacity(
            opacity: opacity,
            child: Icon(
              Icons.favorite,
              size: heart.size,
              color: widget.heartColor,
            ),
          ),
        ),
      ),
    );
  }

  double _calculateOpacity(double progress) {
    if (progress < 0.1) {
      return progress * 10;
    } else if (progress > 0.8) {
      return (1 - progress) * 5;
    } else {
      return 1.0;
    }
  }
}

/// Data class for heart particles
class HeartParticle {
  final double size;
  final double startX;
  final double delay;
  final double rotationSpeed;
  final double pulsePhase;

  HeartParticle({
    required this.size,
    required this.startX,
    required this.delay,
    required this.rotationSpeed,
    required this.pulsePhase,
  });
}

/// Sparkle particles for magical moments
class FloatingSparkleParticles extends StatefulWidget {
  final int sparkleCount;
  final Color sparkleColor;
  final double minSize;
  final double maxSize;
  final Duration animationDuration;

  const FloatingSparkleParticles({
    super.key,
    this.sparkleCount = 15,
    this.sparkleColor = const Color(0xFFF4C2A1),
    this.minSize = 8.0,
    this.maxSize = 16.0,
    this.animationDuration = const Duration(seconds: 8),
  });

  @override
  State<FloatingSparkleParticles> createState() => _FloatingSparkleParticlesState();
}

class _FloatingSparkleParticlesState extends State<FloatingSparkleParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<SparkleParticle> _sparkles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();
    
    _initializeSparkles();
  }

  void _initializeSparkles() {
    for (int i = 0; i < widget.sparkleCount; i++) {
      _sparkles.add(SparkleParticle(
        size: widget.minSize + _random.nextDouble() * (widget.maxSize - widget.minSize),
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        delay: _random.nextDouble(),
        twinkleSpeed: 2.0 + _random.nextDouble() * 3.0,
        rotationSpeed: (_random.nextDouble() - 0.5) * 6,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: _sparkles.map((sparkle) {
                  return _buildSparkle(sparkle, constraints);
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSparkle(SparkleParticle sparkle, BoxConstraints constraints) {
    final twinkleProgress = (_controller.value * sparkle.twinkleSpeed + sparkle.delay) % 1.0;
    final opacity = sin(twinkleProgress * pi * 2) * 0.5 + 0.5;
    
    final x = sparkle.x * constraints.maxWidth - sparkle.size / 2;
    final y = sparkle.y * constraints.maxHeight - sparkle.size / 2;
    
    final rotation = _controller.value * sparkle.rotationSpeed;
    
    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        angle: rotation,
        child: Opacity(
          opacity: opacity * 0.6,
          child: Icon(
            Icons.star,
            size: sparkle.size,
            color: widget.sparkleColor,
          ),
        ),
      ),
    );
  }
}

/// Data class for sparkle particles
class SparkleParticle {
  final double size;
  final double x;
  final double y;
  final double delay;
  final double twinkleSpeed;
  final double rotationSpeed;

  SparkleParticle({
    required this.size,
    required this.x,
    required this.y,
    required this.delay,
    required this.twinkleSpeed,
    required this.rotationSpeed,
  });
}

/// Composite magical background with multiple particle types
class MagicalComfortBackground extends StatelessWidget {
  final bool enableHearts;
  final bool enableSparkles;
  final bool enableBasicParticles;
  final Color primaryColor;
  final Color secondaryColor;

  const MagicalComfortBackground({
    super.key,
    this.enableHearts = true,
    this.enableSparkles = true,
    this.enableBasicParticles = true,
    this.primaryColor = const Color(0xFFD4A5A5),
    this.secondaryColor = const Color(0xFFF4C2A1),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Basic comfort particles
        if (enableBasicParticles)
          FloatingComfortParticles(
            particleCount: 8,
            particleColor: primaryColor,
            minSize: 2.0,
            maxSize: 5.0,
            animationDuration: const Duration(seconds: 12),
            opacity: 0.3,
          ),
        
        // Heart particles (fewer, larger)
        if (enableHearts)
          FloatingHeartParticles(
            heartCount: 3,
            heartColor: primaryColor.withOpacity(0.4),
            minSize: 12.0,
            maxSize: 18.0,
            animationDuration: const Duration(seconds: 15),
          ),
        
        // Sparkle particles
        if (enableSparkles)
          FloatingSparkleParticles(
            sparkleCount: 6,
            sparkleColor: secondaryColor.withOpacity(0.5),
            minSize: 6.0,
            maxSize: 12.0,
            animationDuration: const Duration(seconds: 10),
          ),
      ],
    );
  }
}

/// Stone-specific magical background
class StoneComfortBackground extends StatelessWidget {
  final Color stoneColor;
  final bool isActive; // Whether stone is being touched or receiving

  const StoneComfortBackground({
    super.key,
    required this.stoneColor,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return MagicalComfortBackground(
      enableHearts: isActive,
      enableSparkles: isActive,
      enableBasicParticles: true,
      primaryColor: stoneColor,
      secondaryColor: stoneColor.withOpacity(0.7),
    );
  }
}