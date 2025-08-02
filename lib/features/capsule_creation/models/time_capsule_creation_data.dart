import 'package:freezed_annotation/freezed_annotation.dart';
import 'friend_model.dart';
import 'message_settings.dart';
import 'anonymous_user_model.dart';
import 'anonymous_message_settings.dart';

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
    
    // ==================== TIME SELECTION PROPERTIES ====================
    
    /// Selected time option for delivery (1 hour, 1 day, etc.)
    TimeOption? selectedTimeOption,
    
    /// Selected special occasion for delivery
    SpecialOccasion? selectedOccasion,
    
    /// Custom date and time for delivery
    CustomDateTime? customDateTime,
    
    /// Current visual metaphor for time selection
    @Default('🌰') String timeMetaphor,
    
    /// Current time display text
    @Default('Select Time') String timeDisplay,
    
    /// Current time description
    @Default('Choose when you\'d like to receive this message') String timeDescription,
    
    /// Current growth stage text
    @Default('Ready to Plant') String growthStage,
    
    // ==================== FRIEND SELECTION PROPERTIES ====================
    
    /// Selected friend for "Someone Special" capsules
    Friend? selectedFriend,
    
    /// Message settings for capsule customization
    MessageSettings? messageSettings,
    
    /// Search query for friends list
    @Default('') String friendSearchQuery,
    
    /// Whether friend selection step is completed
    @Default(false) bool friendSelectionCompleted,
    
    // ==================== ANONYMOUS USER SELECTION PROPERTIES ====================
    
    /// Selected anonymous user for "Anonymous Gift" capsules
    AnonymousUser? selectedAnonymousUser,
    
    /// Anonymous message settings for privacy and delivery options
    AnonymousMessageSettings? anonymousMessageSettings,
    
    /// Search query for anonymous users
    @Default('') String anonymousSearchQuery,
    
    /// Whether anonymous user selection step is completed
    @Default(false) bool anonymousSelectionCompleted,
    
    /// Whether anonymous search is currently loading
    @Default(false) bool isAnonymousSearchLoading,
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

// ==================== TIME SELECTION MODELS ====================

/// Time options for delivery scheduling
enum TimeOption {
  @JsonValue('1-hour')
  oneHour,
  
  @JsonValue('1-day')
  oneDay,
  
  @JsonValue('1-week')
  oneWeek,
  
  @JsonValue('1-month')
  oneMonth,
  
  @JsonValue('6-months')
  sixMonths,
  
  @JsonValue('1-year')
  oneYear,
}

/// Extension for time option properties
extension TimeOptionExtension on TimeOption {
  /// Display text for the time option
  String get display {
    switch (this) {
      case TimeOption.oneHour:
        return '1 Hour';
      case TimeOption.oneDay:
        return 'Tomorrow';
      case TimeOption.oneWeek:
        return '1 Week';
      case TimeOption.oneMonth:
        return '1 Month';
      case TimeOption.sixMonths:
        return '6 Months';
      case TimeOption.oneYear:
        return '1 Year';
    }
  }
  
  /// Subtitle for the time option
  String get subtitle {
    switch (this) {
      case TimeOption.oneHour:
        return 'Quick reflection';
      case TimeOption.oneDay:
        return 'Tomorrow\'s gift';
      case TimeOption.oneWeek:
        return 'Weekly wisdom';
      case TimeOption.oneMonth:
        return 'Monthly milestone';
      case TimeOption.sixMonths:
        return 'Growth journey';
      case TimeOption.oneYear:
        return 'Annual reflection';
    }
  }
  
  /// Visual metaphor emoji
  String get metaphor {
    switch (this) {
      case TimeOption.oneHour:
        return '☕';
      case TimeOption.oneDay:
        return '🌅';
      case TimeOption.oneWeek:
        return '🌱';
      case TimeOption.oneMonth:
        return '🌙';
      case TimeOption.sixMonths:
        return '🌳';
      case TimeOption.oneYear:
        return '💎';
    }
  }
  
  /// Description for the time option
  String get description {
    switch (this) {
      case TimeOption.oneHour:
        return 'A quick coffee break into the future';
      case TimeOption.oneDay:
        return 'Wake up to wisdom from yesterday';
      case TimeOption.oneWeek:
        return 'Let your thoughts sprout and grow';
      case TimeOption.oneMonth:
        return 'A full moon cycle of growth';
      case TimeOption.sixMonths:
        return 'Watch your wisdom mature like a tree';
      case TimeOption.oneYear:
        return 'Time crystallizes your thoughts into gems';
    }
  }
  
