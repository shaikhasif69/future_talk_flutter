import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_durations.dart';

/// Reusable fade-in animation widget
/// Provides consistent fade-in effects across the app
class FTFadeIn extends StatelessWidget {
  const FTFadeIn({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(
          duration: duration ?? AppDurations.medium,
          delay: delay ?? Duration.zero,
          curve: curve,
        );
  }
}