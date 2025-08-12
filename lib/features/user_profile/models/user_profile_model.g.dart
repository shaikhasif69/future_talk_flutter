// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      socialBatteryLevel: (json['social_battery_level'] as num?)?.toInt(),
      socialBatteryStatus: json['social_battery_status'] as String?,
      isOnline: json['is_online'] as bool?,
      lastActive: json['last_active'] == null
          ? null
          : DateTime.parse(json['last_active'] as String),
      friendshipStatus: json['friendship_status'] as String?,
      mutualFriendsCount: (json['mutual_friends_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'display_name': instance.displayName,
      'bio': instance.bio,
      'profile_picture_url': instance.profilePictureUrl,
      'interests': instance.interests,
      'social_battery_level': instance.socialBatteryLevel,
      'social_battery_status': instance.socialBatteryStatus,
      'is_online': instance.isOnline,
      'last_active': instance.lastActive?.toIso8601String(),
      'friendship_status': instance.friendshipStatus,
      'mutual_friends_count': instance.mutualFriendsCount,
      'created_at': instance.createdAt?.toIso8601String(),
    };
