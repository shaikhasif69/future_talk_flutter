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
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  DateTime get friendsSince => throw _privateConstructorUsedError;
  SocialBatteryStatus get currentMoodStatus =>
      throw _privateConstructorUsedError;
  ConnectionStats get connectionStats => throw _privateConstructorUsedError;
  List<SharedExperience> get sharedExperiences =>
      throw _privateConstructorUsedError;
  List<TimeCapsuleItem> get timeCapsules => throw _privateConstructorUsedError;
  List<ReadingSession> get readingSessions =>
      throw _privateConstructorUsedError;
  List<ComfortStone> get comfortStones => throw _privateConstructorUsedError;
  FriendshipStats get friendshipStats => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  bool get isTyping => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;

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
      {String id,
      String name,
      String username,
      String bio,
      String avatarUrl,
      DateTime friendsSince,
      SocialBatteryStatus currentMoodStatus,
      ConnectionStats connectionStats,
      List<SharedExperience> sharedExperiences,
      List<TimeCapsuleItem> timeCapsules,
      List<ReadingSession> readingSessions,
      List<ComfortStone> comfortStones,
      FriendshipStats friendshipStats,
      bool isOnline,
      bool isTyping,
      DateTime? lastSeen});

  $SocialBatteryStatusCopyWith<$Res> get currentMoodStatus;
  $ConnectionStatsCopyWith<$Res> get connectionStats;
  $FriendshipStatsCopyWith<$Res> get friendshipStats;
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
    Object? id = null,
    Object? name = null,
    Object? username = null,
    Object? bio = null,
    Object? avatarUrl = null,
    Object? friendsSince = null,
    Object? currentMoodStatus = null,
    Object? connectionStats = null,
    Object? sharedExperiences = null,
    Object? timeCapsules = null,
    Object? readingSessions = null,
    Object? comfortStones = null,
    Object? friendshipStats = null,
    Object? isOnline = null,
    Object? isTyping = null,
    Object? lastSeen = freezed,
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
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      friendsSince: null == friendsSince
          ? _value.friendsSince
          : friendsSince // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentMoodStatus: null == currentMoodStatus
          ? _value.currentMoodStatus
          : currentMoodStatus // ignore: cast_nullable_to_non_nullable
              as SocialBatteryStatus,
      connectionStats: null == connectionStats
          ? _value.connectionStats
          : connectionStats // ignore: cast_nullable_to_non_nullable
              as ConnectionStats,
      sharedExperiences: null == sharedExperiences
          ? _value.sharedExperiences
          : sharedExperiences // ignore: cast_nullable_to_non_nullable
              as List<SharedExperience>,
      timeCapsules: null == timeCapsules
          ? _value.timeCapsules
          : timeCapsules // ignore: cast_nullable_to_non_nullable
              as List<TimeCapsuleItem>,
      readingSessions: null == readingSessions
          ? _value.readingSessions
          : readingSessions // ignore: cast_nullable_to_non_nullable
              as List<ReadingSession>,
      comfortStones: null == comfortStones
          ? _value.comfortStones
          : comfortStones // ignore: cast_nullable_to_non_nullable
              as List<ComfortStone>,
      friendshipStats: null == friendshipStats
          ? _value.friendshipStats
          : friendshipStats // ignore: cast_nullable_to_non_nullable
              as FriendshipStats,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isTyping: null == isTyping
          ? _value.isTyping
          : isTyping // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SocialBatteryStatusCopyWith<$Res> get currentMoodStatus {
    return $SocialBatteryStatusCopyWith<$Res>(_value.currentMoodStatus,
        (value) {
      return _then(_value.copyWith(currentMoodStatus: value) as $Val);
    });
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConnectionStatsCopyWith<$Res> get connectionStats {
    return $ConnectionStatsCopyWith<$Res>(_value.connectionStats, (value) {
      return _then(_value.copyWith(connectionStats: value) as $Val);
    });
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FriendshipStatsCopyWith<$Res> get friendshipStats {
    return $FriendshipStatsCopyWith<$Res>(_value.friendshipStats, (value) {
      return _then(_value.copyWith(friendshipStats: value) as $Val);
    });
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
      {String id,
      String name,
      String username,
      String bio,
      String avatarUrl,
      DateTime friendsSince,
      SocialBatteryStatus currentMoodStatus,
      ConnectionStats connectionStats,
      List<SharedExperience> sharedExperiences,
      List<TimeCapsuleItem> timeCapsules,
      List<ReadingSession> readingSessions,
      List<ComfortStone> comfortStones,
      FriendshipStats friendshipStats,
      bool isOnline,
      bool isTyping,
      DateTime? lastSeen});

  @override
  $SocialBatteryStatusCopyWith<$Res> get currentMoodStatus;
  @override
  $ConnectionStatsCopyWith<$Res> get connectionStats;
  @override
  $FriendshipStatsCopyWith<$Res> get friendshipStats;
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
    Object? id = null,
    Object? name = null,
    Object? username = null,
    Object? bio = null,
    Object? avatarUrl = null,
    Object? friendsSince = null,
    Object? currentMoodStatus = null,
    Object? connectionStats = null,
    Object? sharedExperiences = null,
    Object? timeCapsules = null,
    Object? readingSessions = null,
    Object? comfortStones = null,
    Object? friendshipStats = null,
    Object? isOnline = null,
    Object? isTyping = null,
    Object? lastSeen = freezed,
  }) {
    return _then(_$UserProfileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      friendsSince: null == friendsSince
          ? _value.friendsSince
          : friendsSince // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentMoodStatus: null == currentMoodStatus
          ? _value.currentMoodStatus
          : currentMoodStatus // ignore: cast_nullable_to_non_nullable
              as SocialBatteryStatus,
      connectionStats: null == connectionStats
          ? _value.connectionStats
          : connectionStats // ignore: cast_nullable_to_non_nullable
              as ConnectionStats,
      sharedExperiences: null == sharedExperiences
          ? _value._sharedExperiences
          : sharedExperiences // ignore: cast_nullable_to_non_nullable
              as List<SharedExperience>,
      timeCapsules: null == timeCapsules
          ? _value._timeCapsules
          : timeCapsules // ignore: cast_nullable_to_non_nullable
              as List<TimeCapsuleItem>,
      readingSessions: null == readingSessions
          ? _value._readingSessions
          : readingSessions // ignore: cast_nullable_to_non_nullable
              as List<ReadingSession>,
      comfortStones: null == comfortStones
          ? _value._comfortStones
          : comfortStones // ignore: cast_nullable_to_non_nullable
              as List<ComfortStone>,
      friendshipStats: null == friendshipStats
          ? _value.friendshipStats
          : friendshipStats // ignore: cast_nullable_to_non_nullable
              as FriendshipStats,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isTyping: null == isTyping
          ? _value.isTyping
          : isTyping // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl(
      {required this.id,
      required this.name,
      required this.username,
      required this.bio,
      required this.avatarUrl,
      required this.friendsSince,
      required this.currentMoodStatus,
      required this.connectionStats,
      required final List<SharedExperience> sharedExperiences,
      required final List<TimeCapsuleItem> timeCapsules,
      required final List<ReadingSession> readingSessions,
      required final List<ComfortStone> comfortStones,
      required this.friendshipStats,
      this.isOnline = true,
      this.isTyping = false,
      this.lastSeen})
      : _sharedExperiences = sharedExperiences,
        _timeCapsules = timeCapsules,
        _readingSessions = readingSessions,
        _comfortStones = comfortStones;

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String username;
  @override
  final String bio;
  @override
  final String avatarUrl;
  @override
  final DateTime friendsSince;
  @override
  final SocialBatteryStatus currentMoodStatus;
  @override
  final ConnectionStats connectionStats;
  final List<SharedExperience> _sharedExperiences;
  @override
  List<SharedExperience> get sharedExperiences {
    if (_sharedExperiences is EqualUnmodifiableListView)
      return _sharedExperiences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedExperiences);
  }

  final List<TimeCapsuleItem> _timeCapsules;
  @override
  List<TimeCapsuleItem> get timeCapsules {
    if (_timeCapsules is EqualUnmodifiableListView) return _timeCapsules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeCapsules);
  }

  final List<ReadingSession> _readingSessions;
  @override
  List<ReadingSession> get readingSessions {
    if (_readingSessions is EqualUnmodifiableListView) return _readingSessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readingSessions);
  }

  final List<ComfortStone> _comfortStones;
  @override
  List<ComfortStone> get comfortStones {
    if (_comfortStones is EqualUnmodifiableListView) return _comfortStones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comfortStones);
  }

  @override
  final FriendshipStats friendshipStats;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  @JsonKey()
  final bool isTyping;
  @override
  final DateTime? lastSeen;

  @override
  String toString() {
    return 'UserProfileModel(id: $id, name: $name, username: $username, bio: $bio, avatarUrl: $avatarUrl, friendsSince: $friendsSince, currentMoodStatus: $currentMoodStatus, connectionStats: $connectionStats, sharedExperiences: $sharedExperiences, timeCapsules: $timeCapsules, readingSessions: $readingSessions, comfortStones: $comfortStones, friendshipStats: $friendshipStats, isOnline: $isOnline, isTyping: $isTyping, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.friendsSince, friendsSince) ||
                other.friendsSince == friendsSince) &&
            (identical(other.currentMoodStatus, currentMoodStatus) ||
                other.currentMoodStatus == currentMoodStatus) &&
            (identical(other.connectionStats, connectionStats) ||
                other.connectionStats == connectionStats) &&
            const DeepCollectionEquality()
                .equals(other._sharedExperiences, _sharedExperiences) &&
            const DeepCollectionEquality()
                .equals(other._timeCapsules, _timeCapsules) &&
            const DeepCollectionEquality()
                .equals(other._readingSessions, _readingSessions) &&
            const DeepCollectionEquality()
                .equals(other._comfortStones, _comfortStones) &&
            (identical(other.friendshipStats, friendshipStats) ||
                other.friendshipStats == friendshipStats) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isTyping, isTyping) ||
                other.isTyping == isTyping) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      username,
      bio,
      avatarUrl,
      friendsSince,
      currentMoodStatus,
      connectionStats,
      const DeepCollectionEquality().hash(_sharedExperiences),
      const DeepCollectionEquality().hash(_timeCapsules),
      const DeepCollectionEquality().hash(_readingSessions),
      const DeepCollectionEquality().hash(_comfortStones),
      friendshipStats,
      isOnline,
      isTyping,
      lastSeen);

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
      {required final String id,
      required final String name,
      required final String username,
      required final String bio,
      required final String avatarUrl,
      required final DateTime friendsSince,
      required final SocialBatteryStatus currentMoodStatus,
      required final ConnectionStats connectionStats,
      required final List<SharedExperience> sharedExperiences,
      required final List<TimeCapsuleItem> timeCapsules,
      required final List<ReadingSession> readingSessions,
      required final List<ComfortStone> comfortStones,
      required final FriendshipStats friendshipStats,
      final bool isOnline,
      final bool isTyping,
      final DateTime? lastSeen}) = _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get username;
  @override
  String get bio;
  @override
  String get avatarUrl;
  @override
  DateTime get friendsSince;
  @override
  SocialBatteryStatus get currentMoodStatus;
  @override
  ConnectionStats get connectionStats;
  @override
  List<SharedExperience> get sharedExperiences;
  @override
  List<TimeCapsuleItem> get timeCapsules;
  @override
  List<ReadingSession> get readingSessions;
  @override
  List<ComfortStone> get comfortStones;
  @override
  FriendshipStats get friendshipStats;
  @override
  bool get isOnline;
  @override
  bool get isTyping;
  @override
  DateTime? get lastSeen;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialBatteryStatus _$SocialBatteryStatusFromJson(Map<String, dynamic> json) {
  return _SocialBatteryStatus.fromJson(json);
}

