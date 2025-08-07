// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_picture_url'] as String?,
      location: json['location'] as String?,
      birthDate: json['birth_date'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      emailVerified: json['email_verified'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      privacySettings: json['privacySettings'] == null
          ? null
          : PrivacySettings.fromJson(
              json['privacySettings'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'display_name': instance.displayName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'bio': instance.bio,
      'profile_picture_url': instance.profileImageUrl,
      'location': instance.location,
      'birth_date': instance.birthDate,
      'is_active': instance.isActive,
      'email_verified': instance.emailVerified,
      'isPremium': instance.isPremium,
      'created_at': instance.createdAt,
      'last_login_at': instance.lastLoginAt,
      'privacySettings': instance.privacySettings,
    };

_$PrivacySettingsImpl _$$PrivacySettingsImplFromJson(
  Map<String, dynamic> json,
) => _$PrivacySettingsImpl(
  showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
  allowFriendRequests: json['allowFriendRequests'] as bool? ?? true,
  showReadingActivity: json['showReadingActivity'] as bool? ?? true,
  messagePrivacy: json['messagePrivacy'] as String? ?? 'friends_only',
  profileVisibility: json['profileVisibility'] as String? ?? 'public',
);

Map<String, dynamic> _$$PrivacySettingsImplToJson(
  _$PrivacySettingsImpl instance,
) => <String, dynamic>{
  'showOnlineStatus': instance.showOnlineStatus,
  'allowFriendRequests': instance.allowFriendRequests,
  'showReadingActivity': instance.showReadingActivity,
  'messagePrivacy': instance.messagePrivacy,
  'profileVisibility': instance.profileVisibility,
};

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num?)?.toInt(),
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'user': instance.user,
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      emailOrUsername: json['username_or_email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'username_or_email': instance.emailOrUsername,
      'password': instance.password,
    };

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterRequestImpl(
  email: json['email'] as String,
  password: json['password'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String,
);

Map<String, dynamic> _$$RegisterRequestImplToJson(
  _$RegisterRequestImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'username': instance.username,
  'display_name': instance.displayName,
};

_$RegisterResponseImpl _$$RegisterResponseImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterResponseImpl(
  message: json['message'] as String,
  email: json['email'] as String,
  expiresInMinutes: (json['expires_in_minutes'] as num).toInt(),
  otpSent: json['otp_sent'] as bool,
  remainingRequests: (json['remaining_requests'] as num).toInt(),
);

Map<String, dynamic> _$$RegisterResponseImplToJson(
  _$RegisterResponseImpl instance,
) => <String, dynamic>{
  'message': instance.message,
  'email': instance.email,
  'expires_in_minutes': instance.expiresInMinutes,
  'otp_sent': instance.otpSent,
  'remaining_requests': instance.remainingRequests,
};

_$OtpVerificationRequestImpl _$$OtpVerificationRequestImplFromJson(
  Map<String, dynamic> json,
) => _$OtpVerificationRequestImpl(
  email: json['email'] as String,
  otp: json['otp'] as String,
);

Map<String, dynamic> _$$OtpVerificationRequestImplToJson(
  _$OtpVerificationRequestImpl instance,
) => <String, dynamic>{'email': instance.email, 'otp': instance.otp};

_$ResendOtpRequestImpl _$$ResendOtpRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ResendOtpRequestImpl(email: json['email'] as String);

Map<String, dynamic> _$$ResendOtpRequestImplToJson(
  _$ResendOtpRequestImpl instance,
) => <String, dynamic>{'email': instance.email};

_$ResendOtpResponseImpl _$$ResendOtpResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ResendOtpResponseImpl(
  message: json['message'] as String,
  email: json['email'] as String,
  expiresInMinutes: (json['expires_in_minutes'] as num).toInt(),
  otpSent: json['otp_sent'] as bool,
  remainingRequests: (json['remaining_requests'] as num).toInt(),
);

Map<String, dynamic> _$$ResendOtpResponseImplToJson(
  _$ResendOtpResponseImpl instance,
) => <String, dynamic>{
  'message': instance.message,
  'email': instance.email,
  'expires_in_minutes': instance.expiresInMinutes,
  'otp_sent': instance.otpSent,
  'remaining_requests': instance.remainingRequests,
};

_$RefreshTokenRequestImpl _$$RefreshTokenRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshTokenRequestImpl(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$$RefreshTokenRequestImplToJson(
  _$RefreshTokenRequestImpl instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};

_$PasswordResetRequestImpl _$$PasswordResetRequestImplFromJson(
  Map<String, dynamic> json,
) => _$PasswordResetRequestImpl(email: json['email'] as String);

Map<String, dynamic> _$$PasswordResetRequestImplToJson(
  _$PasswordResetRequestImpl instance,
) => <String, dynamic>{'email': instance.email};

_$PasswordResetConfirmRequestImpl _$$PasswordResetConfirmRequestImplFromJson(
  Map<String, dynamic> json,
) => _$PasswordResetConfirmRequestImpl(
  token: json['token'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$$PasswordResetConfirmRequestImplToJson(
  _$PasswordResetConfirmRequestImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'newPassword': instance.newPassword,
};
