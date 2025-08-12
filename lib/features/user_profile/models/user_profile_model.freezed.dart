// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError; // null for non-friends
  @JsonKey(name: 'profile_picture_url')
  String? get profilePictureUrl => throw _privateConstructorUsedError;
  List<String>? get interests =>
      throw _privateConstructorUsedError; // null for non-friends
  @JsonKey(name: 'social_battery_level')
  int? get socialBatteryLevel =>
      throw _privateConstructorUsedError; // null for non-friends
  @JsonKey(name: 'social_battery_status')
  String? get socialBatteryStatus =>
      throw _privateConstructorUsedError; // null for non-friends
  @JsonKey(name: 'is_online')
  bool? get isOnline =>
      throw _privateConstructorUsedError; // null for non-friends
  @JsonKey(name: 'last_active')
  DateTime? get lastActive =>
      throw _privateConstructorUsedError; // null for non-friends
  @JsonKey(name: 'friendship_status')
  String? get friendshipStatus =>
      throw _privateConstructorUsedError; // 'accepted', 'pending', null
  @JsonKey(name: 'mutual_friends_count')
  int get mutualFriendsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
          UserProfileModel value, $Res Function(UserProfileModel) then) =
      _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      String username,
      @JsonKey(name: 'display_name') String displayName,
      String? bio,
      @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
      List<String>? interests,
      @JsonKey(name: 'social_battery_level') int? socialBatteryLevel,
      @JsonKey(name: 'social_battery_status') String? socialBatteryStatus,
      @JsonKey(name: 'is_online') bool? isOnline,
      @JsonKey(name: 'last_active') DateTime? lastActive,
      @JsonKey(name: 'friendship_status') String? friendshipStatus,
      @JsonKey(name: 'mutual_friends_count') int mutualFriendsCount,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? displayName = null,
    Object? bio = freezed,
    Object? profilePictureUrl = freezed,
    Object? interests = freezed,
    Object? socialBatteryLevel = freezed,
    Object? socialBatteryStatus = freezed,
    Object? isOnline = freezed,
    Object? lastActive = freezed,
    Object? friendshipStatus = freezed,
    Object? mutualFriendsCount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      interests: freezed == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      socialBatteryLevel: freezed == socialBatteryLevel
          ? _value.socialBatteryLevel
          : socialBatteryLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      socialBatteryStatus: freezed == socialBatteryStatus
          ? _value.socialBatteryStatus
          : socialBatteryStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: freezed == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      friendshipStatus: freezed == friendshipStatus
          ? _value.friendshipStatus
          : friendshipStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      mutualFriendsCount: null == mutualFriendsCount
          ? _value.mutualFriendsCount
          : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(_$UserProfileModelImpl value,
          $Res Function(_$UserProfileModelImpl) then) =
      __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      String username,
      @JsonKey(name: 'display_name') String displayName,
      String? bio,
      @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
      List<String>? interests,
      @JsonKey(name: 'social_battery_level') int? socialBatteryLevel,
      @JsonKey(name: 'social_battery_status') String? socialBatteryStatus,
      @JsonKey(name: 'is_online') bool? isOnline,
      @JsonKey(name: 'last_active') DateTime? lastActive,
      @JsonKey(name: 'friendship_status') String? friendshipStatus,
      @JsonKey(name: 'mutual_friends_count') int mutualFriendsCount,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(_$UserProfileModelImpl _value,
      $Res Function(_$UserProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? displayName = null,
    Object? bio = freezed,
    Object? profilePictureUrl = freezed,
    Object? interests = freezed,
    Object? socialBatteryLevel = freezed,
    Object? socialBatteryStatus = freezed,
    Object? isOnline = freezed,
    Object? lastActive = freezed,
    Object? friendshipStatus = freezed,
    Object? mutualFriendsCount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserProfileModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      interests: freezed == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      socialBatteryLevel: freezed == socialBatteryLevel
          ? _value.socialBatteryLevel
          : socialBatteryLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      socialBatteryStatus: freezed == socialBatteryStatus
          ? _value.socialBatteryStatus
          : socialBatteryStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: freezed == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      friendshipStatus: freezed == friendshipStatus
          ? _value.friendshipStatus
          : friendshipStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      mutualFriendsCount: null == mutualFriendsCount
          ? _value.mutualFriendsCount
          : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      required this.username,
      @JsonKey(name: 'display_name') required this.displayName,
      this.bio,
      @JsonKey(name: 'profile_picture_url') this.profilePictureUrl,
      final List<String>? interests,
      @JsonKey(name: 'social_battery_level') this.socialBatteryLevel,
      @JsonKey(name: 'social_battery_status') this.socialBatteryStatus,
      @JsonKey(name: 'is_online') this.isOnline,
      @JsonKey(name: 'last_active') this.lastActive,
      @JsonKey(name: 'friendship_status') this.friendshipStatus,
      @JsonKey(name: 'mutual_friends_count') this.mutualFriendsCount = 0,
      @JsonKey(name: 'created_at') this.createdAt})
      : _interests = interests;

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String username;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  @override
  final String? bio;
