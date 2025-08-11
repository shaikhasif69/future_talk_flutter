// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_search_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSearchResult _$UserSearchResultFromJson(Map<String, dynamic> json) {
  return _UserSearchResult.fromJson(json);
}

/// @nodoc
mixin _$UserSearchResult {
  /// Unique user identifier
  String get id => throw _privateConstructorUsedError;

  /// User's username
  String get username => throw _privateConstructorUsedError;

  /// User's email (may be partially hidden for privacy)
  String? get email => throw _privateConstructorUsedError;

  /// User's first name
  String? get firstName => throw _privateConstructorUsedError;

  /// User's last name
  String? get lastName => throw _privateConstructorUsedError;

  /// Profile picture URL
  String? get profilePictureUrl => throw _privateConstructorUsedError;

  /// User's bio/description
  String? get bio => throw _privateConstructorUsedError;

  /// User's social battery level (0-100)
  int get socialBattery => throw _privateConstructorUsedError;

  /// Current friendship status with this user
  FriendshipStatus get friendshipStatus => throw _privateConstructorUsedError;

  /// Whether user is currently online
  bool get isOnline => throw _privateConstructorUsedError;

  /// Last seen timestamp
  DateTime? get lastSeen => throw _privateConstructorUsedError;

  /// User's interest tags
  List<String> get interestTags => throw _privateConstructorUsedError;

  /// Mutual friends count
  int get mutualFriendsCount => throw _privateConstructorUsedError;

  /// Serializes this UserSearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSearchResultCopyWith<UserSearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSearchResultCopyWith<$Res> {
  factory $UserSearchResultCopyWith(
          UserSearchResult value, $Res Function(UserSearchResult) then) =
      _$UserSearchResultCopyWithImpl<$Res, UserSearchResult>;
  @useResult
  $Res call(
      {String id,
      String username,
      String? email,
      String? firstName,
      String? lastName,
      String? profilePictureUrl,
      String? bio,
      int socialBattery,
      FriendshipStatus friendshipStatus,
      bool isOnline,
      DateTime? lastSeen,
      List<String> interestTags,
      int mutualFriendsCount});
}

/// @nodoc
class _$UserSearchResultCopyWithImpl<$Res, $Val extends UserSearchResult>
    implements $UserSearchResultCopyWith<$Res> {
  _$UserSearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? profilePictureUrl = freezed,
    Object? bio = freezed,
    Object? socialBattery = null,
    Object? friendshipStatus = null,
    Object? isOnline = null,
    Object? lastSeen = freezed,
    Object? interestTags = null,
    Object? mutualFriendsCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      socialBattery: null == socialBattery
          ? _value.socialBattery
          : socialBattery // ignore: cast_nullable_to_non_nullable
              as int,
      friendshipStatus: null == friendshipStatus
          ? _value.friendshipStatus
          : friendshipStatus // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      interestTags: null == interestTags
          ? _value.interestTags
          : interestTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mutualFriendsCount: null == mutualFriendsCount
          ? _value.mutualFriendsCount
          : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSearchResultImplCopyWith<$Res>
    implements $UserSearchResultCopyWith<$Res> {
  factory _$$UserSearchResultImplCopyWith(_$UserSearchResultImpl value,
          $Res Function(_$UserSearchResultImpl) then) =
      __$$UserSearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      String? email,
      String? firstName,
      String? lastName,
      String? profilePictureUrl,
      String? bio,
      int socialBattery,
      FriendshipStatus friendshipStatus,
      bool isOnline,
      DateTime? lastSeen,
      List<String> interestTags,
      int mutualFriendsCount});
}

