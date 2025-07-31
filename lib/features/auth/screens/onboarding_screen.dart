import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_durations.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../widgets/onboarding/onboarding_slide.dart';
import '../widgets/onboarding/onboarding_navigation.dart';

/// Future Talk's Premium Onboarding Screen
/// Features 4 interactive slides with smooth animations and engaging content
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  
  int _currentPage = 0;
  static const int _totalPages = 4;

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController();
    
    _slideController = AnimationController(
      duration: AppDurations.onboardingSlide,
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: AppDurations.onboardingFade,
      vsync: this,
    );
    
    // Start initial animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.selectionClick();
      _pageController.nextPage(
        duration: AppDurations.onboardingSlide,
        curve: Curves.easeOutCubic,
      );
    } else {
      _navigateToSignUp();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _navigateToSignUp();
  }

  void _navigateToSignUp() {
    context.go('/sign_up');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    
    // Reset and restart slide animation for new page
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with skip button
            FTStaggerAnimation(
              slideDirection: FTStaggerSlideDirection.fromTop,
              child: OnboardingTopBar(
                onSkipPressed: _skipOnboarding,
              ),
            ),
            
            // Main content with slides
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  OnboardingSlides.welcome(controller: _slideController),
                  OnboardingSlides.socialBattery(controller: _slideController),
                  OnboardingSlides.timeCapsules(controller: _slideController),
                  OnboardingSlides.forIntroverts(controller: _slideController),
                ],
              ),
            ),
            
            // Bottom section with indicators and navigation
            OnboardingNavigation(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onNextPressed: _nextPage,
              onSkipPressed: _skipOnboarding,
            ),
          ],
        ),
      ),
    );
  }



}