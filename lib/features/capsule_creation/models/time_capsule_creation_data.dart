import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_capsule_creation_data.freezed.dart';
part 'time_capsule_creation_data.g.dart';

/// Data model for time capsule creation flow
/// Tracks the current state and user selections throughout the creation process
@freezed
class TimeCapsuleCreationData with _$TimeCapsuleCreationData {
  const factory TimeCapsuleCreationData({
    /// Currently selected purpose for the time capsule
    TimeCapsulePurpose? selectedPurpose,
    
    /// Current step in the creation flow (1-4)
    @Default(1) int currentStep,
    
    /// Whether the continue button should be shown
    @Default(false) bool showContinueButton,
    
    /// Selected quick start type (if any)
    QuickStartType? selectedQuickStart,
    
    /// Loading state for navigation
    @Default(false) bool isLoading,
    
    /// Creation timestamp for analytics
    DateTime? creationStartedAt,
  }) = _TimeCapsuleCreationData;

  factory TimeCapsuleCreationData.fromJson(Map<String, dynamic> json) =>
      _$TimeCapsuleCreationDataFromJson(json);
}

/// Enum for time capsule purposes matching HTML design
enum TimeCapsulePurpose {
  @JsonValue('future-me')
  futureMe,
  
  @JsonValue('someone-special')
  someoneSpecial,
  
  @JsonValue('anonymous')
  anonymous,
}

/// Extension for purpose properties
extension TimeCapsulePurposeExtension on TimeCapsulePurpose {
  /// Display title for the purpose
  String get title {
    switch (this) {
      case TimeCapsulePurpose.futureMe:
        return 'Future Me';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Someone Special';
      case TimeCapsulePurpose.anonymous:
        return 'Anonymous Gift';
    }
  }
  
  /// Subtitle for the purpose
  String get subtitle {
    switch (this) {
      case TimeCapsulePurpose.futureMe:
        return 'Personal Message';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Friend or Family';
      case TimeCapsulePurpose.anonymous:
        return 'Mystery Message';
    }
  }
  
  /// Description text for the purpose
  String get description {
    switch (this) {
      case TimeCapsulePurpose.futureMe:
        return 'Send yourself encouragement, reminders, or reflections to discover later. Perfect for personal growth and self-care.';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Surprise someone you care about with a thoughtful message delivered at the perfect moment.';
      case TimeCapsulePurpose.anonymous:
        return 'Send comfort or encouragement without revealing your identity. Option to reveal yourself later.';
    }
  }
  
  /// Emoji icon for the purpose
  String get emoji {
    switch (this) {
      case TimeCapsulePurpose.futureMe:
        return '📝';
      case TimeCapsulePurpose.someoneSpecial:
        return '💌';
      case TimeCapsulePurpose.anonymous:
        return '🎁';
    }
  }
  
  /// Feature tags for the purpose
  List<String> get featureTags {
    switch (this) {
      case TimeCapsulePurpose.futureMe:
        return ['Private', 'Reflective', 'Self-care'];
      case TimeCapsulePurpose.someoneSpecial:
        return ['Thoughtful', 'Surprise', 'Connection'];
      case TimeCapsulePurpose.anonymous:
        return ['Anonymous', 'Comfort', 'Mystery'];
    }
  }
  
  /// CSS class name from original HTML
  String get cssClass {
    switch (this) {
      case TimeCapsulePurpose.futureMe:
        return 'future-me';
      case TimeCapsulePurpose.someoneSpecial:
        return 'someone-special';
      case TimeCapsulePurpose.anonymous:
        return 'anonymous';
    }
  }
}

/// Quick start options for time capsules
enum QuickStartType {
  @JsonValue('birthday')
  birthday,
  
  @JsonValue('encouragement')
  encouragement,
  
  @JsonValue('anniversary')
  anniversary,
  
  @JsonValue('gratitude')
  gratitude,
}

/// Extension for quick start properties
extension QuickStartTypeExtension on QuickStartType {
  /// Display text for the quick start option
  String get displayText {
    switch (this) {
      case QuickStartType.birthday:
        return 'Birthday Surprise';
      case QuickStartType.encouragement:
        return 'Encouragement';
      case QuickStartType.anniversary:
        return 'Anniversary';
      case QuickStartType.gratitude:
        return 'Thank You';
    }
  }
  
  /// Emoji icon for the quick start option
  String get emoji {
    switch (this) {
      case QuickStartType.birthday:
        return '🎂';
      case QuickStartType.encouragement:
        return '💪';
      case QuickStartType.anniversary:
        return '❤️';
      case QuickStartType.gratitude:
        return '🙏';
    }
  }
  
  /// Suggested purpose for this quick start type
  TimeCapsulePurpose get suggestedPurpose {
    switch (this) {
      case QuickStartType.birthday:
      case QuickStartType.anniversary:
      case QuickStartType.gratitude:
        return TimeCapsulePurpose.someoneSpecial;
      case QuickStartType.encouragement:
        return TimeCapsulePurpose.futureMe;
    }
  }
}