  /// Growth stage text
  String get growthStage {
    switch (this) {
      case TimeOption.oneHour:
        return 'Brewing';
      case TimeOption.oneDay:
        return 'New Dawn';
      case TimeOption.oneWeek:
        return 'Sprouting';
      case TimeOption.oneMonth:
        return 'Growing';
      case TimeOption.sixMonths:
        return 'Flourishing';
      case TimeOption.oneYear:
        return 'Crystallized';
    }
  }
  
  /// Animation class for the metaphor
  String get animationClass {
    switch (this) {
      case TimeOption.oneHour:
      case TimeOption.oneDay:
      case TimeOption.oneWeek:
        return 'seed-growing';
      case TimeOption.oneMonth:
      case TimeOption.sixMonths:
        return 'tree-swaying';
      case TimeOption.oneYear:
        return 'crystal-forming';
    }
  }
}

/// Special occasions for delivery scheduling
enum SpecialOccasion {
  @JsonValue('birthday')
  birthday,
  
  @JsonValue('new-year')
  newYear,
  
  @JsonValue('graduation')
  graduation,
  
  @JsonValue('job-start')
  jobStart,
  
  @JsonValue('anniversary')
  anniversary,
  
  @JsonValue('milestone')
  milestone,
}

/// Extension for special occasion properties
extension SpecialOccasionExtension on SpecialOccasion {
  /// Display text for the occasion
  String get display {
    switch (this) {
      case SpecialOccasion.birthday:
        return 'Your Birthday';
      case SpecialOccasion.newYear:
        return 'New Year\'s Day';
      case SpecialOccasion.graduation:
        return 'Graduation Day';
      case SpecialOccasion.jobStart:
        return 'First Day';
      case SpecialOccasion.anniversary:
        return 'Anniversary';
      case SpecialOccasion.milestone:
        return 'Achievement';
    }
  }
  
  /// Short display text for cards
  String get shortDisplay {
    switch (this) {
      case SpecialOccasion.birthday:
        return 'Next Birthday';
      case SpecialOccasion.newYear:
        return 'New Year';
      case SpecialOccasion.graduation:
        return 'Graduation';
      case SpecialOccasion.jobStart:
        return 'Job Start';
      case SpecialOccasion.anniversary:
        return 'Anniversary';
      case SpecialOccasion.milestone:
        return 'Milestone';
    }
  }
  
  /// Emoji icon for the occasion
  String get emoji {
    switch (this) {
      case SpecialOccasion.birthday:
        return '🎂';
      case SpecialOccasion.newYear:
        return '🎊';
      case SpecialOccasion.graduation:
        return '🎓';
      case SpecialOccasion.jobStart:
        return '💼';
      case SpecialOccasion.anniversary:
        return '💍';
      case SpecialOccasion.milestone:
        return '🏆';
    }
  }
  
  /// Description for the occasion
  String get description {
    switch (this) {
      case SpecialOccasion.birthday:
        return 'A gift waiting for your special day';
      case SpecialOccasion.newYear:
        return 'Fresh wisdom for a fresh start';
      case SpecialOccasion.graduation:
        return 'Words for your achievement moment';
      case SpecialOccasion.jobStart:
        return 'Encouragement for new beginnings';
      case SpecialOccasion.anniversary:
        return 'Celebrating love and commitment';
      case SpecialOccasion.milestone:
        return 'Recognition of your hard work';
    }
  }
  
  /// Growth stage text
  String get growthStage {
    switch (this) {
      case SpecialOccasion.birthday:
        return 'Birthday Magic';
      case SpecialOccasion.newYear:
        return 'New Beginnings';
      case SpecialOccasion.graduation:
        return 'Milestone Reached';
      case SpecialOccasion.jobStart:
        return 'Career Journey';
      case SpecialOccasion.anniversary:
        return 'Love\'s Growth';
      case SpecialOccasion.milestone:
        return 'Victory Lap';
    }
  }
}

/// Custom date and time model
@freezed
class CustomDateTime with _$CustomDateTime {
  const factory CustomDateTime({
    required DateTime dateTime,
    required String previewText,
  }) = _CustomDateTime;

  factory CustomDateTime.fromJson(Map<String, dynamic> json) =>
      _$CustomDateTimeFromJson(json);
}