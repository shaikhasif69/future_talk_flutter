// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousUserImpl _$$AnonymousUserImplFromJson(Map<String, dynamic> json) =>
    _$AnonymousUserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      isOnline: json['isOnline'] as bool? ?? false,
      acceptsAnonymousMessages:
          json['acceptsAnonymousMessages'] as bool? ?? true,
    );

Map<String, dynamic> _$$AnonymousUserImplToJson(_$AnonymousUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'avatar': instance.avatar,
      'isOnline': instance.isOnline,
      'acceptsAnonymousMessages': instance.acceptsAnonymousMessages,
    };
