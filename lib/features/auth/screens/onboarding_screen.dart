import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../shared/widgets/ft_button.dart';

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
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with skip button
            _buildTopBar(),
            
            // Main content with slides
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildSlide1(screenSize),
                  _buildSlide2(screenSize),
                  _buildSlide3(screenSize),
                  _buildSlide4(screenSize),
                ],
              ),
            ),
            
            // Bottom section with indicators and navigation
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo/Brand
          Container(
            width: AppDimensions.logoSmall,
            height: AppDimensions.logoSmall,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: const Icon(
              Icons.message_rounded,
              color: AppColors.pearlWhite,
              size: 24.0,
            ),
          ),
          
          // Skip button
          FTButton.text(
            text: 'Skip',
            onPressed: _skipOnboarding,
            size: FTButtonSize.small,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: AppDurations.medium,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: -0.2,
          end: 0.0,
          duration: AppDurations.medium,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        children: [
          // Page indicators
          _buildPageIndicators(),
          
          const SizedBox(height: AppDimensions.spacingXXL),
          
          // Next/Get Started button
          SizedBox(
            width: double.infinity,
            child: FTButton.primary(
              text: _currentPage == _totalPages - 1 ? 'Get Started' : 'Next',
              onPressed: _nextPage,
              icon: _currentPage == _totalPages - 1 ? Icons.rocket_launch : Icons.arrow_forward,
              iconPosition: FTButtonIconPosition.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPages, (index) {
        return AnimatedContainer(
          duration: AppDurations.medium,
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index 
                ? AppColors.sageGreen 
                : AppColors.whisperGray,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }

  Widget _buildSlide1(Size screenSize) {
    return _buildSlideContainer(
      icon: Icons.message_rounded,
      title: 'Welcome to Future Talk',
      subtitle: 'Mindful Communication',
      description: 'Experience conversations that respect your energy and time. Connect meaningfully without the pressure of instant responses.',
      gradient: AppColors.primaryGradient,
    );
  }

  Widget _buildSlide2(Size screenSize) {
    return _buildSlideContainer(
      icon: Icons.battery_4_bar,
      title: 'Your Social Battery Matters',
      subtitle: 'Energy Management',
      description: 'Set your social energy level and let friends know when you\'re ready to chat. No more social exhaustion or awkward conversations.',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.warmPeach, AppColors.cloudBlue],
      ),
    );
  }

  Widget _buildSlide3(Size screenSize) {
    return _buildSlideContainer(
      icon: Icons.schedule_send,
      title: 'Time Capsules & Deep Connections',
      subtitle: 'Meaningful Messaging',
      description: 'Send messages to the future, create lasting memories, and build deeper relationships through thoughtful, time-delayed communication.',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lavenderMist, AppColors.dustyRose],
      ),
    );
  }

  Widget _buildSlide4(Size screenSize) {
    return _buildSlideContainer(
      icon: Icons.self_improvement,
      title: 'Built for Introverts',
      subtitle: 'Your Safe Space',
      description: 'A pressure-free environment designed for thoughtful communication. Take your time, be yourself, and connect authentically.',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.sageGreen, AppColors.warmPeach],
      ),
    );
  }

  Widget _buildSlideContainer({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Gradient gradient,
  }) {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container with gradient
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 16.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 56.0,
                  color: AppColors.pearlWhite,
                ),
              )
                  .animate()
                  .scale(
                    duration: AppDurations.slow,
                    curve: Curves.elasticOut,
                  )
                  .shimmer(
                    duration: Duration(milliseconds: 1500),
                    color: AppColors.pearlWhite.withValues(alpha: 0.3),
                  ),
              
              const SizedBox(height: AppDimensions.spacingXXXL),
              
              // Subtitle
              Text(
                subtitle,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.sageGreen,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(
                    duration: AppDurations.medium,
                    delay: Duration(milliseconds: 200),
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0.0,
                    duration: AppDurations.medium,
                    delay: Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                  ),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              // Title
              Text(
                title,
                style: AppTextStyles.displayMedium,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(
                    duration: AppDurations.medium,
                    delay: Duration(milliseconds: 400),
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0.0,
                    duration: AppDurations.medium,
                    delay: Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                  ),
              
              const SizedBox(height: AppDimensions.spacingXL),
              
              // Description
              Text(
                description,
                style: AppTextStyles.bodyLarge.copyWith(
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              )
                  .animate()
                  .fadeIn(
                    duration: AppDurations.medium,
                    delay: Duration(milliseconds: 600),
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0.0,
                    duration: AppDurations.medium,
                    delay: Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  ),
            ],
          ),
        );
      },
    );
  }
}