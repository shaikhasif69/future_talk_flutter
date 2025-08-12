import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// User profile model matching the API specification for both friends and non-friends
@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    @JsonKey(name: 'user_id') required String userId,
    required String username,
    @JsonKey(name: 'display_name') required String displayName,
    String? bio, // null for non-friends
    @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
    List<String>? interests, // null for non-friends
    @JsonKey(name: 'social_battery_level') int? socialBatteryLevel, // null for non-friends
    @JsonKey(name: 'social_battery_status') String? socialBatteryStatus, // null for non-friends
    @JsonKey(name: 'is_online') bool? isOnline, // null for non-friends
    @JsonKey(name: 'last_active') DateTime? lastActive, // null for non-friends
    @JsonKey(name: 'friendship_status') String? friendshipStatus, // 'accepted', 'pending', null
    @JsonKey(name: 'mutual_friends_count') @Default(0) int mutualFriendsCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

/// Helper extensions for UserProfileModel
extension UserProfileModelExtensions on UserProfileModel {
  /// Check if user is a friend (accepted friendship)
  bool get isFriend => friendshipStatus == 'accepted';
  
  /// Check if friend request is pending
  bool get isPending => friendshipStatus == 'pending';
  
  /// Check if user is not a friend
  bool get isNotFriend => friendshipStatus == null || friendshipStatus == 'none';
  
  /// Get user initials for avatar
  String get initials {
    final parts = displayName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return username.substring(0, 1).toUpperCase();
  }
  
  /// Get battery color based on level
  String get batteryColor {
    if (socialBatteryLevel == null) return 'gray';
    final level = socialBatteryLevel!;
    if (level >= 80) return 'green';
    if (level >= 50) return 'yellow';
    if (level >= 25) return 'orange';
    return 'red';
  }
  
  /// Get member since text
  String get memberSince {
    if (createdAt == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return 'Recently joined';
    }
  }
}

