// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSearchResultImpl _$$UserSearchResultImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSearchResultImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      bio: json['bio'] as String?,
      socialBattery: (json['socialBattery'] as num?)?.toInt() ?? 75,
      friendshipStatus: $enumDecodeNullable(
              _$FriendshipStatusEnumMap, json['friendshipStatus']) ??
          FriendshipStatus.none,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      interestTags: (json['interestTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mutualFriendsCount: (json['mutualFriendsCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserSearchResultImplToJson(
        _$UserSearchResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePictureUrl': instance.profilePictureUrl,
      'bio': instance.bio,
      'socialBattery': instance.socialBattery,
      'friendshipStatus': _$FriendshipStatusEnumMap[instance.friendshipStatus]!,
      'isOnline': instance.isOnline,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'interestTags': instance.interestTags,
      'mutualFriendsCount': instance.mutualFriendsCount,
    };

const _$FriendshipStatusEnumMap = {
  FriendshipStatus.none: 'none',
  FriendshipStatus.pending: 'pending',
  FriendshipStatus.accepted: 'accepted',
  FriendshipStatus.blocked: 'blocked',
};

_$UserLookupResultImpl _$$UserLookupResultImplFromJson(
        Map<String, dynamic> json) =>
    _$UserLookupResultImpl(
      id: json['user_id'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      bio: json['bio_preview'] as String?,
      friendshipStatus: $enumDecodeNullable(
              _$FriendshipStatusEnumMap, json['friendship_status']) ??
          FriendshipStatus.none,
      memberSince: json['member_since'] as String?,
      socialBattery: (json['socialBattery'] as num?)?.toInt() ?? 75,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      interestTags: (json['interestTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mutualFriendsCount: (json['mutualFriendsCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserLookupResultImplToJson(
        _$UserLookupResultImpl instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'profile_picture_url': instance.profilePictureUrl,
      'bio_preview': instance.bio,
      'friendship_status':
          _$FriendshipStatusEnumMap[instance.friendshipStatus]!,
      'member_since': instance.memberSince,
      'socialBattery': instance.socialBattery,
      'isOnline': instance.isOnline,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'interestTags': instance.interestTags,
      'mutualFriendsCount': instance.mutualFriendsCount,
    };

_$FriendRequestImpl _$$FriendRequestImplFromJson(Map<String, dynamic> json) =>
    _$FriendRequestImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      message: json['message'] as String?,
      status:
          $enumDecodeNullable(_$FriendRequestStatusEnumMap, json['status']) ??
              FriendRequestStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sender: json['sender'] == null
          ? null
          : UserSearchResult.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: json['receiver'] == null
          ? null
          : UserSearchResult.fromJson(json['receiver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FriendRequestImplToJson(_$FriendRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'message': instance.message,
      'status': _$FriendRequestStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'sender': instance.sender,
      'receiver': instance.receiver,
    };

const _$FriendRequestStatusEnumMap = {
  FriendRequestStatus.pending: 'pending',
  FriendRequestStatus.accepted: 'accepted',
  FriendRequestStatus.rejected: 'rejected',
  FriendRequestStatus.cancelled: 'cancelled',
};

_$SendFriendRequestDataImpl _$$SendFriendRequestDataImplFromJson(
        Map<String, dynamic> json) =>
    _$SendFriendRequestDataImpl(
      targetUsername: json['target_username'] as String,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$SendFriendRequestDataImplToJson(
        _$SendFriendRequestDataImpl instance) =>
    <String, dynamic>{
      'target_username': instance.targetUsername,
      'message': instance.message,
    };

_$FriendRequestResponseImpl _$$FriendRequestResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FriendRequestResponseImpl(
      message: json['message'] as String,
      friendshipId: json['friendshipId'] as String?,
      friendRequest: json['friendRequest'] == null
          ? null
          : FriendRequest.fromJson(
              json['friendRequest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FriendRequestResponseImplToJson(
        _$FriendRequestResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'friendshipId': instance.friendshipId,
      'friendRequest': instance.friendRequest,
    };

_$UserLookupRequestImpl _$$UserLookupRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UserLookupRequestImpl(
      identifier: json['identifier'] as String,
    );

Map<String, dynamic> _$$UserLookupRequestImplToJson(
        _$UserLookupRequestImpl instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
    };
