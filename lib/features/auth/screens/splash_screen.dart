import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../routing/app_router.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../../../shared/widgets/indicators/ft_loading_indicator.dart';
import '../widgets/splash/splash_background.dart';
import '../widgets/splash/splash_logo.dart';
import '../widgets/splash/splash_particles.dart';
import '../providers/auth_provider.dart';

/// Future Talk's Premium Splash Screen
/// Features floating logo with breathing particles and smooth animations
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _loadingController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _loadingAnimation;

  bool _hasNavigated = false;

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
    
    // Set minimum splash duration
    Future.delayed(AppDurations.splashTotal, () {
      if (mounted && !_hasNavigated) {
        _checkAndNavigate();
      }
    });
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

  void _checkAndNavigate() {
    if (_hasNavigated || !mounted) return;
    
    final authState = ref.read(authProvider);
    print('🚀 [Splash] Final auth check: isInitialized=${authState.isInitialized}, isLoggedIn=${authState.isLoggedIn}');
    
    _hasNavigated = true;
    
    if (authState.isInitialized) {
      if (authState.isLoggedIn) {
        print('🚀 [Splash] Navigating to dashboard');
        context.goToDashboard();
      } else {
        print('🚀 [Splash] Navigating to onboarding');
        context.goToOnboarding();
      }
    } else {
      print('🚀 [Splash] Auth not initialized, defaulting to onboarding');
      context.goToOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    // Listen for auth state changes in build method
    ref.listen<AuthState>(authProvider, (previous, next) {
      print('🚀 [Splash] Auth state changed: isInitialized=${next.isInitialized}, isLoggedIn=${next.isLoggedIn}');
      if (next.isInitialized && mounted && !_hasNavigated) {
        _hasNavigated = true;
        if (next.isLoggedIn) {
          print('🚀 [Splash] Navigating to dashboard (from listener)');
          context.goToDashboard();
        } else {
          print('🚀 [Splash] Navigating to onboarding (from listener)');
          context.goToOnboarding();
        }
      }
    });
    
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const SplashBackground(),
          
          // Floating particles
          SplashParticles(
            particleController: _particleController,
            screenSize: screenSize,
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animations
                SplashLogo(
                  logoScaleAnimation: _logoScaleAnimation,
                  logoOpacityAnimation: _logoOpacityAnimation,
                ),
                
                const SizedBox(height: AppDimensions.spacingXXXL),
                
                // App title and tagline
                _buildTitleSection(),
                
                const SizedBox(height: AppDimensions.spacingHuge),
                
                // Loading indicator
                FTLoadingIndicator(
                  text: 'Preparing your sanctuary...',
                  progress: _loadingAnimation.value,
                ),
              ],
            ),
          ),
        ],
      ),
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
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 500),
                child: Text(
                  'Future Talk',
                  style: AppTextStyles.logoText,
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 700),
                child: Text(
                  'Thoughtful connections across time',
                  style: AppTextStyles.tagline,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}