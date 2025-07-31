import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../routing/app_router.dart';

/// Future Talk's Premium Splash Screen
/// Features floating logo with breathing particles and smooth animations
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _loadingController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: AppDurations.splashLogo,
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: AppDurations.particleFloat,
      vsync: this,
    );
    
    _loadingController = AnimationController(
      duration: AppDurations.progressBar,
      vsync: this,
    );
    
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));
    
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
    
    _startAnimations();
    _navigateToOnboarding();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _startAnimations() {
    // Start logo animation
    _logoController.forward();
    
    // Start particle animation (repeating)
    _particleController.repeat();
    
    // Start loading animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadingController.forward();
      }
    });
  }

  void _navigateToOnboarding() {
    Future.delayed(AppDurations.splashTotal, () {
      if (mounted) {
        context.goToOnboarding();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Floating particles background
            _buildFloatingParticles(screenSize),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with glow effect
                  _buildLogoContainer(),
                  
                  const SizedBox(height: AppDimensions.spacingXXXL),
                  
                  // App title and tagline
                  _buildTitleSection(),
                  
                  const SizedBox(height: AppDimensions.spacingHuge),
                  
                  // Loading section
                  _buildLoadingSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticles(Size screenSize) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final double animationOffset = (index * 0.2) % 1.0;
            final double adjustedAnimation = 
                (_particleController.value + animationOffset) % 1.0;
            
            return _buildParticle(
              screenSize,
              index,
              adjustedAnimation,
            );
          }),
        );
      },
    );
  }

  Widget _buildParticle(Size screenSize, int index, double animation) {
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
      parent: _particleController,
      curve: Curves.easeInOut,
    ));
    
    final scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));
    
    final opacityAnimation = Tween<double>(
      begin: 0.2,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _particleController,
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

  Widget _buildLogoContainer() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoScaleAnimation, _logoOpacityAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              width: AppDimensions.logoLarge,
              height: AppDimensions.logoLarge,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppDimensions.logoRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withValues(alpha: 0.3),
                    blurRadius: 24.0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.message_rounded,
                size: 64.0,
                color: AppColors.pearlWhite,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: Duration(milliseconds: 2000),
                  color: AppColors.pearlWhite.withValues(alpha: 0.3),
                )
                .then()
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                  duration: Duration(milliseconds: 3000),
                  curve: Curves.easeInOut,
                ),
          ),
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return AnimatedBuilder(
      animation: _textOpacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacityAnimation.value,
          child: Column(
            children: [
              Text(
                'Future Talk',
                style: AppTextStyles.logoText,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(
                    duration: AppDurations.splashFadeIn,
                    delay: Duration(milliseconds: 500),
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0.0,
                    duration: AppDurations.splashFadeIn,
                    delay: Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                  ),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              Text(
                'Thoughtful connections across time',
                style: AppTextStyles.tagline,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(
                    duration: AppDurations.splashFadeIn,
                    delay: Duration(milliseconds: 700),
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0.0,
                    duration: AppDurations.splashFadeIn,
                    delay: Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Column(
          children: [
            Text(
              'Preparing your sanctuary...',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.sageGreen,
                fontWeight: FontWeight.w500,
              ),
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 1000),
                )
                .slideY(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 1000),
                ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            // Custom loading bar
            Container(
              width: 200.0,
              height: AppDimensions.progressBarHeight,
              decoration: BoxDecoration(
                color: AppColors.whisperGray,
                borderRadius: BorderRadius.circular(AppDimensions.progressBarRadius),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _loadingAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.loadingGradient,
                    borderRadius: BorderRadius.circular(AppDimensions.progressBarRadius),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sageGreen.withValues(alpha: 0.4),
                        blurRadius: 4.0,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 1200),
                )
                .slideY(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 1200),
                ),
          ],
        );
      },
    );
  }
}