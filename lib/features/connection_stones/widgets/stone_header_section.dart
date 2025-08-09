import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../providers/connection_stones_provider.dart';
import '../models/touch_interaction_model.dart';
import '../utils/app_constants.dart';

/// Magical header section for Connection Stones with floating animations
class StoneHeaderSection extends ConsumerStatefulWidget {
  const StoneHeaderSection({super.key});

  @override
  ConsumerState<StoneHeaderSection> createState() => _StoneHeaderSectionState();
}

class _StoneHeaderSectionState extends ConsumerState<StoneHeaderSection>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comfortStats = ref.watch(comfortStatsProvider);
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dustyRose,
            AppColors.dustyRose.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Floating background elements
          _buildFloatingElements(),
          
          // Main header content
          Padding(
            padding: const EdgeInsets.all(StoneConstants.paddingLarge),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with animated stone emoji
                  _buildAnimatedTitle(),
                  
                  const SizedBox(height: StoneConstants.paddingSmall),
                  
                  // Subtitle
                  Text(
                    'Digital comfort objects that bridge hearts',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: StoneConstants.paddingLarge),
                  
                  // Comfort statistics
                  _buildComfortStats(comfortStats),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: [
            // Large floating circle
            Positioned(
              top: -30 + (10 * _floatingController.value),
              right: -30 + (5 * _floatingController.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.1, 1.1),
                  duration: const Duration(seconds: 6),
                  curve: Curves.easeInOut,
                ),
            ),
            
            // Medium floating circle
            Positioned(
              bottom: -20 + (15 * _floatingController.value),
              left: -20 - (8 * _floatingController.value),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.2, 1.2),
                  duration: const Duration(seconds: 8),
                  curve: Curves.easeInOut,
                ),
            ),
            
            // Small floating particles
            ..._buildFloatingParticles(),
          ],
        );
      },
    );
  }

  List<Widget> _buildFloatingParticles() {
    return List.generate(5, (index) {
      final delay = index * 0.2;
      final size = 3.0 + (index * 2);
      
      return AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          final progress = (_particleController.value + delay) % 1.0;
          
          return Positioned(
            left: 50 + (index * 60) + (20 * progress),
            top: 180 - (160 * progress),
            child: Opacity(
              opacity: (1 - progress) * 0.6,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Row(
          children: [
            // Animated stone emoji
            Transform.scale(
              scale: 1.0 + (0.1 * _pulseController.value),
              child: Transform.rotate(
                angle: 0.1 * _pulseController.value,
                child: const Text(
                  '🪨',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            
            const SizedBox(width: StoneConstants.paddingSmall),
            
            // Title text
            Text(
              'Connection Stones',
              style: AppTextStyles.displayMedium.copyWith(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildComfortStats(ComfortStats stats) {
    return Row(
      children: [
        _buildStatItem(
          value: stats.touchesGiven.toString(),
          label: 'Touches Given',
        ),
        
        _buildStatDivider(),
        
        _buildStatItem(
          value: stats.comfortReceived.toString(),
          label: 'Comfort Received',
        ),
        
        _buildStatDivider(),
        
        _buildStatItem(
          value: stats.sacredStones.toString(),
          label: 'Sacred Stones',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headlineLarge.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              duration: const Duration(seconds: 2),
              color: Colors.white.withValues(alpha: 0.3),
            ),
          
          const SizedBox(height: 2),
          
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: StoneConstants.paddingSmall),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

/// Premium gradient header with enhanced visual effects
class PremiumGradientHeader extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final List<double>? gradientStops;

  const PremiumGradientHeader({
    super.key,
    required this.child,
    required this.gradientColors,
    this.gradientStops,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: gradientStops,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Magical floating comfort particles widget
class FloatingComfortParticles extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double particleSize;
  final Duration animationDuration;

  const FloatingComfortParticles({
    super.key,
    this.particleCount = 8,
    this.particleColor = Colors.white,
    this.particleSize = 3.0,
    this.animationDuration = const Duration(seconds: 12),
  });

  @override
  State<FloatingComfortParticles> createState() => _FloatingComfortParticlesState();
}

class _FloatingComfortParticlesState extends State<FloatingComfortParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ComfortParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();
    
    // Initialize particles
    _initializeParticles();
  }

  void _initializeParticles() {
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(ComfortParticle(
        delay: i * 0.15,
        horizontalOffset: (i % 3) * 0.3,
        size: widget.particleSize + (i % 3),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _particles.map((particle) {
            return _buildParticle(particle);
          }).toList(),
        );
      },
    );
  }

  Widget _buildParticle(ComfortParticle particle) {
    final progress = (_controller.value + particle.delay) % 1.0;
    final opacity = _calculateParticleOpacity(progress);
    
    return Positioned(
      left: MediaQuery.of(context).size.width * 
            (0.1 + particle.horizontalOffset + (progress * 0.3)),
      bottom: -particle.size + (MediaQuery.of(context).size.height * progress),
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: particle.size,
          height: particle.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.particleColor.withValues(alpha: 0.4),
            boxShadow: [
              BoxShadow(
                color: widget.particleColor.withValues(alpha: 0.2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateParticleOpacity(double progress) {
    if (progress < 0.1) {
      return progress * 10; // Fade in
    } else if (progress > 0.9) {
      return (1 - progress) * 10; // Fade out
    } else {
      return 1.0; // Full opacity
    }
  }
}

/// Data class for comfort particle properties
class ComfortParticle {
  final double delay;
  final double horizontalOffset;
  final double size;

  ComfortParticle({
    required this.delay,
    required this.horizontalOffset,
    required this.size,
  });
}