/// @nodoc
mixin _$SocialBatteryStatus {
  BatteryLevel get level => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get colorName => throw _privateConstructorUsedError;
  bool get isAvailableForChat => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this SocialBatteryStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialBatteryStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialBatteryStatusCopyWith<SocialBatteryStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialBatteryStatusCopyWith<$Res> {
  factory $SocialBatteryStatusCopyWith(
          SocialBatteryStatus value, $Res Function(SocialBatteryStatus) then) =
      _$SocialBatteryStatusCopyWithImpl<$Res, SocialBatteryStatus>;
  @useResult
  $Res call(
      {BatteryLevel level,
      String description,
      String colorName,
      bool isAvailableForChat,
      DateTime? lastUpdated});
}

/// @nodoc
class _$SocialBatteryStatusCopyWithImpl<$Res, $Val extends SocialBatteryStatus>
    implements $SocialBatteryStatusCopyWith<$Res> {
  _$SocialBatteryStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialBatteryStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? description = null,
    Object? colorName = null,
    Object? isAvailableForChat = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as BatteryLevel,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      colorName: null == colorName
          ? _value.colorName
          : colorName // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailableForChat: null == isAvailableForChat
          ? _value.isAvailableForChat
          : isAvailableForChat // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialBatteryStatusImplCopyWith<$Res>
    implements $SocialBatteryStatusCopyWith<$Res> {
  factory _$$SocialBatteryStatusImplCopyWith(_$SocialBatteryStatusImpl value,
          $Res Function(_$SocialBatteryStatusImpl) then) =
      __$$SocialBatteryStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BatteryLevel level,
      String description,
      String colorName,
      bool isAvailableForChat,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$SocialBatteryStatusImplCopyWithImpl<$Res>
    extends _$SocialBatteryStatusCopyWithImpl<$Res, _$SocialBatteryStatusImpl>
    implements _$$SocialBatteryStatusImplCopyWith<$Res> {
  __$$SocialBatteryStatusImplCopyWithImpl(_$SocialBatteryStatusImpl _value,
      $Res Function(_$SocialBatteryStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialBatteryStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? description = null,
    Object? colorName = null,
    Object? isAvailableForChat = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$SocialBatteryStatusImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as BatteryLevel,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      colorName: null == colorName
          ? _value.colorName
          : colorName // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailableForChat: null == isAvailableForChat
          ? _value.isAvailableForChat
          : isAvailableForChat // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialBatteryStatusImpl implements _SocialBatteryStatus {
  const _$SocialBatteryStatusImpl(
      {required this.level,
      required this.description,
      required this.colorName,
      this.isAvailableForChat = false,
      this.lastUpdated});

  factory _$SocialBatteryStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialBatteryStatusImplFromJson(json);

  @override
  final BatteryLevel level;
  @override
  final String description;
  @override
  final String colorName;
  @override
  @JsonKey()
  final bool isAvailableForChat;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'SocialBatteryStatus(level: $level, description: $description, colorName: $colorName, isAvailableForChat: $isAvailableForChat, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialBatteryStatusImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.colorName, colorName) ||
                other.colorName == colorName) &&
            (identical(other.isAvailableForChat, isAvailableForChat) ||
                other.isAvailableForChat == isAvailableForChat) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, description, colorName,
      isAvailableForChat, lastUpdated);

  /// Create a copy of SocialBatteryStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialBatteryStatusImplCopyWith<_$SocialBatteryStatusImpl> get copyWith =>
      __$$SocialBatteryStatusImplCopyWithImpl<_$SocialBatteryStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialBatteryStatusImplToJson(
      this,
    );
  }
}

abstract class _SocialBatteryStatus implements SocialBatteryStatus {
  const factory _SocialBatteryStatus(
      {required final BatteryLevel level,
      required final String description,
      required final String colorName,
      final bool isAvailableForChat,
      final DateTime? lastUpdated}) = _$SocialBatteryStatusImpl;

  factory _SocialBatteryStatus.fromJson(Map<String, dynamic> json) =
      _$SocialBatteryStatusImpl.fromJson;

  @override
  BatteryLevel get level;
  @override
  String get description;
  @override
  String get colorName;
  @override
  bool get isAvailableForChat;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of SocialBatteryStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialBatteryStatusImplCopyWith<_$SocialBatteryStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectionStats _$ConnectionStatsFromJson(Map<String, dynamic> json) {
  return _ConnectionStats.fromJson(json);
}

/// @nodoc
mixin _$ConnectionStats {
  int get daysOfFriendship => throw _privateConstructorUsedError;
  int get conversationsCount => throw _privateConstructorUsedError;
  int get comfortTouchesShared => throw _privateConstructorUsedError;
  int get hoursReadingTogether => throw _privateConstructorUsedError;
  int get gamesPlayed => throw _privateConstructorUsedError;
  int get timeCapsulesSent => throw _privateConstructorUsedError;

  /// Serializes this ConnectionStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionStatsCopyWith<ConnectionStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionStatsCopyWith<$Res> {
  factory $ConnectionStatsCopyWith(
          ConnectionStats value, $Res Function(ConnectionStats) then) =
      _$ConnectionStatsCopyWithImpl<$Res, ConnectionStats>;
  @useResult
  $Res call(
      {int daysOfFriendship,
      int conversationsCount,
      int comfortTouchesShared,
      int hoursReadingTogether,
      int gamesPlayed,
      int timeCapsulesSent});
}

/// @nodoc
class _$ConnectionStatsCopyWithImpl<$Res, $Val extends ConnectionStats>
    implements $ConnectionStatsCopyWith<$Res> {
  _$ConnectionStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daysOfFriendship = null,
    Object? conversationsCount = null,
    Object? comfortTouchesShared = null,
    Object? hoursReadingTogether = null,
    Object? gamesPlayed = null,
    Object? timeCapsulesSent = null,
  }) {
    return _then(_value.copyWith(
      daysOfFriendship: null == daysOfFriendship
          ? _value.daysOfFriendship
          : daysOfFriendship // ignore: cast_nullable_to_non_nullable
              as int,
      conversationsCount: null == conversationsCount
          ? _value.conversationsCount
          : conversationsCount // ignore: cast_nullable_to_non_nullable
              as int,
      comfortTouchesShared: null == comfortTouchesShared
          ? _value.comfortTouchesShared
          : comfortTouchesShared // ignore: cast_nullable_to_non_nullable
              as int,
      hoursReadingTogether: null == hoursReadingTogether
          ? _value.hoursReadingTogether
          : hoursReadingTogether // ignore: cast_nullable_to_non_nullable
              as int,
      gamesPlayed: null == gamesPlayed
          ? _value.gamesPlayed
          : gamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      timeCapsulesSent: null == timeCapsulesSent
          ? _value.timeCapsulesSent
          : timeCapsulesSent // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectionStatsImplCopyWith<$Res>
    implements $ConnectionStatsCopyWith<$Res> {
  factory _$$ConnectionStatsImplCopyWith(_$ConnectionStatsImpl value,
          $Res Function(_$ConnectionStatsImpl) then) =
      __$$ConnectionStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int daysOfFriendship,
      int conversationsCount,
      int comfortTouchesShared,
      int hoursReadingTogether,
      int gamesPlayed,
      int timeCapsulesSent});
}

/// @nodoc
class __$$ConnectionStatsImplCopyWithImpl<$Res>
    extends _$ConnectionStatsCopyWithImpl<$Res, _$ConnectionStatsImpl>
    implements _$$ConnectionStatsImplCopyWith<$Res> {
  __$$ConnectionStatsImplCopyWithImpl(
      _$ConnectionStatsImpl _value, $Res Function(_$ConnectionStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConnectionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daysOfFriendship = null,
    Object? conversationsCount = null,
    Object? comfortTouchesShared = null,
    Object? hoursReadingTogether = null,
    Object? gamesPlayed = null,
    Object? timeCapsulesSent = null,
  }) {
    return _then(_$ConnectionStatsImpl(
      daysOfFriendship: null == daysOfFriendship
          ? _value.daysOfFriendship
          : daysOfFriendship // ignore: cast_nullable_to_non_nullable
              as int,
      conversationsCount: null == conversationsCount
          ? _value.conversationsCount
          : conversationsCount // ignore: cast_nullable_to_non_nullable
              as int,
      comfortTouchesShared: null == comfortTouchesShared
          ? _value.comfortTouchesShared
          : comfortTouchesShared // ignore: cast_nullable_to_non_nullable
              as int,
      hoursReadingTogether: null == hoursReadingTogether
          ? _value.hoursReadingTogether
          : hoursReadingTogether // ignore: cast_nullable_to_non_nullable
              as int,
      gamesPlayed: null == gamesPlayed
          ? _value.gamesPlayed
          : gamesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      timeCapsulesSent: null == timeCapsulesSent
          ? _value.timeCapsulesSent
          : timeCapsulesSent // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionStatsImpl implements _ConnectionStats {
  const _$ConnectionStatsImpl(
      {required this.daysOfFriendship,
      required this.conversationsCount,
      required this.comfortTouchesShared,
      required this.hoursReadingTogether,
      required this.gamesPlayed,
      required this.timeCapsulesSent});

  factory _$ConnectionStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionStatsImplFromJson(json);

  @override
  final int daysOfFriendship;
  @override
  final int conversationsCount;
  @override
  final int comfortTouchesShared;
  @override
  final int hoursReadingTogether;
  @override
  final int gamesPlayed;
  @override
  final int timeCapsulesSent;

  @override
  String toString() {
    return 'ConnectionStats(daysOfFriendship: $daysOfFriendship, conversationsCount: $conversationsCount, comfortTouchesShared: $comfortTouchesShared, hoursReadingTogether: $hoursReadingTogether, gamesPlayed: $gamesPlayed, timeCapsulesSent: $timeCapsulesSent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionStatsImpl &&
            (identical(other.daysOfFriendship, daysOfFriendship) ||
                other.daysOfFriendship == daysOfFriendship) &&
            (identical(other.conversationsCount, conversationsCount) ||
                other.conversationsCount == conversationsCount) &&
            (identical(other.comfortTouchesShared, comfortTouchesShared) ||
                other.comfortTouchesShared == comfortTouchesShared) &&
            (identical(other.hoursReadingTogether, hoursReadingTogether) ||
                other.hoursReadingTogether == hoursReadingTogether) &&
            (identical(other.gamesPlayed, gamesPlayed) ||
                other.gamesPlayed == gamesPlayed) &&
            (identical(other.timeCapsulesSent, timeCapsulesSent) ||
                other.timeCapsulesSent == timeCapsulesSent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      daysOfFriendship,
      conversationsCount,
      comfortTouchesShared,
      hoursReadingTogether,
      gamesPlayed,
      timeCapsulesSent);

  /// Create a copy of ConnectionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionStatsImplCopyWith<_$ConnectionStatsImpl> get copyWith =>
      __$$ConnectionStatsImplCopyWithImpl<_$ConnectionStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionStatsImplToJson(
      this,
    );
  }
}

abstract class _ConnectionStats implements ConnectionStats {
  const factory _ConnectionStats(
      {required final int daysOfFriendship,
      required final int conversationsCount,
      required final int comfortTouchesShared,
      required final int hoursReadingTogether,
      required final int gamesPlayed,
      required final int timeCapsulesSent}) = _$ConnectionStatsImpl;

  factory _ConnectionStats.fromJson(Map<String, dynamic> json) =
      _$ConnectionStatsImpl.fromJson;

  @override
  int get daysOfFriendship;
  @override
  int get conversationsCount;
  @override
  int get comfortTouchesShared;
  @override
  int get hoursReadingTogether;
  @override
  int get gamesPlayed;
  @override
  int get timeCapsulesSent;

  /// Create a copy of ConnectionStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionStatsImplCopyWith<_$ConnectionStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SharedExperience _$SharedExperienceFromJson(Map<String, dynamic> json) {
  return _SharedExperience.fromJson(json);
}

/// @nodoc
mixin _$SharedExperience {
  String get id => throw _privateConstructorUsedError;
  ExperienceType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  DateTime? get lastActivity => throw _privateConstructorUsedError;

  /// Serializes this SharedExperience to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SharedExperience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedExperienceCopyWith<SharedExperience> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedExperienceCopyWith<$Res> {
  factory $SharedExperienceCopyWith(
          SharedExperience value, $Res Function(SharedExperience) then) =
      _$SharedExperienceCopyWithImpl<$Res, SharedExperience>;
  @useResult
  $Res call(
      {String id,
      ExperienceType type,
      String title,
      String subtitle,
      String icon,
      int count,
      DateTime? lastActivity});
}

/// @nodoc
class _$SharedExperienceCopyWithImpl<$Res, $Val extends SharedExperience>
    implements $SharedExperienceCopyWith<$Res> {
  _$SharedExperienceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedExperience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? subtitle = null,
    Object? icon = null,
    Object? count = null,
    Object? lastActivity = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ExperienceType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      lastActivity: freezed == lastActivity
          ? _value.lastActivity
          : lastActivity // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedExperienceImplCopyWith<$Res>
    implements $SharedExperienceCopyWith<$Res> {
  factory _$$SharedExperienceImplCopyWith(_$SharedExperienceImpl value,
          $Res Function(_$SharedExperienceImpl) then) =
      __$$SharedExperienceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ExperienceType type,
      String title,
      String subtitle,
      String icon,
      int count,
      DateTime? lastActivity});
}

/// @nodoc
class __$$SharedExperienceImplCopyWithImpl<$Res>
    extends _$SharedExperienceCopyWithImpl<$Res, _$SharedExperienceImpl>
    implements _$$SharedExperienceImplCopyWith<$Res> {
  __$$SharedExperienceImplCopyWithImpl(_$SharedExperienceImpl _value,
      $Res Function(_$SharedExperienceImpl) _then)
      : super(_value, _then);

  /// Create a copy of SharedExperience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? subtitle = null,
    Object? icon = null,
    Object? count = null,
    Object? lastActivity = freezed,
  }) {
    return _then(_$SharedExperienceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ExperienceType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      lastActivity: freezed == lastActivity
          ? _value.lastActivity
          : lastActivity // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharedExperienceImpl implements _SharedExperience {
  const _$SharedExperienceImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.count,
      this.lastActivity});

  factory _$SharedExperienceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharedExperienceImplFromJson(json);

  @override
  final String id;
  @override
  final ExperienceType type;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String icon;
  @override
  final int count;
  @override
  final DateTime? lastActivity;

  @override
  String toString() {
    return 'SharedExperience(id: $id, type: $type, title: $title, subtitle: $subtitle, icon: $icon, count: $count, lastActivity: $lastActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedExperienceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.lastActivity, lastActivity) ||
                other.lastActivity == lastActivity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, title, subtitle, icon, count, lastActivity);

  /// Create a copy of SharedExperience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedExperienceImplCopyWith<_$SharedExperienceImpl> get copyWith =>
      __$$SharedExperienceImplCopyWithImpl<_$SharedExperienceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharedExperienceImplToJson(
      this,
    );
  }
}

abstract class _SharedExperience implements SharedExperience {
  const factory _SharedExperience(
      {required final String id,
      required final ExperienceType type,
      required final String title,
      required final String subtitle,
      required final String icon,
      required final int count,
      final DateTime? lastActivity}) = _$SharedExperienceImpl;

  factory _SharedExperience.fromJson(Map<String, dynamic> json) =
      _$SharedExperienceImpl.fromJson;

  @override
  String get id;
  @override
  ExperienceType get type;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  String get icon;
  @override
  int get count;
  @override
  DateTime? get lastActivity;

  /// Create a copy of SharedExperience
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedExperienceImplCopyWith<_$SharedExperienceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeCapsuleItem _$TimeCapsuleItemFromJson(Map<String, dynamic> json) {
  return _TimeCapsuleItem.fromJson(json);
}

/// @nodoc
mixin _$TimeCapsuleItem {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  String get preview => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get deliveryDate => throw _privateConstructorUsedError;
  CapsuleStatus get status => throw _privateConstructorUsedError;
  bool get isFromCurrentUser => throw _privateConstructorUsedError;

  /// Serializes this TimeCapsuleItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeCapsuleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeCapsuleItemCopyWith<TimeCapsuleItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeCapsuleItemCopyWith<$Res> {
  factory $TimeCapsuleItemCopyWith(
          TimeCapsuleItem value, $Res Function(TimeCapsuleItem) then) =
      _$TimeCapsuleItemCopyWithImpl<$Res, TimeCapsuleItem>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String recipientId,
      String preview,
      DateTime createdAt,
      DateTime deliveryDate,
      CapsuleStatus status,
      bool isFromCurrentUser});
}

/// @nodoc
class _$TimeCapsuleItemCopyWithImpl<$Res, $Val extends TimeCapsuleItem>
    implements $TimeCapsuleItemCopyWith<$Res> {
  _$TimeCapsuleItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeCapsuleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? recipientId = null,
    Object? preview = null,
    Object? createdAt = null,
    Object? deliveryDate = null,
    Object? status = null,
    Object? isFromCurrentUser = null,
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
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      preview: null == preview
          ? _value.preview
          : preview // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CapsuleStatus,
      isFromCurrentUser: null == isFromCurrentUser
          ? _value.isFromCurrentUser
          : isFromCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeCapsuleItemImplCopyWith<$Res>
    implements $TimeCapsuleItemCopyWith<$Res> {
  factory _$$TimeCapsuleItemImplCopyWith(_$TimeCapsuleItemImpl value,
          $Res Function(_$TimeCapsuleItemImpl) then) =
      __$$TimeCapsuleItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String recipientId,
      String preview,
      DateTime createdAt,
      DateTime deliveryDate,
      CapsuleStatus status,
      bool isFromCurrentUser});
}

