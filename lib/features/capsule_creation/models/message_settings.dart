import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_settings.freezed.dart';
part 'message_settings.g.dart';

/// Message settings for time capsule customization
/// Controls how the recipient receives and interacts with the capsule
@freezed
class MessageSettings with _$MessageSettings {
  const factory MessageSettings({
    /// Whether to notify the recipient about the capsule
    /// Default: true - Let them know a time capsule is waiting
    @Default(true) bool notifyAboutCapsule,
    
    /// Whether to send the capsule anonymously
    /// Default: false - Sender identity is revealed by default
    @Default(false) bool anonymousSending,
    
    /// Whether the message can only be viewed once
    /// Default: false - Message can be re-read
    @Default(false) bool oneTimeView,
    
    /// How the final message should be delivered
    /// Default: app only
    @Default(DeliveryMethod.appOnly) DeliveryMethod deliveryMethod,
    
    /// Whether to allow the recipient to share the message
    /// Default: true - Recipient can share with others
    @Default(true) bool allowSharing,
    
    /// Whether to send delivery confirmation to sender
    /// Default: true - Sender gets notified when message is read
    @Default(true) bool sendDeliveryConfirmation,
    
    /// Custom delivery time zone (if different from sender's)
    String? customTimeZone,
    
    /// Additional delivery instructions or notes
    String? deliveryNotes,
  }) = _MessageSettings;

  factory MessageSettings.fromJson(Map<String, dynamic> json) =>
      _$MessageSettingsFromJson(json);
}

/// Delivery method options for time capsules
enum DeliveryMethod {
  @JsonValue('app-only')
  appOnly,
  
  @JsonValue('app-and-email')
  appAndEmail,
  
  @JsonValue('email-only')
  emailOnly,
}

/// Extension for delivery method properties
extension DeliveryMethodExtension on DeliveryMethod {
  /// Display text for the delivery method
  String get displayText {
    switch (this) {
      case DeliveryMethod.appOnly:
        return 'App Only';
      case DeliveryMethod.appAndEmail:
        return 'App + Email';
      case DeliveryMethod.emailOnly:
        return 'Email Only';
    }
  }
  
  /// Short display text for compact UI
  String get shortDisplayText {
    switch (this) {
      case DeliveryMethod.appOnly:
        return 'App';
      case DeliveryMethod.appAndEmail:
        return 'Both';
      case DeliveryMethod.emailOnly:
        return 'Email';
    }
  }
  
  /// Icon representation
  String get icon {
    switch (this) {
      case DeliveryMethod.appOnly:
        return '📱';
      case DeliveryMethod.appAndEmail:
        return '📱📧';
      case DeliveryMethod.emailOnly:
        return '📧';
    }
  }
  
  /// Full icon and text display
  String get fullDisplay {
    return '${icon} ${displayText}';
  }
  
  /// Description of what this method means
  String get description {
    switch (this) {
      case DeliveryMethod.appOnly:
        return 'Recipient will only receive the message through the app';
      case DeliveryMethod.appAndEmail:
        return 'Recipient will receive the message through both app and email';
      case DeliveryMethod.emailOnly:
        return 'Recipient will only receive the message via email';
    }
  }
  
  /// Whether this method requires email setup
  bool get requiresEmail {
    switch (this) {
      case DeliveryMethod.appOnly:
        return false;
      case DeliveryMethod.appAndEmail:
      case DeliveryMethod.emailOnly:
        return true;
    }
  }
  
  /// Whether this method delivers through the app
  bool get deliversThroughApp {
    switch (this) {
      case DeliveryMethod.appOnly:
      case DeliveryMethod.appAndEmail:
        return true;
      case DeliveryMethod.emailOnly:
        return false;
    }
  }
}