/// @nodoc
class __$$UserSearchResultImplCopyWithImpl<$Res>
    extends _$UserSearchResultCopyWithImpl<$Res, _$UserSearchResultImpl>
    implements _$$UserSearchResultImplCopyWith<$Res> {
  __$$UserSearchResultImplCopyWithImpl(_$UserSearchResultImpl _value,
      $Res Function(_$UserSearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? profilePictureUrl = freezed,
    Object? bio = freezed,
    Object? socialBattery = null,
    Object? friendshipStatus = null,
    Object? isOnline = null,
    Object? lastSeen = freezed,
    Object? interestTags = null,
    Object? mutualFriendsCount = null,
  }) {
    return _then(_$UserSearchResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      socialBattery: null == socialBattery
          ? _value.socialBattery
          : socialBattery // ignore: cast_nullable_to_non_nullable
              as int,
      friendshipStatus: null == friendshipStatus
          ? _value.friendshipStatus
          : friendshipStatus // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      interestTags: null == interestTags
          ? _value._interestTags
          : interestTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mutualFriendsCount: null == mutualFriendsCount
          ? _value.mutualFriendsCount
          : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSearchResultImpl extends _UserSearchResult {
  const _$UserSearchResultImpl(
      {required this.id,
      required this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.profilePictureUrl,
      this.bio,
      this.socialBattery = 75,
      this.friendshipStatus = FriendshipStatus.none,
      this.isOnline = false,
      this.lastSeen,
      final List<String> interestTags = const [],
      this.mutualFriendsCount = 0})
      : _interestTags = interestTags,
        super._();

  factory _$UserSearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSearchResultImplFromJson(json);

  /// Unique user identifier
  @override
  final String id;

  /// User's username
  @override
  final String username;

  /// User's email (may be partially hidden for privacy)
  @override
  final String? email;

  /// User's first name
  @override
  final String? firstName;

  /// User's last name
  @override
  final String? lastName;

  /// Profile picture URL
  @override
  final String? profilePictureUrl;

  /// User's bio/description
  @override
  final String? bio;

  /// User's social battery level (0-100)
  @override
  @JsonKey()
  final int socialBattery;

  /// Current friendship status with this user
  @override
  @JsonKey()
  final FriendshipStatus friendshipStatus;

  /// Whether user is currently online
  @override
  @JsonKey()
  final bool isOnline;

  /// Last seen timestamp
  @override
  final DateTime? lastSeen;

  /// User's interest tags
  final List<String> _interestTags;

  /// User's interest tags
  @override
  @JsonKey()
  List<String> get interestTags {
    if (_interestTags is EqualUnmodifiableListView) return _interestTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interestTags);
  }

  /// Mutual friends count
  @override
  @JsonKey()
  final int mutualFriendsCount;

  @override
  String toString() {
    return 'UserSearchResult(id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, profilePictureUrl: $profilePictureUrl, bio: $bio, socialBattery: $socialBattery, friendshipStatus: $friendshipStatus, isOnline: $isOnline, lastSeen: $lastSeen, interestTags: $interestTags, mutualFriendsCount: $mutualFriendsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSearchResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.socialBattery, socialBattery) ||
                other.socialBattery == socialBattery) &&
            (identical(other.friendshipStatus, friendshipStatus) ||
                other.friendshipStatus == friendshipStatus) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            const DeepCollectionEquality()
                .equals(other._interestTags, _interestTags) &&
            (identical(other.mutualFriendsCount, mutualFriendsCount) ||
                other.mutualFriendsCount == mutualFriendsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      email,
      firstName,
      lastName,
      profilePictureUrl,
      bio,
      socialBattery,
      friendshipStatus,
      isOnline,
      lastSeen,
      const DeepCollectionEquality().hash(_interestTags),
      mutualFriendsCount);

  /// Create a copy of UserSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSearchResultImplCopyWith<_$UserSearchResultImpl> get copyWith =>
      __$$UserSearchResultImplCopyWithImpl<_$UserSearchResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSearchResultImplToJson(
      this,
    );
  }
}

abstract class _UserSearchResult extends UserSearchResult {
  const factory _UserSearchResult(
      {required final String id,
      required final String username,
      final String? email,
      final String? firstName,
      final String? lastName,
      final String? profilePictureUrl,
      final String? bio,
      final int socialBattery,
      final FriendshipStatus friendshipStatus,
      final bool isOnline,
      final DateTime? lastSeen,
      final List<String> interestTags,
      final int mutualFriendsCount}) = _$UserSearchResultImpl;
  const _UserSearchResult._() : super._();

  factory _UserSearchResult.fromJson(Map<String, dynamic> json) =
      _$UserSearchResultImpl.fromJson;

  /// Unique user identifier
  @override
  String get id;

  /// User's username
  @override
  String get username;

  /// User's email (may be partially hidden for privacy)
  @override
  String? get email;

  /// User's first name
  @override
  String? get firstName;

  /// User's last name
  @override
  String? get lastName;

  /// Profile picture URL
  @override
  String? get profilePictureUrl;

  /// User's bio/description
  @override
  String? get bio;

  /// User's social battery level (0-100)
  @override
  int get socialBattery;

  /// Current friendship status with this user
  @override
  FriendshipStatus get friendshipStatus;

  /// Whether user is currently online
  @override
  bool get isOnline;

  /// Last seen timestamp
  @override
  DateTime? get lastSeen;

  /// User's interest tags
  @override
  List<String> get interestTags;

  /// Mutual friends count
  @override
  int get mutualFriendsCount;

  /// Create a copy of UserSearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSearchResultImplCopyWith<_$UserSearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserLookupResult _$UserLookupResultFromJson(Map<String, dynamic> json) {
  return _UserLookupResult.fromJson(json);
}

/// @nodoc
mixin _$UserLookupResult {
  /// Unique user identifier
  @JsonKey(name: 'user_id')
  String get id => throw _privateConstructorUsedError;

  /// User's username
  String get username => throw _privateConstructorUsedError;

  /// User's display name
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;

  /// Profile picture URL
  @JsonKey(name: 'profile_picture_url')
  String? get profilePictureUrl => throw _privateConstructorUsedError;

  /// User's bio/description (bio_preview from API)
  @JsonKey(name: 'bio_preview')
  String? get bio => throw _privateConstructorUsedError;

  /// Current friendship status with this user
  @JsonKey(name: 'friendship_status')
  FriendshipStatus get friendshipStatus => throw _privateConstructorUsedError;

  /// Member since date string
  @JsonKey(name: 'member_since')
  String? get memberSince => throw _privateConstructorUsedError;

  /// User's social battery level (0-100) - default for missing data
  int get socialBattery => throw _privateConstructorUsedError;

  /// Whether user is currently online
  bool get isOnline => throw _privateConstructorUsedError;

  /// Last seen timestamp
  DateTime? get lastSeen => throw _privateConstructorUsedError;

  /// User's interest tags
  List<String> get interestTags => throw _privateConstructorUsedError;

  /// Mutual friends count
  int get mutualFriendsCount => throw _privateConstructorUsedError;

  /// Serializes this UserLookupResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserLookupResultCopyWith<UserLookupResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLookupResultCopyWith<$Res> {
  factory $UserLookupResultCopyWith(
          UserLookupResult value, $Res Function(UserLookupResult) then) =
      _$UserLookupResultCopyWithImpl<$Res, UserLookupResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String id,
      String username,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
      @JsonKey(name: 'bio_preview') String? bio,
      @JsonKey(name: 'friendship_status') FriendshipStatus friendshipStatus,
      @JsonKey(name: 'member_since') String? memberSince,
      int socialBattery,
      bool isOnline,
      DateTime? lastSeen,
      List<String> interestTags,
      int mutualFriendsCount});
}

