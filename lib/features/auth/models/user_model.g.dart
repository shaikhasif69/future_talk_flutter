// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      socialBattery: (json['socialBattery'] as num?)?.toInt() ?? 75,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      communicationStyle: $enumDecodeNullable(
              _$CommunicationStyleEnumMap, json['communicationStyle']) ??
          CommunicationStyle.balanced,
      availability: $enumDecodeNullable(
              _$AvailabilityStatusEnumMap, json['availability']) ??
          AvailabilityStatus.available,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      timezone: json['timezone'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      pushNotificationsEnabled:
          json['pushNotificationsEnabled'] as bool? ?? true,
      isDiscoverable: json['isDiscoverable'] as bool? ?? true,
      bio: json['bio'] as String?,
      currentMood: json['currentMood'] as String?,
      interestTags: (json['interestTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePictureUrl': instance.profilePictureUrl,
      'socialBattery': instance.socialBattery,
      'hasCompletedOnboarding': instance.hasCompletedOnboarding,
      'communicationStyle':
          _$CommunicationStyleEnumMap[instance.communicationStyle]!,
      'availability': _$AvailabilityStatusEnumMap[instance.availability]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'timezone': instance.timezone,
      'preferredLanguage': instance.preferredLanguage,
      'pushNotificationsEnabled': instance.pushNotificationsEnabled,
      'isDiscoverable': instance.isDiscoverable,
      'bio': instance.bio,
      'currentMood': instance.currentMood,
      'interestTags': instance.interestTags,
    };

const _$CommunicationStyleEnumMap = {
  CommunicationStyle.minimal: 'minimal',
  CommunicationStyle.balanced: 'balanced',
  CommunicationStyle.expressive: 'expressive',
};

const _$AvailabilityStatusEnumMap = {
  AvailabilityStatus.available: 'available',
  AvailabilityStatus.busy: 'busy',
  AvailabilityStatus.away: 'away',
  AvailabilityStatus.doNotDisturb: 'do_not_disturb',
  AvailabilityStatus.invisible: 'invisible',
};

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      tokenExpiresAt: json['tokenExpiresAt'] == null
          ? null
          : DateTime.parse(json['tokenExpiresAt'] as String),
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'isLoading': instance.isLoading,
      'error': instance.error,
      'isAuthenticated': instance.isAuthenticated,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'tokenExpiresAt': instance.tokenExpiresAt?.toIso8601String(),
    };

_$CreateUserDataImpl _$$CreateUserDataImplFromJson(Map<String, dynamic> json) =>
    _$CreateUserDataImpl(
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      agreedToTerms: json['agreedToTerms'] as bool? ?? false,
      allowMarketingEmails: json['allowMarketingEmails'] as bool? ?? false,
    );

Map<String, dynamic> _$$CreateUserDataImplToJson(
        _$CreateUserDataImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'agreedToTerms': instance.agreedToTerms,
      'allowMarketingEmails': instance.allowMarketingEmails,
    };

_$LoginDataImpl _$$LoginDataImplFromJson(Map<String, dynamic> json) =>
    _$LoginDataImpl(
      emailOrUsername: json['emailOrUsername'] as String,
      password: json['password'] as String,
      rememberMe: json['rememberMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$LoginDataImplToJson(_$LoginDataImpl instance) =>
    <String, dynamic>{
      'emailOrUsername': instance.emailOrUsername,
      'password': instance.password,
      'rememberMe': instance.rememberMe,
    };
