import 'package:freezed_annotation/freezed_annotation.dart';

part 'anonymous_user_model.freezed.dart';
part 'anonymous_user_model.g.dart';

/// Data model for anonymous users found in search
/// Privacy-focused model that only exposes safe public information
@freezed
class AnonymousUser with _$AnonymousUser {
  const factory AnonymousUser({
    /// Unique identifier for the user (privacy-safe)
    required String id,
    
    /// User's display name
    required String name,
    
    /// User's username for exact search matching
    required String username,
    
    /// User's email for exact search matching (privacy-protected)
    required String email,
    
    /// Avatar character or URL identifier
    required String avatar,
    
    /// Whether this user is currently online
    @Default(false) bool isOnline,
    
    /// Privacy-safe status for anonymous recipients
    @Default(true) bool acceptsAnonymousMessages,
  }) = _AnonymousUser;

  factory AnonymousUser.fromJson(Map<String, dynamic> json) =>
      _$AnonymousUserFromJson(json);
}

/// Extension for AnonymousUser model with utility methods
extension AnonymousUserExtension on AnonymousUser {
  /// Get avatar initials for display
  String get avatarInitials {
    if (name.isEmpty) return '?';
    
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    } else {
      return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
    }
  }
  
  /// Generate consistent gradient colors for avatar based on name
  List<String> get avatarGradientColors {
    final hash = name.hashCode;
    const colorSets = [
      ['#B8D4E3', '#C8B5D1'], // Primary anonymous gradient from HTML
      ['#D4A5A5', '#F4C2A1'], // Pink to peach
      ['#87A96B', '#A4B88A'], // Green gradient
      ['#F4C2A1', '#D4A5A5'], // Peach to pink
      ['#A4B88A', '#87A96B'], // Light green to green
      ['#C8B5D1', '#B8D4E3'], // Purple to blue
    ];
    
    final index = hash.abs() % colorSets.length;
    return colorSets[index];
  }
  
  /// Check if user matches exact search query (privacy-focused)
  bool matchesExactSearch(String query) {
    if (query.isEmpty) return false;
    
    final lowercaseQuery = query.toLowerCase().trim();
    final lowercaseUsername = username.toLowerCase();
    final lowercaseEmail = email.toLowerCase();
    
    // Only return true for exact matches to protect privacy
    return lowercaseUsername == lowercaseQuery || 
           lowercaseEmail == lowercaseQuery;
  }
  
  /// Get online status display text
  String get onlineStatusText {
    if (isOnline) {
      return 'Online now';
    } else {
      return 'Last seen recently';
    }
  }
  
  /// Get privacy badge text
  String get privacyBadgeText {
    return 'Anonymous Recipient';
  }
  
  /// Get masked email for privacy (show first 2 chars + domain)
  String get maskedEmail {
    if (email.isEmpty) return '';
    
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '${username[0]}*@$domain';
    } else {
      return '${username.substring(0, 2)}***@$domain';
    }
  }
}

/// Demo data for anonymous user search (privacy-safe test data)
class AnonymousUserDemoData {
  static List<AnonymousUser> get demoUsers => [
    const AnonymousUser(
      id: 'oscar_martinez_anon',
      name: 'Oscar Martinez',
      username: 'oscar',
      email: 'oscar@email.com',
      avatar: 'O',
      isOnline: false,
      acceptsAnonymousMessages: true,
    ),
    const AnonymousUser(
      id: 'maya_chen_anon',
      name: 'Maya Chen',
      username: 'maya_artist',
      email: 'maya.chen@email.com',
      avatar: 'M',
      isOnline: true,
      acceptsAnonymousMessages: true,
    ),
    const AnonymousUser(
      id: 'alex_writer_anon',
      name: 'Alex Writer',
      username: 'alexwrites',
      email: 'alex.writer@email.com',
      avatar: 'A',
      isOnline: false,
      acceptsAnonymousMessages: true,
    ),
    const AnonymousUser(
      id: 'sam_dev_anon',
      name: 'Sam Developer',
      username: 'sam_dev',
      email: 'sam.dev@email.com',
      avatar: 'S',
      isOnline: true,
      acceptsAnonymousMessages: true,
    ),
  ];
  
  /// Search for users by exact match (privacy-focused)
  static List<AnonymousUser> searchUsersExact(String query) {
    if (query.isEmpty || query.length < 3) return [];
    
    return demoUsers.where((user) => user.matchesExactSearch(query)).toList();
  }
  
  /// Get a specific user by ID
  static AnonymousUser? getUserById(String id) {
    try {
      return demoUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Check if a search term would yield results (without exposing actual users)
  static bool hasExactMatches(String query) {
    return searchUsersExact(query).isNotEmpty;
  }
}