/// @nodoc
class _$UserLookupResultCopyWithImpl<$Res, $Val extends UserLookupResult>
    implements $UserLookupResultCopyWith<$Res> {
  _$UserLookupResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = null,
    Object? profilePictureUrl = freezed,
    Object? bio = freezed,
    Object? friendshipStatus = null,
    Object? memberSince = freezed,
    Object? socialBattery = null,
    Object? isOnline = null,
    Object? lastSeen = freezed,
    Object? interestTags = null,
    Object? mutualFriendsCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      friendshipStatus: null == friendshipStatus
          ? _value.friendshipStatus
          : friendshipStatus // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      memberSince: freezed == memberSince
          ? _value.memberSince
          : memberSince // ignore: cast_nullable_to_non_nullable
              as String?,
      socialBattery: null == socialBattery
          ? _value.socialBattery
          : socialBattery // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      interestTags: null == interestTags
          ? _value.interestTags
          : interestTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mutualFriendsCount: null == mutualFriendsCount
          ? _value.mutualFriendsCount
          : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserLookupResultImplCopyWith<$Res>
    implements $UserLookupResultCopyWith<$Res> {
  factory _$$UserLookupResultImplCopyWith(_$UserLookupResultImpl value,
          $Res Function(_$UserLookupResultImpl) then) =
      __$$UserLookupResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String id,
      String username,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
      @JsonKey(name: 'bio_preview') String? bio,
      @JsonKey(name: 'friendship_status') FriendshipStatus friendshipStatus,
      @JsonKey(name: 'member_since') String? memberSince,
      int socialBattery,
      bool isOnline,
      DateTime? lastSeen,
      List<String> interestTags,
      int mutualFriendsCount});
}

