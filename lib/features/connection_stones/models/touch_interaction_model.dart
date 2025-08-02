import 'package:freezed_annotation/freezed_annotation.dart';

part 'touch_interaction_model.freezed.dart';
part 'touch_interaction_model.g.dart';

/// Model representing a touch interaction with a connection stone
@freezed
class TouchInteraction with _$TouchInteraction {
  const factory TouchInteraction({
    /// Unique identifier for this interaction
    required String id,
    
    /// ID of the stone that was touched
    required String stoneId,
    
    /// Type of interaction
    required TouchType touchType,
    
    /// When the interaction occurred
    required DateTime timestamp,
    
    /// Duration of the touch (for long presses)
    Duration? duration,
    
    /// Whether this was sent or received
    required TouchDirection direction,
    
    /// Friend involved in the interaction
    required String friendId,
    
    /// Optional message sent with the touch
    String? message,
    
    /// Intensity of the touch (0.0 to 1.0)
    @Default(1.0) double intensity,
    
    /// Whether this interaction included haptic feedback
    @Default(true) bool hadHapticFeedback,
    
    /// Location on screen where touch occurred (for ripple effects)
    TouchLocation? touchLocation,
  }) = _TouchInteraction;

  factory TouchInteraction.fromJson(Map<String, dynamic> json) =>
      _$TouchInteractionFromJson(json);
}

/// Type of touch interaction
enum TouchType {
  quickTouch,    // Quick tap for instant comfort
  longPress,     // Long press for deep comfort
  doubleTap,     // Double tap for special messages
  heartTouch,    // Special heart-shaped touch pattern
}

/// Direction of the touch interaction
enum TouchDirection {
  sent,          // User sent comfort to friend
  received,      // User received comfort from friend
}

/// Location data for touch ripple effects
@freezed
class TouchLocation with _$TouchLocation {
  const factory TouchLocation({
    required double x,
    required double y,
    @Default(50.0) double size,
  }) = _TouchLocation;

  factory TouchLocation.fromJson(Map<String, dynamic> json) =>
      _$TouchLocationFromJson(json);
}

/// Extensions for TouchInteraction
extension TouchInteractionExtensions on TouchInteraction {
  /// Get display text for the touch type
  String get touchTypeDisplay {
    switch (touchType) {
      case TouchType.quickTouch:
        return 'Quick Comfort';
      case TouchType.longPress:
        return 'Deep Comfort';
      case TouchType.doubleTap:
        return 'Special Touch';
      case TouchType.heartTouch:
        return 'Heart Touch';
    }
  }

  /// Get emoji for the touch type
  String get touchTypeEmoji {
    switch (touchType) {
      case TouchType.quickTouch:
        return '✨';
      case TouchType.longPress:
        return '💕';
      case TouchType.doubleTap:
        return '💫';
      case TouchType.heartTouch:
        return '💖';
    }
  }

  /// Get formatted timestamp
  String get timeDisplay {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }

  /// Get intensity display
  String get intensityDisplay {
    if (intensity >= 0.8) return 'Intense';
    if (intensity >= 0.6) return 'Strong';
    if (intensity >= 0.4) return 'Gentle';
    return 'Soft';
  }

  /// Whether this touch should trigger strong haptic feedback
  bool get shouldUseStrongHaptics {
    return touchType == TouchType.longPress || 
           touchType == TouchType.heartTouch ||
           intensity >= 0.7;
  }

  /// Get the ripple animation duration based on touch type
  Duration get rippleDuration {
    switch (touchType) {
      case TouchType.quickTouch:
        return const Duration(milliseconds: 400);
      case TouchType.longPress:
        return const Duration(milliseconds: 800);
      case TouchType.doubleTap:
        return const Duration(milliseconds: 300);
      case TouchType.heartTouch:
        return const Duration(milliseconds: 1000);
    }
  }

  /// Generate a display message for the interaction
  String getDisplayMessage(String stoneName, String friendName) {
    final direction = this.direction == TouchDirection.sent ? 'to' : 'from';
    final directionEmoji = this.direction == TouchDirection.sent ? '→' : '←';
    
    return '$touchTypeEmoji $touchTypeDisplay $directionEmoji $friendName';
  }
}

/// Comfort stats aggregated from touch interactions
@freezed
class ComfortStats with _$ComfortStats {
  const factory ComfortStats({
    /// Total comfort touches given
    @Default(0) int touchesGiven,
    
    /// Total comfort received
    @Default(0) int comfortReceived,
    
    /// Number of sacred stones (highly connected)
    @Default(0) int sacredStones,
    
    /// Current streak of daily interactions
    @Default(0) int dailyStreak,
    
    /// Total stones created
    @Default(0) int totalStones,
    
    /// Favorite stone type
    String? favoriteStoneType,
    
    /// Most connected friend
    String? mostConnectedFriend,
    
    /// Weekly touch goal
    @Default(21) int weeklyTouchGoal,
    
    /// Current week's touches
    @Default(0) int weeklyTouches,
    
    /// Monthly comfort received goal
    @Default(30) int monthlyComfortGoal,
    
    /// Current month's comfort received
    @Default(0) int monthlyComfortReceived,
  }) = _ComfortStats;

  factory ComfortStats.fromJson(Map<String, dynamic> json) =>
      _$ComfortStatsFromJson(json);
}

/// Extensions for ComfortStats
extension ComfortStatsExtensions on ComfortStats {
  /// Calculate weekly progress percentage
  double get weeklyProgress {
    return (weeklyTouches / weeklyTouchGoal).clamp(0.0, 1.0);
  }

  /// Calculate monthly progress percentage
  double get monthlyProgress {
    return (monthlyComfortReceived / monthlyComfortGoal).clamp(0.0, 1.0);
  }

  /// Get achievement level based on total touches
  String get achievementLevel {
    if (touchesGiven >= 500) return 'Stone Master';
    if (touchesGiven >= 200) return 'Comfort Keeper';
    if (touchesGiven >= 100) return 'Heart Bridge';
    if (touchesGiven >= 50) return 'Touch Sender';
    if (touchesGiven >= 20) return 'Stone Friend';
    return 'New Toucher';
  }

  /// Get achievement emoji
  String get achievementEmoji {
    if (touchesGiven >= 500) return '🏆';
    if (touchesGiven >= 200) return '💎';
    if (touchesGiven >= 100) return '🌟';
    if (touchesGiven >= 50) return '✨';
    if (touchesGiven >= 20) return '💝';
    return '🌱';
  }

  /// Whether user has reached their weekly goal
  bool get weeklyGoalReached => weeklyTouches >= weeklyTouchGoal;

  /// Whether user has reached their monthly goal
  bool get monthlyGoalReached => monthlyComfortReceived >= monthlyComfortGoal;

  /// Get encouragement message based on current stats
  String get encouragementMessage {
    if (weeklyGoalReached && monthlyGoalReached) {
      return 'You\'re spreading incredible comfort! 🌟';
    } else if (weeklyGoalReached) {
      return 'Weekly goal reached! You\'re amazing! ✨';
    } else if (monthlyGoalReached) {
      return 'So much comfort received this month! 💕';
    } else if (dailyStreak >= 7) {
      return 'Amazing ${dailyStreak}-day streak! Keep it up! 🔥';
    } else if (touchesGiven > 0) {
      return 'Every touch matters. Keep connecting! 💝';
    } else {
      return 'Start your comfort journey today! 🌱';
    }
  }
}