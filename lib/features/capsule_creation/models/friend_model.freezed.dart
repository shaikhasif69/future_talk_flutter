// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return _Friend.fromJson(json);
}

/// @nodoc
mixin _$Friend {
  /// Unique identifier for the friend
  String get id => throw _privateConstructorUsedError;

  /// Friend's display name
  String get name => throw _privateConstructorUsedError;

  /// Friend's avatar URL or identifier
  String get avatar => throw _privateConstructorUsedError;

  /// Friend's current social battery status
  SocialBatteryLevel get socialBattery => throw _privateConstructorUsedError;

  /// When the friend was last active
  DateTime get lastActive => throw _privateConstructorUsedError;

  /// Optional username for search
  String? get username => throw _privateConstructorUsedError;

  /// Whether this friend is currently online
  bool get isOnline => throw _privateConstructorUsedError;

  /// Friend's preferred communication method
  FriendCommunicationPreference get communicationPreference =>
      throw _privateConstructorUsedError;

  /// Whether this friend has enabled capsule notifications
  bool get allowsCapsuleNotifications => throw _privateConstructorUsedError;

  /// Serializes this Friend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendCopyWith<Friend> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendCopyWith<$Res> {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) then) =
      _$FriendCopyWithImpl<$Res, Friend>;
  @useResult
  $Res call(
      {String id,
      String name,
      String avatar,
      SocialBatteryLevel socialBattery,
      DateTime lastActive,
      String? username,
      bool isOnline,
      FriendCommunicationPreference communicationPreference,
      bool allowsCapsuleNotifications});
}

/// @nodoc
class _$FriendCopyWithImpl<$Res, $Val extends Friend>
    implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = null,
    Object? socialBattery = null,
    Object? lastActive = null,
    Object? username = freezed,
    Object? isOnline = null,
    Object? communicationPreference = null,
    Object? allowsCapsuleNotifications = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      socialBattery: null == socialBattery
          ? _value.socialBattery
          : socialBattery // ignore: cast_nullable_to_non_nullable
              as SocialBatteryLevel,
      lastActive: null == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      communicationPreference: null == communicationPreference
          ? _value.communicationPreference
          : communicationPreference // ignore: cast_nullable_to_non_nullable
              as FriendCommunicationPreference,
      allowsCapsuleNotifications: null == allowsCapsuleNotifications
          ? _value.allowsCapsuleNotifications
          : allowsCapsuleNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendImplCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$$FriendImplCopyWith(
          _$FriendImpl value, $Res Function(_$FriendImpl) then) =
      __$$FriendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String avatar,
      SocialBatteryLevel socialBattery,
      DateTime lastActive,
      String? username,
      bool isOnline,
      FriendCommunicationPreference communicationPreference,
      bool allowsCapsuleNotifications});
}

/// @nodoc
class __$$FriendImplCopyWithImpl<$Res>
    extends _$FriendCopyWithImpl<$Res, _$FriendImpl>
    implements _$$FriendImplCopyWith<$Res> {
  __$$FriendImplCopyWithImpl(
      _$FriendImpl _value, $Res Function(_$FriendImpl) _then)
      : super(_value, _then);

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = null,
    Object? socialBattery = null,
    Object? lastActive = null,
    Object? username = freezed,
    Object? isOnline = null,
    Object? communicationPreference = null,
    Object? allowsCapsuleNotifications = null,
  }) {
    return _then(_$FriendImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      socialBattery: null == socialBattery
          ? _value.socialBattery
          : socialBattery // ignore: cast_nullable_to_non_nullable
              as SocialBatteryLevel,
      lastActive: null == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      communicationPreference: null == communicationPreference
          ? _value.communicationPreference
          : communicationPreference // ignore: cast_nullable_to_non_nullable
              as FriendCommunicationPreference,
      allowsCapsuleNotifications: null == allowsCapsuleNotifications
          ? _value.allowsCapsuleNotifications
          : allowsCapsuleNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendImpl implements _Friend {
  const _$FriendImpl(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.socialBattery,
      required this.lastActive,
      this.username,
      this.isOnline = false,
      this.communicationPreference = FriendCommunicationPreference.app,
      this.allowsCapsuleNotifications = true});

  factory _$FriendImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendImplFromJson(json);

  /// Unique identifier for the friend
  @override
  final String id;

  /// Friend's display name
  @override
  final String name;

  /// Friend's avatar URL or identifier
  @override
  final String avatar;

  /// Friend's current social battery status
  @override
  final SocialBatteryLevel socialBattery;

  /// When the friend was last active
  @override
  final DateTime lastActive;

  /// Optional username for search
  @override
  final String? username;

  /// Whether this friend is currently online
  @override
  @JsonKey()
  final bool isOnline;

  /// Friend's preferred communication method
  @override
  @JsonKey()
  final FriendCommunicationPreference communicationPreference;

  /// Whether this friend has enabled capsule notifications
  @override
  @JsonKey()
  final bool allowsCapsuleNotifications;

  @override
  String toString() {
    return 'Friend(id: $id, name: $name, avatar: $avatar, socialBattery: $socialBattery, lastActive: $lastActive, username: $username, isOnline: $isOnline, communicationPreference: $communicationPreference, allowsCapsuleNotifications: $allowsCapsuleNotifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.socialBattery, socialBattery) ||
                other.socialBattery == socialBattery) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(
                    other.communicationPreference, communicationPreference) ||
                other.communicationPreference == communicationPreference) &&
            (identical(other.allowsCapsuleNotifications,
                    allowsCapsuleNotifications) ||
                other.allowsCapsuleNotifications ==
                    allowsCapsuleNotifications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      avatar,
      socialBattery,
      lastActive,
      username,
      isOnline,
      communicationPreference,
      allowsCapsuleNotifications);

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      __$$FriendImplCopyWithImpl<_$FriendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendImplToJson(
      this,
    );
  }
}

abstract class _Friend implements Friend {
  const factory _Friend(
      {required final String id,
      required final String name,
      required final String avatar,
      required final SocialBatteryLevel socialBattery,
      required final DateTime lastActive,
      final String? username,
      final bool isOnline,
      final FriendCommunicationPreference communicationPreference,
      final bool allowsCapsuleNotifications}) = _$FriendImpl;

  factory _Friend.fromJson(Map<String, dynamic> json) = _$FriendImpl.fromJson;

  /// Unique identifier for the friend
  @override
  String get id;

  /// Friend's display name
  @override
  String get name;

  /// Friend's avatar URL or identifier
  @override
  String get avatar;

  /// Friend's current social battery status
  @override
  SocialBatteryLevel get socialBattery;

  /// When the friend was last active
  @override
  DateTime get lastActive;

  /// Optional username for search
  @override
  String? get username;

  /// Whether this friend is currently online
  @override
  bool get isOnline;

  /// Friend's preferred communication method
  @override
  FriendCommunicationPreference get communicationPreference;

  /// Whether this friend has enabled capsule notifications
  @override
  bool get allowsCapsuleNotifications;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