/// @nodoc
class __$$UserLookupResultImplCopyWithImpl<$Res>
    extends _$UserLookupResultCopyWithImpl<$Res, _$UserLookupResultImpl>
    implements _$$UserLookupResultImplCopyWith<$Res> {
  __$$UserLookupResultImplCopyWithImpl(_$UserLookupResultImpl _value,
      $Res Function(_$UserLookupResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = null,
    Object? profilePictureUrl = freezed,
    Object? bio = freezed,
    Object? friendshipStatus = null,
    Object? memberSince = freezed,
    Object? socialBattery = null,
    Object? isOnline = null,
    Object? lastSeen = freezed,
    Object? interestTags = null,
    Object? mutualFriendsCount = null,
  }) {
    return _then(_$UserLookupResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      friendshipStatus: null == friendshipStatus
          ? _value.friendshipStatus
          : friendshipStatus // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      memberSince: freezed == memberSince
          ? _value.memberSince
          : memberSince // ignore: cast_nullable_to_non_nullable
              as String?,
      socialBattery: null == socialBattery
          ? _value.socialBattery
          : socialBattery // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      interestTags: null == interestTags
          ? _value._interestTags
          : interestTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mutualFriendsCount: null == mutualFriendsCount
          ? _value.mutualFriendsCount
          : mutualFriendsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserLookupResultImpl extends _UserLookupResult {
  const _$UserLookupResultImpl(
      {@JsonKey(name: 'user_id') required this.id,
      required this.username,
      @JsonKey(name: 'display_name') required this.displayName,
      @JsonKey(name: 'profile_picture_url') this.profilePictureUrl,
      @JsonKey(name: 'bio_preview') this.bio,
      @JsonKey(name: 'friendship_status')
      this.friendshipStatus = FriendshipStatus.none,
      @JsonKey(name: 'member_since') this.memberSince,
      this.socialBattery = 75,
      this.isOnline = false,
      this.lastSeen,
      final List<String> interestTags = const [],
      this.mutualFriendsCount = 0})
      : _interestTags = interestTags,
        super._();

  factory _$UserLookupResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserLookupResultImplFromJson(json);

  /// Unique user identifier
  @override
  @JsonKey(name: 'user_id')
  final String id;

  /// User's username
  @override
  final String username;

  /// User's display name
  @override
  @JsonKey(name: 'display_name')
  final String displayName;

  /// Profile picture URL
  @override
  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;

  /// User's bio/description (bio_preview from API)
  @override
  @JsonKey(name: 'bio_preview')
  final String? bio;

  /// Current friendship status with this user
  @override
  @JsonKey(name: 'friendship_status')
  final FriendshipStatus friendshipStatus;

  /// Member since date string
  @override
  @JsonKey(name: 'member_since')
  final String? memberSince;

  /// User's social battery level (0-100) - default for missing data
  @override
  @JsonKey()
  final int socialBattery;

  /// Whether user is currently online
  @override
  @JsonKey()
  final bool isOnline;

  /// Last seen timestamp
  @override
  final DateTime? lastSeen;

  /// User's interest tags
  final List<String> _interestTags;

  /// User's interest tags
  @override
  @JsonKey()
  List<String> get interestTags {
    if (_interestTags is EqualUnmodifiableListView) return _interestTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interestTags);
  }

  /// Mutual friends count
  @override
  @JsonKey()
  final int mutualFriendsCount;

  @override
  String toString() {
    return 'UserLookupResult(id: $id, username: $username, displayName: $displayName, profilePictureUrl: $profilePictureUrl, bio: $bio, friendshipStatus: $friendshipStatus, memberSince: $memberSince, socialBattery: $socialBattery, isOnline: $isOnline, lastSeen: $lastSeen, interestTags: $interestTags, mutualFriendsCount: $mutualFriendsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserLookupResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.friendshipStatus, friendshipStatus) ||
                other.friendshipStatus == friendshipStatus) &&
            (identical(other.memberSince, memberSince) ||
                other.memberSince == memberSince) &&
            (identical(other.socialBattery, socialBattery) ||
                other.socialBattery == socialBattery) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            const DeepCollectionEquality()
                .equals(other._interestTags, _interestTags) &&
            (identical(other.mutualFriendsCount, mutualFriendsCount) ||
                other.mutualFriendsCount == mutualFriendsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      displayName,
      profilePictureUrl,
      bio,
      friendshipStatus,
      memberSince,
      socialBattery,
      isOnline,
      lastSeen,
      const DeepCollectionEquality().hash(_interestTags),
      mutualFriendsCount);

  /// Create a copy of UserLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserLookupResultImplCopyWith<_$UserLookupResultImpl> get copyWith =>
      __$$UserLookupResultImplCopyWithImpl<_$UserLookupResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserLookupResultImplToJson(
      this,
    );
  }
}

abstract class _UserLookupResult extends UserLookupResult {
  const factory _UserLookupResult(
      {@JsonKey(name: 'user_id') required final String id,
      required final String username,
      @JsonKey(name: 'display_name') required final String displayName,
      @JsonKey(name: 'profile_picture_url') final String? profilePictureUrl,
      @JsonKey(name: 'bio_preview') final String? bio,
      @JsonKey(name: 'friendship_status')
      final FriendshipStatus friendshipStatus,
      @JsonKey(name: 'member_since') final String? memberSince,
      final int socialBattery,
      final bool isOnline,
      final DateTime? lastSeen,
      final List<String> interestTags,
      final int mutualFriendsCount}) = _$UserLookupResultImpl;
  const _UserLookupResult._() : super._();

  factory _UserLookupResult.fromJson(Map<String, dynamic> json) =
      _$UserLookupResultImpl.fromJson;

  /// Unique user identifier
  @override
  @JsonKey(name: 'user_id')
  String get id;

  /// User's username
  @override
  String get username;

  /// User's display name
  @override
  @JsonKey(name: 'display_name')
  String get displayName;

  /// Profile picture URL
  @override
  @JsonKey(name: 'profile_picture_url')
  String? get profilePictureUrl;

  /// User's bio/description (bio_preview from API)
  @override
  @JsonKey(name: 'bio_preview')
  String? get bio;

  /// Current friendship status with this user
  @override
  @JsonKey(name: 'friendship_status')
  FriendshipStatus get friendshipStatus;

  /// Member since date string
  @override
  @JsonKey(name: 'member_since')
  String? get memberSince;

  /// User's social battery level (0-100) - default for missing data
  @override
  int get socialBattery;

  /// Whether user is currently online
  @override
  bool get isOnline;

  /// Last seen timestamp
  @override
  DateTime? get lastSeen;

  /// User's interest tags
  @override
  List<String> get interestTags;

  /// Mutual friends count
  @override
  int get mutualFriendsCount;

  /// Create a copy of UserLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserLookupResultImplCopyWith<_$UserLookupResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) {
  return _FriendRequest.fromJson(json);
}

/// @nodoc
mixin _$FriendRequest {
  /// Unique friend request identifier
  String get id => throw _privateConstructorUsedError;

  /// ID of user who sent the request
  String get senderId => throw _privateConstructorUsedError;

  /// ID of user who received the request
  String get receiverId => throw _privateConstructorUsedError;

  /// Optional message with the friend request
  String? get message => throw _privateConstructorUsedError;

  /// Current status of the friend request
  FriendRequestStatus get status => throw _privateConstructorUsedError;

  /// When the request was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When the request was last updated
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Sender user details (populated in responses)
  UserSearchResult? get sender => throw _privateConstructorUsedError;

  /// Receiver user details (populated in responses)
  UserSearchResult? get receiver => throw _privateConstructorUsedError;

  /// Serializes this FriendRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendRequestCopyWith<FriendRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendRequestCopyWith<$Res> {
  factory $FriendRequestCopyWith(
          FriendRequest value, $Res Function(FriendRequest) then) =
      _$FriendRequestCopyWithImpl<$Res, FriendRequest>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String receiverId,
      String? message,
      FriendRequestStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      UserSearchResult? sender,
      UserSearchResult? receiver});

  $UserSearchResultCopyWith<$Res>? get sender;
  $UserSearchResultCopyWith<$Res>? get receiver;
}

