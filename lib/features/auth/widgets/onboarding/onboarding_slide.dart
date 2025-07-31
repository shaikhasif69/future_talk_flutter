import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/layouts/ft_slide_container.dart';

/// Individual onboarding slide component
class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    this.animationController,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Gradient gradient;
  final AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    return FTSlideContainer(
      icon: icon,
      title: title,
      subtitle: subtitle,
      description: description,
      gradient: gradient,
      animationController: animationController,
    );
  }
}

/// Predefined onboarding slides
class OnboardingSlides {
  static OnboardingSlide welcome({AnimationController? controller}) {
    return OnboardingSlide(
      icon: Icons.message_rounded,
      title: 'Welcome to Future Talk',
      subtitle: 'Mindful Communication',
      description: 'Experience conversations that respect your energy and time. Connect meaningfully without the pressure of instant responses.',
      gradient: AppColors.primaryGradient,
      animationController: controller,
    );
  }

  static OnboardingSlide socialBattery({AnimationController? controller}) {
    return OnboardingSlide(
      icon: Icons.battery_4_bar,
      title: 'Your Social Battery Matters',
      subtitle: 'Energy Management',
      description: 'Set your social energy level and let friends know when you\'re ready to chat. No more social exhaustion or awkward conversations.',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.warmPeach, AppColors.cloudBlue],
      ),
      animationController: controller,
    );
  }

  static OnboardingSlide timeCapsules({AnimationController? controller}) {
    return OnboardingSlide(
      icon: Icons.schedule_send,
      title: 'Time Capsules & Deep Connections',
      subtitle: 'Meaningful Messaging',
      description: 'Send messages to the future, create lasting memories, and build deeper relationships through thoughtful, time-delayed communication.',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lavenderMist, AppColors.dustyRose],
      ),
      animationController: controller,
    );
  }

  static OnboardingSlide forIntroverts({AnimationController? controller}) {
    return OnboardingSlide(
      icon: Icons.self_improvement,
      title: 'Built for Introverts',
      subtitle: 'Your Safe Space',
      description: 'A pressure-free environment designed for thoughtful communication. Take your time, be yourself, and connect authentically.',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.sageGreen, AppColors.warmPeach],
      ),
      animationController: controller,
    );
  }
}