import 'package:freezed_annotation/freezed_annotation.dart';

part 'anonymous_message_settings.freezed.dart';
part 'anonymous_message_settings.g.dart';

/// Settings model for anonymous message delivery and privacy options
/// Handles all anonymity-related configurations for time capsules
@freezed
class AnonymousMessageSettings with _$AnonymousMessageSettings {
  const factory AnonymousMessageSettings({
    /// Whether to notify the recipient about the incoming anonymous capsule
    @Default(true) bool notifyAboutCapsule,
    
    /// Identity reveal preference for the sender
    @Default(IdentityRevealOption.stayAnonymous) IdentityRevealOption identityRevealOption,
    
    /// Whether the message should disappear after being read once
    @Default(false) bool oneTimeView,
    
    /// Whether to include a delivery hint about who might have sent this
    @Default(false) bool includeDeliveryHint,
    
    /// Custom delivery hint text (optional)
    String? customDeliveryHint,
    
    /// Anonymous delivery method preference
    @Default(AnonymousDeliveryMethod.silent) AnonymousDeliveryMethod deliveryMethod,
  }) = _AnonymousMessageSettings;

  factory AnonymousMessageSettings.fromJson(Map<String, dynamic> json) =>
      _$AnonymousMessageSettingsFromJson(json);
}

/// Identity reveal options for anonymous messages
enum IdentityRevealOption {
  @JsonValue('stay_anonymous')
  stayAnonymous,
  
  @JsonValue('can_reveal_later')
  canRevealLater,
}

/// Extension for identity reveal option properties
extension IdentityRevealOptionExtension on IdentityRevealOption {
  /// Display text for the option
  String get displayText {
    switch (this) {
      case IdentityRevealOption.stayAnonymous:
        return 'Stay Anonymous';
      case IdentityRevealOption.canRevealLater:
        return 'Can Reveal Later';
    }
  }
  
  /// Description for the option
  String get description {
    switch (this) {
      case IdentityRevealOption.stayAnonymous:
        return 'Your identity will remain permanently hidden';
      case IdentityRevealOption.canRevealLater:
        return 'You can choose to reveal yourself after delivery';
    }
  }
  
  /// Emoji icon for the option
  String get emoji {
    switch (this) {
      case IdentityRevealOption.stayAnonymous:
        return '🎭';
      case IdentityRevealOption.canRevealLater:
        return '✨';
    }
  }
  
  /// Whether this option allows identity reveal
  bool get allowsReveal {
    switch (this) {
      case IdentityRevealOption.stayAnonymous:
        return false;
      case IdentityRevealOption.canRevealLater:
        return true;
    }
  }
}

/// Anonymous delivery methods
enum AnonymousDeliveryMethod {
  @JsonValue('silent')
  silent,
  
  @JsonValue('mysterious')
  mysterious,
  
  @JsonValue('gentle')
  gentle,
}

/// Extension for anonymous delivery method properties
extension AnonymousDeliveryMethodExtension on AnonymousDeliveryMethod {
  /// Display text for the method
  String get displayText {
    switch (this) {
      case AnonymousDeliveryMethod.silent:
        return 'Silent Delivery';
      case AnonymousDeliveryMethod.mysterious:
        return 'Mysterious Arrival';
      case AnonymousDeliveryMethod.gentle:
        return 'Gentle Notification';
    }
  }
  
  /// Description for the method
  String get description {
    switch (this) {
      case AnonymousDeliveryMethod.silent:
        return 'Appears quietly in their capsule garden';
      case AnonymousDeliveryMethod.mysterious:
        return 'Arrives with intriguing mystery elements';
      case AnonymousDeliveryMethod.gentle:
        return 'Soft notification with warm introduction';
    }
  }
  
  /// Emoji icon for the method
  String get emoji {
    switch (this) {
      case AnonymousDeliveryMethod.silent:
        return '🤫';
      case AnonymousDeliveryMethod.mysterious:
        return '🔮';
      case AnonymousDeliveryMethod.gentle:
        return '🌸';
    }
  }
}

/// Extension for AnonymousMessageSettings with utility methods
extension AnonymousMessageSettingsExtension on AnonymousMessageSettings {
  /// Get privacy level description
  String get privacyLevelDescription {
    if (identityRevealOption == IdentityRevealOption.stayAnonymous) {
      return 'Complete anonymity maintained';
    } else {
      return 'Identity can be revealed later';
    }
  }
  
