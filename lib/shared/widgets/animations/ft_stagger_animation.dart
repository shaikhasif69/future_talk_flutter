import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_durations.dart';

/// Reusable staggered animation widget
/// Combines fade and slide effects with customizable delays
class FTStaggerAnimation extends StatelessWidget {
  const FTStaggerAnimation({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve = Curves.easeOutCubic,
    this.fadeDelay,
    this.slideDelay,
    this.slideBegin = 0.3,
    this.slideEnd = 0.0,
    this.slideDirection = FTStaggerSlideDirection.fromBottom,
  });

  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final Curve curve;
  final Duration? fadeDelay;
  final Duration? slideDelay;
  final double slideBegin;
  final double slideEnd;
  final FTStaggerSlideDirection slideDirection;

  @override
  Widget build(BuildContext context) {
    final baseDuration = duration ?? AppDurations.medium;
    final baseDelay = delay ?? Duration.zero;
    final actualFadeDelay = fadeDelay ?? baseDelay;
    final actualSlideDelay = slideDelay ?? baseDelay;

    switch (slideDirection) {
      case FTStaggerSlideDirection.fromTop:
        return child
            .animate()
            .fadeIn(
              duration: baseDuration,
              delay: actualFadeDelay,
              curve: curve,
            )
            .slideY(
              begin: -slideBegin,
              end: slideEnd,
              duration: baseDuration,
              delay: actualSlideDelay,
              curve: curve,
            );
      case FTStaggerSlideDirection.fromBottom:
        return child
            .animate()
            .fadeIn(
              duration: baseDuration,
              delay: actualFadeDelay,
              curve: curve,
            )
            .slideY(
              begin: slideBegin,
              end: slideEnd,
              duration: baseDuration,
              delay: actualSlideDelay,
              curve: curve,
            );
      case FTStaggerSlideDirection.fromLeft:
        return child
            .animate()
            .fadeIn(
              duration: baseDuration,
              delay: actualFadeDelay,
              curve: curve,
            )
            .slideX(
              begin: -slideBegin,
              end: slideEnd,
              duration: baseDuration,
              delay: actualSlideDelay,
              curve: curve,
            );
      case FTStaggerSlideDirection.fromRight:
        return child
            .animate()
            .fadeIn(
              duration: baseDuration,
              delay: actualFadeDelay,
              curve: curve,
            )
            .slideX(
              begin: slideBegin,
              end: slideEnd,
              duration: baseDuration,
              delay: actualSlideDelay,
              curve: curve,
            );
    }
  }
}

/// Slide direction options for stagger animation
enum FTStaggerSlideDirection {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
}