/// @nodoc
class __$$TimeCapsuleItemImplCopyWithImpl<$Res>
    extends _$TimeCapsuleItemCopyWithImpl<$Res, _$TimeCapsuleItemImpl>
    implements _$$TimeCapsuleItemImplCopyWith<$Res> {
  __$$TimeCapsuleItemImplCopyWithImpl(
      _$TimeCapsuleItemImpl _value, $Res Function(_$TimeCapsuleItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeCapsuleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? recipientId = null,
    Object? preview = null,
    Object? createdAt = null,
    Object? deliveryDate = null,
    Object? status = null,
    Object? isFromCurrentUser = null,
  }) {
    return _then(_$TimeCapsuleItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      preview: null == preview
          ? _value.preview
          : preview // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryDate: null == deliveryDate
          ? _value.deliveryDate
          : deliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CapsuleStatus,
      isFromCurrentUser: null == isFromCurrentUser
          ? _value.isFromCurrentUser
          : isFromCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeCapsuleItemImpl implements _TimeCapsuleItem {
  const _$TimeCapsuleItemImpl(
      {required this.id,
      required this.senderId,
      required this.recipientId,
      required this.preview,
      required this.createdAt,
      required this.deliveryDate,
      required this.status,
      this.isFromCurrentUser = false});

  factory _$TimeCapsuleItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeCapsuleItemImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String recipientId;
  @override
  final String preview;
  @override
  final DateTime createdAt;
  @override
  final DateTime deliveryDate;
  @override
  final CapsuleStatus status;
  @override
  @JsonKey()
  final bool isFromCurrentUser;

  @override
  String toString() {
    return 'TimeCapsuleItem(id: $id, senderId: $senderId, recipientId: $recipientId, preview: $preview, createdAt: $createdAt, deliveryDate: $deliveryDate, status: $status, isFromCurrentUser: $isFromCurrentUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeCapsuleItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.preview, preview) || other.preview == preview) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isFromCurrentUser, isFromCurrentUser) ||
                other.isFromCurrentUser == isFromCurrentUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, senderId, recipientId,
      preview, createdAt, deliveryDate, status, isFromCurrentUser);

  /// Create a copy of TimeCapsuleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeCapsuleItemImplCopyWith<_$TimeCapsuleItemImpl> get copyWith =>
      __$$TimeCapsuleItemImplCopyWithImpl<_$TimeCapsuleItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeCapsuleItemImplToJson(
      this,
    );
  }
}

abstract class _TimeCapsuleItem implements TimeCapsuleItem {
  const factory _TimeCapsuleItem(
      {required final String id,
      required final String senderId,
      required final String recipientId,
      required final String preview,
      required final DateTime createdAt,
      required final DateTime deliveryDate,
      required final CapsuleStatus status,
      final bool isFromCurrentUser}) = _$TimeCapsuleItemImpl;

  factory _TimeCapsuleItem.fromJson(Map<String, dynamic> json) =
      _$TimeCapsuleItemImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get recipientId;
  @override
  String get preview;
  @override
  DateTime get createdAt;
  @override
  DateTime get deliveryDate;
  @override
  CapsuleStatus get status;
  @override
  bool get isFromCurrentUser;

  /// Create a copy of TimeCapsuleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeCapsuleItemImplCopyWith<_$TimeCapsuleItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReadingSession _$ReadingSessionFromJson(Map<String, dynamic> json) {
  return _ReadingSession.fromJson(json);
}

/// @nodoc
mixin _$ReadingSession {
  String get id => throw _privateConstructorUsedError;
  String get bookTitle => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get bookCover => throw _privateConstructorUsedError;
  int get currentChapter => throw _privateConstructorUsedError;
  int get totalChapters => throw _privateConstructorUsedError;
  double get progressPercentage => throw _privateConstructorUsedError;
  DateTime get lastReadAt => throw _privateConstructorUsedError;
  ReadingStatus get status => throw _privateConstructorUsedError;
  List<String>? get participantIds => throw _privateConstructorUsedError;

  /// Serializes this ReadingSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingSessionCopyWith<ReadingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingSessionCopyWith<$Res> {
  factory $ReadingSessionCopyWith(
          ReadingSession value, $Res Function(ReadingSession) then) =
      _$ReadingSessionCopyWithImpl<$Res, ReadingSession>;
  @useResult
  $Res call(
      {String id,
      String bookTitle,
      String author,
      String bookCover,
      int currentChapter,
      int totalChapters,
      double progressPercentage,
      DateTime lastReadAt,
      ReadingStatus status,
      List<String>? participantIds});
}

/// @nodoc
class _$ReadingSessionCopyWithImpl<$Res, $Val extends ReadingSession>
    implements $ReadingSessionCopyWith<$Res> {
  _$ReadingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookTitle = null,
    Object? author = null,
    Object? bookCover = null,
    Object? currentChapter = null,
    Object? totalChapters = null,
    Object? progressPercentage = null,
    Object? lastReadAt = null,
    Object? status = null,
    Object? participantIds = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: null == bookTitle
          ? _value.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      bookCover: null == bookCover
          ? _value.bookCover
          : bookCover // ignore: cast_nullable_to_non_nullable
              as String,
      currentChapter: null == currentChapter
          ? _value.currentChapter
          : currentChapter // ignore: cast_nullable_to_non_nullable
              as int,
      totalChapters: null == totalChapters
          ? _value.totalChapters
          : totalChapters // ignore: cast_nullable_to_non_nullable
              as int,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      lastReadAt: null == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReadingStatus,
      participantIds: freezed == participantIds
          ? _value.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReadingSessionImplCopyWith<$Res>
    implements $ReadingSessionCopyWith<$Res> {
  factory _$$ReadingSessionImplCopyWith(_$ReadingSessionImpl value,
          $Res Function(_$ReadingSessionImpl) then) =
      __$$ReadingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookTitle,
      String author,
      String bookCover,
      int currentChapter,
      int totalChapters,
      double progressPercentage,
      DateTime lastReadAt,
      ReadingStatus status,
      List<String>? participantIds});
}

/// @nodoc
class __$$ReadingSessionImplCopyWithImpl<$Res>
    extends _$ReadingSessionCopyWithImpl<$Res, _$ReadingSessionImpl>
    implements _$$ReadingSessionImplCopyWith<$Res> {
  __$$ReadingSessionImplCopyWithImpl(
      _$ReadingSessionImpl _value, $Res Function(_$ReadingSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookTitle = null,
    Object? author = null,
    Object? bookCover = null,
    Object? currentChapter = null,
    Object? totalChapters = null,
    Object? progressPercentage = null,
    Object? lastReadAt = null,
    Object? status = null,
    Object? participantIds = freezed,
  }) {
    return _then(_$ReadingSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: null == bookTitle
          ? _value.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      bookCover: null == bookCover
          ? _value.bookCover
          : bookCover // ignore: cast_nullable_to_non_nullable
              as String,
      currentChapter: null == currentChapter
          ? _value.currentChapter
          : currentChapter // ignore: cast_nullable_to_non_nullable
              as int,
      totalChapters: null == totalChapters
          ? _value.totalChapters
          : totalChapters // ignore: cast_nullable_to_non_nullable
              as int,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      lastReadAt: null == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReadingStatus,
      participantIds: freezed == participantIds
          ? _value._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingSessionImpl implements _ReadingSession {
  const _$ReadingSessionImpl(
      {required this.id,
      required this.bookTitle,
      required this.author,
      required this.bookCover,
      required this.currentChapter,
      required this.totalChapters,
      required this.progressPercentage,
      required this.lastReadAt,
      required this.status,
      final List<String>? participantIds})
      : _participantIds = participantIds;

  factory _$ReadingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String bookTitle;
  @override
  final String author;
  @override
  final String bookCover;
  @override
  final int currentChapter;
  @override
  final int totalChapters;
  @override
  final double progressPercentage;
  @override
  final DateTime lastReadAt;
  @override
  final ReadingStatus status;
  final List<String>? _participantIds;
  @override
  List<String>? get participantIds {
    final value = _participantIds;
    if (value == null) return null;
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ReadingSession(id: $id, bookTitle: $bookTitle, author: $author, bookCover: $bookCover, currentChapter: $currentChapter, totalChapters: $totalChapters, progressPercentage: $progressPercentage, lastReadAt: $lastReadAt, status: $status, participantIds: $participantIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.bookCover, bookCover) ||
                other.bookCover == bookCover) &&
            (identical(other.currentChapter, currentChapter) ||
                other.currentChapter == currentChapter) &&
            (identical(other.totalChapters, totalChapters) ||
                other.totalChapters == totalChapters) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.lastReadAt, lastReadAt) ||
                other.lastReadAt == lastReadAt) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookTitle,
      author,
      bookCover,
      currentChapter,
      totalChapters,
      progressPercentage,
      lastReadAt,
      status,
      const DeepCollectionEquality().hash(_participantIds));

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingSessionImplCopyWith<_$ReadingSessionImpl> get copyWith =>
      __$$ReadingSessionImplCopyWithImpl<_$ReadingSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingSessionImplToJson(
      this,
    );
  }
}

