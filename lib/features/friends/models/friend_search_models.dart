import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_search_models.freezed.dart';
part 'friend_search_models.g.dart';

/// Represents the friendship status between current user and another user
enum FriendshipStatus {
  @JsonValue('none')
  none,
  
  @JsonValue('pending')
  pending,
  
  @JsonValue('accepted')
  accepted,
  
  @JsonValue('blocked')
  blocked,
}

/// Extension for FriendshipStatus to provide UI-friendly descriptions
extension FriendshipStatusExtension on FriendshipStatus {
  String get description {
    switch (this) {
      case FriendshipStatus.none:
        return 'No friendship connection';
      case FriendshipStatus.pending:
        return 'Friend request pending';
      case FriendshipStatus.accepted:
        return 'Friends';
      case FriendshipStatus.blocked:
        return 'Blocked user';
    }
  }
  
  String get actionLabel {
    switch (this) {
      case FriendshipStatus.none:
        return 'Send Friend Request';
      case FriendshipStatus.pending:
        return 'Request Pending';
      case FriendshipStatus.accepted:
        return 'Friends';
      case FriendshipStatus.blocked:
        return 'Unblock';
    }
  }
  
  bool get canSendRequest => this == FriendshipStatus.none;
  bool get canAcceptRequest => this == FriendshipStatus.pending;
  bool get isFriend => this == FriendshipStatus.accepted;
  bool get isBlocked => this == FriendshipStatus.blocked;
}

/// User search result model for partial match searches
/// Used when searching for users by partial username or email
@freezed
class UserSearchResult with _$UserSearchResult {
  const factory UserSearchResult({
    /// Unique user identifier
    required String id,
    
    /// User's username
    required String username,
    
    /// User's email (may be partially hidden for privacy)
    String? email,
    
    /// User's first name
    String? firstName,
    
    /// User's last name
    String? lastName,
    
    /// Profile picture URL
    String? profilePictureUrl,
    
    /// User's bio/description
    String? bio,
    
    /// User's social battery level (0-100)
    @Default(75) int socialBattery,
    
    /// Current friendship status with this user
    @Default(FriendshipStatus.none) FriendshipStatus friendshipStatus,
    
    /// Whether user is currently online
    @Default(false) bool isOnline,
    
    /// Last seen timestamp
    DateTime? lastSeen,
    
    /// User's interest tags
    @Default([]) List<String> interestTags,
    
    /// Mutual friends count
    @Default(0) int mutualFriendsCount,
  }) = _UserSearchResult;

  factory UserSearchResult.fromJson(Map<String, dynamic> json) => 
      _$UserSearchResultFromJson(json);
  
  /// Helper methods
  const UserSearchResult._();
  
  /// Get user's display name
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
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
  
  /// Get social battery color for UI
  String get socialBatteryColor {
    if (socialBattery >= 80) return '#87A96B'; // Sage Green
    if (socialBattery >= 50) return '#F4C2A1'; // Warm Peach
    if (socialBattery >= 20) return '#D4A5A5'; // Dusty Rose
    return '#6B6B6B'; // Soft Charcoal Light
  }
}

/// User lookup result model for exact match lookups
/// Used when looking up users by exact username or email
@freezed
class UserLookupResult with _$UserLookupResult {
  const factory UserLookupResult({
    /// Unique user identifier
    @JsonKey(name: 'user_id') required String id,
    
    /// User's username
    required String username,
    
    /// User's display name
    @JsonKey(name: 'display_name') required String displayName,
    
    /// Profile picture URL
    @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
    
    /// User's bio/description (bio_preview from API)
    @JsonKey(name: 'bio_preview') String? bio,
    
    /// Current friendship status with this user
    @JsonKey(name: 'friendship_status') @Default(FriendshipStatus.none) FriendshipStatus friendshipStatus,
    
    /// Member since date string
    @JsonKey(name: 'member_since') String? memberSince,
    
    /// User's social battery level (0-100) - default for missing data
    @Default(75) int socialBattery,
    
    /// Whether user is currently online
    @Default(false) bool isOnline,
    
    /// Last seen timestamp
    DateTime? lastSeen,
    
    /// User's interest tags
    @Default([]) List<String> interestTags,
    
    /// Mutual friends count
    @Default(0) int mutualFriendsCount,
  }) = _UserLookupResult;

  factory UserLookupResult.fromJson(Map<String, dynamic> json) => 
      _$UserLookupResultFromJson(json);
  