// null for non-friends
  @override
  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;
  final List<String>? _interests;
  @override
  List<String>? get interests {
    final value = _interests;
    if (value == null) return null;
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// null for non-friends
  @override
  @JsonKey(name: 'social_battery_level')
  final int? socialBatteryLevel;
// null for non-friends
  @override
  @JsonKey(name: 'social_battery_status')
  final String? socialBatteryStatus;
// null for non-friends
  @override
  @JsonKey(name: 'is_online')
  final bool? isOnline;
// null for non-friends
  @override
  @JsonKey(name: 'last_active')
  final DateTime? lastActive;
// null for non-friends
  @override
  @JsonKey(name: 'friendship_status')
  final String? friendshipStatus;
// 'accepted', 'pending', null
  @override
  @JsonKey(name: 'mutual_friends_count')
  final int mutualFriendsCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserProfileModel(userId: $userId, username: $username, displayName: $displayName, bio: $bio, profilePictureUrl: $profilePictureUrl, interests: $interests, socialBatteryLevel: $socialBatteryLevel, socialBatteryStatus: $socialBatteryStatus, isOnline: $isOnline, lastActive: $lastActive, friendshipStatus: $friendshipStatus, mutualFriendsCount: $mutualFriendsCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            (identical(other.socialBatteryLevel, socialBatteryLevel) ||
                other.socialBatteryLevel == socialBatteryLevel) &&
            (identical(other.socialBatteryStatus, socialBatteryStatus) ||
                other.socialBatteryStatus == socialBatteryStatus) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.friendshipStatus, friendshipStatus) ||
                other.friendshipStatus == friendshipStatus) &&
            (identical(other.mutualFriendsCount, mutualFriendsCount) ||
                other.mutualFriendsCount == mutualFriendsCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      username,
      displayName,
      bio,
      profilePictureUrl,
      const DeepCollectionEquality().hash(_interests),
      socialBatteryLevel,
      socialBatteryStatus,
      isOnline,
      lastActive,
      friendshipStatus,
      mutualFriendsCount,
      createdAt);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(
      this,
    );
  }
}

abstract class _UserProfileModel implements UserProfileModel {
  const factory _UserProfileModel(
      {@JsonKey(name: 'user_id') required final String userId,
      required final String username,
      @JsonKey(name: 'display_name') required final String displayName,
      final String? bio,
      @JsonKey(name: 'profile_picture_url') final String? profilePictureUrl,
      final List<String>? interests,
      @JsonKey(name: 'social_battery_level') final int? socialBatteryLevel,
      @JsonKey(name: 'social_battery_status') final String? socialBatteryStatus,
      @JsonKey(name: 'is_online') final bool? isOnline,
      @JsonKey(name: 'last_active') final DateTime? lastActive,
      @JsonKey(name: 'friendship_status') final String? friendshipStatus,
      @JsonKey(name: 'mutual_friends_count') final int mutualFriendsCount,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get username;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;
  @override
  String? get bio; // null for non-friends
  @override
  @JsonKey(name: 'profile_picture_url')
  String? get profilePictureUrl;
  @override
  List<String>? get interests; // null for non-friends
  @override
  @JsonKey(name: 'social_battery_level')
  int? get socialBatteryLevel; // null for non-friends
  @override
  @JsonKey(name: 'social_battery_status')
  String? get socialBatteryStatus; // null for non-friends
  @override
  @JsonKey(name: 'is_online')
  bool? get isOnline; // null for non-friends
  @override
  @JsonKey(name: 'last_active')
  DateTime? get lastActive; // null for non-friends
  @override
  @JsonKey(name: 'friendship_status')
  String? get friendshipStatus; // 'accepted', 'pending', null
  @override
  @JsonKey(name: 'mutual_friends_count')
  int get mutualFriendsCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