  /// Get delivery preview text
  String get deliveryPreviewText {
    final method = deliveryMethod.displayText;
    final notification = notifyAboutCapsule ? 'with notification' : 'silently';
    return '$method • Delivered $notification';
  }
  
  /// Get security summary for display
  List<String> get securityFeatures {
    final features = <String>[];
    
    features.add('Anonymous sender');
    
    if (identityRevealOption == IdentityRevealOption.stayAnonymous) {
      features.add('Permanent anonymity');
    } else {
      features.add('Optional reveal');
    }
    
    if (oneTimeView) {
      features.add('Self-destructing');
    }
    
    if (!notifyAboutCapsule) {
      features.add('Silent delivery');
    }
    
    if (includeDeliveryHint && customDeliveryHint?.isNotEmpty == true) {
      features.add('With hint');
    }
    
    return features;
  }
  
  /// Check if settings provide maximum privacy
  bool get isMaximumPrivacy {
    return identityRevealOption == IdentityRevealOption.stayAnonymous &&
           !includeDeliveryHint &&
           deliveryMethod == AnonymousDeliveryMethod.silent;
  }
  
  /// Get recommended security level text
  String get securityLevelText {
    if (isMaximumPrivacy) {
      return 'Maximum Privacy';
    } else if (identityRevealOption == IdentityRevealOption.stayAnonymous) {
      return 'High Privacy';
    } else {
      return 'Moderate Privacy';
    }
  }
  
  /// Get security level color for UI
  String get securityLevelColor {
    if (isMaximumPrivacy) {
      return '#4CAF50'; // Green for maximum privacy
    } else if (identityRevealOption == IdentityRevealOption.stayAnonymous) {
      return '#FFC107'; // Yellow for high privacy
    } else {
      return '#FF9800'; // Orange for moderate privacy
    }
  }
}

/// Predefined settings templates for common use cases
class AnonymousMessageSettingsTemplates {
  /// Complete anonymity - maximum privacy
  static const AnonymousMessageSettings completeAnonymity = AnonymousMessageSettings(
    notifyAboutCapsule: false,
    identityRevealOption: IdentityRevealOption.stayAnonymous,
    oneTimeView: true,
    includeDeliveryHint: false,
    deliveryMethod: AnonymousDeliveryMethod.silent,
  );
  
  /// Mysterious gift - engaging but anonymous
  static const AnonymousMessageSettings mysteriousGift = AnonymousMessageSettings(
    notifyAboutCapsule: true,
    identityRevealOption: IdentityRevealOption.stayAnonymous,
    oneTimeView: false,
    includeDeliveryHint: true,
    deliveryMethod: AnonymousDeliveryMethod.mysterious,
  );
  
  /// Gentle anonymous - kind but private
  static const AnonymousMessageSettings gentleAnonymous = AnonymousMessageSettings(
    notifyAboutCapsule: true,
    identityRevealOption: IdentityRevealOption.canRevealLater,
    oneTimeView: false,
    includeDeliveryHint: false,
    deliveryMethod: AnonymousDeliveryMethod.gentle,
  );
  
  /// Secret admirer - romantic and mysterious
  static const AnonymousMessageSettings secretAdmirer = AnonymousMessageSettings(
    notifyAboutCapsule: true,
    identityRevealOption: IdentityRevealOption.canRevealLater,
    oneTimeView: false,
    includeDeliveryHint: true,
    customDeliveryHint: 'Someone who thinks you\'re amazing',
    deliveryMethod: AnonymousDeliveryMethod.mysterious,
  );
  
  /// Get template by name
  static AnonymousMessageSettings? getTemplate(String templateName) {
    switch (templateName.toLowerCase()) {
      case 'complete_anonymity':
        return completeAnonymity;
      case 'mysterious_gift':
        return mysteriousGift;
      case 'gentle_anonymous':
        return gentleAnonymous;
      case 'secret_admirer':
        return secretAdmirer;
      default:
        return null;
    }
  }
  
  /// Get all available templates
  static Map<String, AnonymousMessageSettings> get allTemplates => {
    'Complete Anonymity': completeAnonymity,
    'Mysterious Gift': mysteriousGift,
    'Gentle Anonymous': gentleAnonymous,
    'Secret Admirer': secretAdmirer,
  };
}