  /// Helper methods
  const UserLookupResult._();
  
  /// Get user's initials for avatar
  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return username.isNotEmpty ? username[0].toUpperCase() : 'U';
  }
  
  /// Get social battery color for UI
  String get socialBatteryColor {
    if (socialBattery >= 80) return '#87A96B'; // Sage Green
    if (socialBattery >= 50) return '#F4C2A1'; // Warm Peach
    if (socialBattery >= 20) return '#D4A5A5'; // Dusty Rose
    return '#6B6B6B'; // Soft Charcoal Light
  }
}

/// Friend request model for sending and managing friend requests
@freezed
class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    /// Unique friend request identifier
    required String id,
    
    /// ID of user who sent the request
    required String senderId,
    
    /// ID of user who received the request
    required String receiverId,
    
    /// Optional message with the friend request
    String? message,
    
    /// Current status of the friend request
    @Default(FriendRequestStatus.pending) FriendRequestStatus status,
    
    /// When the request was created
    required DateTime createdAt,
    
    /// When the request was last updated
    required DateTime updatedAt,
    
    /// Sender user details (populated in responses)
    UserSearchResult? sender,
    
    /// Receiver user details (populated in responses)
    UserSearchResult? receiver,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) => 
      _$FriendRequestFromJson(json);
}

/// Friend request status
enum FriendRequestStatus {
  @JsonValue('pending')
  pending,
  
  @JsonValue('accepted')
  accepted,
  
  @JsonValue('rejected')
  rejected,
  
  @JsonValue('cancelled')
  cancelled,
}

/// Extension for FriendRequestStatus
extension FriendRequestStatusExtension on FriendRequestStatus {
  String get description {
    switch (this) {
      case FriendRequestStatus.pending:
        return 'Waiting for response';
      case FriendRequestStatus.accepted:
        return 'Request accepted';
      case FriendRequestStatus.rejected:
        return 'Request rejected';
      case FriendRequestStatus.cancelled:
        return 'Request cancelled';
    }
  }
  
  bool get isPending => this == FriendRequestStatus.pending;
  bool get isAccepted => this == FriendRequestStatus.accepted;
  bool get isRejected => this == FriendRequestStatus.rejected;
  bool get isCancelled => this == FriendRequestStatus.cancelled;
}

/// Request model for sending friend requests
@freezed
class SendFriendRequestData with _$SendFriendRequestData {
  const factory SendFriendRequestData({
    /// Target user's username
    required String targetUsername,
    
    /// Optional message to include with request
    String? message,
  }) = _SendFriendRequestData;

  factory SendFriendRequestData.fromJson(Map<String, dynamic> json) => 
      _$SendFriendRequestDataFromJson(json);
}

/// Response model for friend request operations
@freezed
class FriendRequestResponse with _$FriendRequestResponse {
  const factory FriendRequestResponse({
    /// Success message
    required String message,
    
    /// Friend request or friendship ID
    String? friendshipId,
    
    /// Created friend request (for send operations)
    FriendRequest? friendRequest,
  }) = _FriendRequestResponse;

  factory FriendRequestResponse.fromJson(Map<String, dynamic> json) => 
      _$FriendRequestResponseFromJson(json);
}

/// Request model for user lookup by identifier
@freezed
class UserLookupRequest with _$UserLookupRequest {
  const factory UserLookupRequest({
    /// Username or email to look up
    required String identifier,
  }) = _UserLookupRequest;

  factory UserLookupRequest.fromJson(Map<String, dynamic> json) => 
      _$UserLookupRequestFromJson(json);
}

/// Search type for user searches
enum SearchType {
  @JsonValue('all')
  all,
  
  @JsonValue('username')
  username,
  
  @JsonValue('email')
  email,
  
  @JsonValue('name')
  name,
}

/// Extension for SearchType
extension SearchTypeExtension on SearchType {
  String get description {
    switch (this) {
      case SearchType.all:
        return 'Search all fields';
      case SearchType.username:
        return 'Search usernames only';
      case SearchType.email:
        return 'Search emails only';
      case SearchType.name:
        return 'Search names only';
    }
  }
  
  String get label {
    switch (this) {
      case SearchType.all:
        return 'All';
      case SearchType.username:
        return 'Username';
      case SearchType.email:
        return 'Email';
      case SearchType.name:
        return 'Name';
    }
  }
}