/// @nodoc
class _$FriendRequestCopyWithImpl<$Res, $Val extends FriendRequest>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? message = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sender = freezed,
    Object? receiver = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendRequestStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserSearchResult?,
      receiver: freezed == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as UserSearchResult?,
    ) as $Val);
  }

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserSearchResultCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $UserSearchResultCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserSearchResultCopyWith<$Res>? get receiver {
    if (_value.receiver == null) {
      return null;
    }

    return $UserSearchResultCopyWith<$Res>(_value.receiver!, (value) {
      return _then(_value.copyWith(receiver: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendRequestImplCopyWith<$Res>
    implements $FriendRequestCopyWith<$Res> {
  factory _$$FriendRequestImplCopyWith(
          _$FriendRequestImpl value, $Res Function(_$FriendRequestImpl) then) =
      __$$FriendRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String receiverId,
      String? message,
      FriendRequestStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      UserSearchResult? sender,
      UserSearchResult? receiver});

  @override
  $UserSearchResultCopyWith<$Res>? get sender;
  @override
  $UserSearchResultCopyWith<$Res>? get receiver;
}

/// @nodoc
class __$$FriendRequestImplCopyWithImpl<$Res>
    extends _$FriendRequestCopyWithImpl<$Res, _$FriendRequestImpl>
    implements _$$FriendRequestImplCopyWith<$Res> {
  __$$FriendRequestImplCopyWithImpl(
      _$FriendRequestImpl _value, $Res Function(_$FriendRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? message = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sender = freezed,
    Object? receiver = freezed,
  }) {
    return _then(_$FriendRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendRequestStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserSearchResult?,
      receiver: freezed == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as UserSearchResult?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendRequestImpl implements _FriendRequest {
  const _$FriendRequestImpl(
      {required this.id,
      required this.senderId,
      required this.receiverId,
      this.message,
      this.status = FriendRequestStatus.pending,
      required this.createdAt,
      required this.updatedAt,
      this.sender,
      this.receiver});

  factory _$FriendRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendRequestImplFromJson(json);

  /// Unique friend request identifier
  @override
  final String id;

  /// ID of user who sent the request
  @override
  final String senderId;

  /// ID of user who received the request
  @override
  final String receiverId;

  /// Optional message with the friend request
  @override
  final String? message;

  /// Current status of the friend request
  @override
  @JsonKey()
  final FriendRequestStatus status;

  /// When the request was created
  @override
  final DateTime createdAt;

  /// When the request was last updated
  @override
  final DateTime updatedAt;

  /// Sender user details (populated in responses)
  @override
  final UserSearchResult? sender;

  /// Receiver user details (populated in responses)
  @override
  final UserSearchResult? receiver;

  @override
  String toString() {
    return 'FriendRequest(id: $id, senderId: $senderId, receiverId: $receiverId, message: $message, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, sender: $sender, receiver: $receiver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, senderId, receiverId,
      message, status, createdAt, updatedAt, sender, receiver);

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendRequestImplCopyWith<_$FriendRequestImpl> get copyWith =>
      __$$FriendRequestImplCopyWithImpl<_$FriendRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendRequestImplToJson(
      this,
    );
  }
}

abstract class _FriendRequest implements FriendRequest {
  const factory _FriendRequest(
      {required final String id,
      required final String senderId,
      required final String receiverId,
      final String? message,
      final FriendRequestStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final UserSearchResult? sender,
      final UserSearchResult? receiver}) = _$FriendRequestImpl;

  factory _FriendRequest.fromJson(Map<String, dynamic> json) =
      _$FriendRequestImpl.fromJson;

  /// Unique friend request identifier
  @override
  String get id;

  /// ID of user who sent the request
  @override
  String get senderId;

  /// ID of user who received the request
  @override
  String get receiverId;

  /// Optional message with the friend request
  @override
  String? get message;

  /// Current status of the friend request
  @override
  FriendRequestStatus get status;

  /// When the request was created
  @override
  DateTime get createdAt;

  /// When the request was last updated
  @override
  DateTime get updatedAt;

  /// Sender user details (populated in responses)
  @override
  UserSearchResult? get sender;

  /// Receiver user details (populated in responses)
  @override
  UserSearchResult? get receiver;

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendRequestImplCopyWith<_$FriendRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SendFriendRequestData _$SendFriendRequestDataFromJson(
    Map<String, dynamic> json) {
  return _SendFriendRequestData.fromJson(json);
}

/// @nodoc
mixin _$SendFriendRequestData {
  /// Target user's username
  String get targetUsername => throw _privateConstructorUsedError;

  /// Optional message to include with request
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this SendFriendRequestData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendFriendRequestData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendFriendRequestDataCopyWith<SendFriendRequestData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendFriendRequestDataCopyWith<$Res> {
  factory $SendFriendRequestDataCopyWith(SendFriendRequestData value,
          $Res Function(SendFriendRequestData) then) =
      _$SendFriendRequestDataCopyWithImpl<$Res, SendFriendRequestData>;
  @useResult
  $Res call({String targetUsername, String? message});
}

/// @nodoc
class _$SendFriendRequestDataCopyWithImpl<$Res,
        $Val extends SendFriendRequestData>
    implements $SendFriendRequestDataCopyWith<$Res> {
  _$SendFriendRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendFriendRequestData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetUsername = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      targetUsername: null == targetUsername
          ? _value.targetUsername
          : targetUsername // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendFriendRequestDataImplCopyWith<$Res>
    implements $SendFriendRequestDataCopyWith<$Res> {
  factory _$$SendFriendRequestDataImplCopyWith(
          _$SendFriendRequestDataImpl value,
          $Res Function(_$SendFriendRequestDataImpl) then) =
      __$$SendFriendRequestDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String targetUsername, String? message});
}

/// @nodoc
class __$$SendFriendRequestDataImplCopyWithImpl<$Res>
    extends _$SendFriendRequestDataCopyWithImpl<$Res,
        _$SendFriendRequestDataImpl>
    implements _$$SendFriendRequestDataImplCopyWith<$Res> {
  __$$SendFriendRequestDataImplCopyWithImpl(_$SendFriendRequestDataImpl _value,
      $Res Function(_$SendFriendRequestDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SendFriendRequestData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetUsername = null,
    Object? message = freezed,
  }) {
    return _then(_$SendFriendRequestDataImpl(
      targetUsername: null == targetUsername
          ? _value.targetUsername
          : targetUsername // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendFriendRequestDataImpl implements _SendFriendRequestData {
  const _$SendFriendRequestDataImpl(
      {required this.targetUsername, this.message});

  factory _$SendFriendRequestDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendFriendRequestDataImplFromJson(json);

  /// Target user's username
  @override
  final String targetUsername;

  /// Optional message to include with request
  @override
  final String? message;

  @override
  String toString() {
    return 'SendFriendRequestData(targetUsername: $targetUsername, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendFriendRequestDataImpl &&
            (identical(other.targetUsername, targetUsername) ||
                other.targetUsername == targetUsername) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, targetUsername, message);

  /// Create a copy of SendFriendRequestData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendFriendRequestDataImplCopyWith<_$SendFriendRequestDataImpl>
      get copyWith => __$$SendFriendRequestDataImplCopyWithImpl<
          _$SendFriendRequestDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendFriendRequestDataImplToJson(
      this,
    );
  }
}

abstract class _SendFriendRequestData implements SendFriendRequestData {
  const factory _SendFriendRequestData(
      {required final String targetUsername,
      final String? message}) = _$SendFriendRequestDataImpl;

  factory _SendFriendRequestData.fromJson(Map<String, dynamic> json) =
      _$SendFriendRequestDataImpl.fromJson;

  /// Target user's username
  @override
  String get targetUsername;

  /// Optional message to include with request
  @override
  String? get message;

  /// Create a copy of SendFriendRequestData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendFriendRequestDataImplCopyWith<_$SendFriendRequestDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FriendRequestResponse _$FriendRequestResponseFromJson(
    Map<String, dynamic> json) {
  return _FriendRequestResponse.fromJson(json);
}

/// @nodoc
mixin _$FriendRequestResponse {
  /// Success message
  String get message => throw _privateConstructorUsedError;

  /// Friend request or friendship ID
  String? get friendshipId => throw _privateConstructorUsedError;

  /// Created friend request (for send operations)
  FriendRequest? get friendRequest => throw _privateConstructorUsedError;

  /// Serializes this FriendRequestResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendRequestResponseCopyWith<FriendRequestResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendRequestResponseCopyWith<$Res> {
  factory $FriendRequestResponseCopyWith(FriendRequestResponse value,
          $Res Function(FriendRequestResponse) then) =
      _$FriendRequestResponseCopyWithImpl<$Res, FriendRequestResponse>;
  @useResult
  $Res call(
      {String message, String? friendshipId, FriendRequest? friendRequest});

  $FriendRequestCopyWith<$Res>? get friendRequest;
}

/// @nodoc
class _$FriendRequestResponseCopyWithImpl<$Res,
        $Val extends FriendRequestResponse>
    implements $FriendRequestResponseCopyWith<$Res> {
  _$FriendRequestResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? friendshipId = freezed,
    Object? friendRequest = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      friendshipId: freezed == friendshipId
          ? _value.friendshipId
          : friendshipId // ignore: cast_nullable_to_non_nullable
              as String?,
      friendRequest: freezed == friendRequest
          ? _value.friendRequest
          : friendRequest // ignore: cast_nullable_to_non_nullable
              as FriendRequest?,
    ) as $Val);
  }

  /// Create a copy of FriendRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FriendRequestCopyWith<$Res>? get friendRequest {
    if (_value.friendRequest == null) {
      return null;
    }

    return $FriendRequestCopyWith<$Res>(_value.friendRequest!, (value) {
      return _then(_value.copyWith(friendRequest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendRequestResponseImplCopyWith<$Res>
    implements $FriendRequestResponseCopyWith<$Res> {
  factory _$$FriendRequestResponseImplCopyWith(
          _$FriendRequestResponseImpl value,
          $Res Function(_$FriendRequestResponseImpl) then) =
      __$$FriendRequestResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message, String? friendshipId, FriendRequest? friendRequest});

  @override
  $FriendRequestCopyWith<$Res>? get friendRequest;
}

/// @nodoc
class __$$FriendRequestResponseImplCopyWithImpl<$Res>
    extends _$FriendRequestResponseCopyWithImpl<$Res,
        _$FriendRequestResponseImpl>
    implements _$$FriendRequestResponseImplCopyWith<$Res> {
  __$$FriendRequestResponseImplCopyWithImpl(_$FriendRequestResponseImpl _value,
      $Res Function(_$FriendRequestResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? friendshipId = freezed,
    Object? friendRequest = freezed,
  }) {
    return _then(_$FriendRequestResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      friendshipId: freezed == friendshipId
          ? _value.friendshipId
          : friendshipId // ignore: cast_nullable_to_non_nullable
              as String?,
      friendRequest: freezed == friendRequest
          ? _value.friendRequest
          : friendRequest // ignore: cast_nullable_to_non_nullable
              as FriendRequest?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendRequestResponseImpl implements _FriendRequestResponse {
  const _$FriendRequestResponseImpl(
      {required this.message, this.friendshipId, this.friendRequest});

  factory _$FriendRequestResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendRequestResponseImplFromJson(json);

  /// Success message
  @override
  final String message;

  /// Friend request or friendship ID
  @override
  final String? friendshipId;

  /// Created friend request (for send operations)
  @override
  final FriendRequest? friendRequest;

  @override
  String toString() {
    return 'FriendRequestResponse(message: $message, friendshipId: $friendshipId, friendRequest: $friendRequest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendRequestResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.friendshipId, friendshipId) ||
                other.friendshipId == friendshipId) &&
            (identical(other.friendRequest, friendRequest) ||
                other.friendRequest == friendRequest));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, message, friendshipId, friendRequest);

  /// Create a copy of FriendRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendRequestResponseImplCopyWith<_$FriendRequestResponseImpl>
      get copyWith => __$$FriendRequestResponseImplCopyWithImpl<
          _$FriendRequestResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendRequestResponseImplToJson(
      this,
    );
  }
}

abstract class _FriendRequestResponse implements FriendRequestResponse {
  const factory _FriendRequestResponse(
      {required final String message,
      final String? friendshipId,
      final FriendRequest? friendRequest}) = _$FriendRequestResponseImpl;

  factory _FriendRequestResponse.fromJson(Map<String, dynamic> json) =
      _$FriendRequestResponseImpl.fromJson;

  /// Success message
  @override
  String get message;

  /// Friend request or friendship ID
  @override
  String? get friendshipId;

  /// Created friend request (for send operations)
  @override
  FriendRequest? get friendRequest;

  /// Create a copy of FriendRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendRequestResponseImplCopyWith<_$FriendRequestResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserLookupRequest _$UserLookupRequestFromJson(Map<String, dynamic> json) {
  return _UserLookupRequest.fromJson(json);
}

/// @nodoc
mixin _$UserLookupRequest {
  /// Username or email to look up
  String get identifier => throw _privateConstructorUsedError;

  /// Serializes this UserLookupRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserLookupRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserLookupRequestCopyWith<UserLookupRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLookupRequestCopyWith<$Res> {
  factory $UserLookupRequestCopyWith(
          UserLookupRequest value, $Res Function(UserLookupRequest) then) =
      _$UserLookupRequestCopyWithImpl<$Res, UserLookupRequest>;
  @useResult
  $Res call({String identifier});
}

/// @nodoc
class _$UserLookupRequestCopyWithImpl<$Res, $Val extends UserLookupRequest>
    implements $UserLookupRequestCopyWith<$Res> {
  _$UserLookupRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserLookupRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
  }) {
    return _then(_value.copyWith(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserLookupRequestImplCopyWith<$Res>
    implements $UserLookupRequestCopyWith<$Res> {
  factory _$$UserLookupRequestImplCopyWith(_$UserLookupRequestImpl value,
          $Res Function(_$UserLookupRequestImpl) then) =
      __$$UserLookupRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String identifier});
}

/// @nodoc
class __$$UserLookupRequestImplCopyWithImpl<$Res>
    extends _$UserLookupRequestCopyWithImpl<$Res, _$UserLookupRequestImpl>
    implements _$$UserLookupRequestImplCopyWith<$Res> {
  __$$UserLookupRequestImplCopyWithImpl(_$UserLookupRequestImpl _value,
      $Res Function(_$UserLookupRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserLookupRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
  }) {
    return _then(_$UserLookupRequestImpl(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserLookupRequestImpl implements _UserLookupRequest {
  const _$UserLookupRequestImpl({required this.identifier});

  factory _$UserLookupRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserLookupRequestImplFromJson(json);

  /// Username or email to look up
  @override
  final String identifier;

  @override
  String toString() {
    return 'UserLookupRequest(identifier: $identifier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserLookupRequestImpl &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identifier);

  /// Create a copy of UserLookupRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserLookupRequestImplCopyWith<_$UserLookupRequestImpl> get copyWith =>
      __$$UserLookupRequestImplCopyWithImpl<_$UserLookupRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserLookupRequestImplToJson(
      this,
    );
  }
}

abstract class _UserLookupRequest implements UserLookupRequest {
  const factory _UserLookupRequest({required final String identifier}) =
      _$UserLookupRequestImpl;

  factory _UserLookupRequest.fromJson(Map<String, dynamic> json) =
      _$UserLookupRequestImpl.fromJson;

  /// Username or email to look up
  @override
  String get identifier;

  /// Create a copy of UserLookupRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserLookupRequestImplCopyWith<_$UserLookupRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
