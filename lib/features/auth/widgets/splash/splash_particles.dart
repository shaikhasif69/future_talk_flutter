import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Floating particles background for splash screen
class SplashParticles extends StatelessWidget {
  const SplashParticles({
    super.key,
    required this.particleController,
    required this.screenSize,
  });

  final AnimationController particleController;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final double animationOffset = (index * 0.2) % 1.0;
            final double adjustedAnimation = 
                (particleController.value + animationOffset) % 1.0;
            
            return _buildParticle(index, adjustedAnimation);
          }),
        );
      },
    );
  }

  Widget _buildParticle(int index, double animation) {
    final positions = [
      Offset(screenSize.width * 0.1, screenSize.height * 0.2),
      Offset(screenSize.width * 0.8, screenSize.height * 0.15),
      Offset(screenSize.width * 0.15, screenSize.height * 0.7),
      Offset(screenSize.width * 0.85, screenSize.height * 0.6),
      Offset(screenSize.width * 0.3, screenSize.height * 0.3),
      Offset(screenSize.width * 0.7, screenSize.height * 0.8),
    ];
    
    final position = positions[index % positions.length];
    final floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: particleController,
      curve: Curves.easeInOut,
    ));
    
    final scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: particleController,
      curve: Curves.easeInOut,
    ));
    
    final opacityAnimation = Tween<double>(
      begin: 0.2,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: particleController,
      curve: Curves.easeInOut,
    ));

    return Positioned(
      left: position.dx,
      top: position.dy + floatAnimation.value,
      child: Transform.scale(
        scale: scaleAnimation.value,
        child: Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: AppColors.lavenderMist.withValues(
              alpha: opacityAnimation.value,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.lavenderMist.withValues(
                  alpha: opacityAnimation.value * 0.5,
                ),
                blurRadius: 8.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}