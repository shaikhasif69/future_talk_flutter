// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendImpl _$$FriendImplFromJson(Map<String, dynamic> json) => _$FriendImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  avatar: json['avatar'] as String,
  socialBattery: $enumDecode(
    _$SocialBatteryLevelEnumMap,
    json['socialBattery'],
  ),
  lastActive: DateTime.parse(json['lastActive'] as String),
  username: json['username'] as String?,
  isOnline: json['isOnline'] as bool? ?? false,
  communicationPreference:
      $enumDecodeNullable(
        _$FriendCommunicationPreferenceEnumMap,
        json['communicationPreference'],
      ) ??
      FriendCommunicationPreference.app,
  allowsCapsuleNotifications:
      json['allowsCapsuleNotifications'] as bool? ?? true,
);

Map<String, dynamic> _$$FriendImplToJson(
  _$FriendImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar': instance.avatar,
  'socialBattery': _$SocialBatteryLevelEnumMap[instance.socialBattery]!,
  'lastActive': instance.lastActive.toIso8601String(),
  'username': instance.username,
  'isOnline': instance.isOnline,
  'communicationPreference':
      _$FriendCommunicationPreferenceEnumMap[instance.communicationPreference]!,
  'allowsCapsuleNotifications': instance.allowsCapsuleNotifications,
};

const _$SocialBatteryLevelEnumMap = {
  SocialBatteryLevel.green: 'green',
  SocialBatteryLevel.yellow: 'yellow',
  SocialBatteryLevel.red: 'red',
};

const _$FriendCommunicationPreferenceEnumMap = {
  FriendCommunicationPreference.app: 'app',
  FriendCommunicationPreference.email: 'email',
  FriendCommunicationPreference.both: 'both',
};