abstract class _ReadingSession implements ReadingSession {
  const factory _ReadingSession(
      {required final String id,
      required final String bookTitle,
      required final String author,
      required final String bookCover,
      required final int currentChapter,
      required final int totalChapters,
      required final double progressPercentage,
      required final DateTime lastReadAt,
      required final ReadingStatus status,
      final List<String>? participantIds}) = _$ReadingSessionImpl;

  factory _ReadingSession.fromJson(Map<String, dynamic> json) =
      _$ReadingSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get bookTitle;
  @override
  String get author;
  @override
  String get bookCover;
  @override
  int get currentChapter;
  @override
  int get totalChapters;
  @override
  double get progressPercentage;
  @override
  DateTime get lastReadAt;
  @override
  ReadingStatus get status;
  @override
  List<String>? get participantIds;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingSessionImplCopyWith<_$ReadingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ComfortStone _$ComfortStoneFromJson(Map<String, dynamic> json) {
  return _ComfortStone.fromJson(json);
}

/// @nodoc
mixin _$ComfortStone {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get totalTouches => throw _privateConstructorUsedError;
  DateTime? get lastTouchedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isSharedWithCurrentUser => throw _privateConstructorUsedError;

  /// Serializes this ComfortStone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComfortStone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComfortStoneCopyWith<ComfortStone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComfortStoneCopyWith<$Res> {
  factory $ComfortStoneCopyWith(
          ComfortStone value, $Res Function(ComfortStone) then) =
      _$ComfortStoneCopyWithImpl<$Res, ComfortStone>;
  @useResult
  $Res call(
      {String id,
      String name,
      String icon,
      String creatorId,
      DateTime createdAt,
      int totalTouches,
      DateTime? lastTouchedAt,
      bool isActive,
      bool isSharedWithCurrentUser});
}

/// @nodoc
class _$ComfortStoneCopyWithImpl<$Res, $Val extends ComfortStone>
    implements $ComfortStoneCopyWith<$Res> {
  _$ComfortStoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComfortStone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? creatorId = null,
    Object? createdAt = null,
    Object? totalTouches = null,
    Object? lastTouchedAt = freezed,
    Object? isActive = null,
    Object? isSharedWithCurrentUser = null,
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
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalTouches: null == totalTouches
          ? _value.totalTouches
          : totalTouches // ignore: cast_nullable_to_non_nullable
              as int,
      lastTouchedAt: freezed == lastTouchedAt
          ? _value.lastTouchedAt
          : lastTouchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSharedWithCurrentUser: null == isSharedWithCurrentUser
          ? _value.isSharedWithCurrentUser
          : isSharedWithCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ComfortStoneImplCopyWith<$Res>
    implements $ComfortStoneCopyWith<$Res> {
  factory _$$ComfortStoneImplCopyWith(
          _$ComfortStoneImpl value, $Res Function(_$ComfortStoneImpl) then) =
      __$$ComfortStoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String icon,
      String creatorId,
      DateTime createdAt,
      int totalTouches,
      DateTime? lastTouchedAt,
      bool isActive,
      bool isSharedWithCurrentUser});
}

