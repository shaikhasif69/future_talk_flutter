import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_durations.dart';

/// Reusable slide transition animation widget
/// Provides consistent slide animations across the app
class FTSlideTransition extends StatelessWidget {
  const FTSlideTransition({
    super.key,
    required this.child,
    this.duration,
    this.delay,
    this.curve = Curves.easeOutCubic,
    this.begin = 0.3,
    this.end = 0.0,
    this.direction = FTSlideDirection.fromBottom,
  });

  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final Curve curve;
  final double begin;
  final double end;
  final FTSlideDirection direction;

  @override
  Widget build(BuildContext context) {
    switch (direction) {
      case FTSlideDirection.fromTop:
        return child
            .animate()
            .slideY(
              begin: -begin,
              end: end,
              duration: duration ?? AppDurations.medium,
              delay: delay ?? Duration.zero,
              curve: curve,
            );
      case FTSlideDirection.fromBottom:
        return child
            .animate()
            .slideY(
              begin: begin,
              end: end,
              duration: duration ?? AppDurations.medium,
              delay: delay ?? Duration.zero,
              curve: curve,
            );
      case FTSlideDirection.fromLeft:
        return child
            .animate()
            .slideX(
              begin: -begin,
              end: end,
              duration: duration ?? AppDurations.medium,
              delay: delay ?? Duration.zero,
              curve: curve,
            );
      case FTSlideDirection.fromRight:
        return child
            .animate()
            .slideX(
              begin: begin,
              end: end,
              duration: duration ?? AppDurations.medium,
              delay: delay ?? Duration.zero,
              curve: curve,
            );
    }
  }
}

/// Slide direction options
enum FTSlideDirection {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
}