/// Extension for MessageSettings with additional utility methods
extension MessageSettingsExtension on MessageSettings {
  /// Get a summary description of the current settings
  String get summaryDescription {
    final features = <String>[];
    
    if (notifyAboutCapsule) {
      features.add('Notification enabled');
    } else {
      features.add('Silent delivery');
    }
    
    if (anonymousSending) {
      features.add('Anonymous');
    } else {
      features.add('From you');
    }
    
    if (oneTimeView) {
      features.add('One-time view');
    } else {
      features.add('Re-readable');
    }
    
    features.add(deliveryMethod.shortDisplayText);
    
    return features.join(' • ');
  }
  
  /// Get a list of enabled privacy features
  List<String> get privacyFeatures {
    final features = <String>[];
    
    if (anonymousSending) {
      features.add('Anonymous sending');
    }
    
    if (oneTimeView) {
      features.add('Self-destructing message');
    }
    
    if (!allowSharing) {
      features.add('Sharing disabled');
    }
    
    if (!sendDeliveryConfirmation) {
      features.add('No read receipts');
    }
    
    return features;
  }
  
  /// Get a list of notification features
  List<String> get notificationFeatures {
    final features = <String>[];
    
    if (notifyAboutCapsule) {
      features.add('Arrival notification');
    }
    
    if (sendDeliveryConfirmation) {
      features.add('Read confirmation');
    }
    
    features.add(deliveryMethod.description);
    
    return features;
  }
  
  /// Check if settings are privacy-focused
  bool get isPrivacyFocused {
    return anonymousSending || oneTimeView || !allowSharing;
  }
  
  /// Check if settings are notification-heavy
  bool get isNotificationHeavy {
    return notifyAboutCapsule && 
           sendDeliveryConfirmation && 
           deliveryMethod == DeliveryMethod.appAndEmail;
  }
  
  /// Get recommendation based on current settings
  String get recommendation {
    if (isPrivacyFocused) {
      return 'Your message will be delivered with maximum privacy';
    } else if (isNotificationHeavy) {
      return 'Your friend will receive full notifications about this capsule';
    } else if (!notifyAboutCapsule) {
      return 'Your message will arrive as a pleasant surprise';
    } else {
      return 'Balanced settings for a thoughtful delivery';
    }
  }
  
  /// Validate settings and return any warnings
  List<String> get validationWarnings {
    final warnings = <String>[];
    
    if (anonymousSending && sendDeliveryConfirmation) {
      warnings.add('Anonymous messages may not provide read confirmations');
    }
    
    if (oneTimeView && allowSharing) {
      warnings.add('One-time view messages cannot be shared after reading');
    }
    
    if (!notifyAboutCapsule && deliveryMethod == DeliveryMethod.emailOnly) {
      warnings.add('Silent delivery via email only may be missed');
    }
    
    return warnings;
  }
}

/// Predefined message setting templates for common use cases
class MessageSettingsTemplates {
  static const MessageSettings standard = MessageSettings();
  
  static const MessageSettings private = MessageSettings(
    anonymousSending: true,
    oneTimeView: true,
    allowSharing: false,
    sendDeliveryConfirmation: false,
    deliveryMethod: DeliveryMethod.appOnly,
  );
  
  static const MessageSettings surprise = MessageSettings(
    notifyAboutCapsule: false,
    deliveryMethod: DeliveryMethod.appOnly,
  );
  
  static const MessageSettings important = MessageSettings(
    deliveryMethod: DeliveryMethod.appAndEmail,
    sendDeliveryConfirmation: true,
  );
  
  static const MessageSettings casual = MessageSettings(
    notifyAboutCapsule: true,
    allowSharing: true,
    deliveryMethod: DeliveryMethod.appOnly,
  );
  
  /// Get all template options
  static Map<String, MessageSettings> get allTemplates => {
    'Standard': standard,
    'Private': private,
    'Surprise': surprise,
    'Important': important,
    'Casual': casual,
  };
  
  /// Get template by name
  static MessageSettings? getTemplate(String name) {
    return allTemplates[name];
  }
  
  /// Get template names
  static List<String> get templateNames => allTemplates.keys.toList();
}