/// @nodoc
class __$$ComfortStoneImplCopyWithImpl<$Res>
    extends _$ComfortStoneCopyWithImpl<$Res, _$ComfortStoneImpl>
    implements _$$ComfortStoneImplCopyWith<$Res> {
  __$$ComfortStoneImplCopyWithImpl(
      _$ComfortStoneImpl _value, $Res Function(_$ComfortStoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of ComfortStone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? creatorId = null,
    Object? createdAt = null,
    Object? totalTouches = null,
    Object? lastTouchedAt = freezed,
    Object? isActive = null,
    Object? isSharedWithCurrentUser = null,
  }) {
    return _then(_$ComfortStoneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalTouches: null == totalTouches
          ? _value.totalTouches
          : totalTouches // ignore: cast_nullable_to_non_nullable
              as int,
      lastTouchedAt: freezed == lastTouchedAt
          ? _value.lastTouchedAt
          : lastTouchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSharedWithCurrentUser: null == isSharedWithCurrentUser
          ? _value.isSharedWithCurrentUser
          : isSharedWithCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComfortStoneImpl implements _ComfortStone {
  const _$ComfortStoneImpl(
      {required this.id,
      required this.name,
      required this.icon,
      required this.creatorId,
      required this.createdAt,
      required this.totalTouches,
      this.lastTouchedAt,
      this.isActive = false,
      this.isSharedWithCurrentUser = false});

  factory _$ComfortStoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComfortStoneImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String icon;
  @override
  final String creatorId;
  @override
  final DateTime createdAt;
  @override
  final int totalTouches;
  @override
  final DateTime? lastTouchedAt;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isSharedWithCurrentUser;

  @override
  String toString() {
    return 'ComfortStone(id: $id, name: $name, icon: $icon, creatorId: $creatorId, createdAt: $createdAt, totalTouches: $totalTouches, lastTouchedAt: $lastTouchedAt, isActive: $isActive, isSharedWithCurrentUser: $isSharedWithCurrentUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComfortStoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.totalTouches, totalTouches) ||
                other.totalTouches == totalTouches) &&
            (identical(other.lastTouchedAt, lastTouchedAt) ||
                other.lastTouchedAt == lastTouchedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(
                    other.isSharedWithCurrentUser, isSharedWithCurrentUser) ||
                other.isSharedWithCurrentUser == isSharedWithCurrentUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      icon,
      creatorId,
      createdAt,
      totalTouches,
      lastTouchedAt,
      isActive,
      isSharedWithCurrentUser);

  /// Create a copy of ComfortStone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComfortStoneImplCopyWith<_$ComfortStoneImpl> get copyWith =>
      __$$ComfortStoneImplCopyWithImpl<_$ComfortStoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComfortStoneImplToJson(
      this,
    );
  }
}

abstract class _ComfortStone implements ComfortStone {
  const factory _ComfortStone(
      {required final String id,
      required final String name,
      required final String icon,
      required final String creatorId,
      required final DateTime createdAt,
      required final int totalTouches,
      final DateTime? lastTouchedAt,
      final bool isActive,
      final bool isSharedWithCurrentUser}) = _$ComfortStoneImpl;

  factory _ComfortStone.fromJson(Map<String, dynamic> json) =
      _$ComfortStoneImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get icon;
  @override
  String get creatorId;
  @override
  DateTime get createdAt;
  @override
  int get totalTouches;
  @override
  DateTime? get lastTouchedAt;
  @override
  bool get isActive;
  @override
  bool get isSharedWithCurrentUser;

  /// Create a copy of ComfortStone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComfortStoneImplCopyWith<_$ComfortStoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendshipStats _$FriendshipStatsFromJson(Map<String, dynamic> json) {
  return _FriendshipStats.fromJson(json);
}

/// @nodoc
mixin _$FriendshipStats {
  int get totalDays => throw _privateConstructorUsedError;
  int get meaningfulConversations => throw _privateConstructorUsedError;
  int get hoursReadingTogether => throw _privateConstructorUsedError;
  int get comfortTouchesShared => throw _privateConstructorUsedError;

  /// Serializes this FriendshipStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendshipStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendshipStatsCopyWith<FriendshipStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendshipStatsCopyWith<$Res> {
  factory $FriendshipStatsCopyWith(
          FriendshipStats value, $Res Function(FriendshipStats) then) =
      _$FriendshipStatsCopyWithImpl<$Res, FriendshipStats>;
  @useResult
  $Res call(
      {int totalDays,
      int meaningfulConversations,
      int hoursReadingTogether,
      int comfortTouchesShared});
}

/// @nodoc
class _$FriendshipStatsCopyWithImpl<$Res, $Val extends FriendshipStats>
    implements $FriendshipStatsCopyWith<$Res> {
  _$FriendshipStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendshipStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDays = null,
    Object? meaningfulConversations = null,
    Object? hoursReadingTogether = null,
    Object? comfortTouchesShared = null,
  }) {
    return _then(_value.copyWith(
      totalDays: null == totalDays
          ? _value.totalDays
          : totalDays // ignore: cast_nullable_to_non_nullable
              as int,
      meaningfulConversations: null == meaningfulConversations
          ? _value.meaningfulConversations
          : meaningfulConversations // ignore: cast_nullable_to_non_nullable
              as int,
      hoursReadingTogether: null == hoursReadingTogether
          ? _value.hoursReadingTogether
          : hoursReadingTogether // ignore: cast_nullable_to_non_nullable
              as int,
      comfortTouchesShared: null == comfortTouchesShared
          ? _value.comfortTouchesShared
          : comfortTouchesShared // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendshipStatsImplCopyWith<$Res>
    implements $FriendshipStatsCopyWith<$Res> {
  factory _$$FriendshipStatsImplCopyWith(_$FriendshipStatsImpl value,
          $Res Function(_$FriendshipStatsImpl) then) =
      __$$FriendshipStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalDays,
      int meaningfulConversations,
      int hoursReadingTogether,
      int comfortTouchesShared});
}

/// @nodoc
class __$$FriendshipStatsImplCopyWithImpl<$Res>
    extends _$FriendshipStatsCopyWithImpl<$Res, _$FriendshipStatsImpl>
    implements _$$FriendshipStatsImplCopyWith<$Res> {
  __$$FriendshipStatsImplCopyWithImpl(
      _$FriendshipStatsImpl _value, $Res Function(_$FriendshipStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendshipStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDays = null,
    Object? meaningfulConversations = null,
    Object? hoursReadingTogether = null,
    Object? comfortTouchesShared = null,
  }) {
    return _then(_$FriendshipStatsImpl(
      totalDays: null == totalDays
          ? _value.totalDays
          : totalDays // ignore: cast_nullable_to_non_nullable
              as int,
      meaningfulConversations: null == meaningfulConversations
          ? _value.meaningfulConversations
          : meaningfulConversations // ignore: cast_nullable_to_non_nullable
              as int,
      hoursReadingTogether: null == hoursReadingTogether
          ? _value.hoursReadingTogether
          : hoursReadingTogether // ignore: cast_nullable_to_non_nullable
              as int,
      comfortTouchesShared: null == comfortTouchesShared
          ? _value.comfortTouchesShared
          : comfortTouchesShared // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendshipStatsImpl implements _FriendshipStats {
  const _$FriendshipStatsImpl(
      {required this.totalDays,
      required this.meaningfulConversations,
      required this.hoursReadingTogether,
      required this.comfortTouchesShared});

  factory _$FriendshipStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendshipStatsImplFromJson(json);

  @override
  final int totalDays;
  @override
  final int meaningfulConversations;
  @override
  final int hoursReadingTogether;
  @override
  final int comfortTouchesShared;

  @override
  String toString() {
    return 'FriendshipStats(totalDays: $totalDays, meaningfulConversations: $meaningfulConversations, hoursReadingTogether: $hoursReadingTogether, comfortTouchesShared: $comfortTouchesShared)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendshipStatsImpl &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays) &&
            (identical(
                    other.meaningfulConversations, meaningfulConversations) ||
                other.meaningfulConversations == meaningfulConversations) &&
            (identical(other.hoursReadingTogether, hoursReadingTogether) ||
                other.hoursReadingTogether == hoursReadingTogether) &&
            (identical(other.comfortTouchesShared, comfortTouchesShared) ||
                other.comfortTouchesShared == comfortTouchesShared));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalDays,
      meaningfulConversations, hoursReadingTogether, comfortTouchesShared);

  /// Create a copy of FriendshipStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendshipStatsImplCopyWith<_$FriendshipStatsImpl> get copyWith =>
      __$$FriendshipStatsImplCopyWithImpl<_$FriendshipStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendshipStatsImplToJson(
      this,
    );
  }
}

abstract class _FriendshipStats implements FriendshipStats {
  const factory _FriendshipStats(
      {required final int totalDays,
      required final int meaningfulConversations,
      required final int hoursReadingTogether,
      required final int comfortTouchesShared}) = _$FriendshipStatsImpl;

  factory _FriendshipStats.fromJson(Map<String, dynamic> json) =
      _$FriendshipStatsImpl.fromJson;

  @override
  int get totalDays;
  @override
  int get meaningfulConversations;
  @override
  int get hoursReadingTogether;
  @override
  int get comfortTouchesShared;

  /// Create a copy of FriendshipStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendshipStatsImplCopyWith<_$FriendshipStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
