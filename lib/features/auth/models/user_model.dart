import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model for Future Talk authentication
/// Represents a user with all necessary authentication and profile data
@freezed
class User with _$User {
  const factory User({
    /// Unique user identifier
    required String id,
    
    /// User's email address
    required String email,
    
    /// User's display name
    required String username,
    
    /// User's first name (optional)
    String? firstName,
    
    /// User's last name (optional)
    String? lastName,
    
    /// User's profile picture URL (optional)
    String? profilePictureUrl,
    
    /// User's social battery level (0-100)
    @Default(75) int socialBattery,
    
    /// Whether user has completed onboarding
    @Default(false) bool hasCompletedOnboarding,
    
    /// User's preferred communication style
    @Default(CommunicationStyle.balanced) CommunicationStyle communicationStyle,
    
    /// User's availability status
    @Default(AvailabilityStatus.available) AvailabilityStatus availability,
    
    /// When the user account was created
    required DateTime createdAt,
    
    /// When the user account was last updated
    required DateTime updatedAt,
    
    /// User's timezone
    String? timezone,
    
    /// User's preferred language
    @Default('en') String preferredLanguage,
    
    /// Whether user has enabled push notifications
    @Default(true) bool pushNotificationsEnabled,
    
    /// Whether user wants to be discoverable by friends
    @Default(true) bool isDiscoverable,
    
    /// User's bio/about section
    String? bio,
    
    /// User's current mood (optional)
    String? currentMood,
    
    /// Tags that describe user's interests
    @Default([]) List<String> interestTags,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  /// Helper methods
  const User._();
  
  /// Get user's full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }
  
  /// Get user's display name (prioritizes full name, falls back to username)
  String get displayName {
    final full = fullName;
    return full.isNotEmpty ? full : username;
  }
  
  /// Get user's initials for avatar
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0].toUpperCase()}${lastName![0].toUpperCase()}';
    } else if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    } else if (lastName != null && lastName!.isNotEmpty) {
      return lastName![0].toUpperCase();
    }
    return username.isNotEmpty ? username[0].toUpperCase() : 'U';
  }
  
  /// Check if user has a complete profile
  bool get hasCompleteProfile {
    return firstName != null && 
           lastName != null && 
           bio != null && 
           bio!.isNotEmpty;
  }
  
  /// Get social battery status
  SocialBatteryStatus get socialBatteryStatus {
    if (socialBattery >= 80) return SocialBatteryStatus.high;
    if (socialBattery >= 50) return SocialBatteryStatus.medium;
    if (socialBattery >= 20) return SocialBatteryStatus.low;
    return SocialBatteryStatus.depleted;
  }
  
  /// Get social battery color for UI
  String get socialBatteryColor {
    switch (socialBatteryStatus) {
      case SocialBatteryStatus.high:
        return '#87A96B'; // Sage Green
      case SocialBatteryStatus.medium:
        return '#F4C2A1'; // Warm Peach
      case SocialBatteryStatus.low:
        return '#D4A5A5'; // Dusty Rose
      case SocialBatteryStatus.depleted:
        return '#6B6B6B'; // Soft Charcoal Light
    }
  }
  
  /// Check if user is new (created less than 7 days ago)
  bool get isNewUser {
    final now = DateTime.now();
    final difference = now.difference(createdAt).inDays;
    return difference < 7;
  }
  
  /// Check if user profile was recently updated (less than 1 hour ago)
  bool get isRecentlyUpdated {
    final now = DateTime.now();
    final difference = now.difference(updatedAt).inMinutes;
    return difference < 60;
  }
}

/// User's communication style preferences
enum CommunicationStyle {
  @JsonValue('minimal')
  minimal,
  
  @JsonValue('balanced')
  balanced,
  
  @JsonValue('expressive')
  expressive,
}

/// User's availability status
enum AvailabilityStatus {
  @JsonValue('available')
  available,
  
  @JsonValue('busy')
  busy,
  
  @JsonValue('away')
  away,
  
  @JsonValue('do_not_disturb')
  doNotDisturb,
  
  @JsonValue('invisible')
  invisible,
}

/// Social battery status levels
enum SocialBatteryStatus {
  high,
  medium,
  low,
  depleted,
}

/// Authentication state for the user
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    /// Currently authenticated user (null if not authenticated)
    User? user,
    
    /// Whether authentication is in progress
    @Default(false) bool isLoading,
    
    /// Authentication error message
    String? error,
    
    /// Whether user is authenticated
    @Default(false) bool isAuthenticated,
    
    /// Authentication token (for API calls)
    String? token,
    
    /// Refresh token
    String? refreshToken,
    
    /// Token expiration time
    DateTime? tokenExpiresAt,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);
  
  /// Helper methods
  const AuthState._();
  
  /// Check if token is expired
  bool get isTokenExpired {
    if (tokenExpiresAt == null) return true;
    return DateTime.now().isAfter(tokenExpiresAt!);
  }
  
  /// Check if user needs to complete onboarding
  bool get needsOnboarding {
    return user != null && !user!.hasCompletedOnboarding;
  }
}

/// User creation/registration data
@freezed
class CreateUserData with _$CreateUserData {
  const factory CreateUserData({
    /// User's email
    required String email,
    
    /// User's chosen username
    required String username,
    
    /// User's password
    required String password,
    
    /// User's first name (optional)
    String? firstName,
    
    /// User's last name (optional)
    String? lastName,
    
    /// Whether user agreed to terms
    @Default(false) bool agreedToTerms,
    
    /// Whether user wants marketing emails
    @Default(false) bool allowMarketingEmails,
  }) = _CreateUserData;

  factory CreateUserData.fromJson(Map<String, dynamic> json) => 
      _$CreateUserDataFromJson(json);
}

/// User login data
@freezed
class LoginData with _$LoginData {
  const factory LoginData({
    /// Email or username
    required String emailOrUsername,
    
    /// User's password
    required String password,
    
    /// Whether to remember the user
    @Default(false) bool rememberMe,
  }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) => 
      _$LoginDataFromJson(json);
}

/// Extensions for enum descriptions
extension CommunicationStyleExtension on CommunicationStyle {
  String get description {
    switch (this) {
      case CommunicationStyle.minimal:
        return 'I prefer brief, direct messages';
      case CommunicationStyle.balanced:
        return 'I like a mix of short and detailed conversations';
      case CommunicationStyle.expressive:
        return 'I enjoy detailed, expressive conversations';
    }
  }
  
  String get label {
    switch (this) {
      case CommunicationStyle.minimal:
        return 'Minimal';
      case CommunicationStyle.balanced:
        return 'Balanced';
      case CommunicationStyle.expressive:
        return 'Expressive';
    }
  }
}

extension AvailabilityStatusExtension on AvailabilityStatus {
  String get description {
    switch (this) {
      case AvailabilityStatus.available:
        return 'Available to chat';
      case AvailabilityStatus.busy:
        return 'Busy, may respond later';
      case AvailabilityStatus.away:
        return 'Away from device';
      case AvailabilityStatus.doNotDisturb:
        return 'Do not disturb';
      case AvailabilityStatus.invisible:
        return 'Appear offline';
    }
  }
  
  String get label {
    switch (this) {
      case AvailabilityStatus.available:
        return 'Available';
      case AvailabilityStatus.busy:
        return 'Busy';
      case AvailabilityStatus.away:
        return 'Away';
      case AvailabilityStatus.doNotDisturb:
        return 'Do Not Disturb';
      case AvailabilityStatus.invisible:
        return 'Invisible';
    }
  }
}