// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_stone_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConnectionStone _$ConnectionStoneFromJson(Map<String, dynamic> json) {
  return _ConnectionStone.fromJson(json);
}

/// @nodoc
mixin _$ConnectionStone {
  /// Unique identifier for the stone
  String get id => throw _privateConstructorUsedError;

  /// The type of stone with its visual and emotional properties
  StoneType get stoneType => throw _privateConstructorUsedError;

  /// Name given to this specific stone
  String get name => throw _privateConstructorUsedError;

  /// Friend this stone is connected to
  String get friendName => throw _privateConstructorUsedError;

  /// Friend's user ID for real-time connections
  String get friendId => throw _privateConstructorUsedError;

  /// When this stone was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last time this stone was touched by the owner
  DateTime? get lastTouchedByOwner => throw _privateConstructorUsedError;

  /// Last time this stone received comfort from the friend
  DateTime? get lastReceivedComfort => throw _privateConstructorUsedError;

  /// Total times this stone has been touched by owner
  int get totalTouches => throw _privateConstructorUsedError;

  /// Total times comfort has been received through this stone
  int get totalComfortReceived => throw _privateConstructorUsedError;

  /// Whether this stone is currently receiving comfort
  bool get isReceivingComfort => throw _privateConstructorUsedError;

  /// Whether this stone is currently being touched (sending comfort)
  bool get isSendingComfort => throw _privateConstructorUsedError;

  /// Custom message or intention set for this stone
  String? get intention => throw _privateConstructorUsedError;

  /// Whether this stone is part of the quick touch bar
  bool get isQuickAccess => throw _privateConstructorUsedError;

  /// Connection strength (0.0 to 1.0) based on usage
  double get connectionStrength => throw _privateConstructorUsedError;

  /// Serializes this ConnectionStone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionStone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionStoneCopyWith<ConnectionStone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionStoneCopyWith<$Res> {
  factory $ConnectionStoneCopyWith(
          ConnectionStone value, $Res Function(ConnectionStone) then) =
      _$ConnectionStoneCopyWithImpl<$Res, ConnectionStone>;
  @useResult
  $Res call(
      {String id,
      StoneType stoneType,
      String name,
      String friendName,
      String friendId,
      DateTime createdAt,
      DateTime? lastTouchedByOwner,
      DateTime? lastReceivedComfort,
      int totalTouches,
      int totalComfortReceived,
      bool isReceivingComfort,
      bool isSendingComfort,
      String? intention,
      bool isQuickAccess,
      double connectionStrength});
}

/// @nodoc
class _$ConnectionStoneCopyWithImpl<$Res, $Val extends ConnectionStone>
    implements $ConnectionStoneCopyWith<$Res> {
  _$ConnectionStoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionStone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stoneType = null,
    Object? name = null,
    Object? friendName = null,
    Object? friendId = null,
    Object? createdAt = null,
    Object? lastTouchedByOwner = freezed,
    Object? lastReceivedComfort = freezed,
    Object? totalTouches = null,
    Object? totalComfortReceived = null,
    Object? isReceivingComfort = null,
    Object? isSendingComfort = null,
    Object? intention = freezed,
    Object? isQuickAccess = null,
    Object? connectionStrength = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stoneType: null == stoneType
          ? _value.stoneType
          : stoneType // ignore: cast_nullable_to_non_nullable
              as StoneType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      friendName: null == friendName
          ? _value.friendName
          : friendName // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: null == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastTouchedByOwner: freezed == lastTouchedByOwner
          ? _value.lastTouchedByOwner
          : lastTouchedByOwner // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReceivedComfort: freezed == lastReceivedComfort
          ? _value.lastReceivedComfort
          : lastReceivedComfort // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalTouches: null == totalTouches
          ? _value.totalTouches
          : totalTouches // ignore: cast_nullable_to_non_nullable
              as int,
      totalComfortReceived: null == totalComfortReceived
          ? _value.totalComfortReceived
          : totalComfortReceived // ignore: cast_nullable_to_non_nullable
              as int,
      isReceivingComfort: null == isReceivingComfort
          ? _value.isReceivingComfort
          : isReceivingComfort // ignore: cast_nullable_to_non_nullable
              as bool,
      isSendingComfort: null == isSendingComfort
          ? _value.isSendingComfort
          : isSendingComfort // ignore: cast_nullable_to_non_nullable
              as bool,
      intention: freezed == intention
          ? _value.intention
          : intention // ignore: cast_nullable_to_non_nullable
              as String?,
      isQuickAccess: null == isQuickAccess
          ? _value.isQuickAccess
          : isQuickAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionStrength: null == connectionStrength
          ? _value.connectionStrength
          : connectionStrength // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectionStoneImplCopyWith<$Res>
    implements $ConnectionStoneCopyWith<$Res> {
  factory _$$ConnectionStoneImplCopyWith(_$ConnectionStoneImpl value,
          $Res Function(_$ConnectionStoneImpl) then) =
      __$$ConnectionStoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      StoneType stoneType,
      String name,
      String friendName,
      String friendId,
      DateTime createdAt,
      DateTime? lastTouchedByOwner,
      DateTime? lastReceivedComfort,
      int totalTouches,
      int totalComfortReceived,
      bool isReceivingComfort,
      bool isSendingComfort,
      String? intention,
      bool isQuickAccess,
      double connectionStrength});
}

/// @nodoc
class __$$ConnectionStoneImplCopyWithImpl<$Res>
    extends _$ConnectionStoneCopyWithImpl<$Res, _$ConnectionStoneImpl>
    implements _$$ConnectionStoneImplCopyWith<$Res> {
  __$$ConnectionStoneImplCopyWithImpl(
      _$ConnectionStoneImpl _value, $Res Function(_$ConnectionStoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConnectionStone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stoneType = null,
    Object? name = null,
    Object? friendName = null,
    Object? friendId = null,
    Object? createdAt = null,
    Object? lastTouchedByOwner = freezed,
    Object? lastReceivedComfort = freezed,
    Object? totalTouches = null,
    Object? totalComfortReceived = null,
    Object? isReceivingComfort = null,
    Object? isSendingComfort = null,
    Object? intention = freezed,
    Object? isQuickAccess = null,
    Object? connectionStrength = null,
  }) {
    return _then(_$ConnectionStoneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      stoneType: null == stoneType
          ? _value.stoneType
          : stoneType // ignore: cast_nullable_to_non_nullable
              as StoneType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      friendName: null == friendName
          ? _value.friendName
          : friendName // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: null == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastTouchedByOwner: freezed == lastTouchedByOwner
          ? _value.lastTouchedByOwner
          : lastTouchedByOwner // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReceivedComfort: freezed == lastReceivedComfort
          ? _value.lastReceivedComfort
          : lastReceivedComfort // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalTouches: null == totalTouches
          ? _value.totalTouches
          : totalTouches // ignore: cast_nullable_to_non_nullable
              as int,
      totalComfortReceived: null == totalComfortReceived
          ? _value.totalComfortReceived
          : totalComfortReceived // ignore: cast_nullable_to_non_nullable
              as int,
      isReceivingComfort: null == isReceivingComfort
          ? _value.isReceivingComfort
          : isReceivingComfort // ignore: cast_nullable_to_non_nullable
              as bool,
      isSendingComfort: null == isSendingComfort
          ? _value.isSendingComfort
          : isSendingComfort // ignore: cast_nullable_to_non_nullable
              as bool,
      intention: freezed == intention
          ? _value.intention
          : intention // ignore: cast_nullable_to_non_nullable
              as String?,
      isQuickAccess: null == isQuickAccess
          ? _value.isQuickAccess
          : isQuickAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionStrength: null == connectionStrength
          ? _value.connectionStrength
          : connectionStrength // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionStoneImpl implements _ConnectionStone {
  const _$ConnectionStoneImpl(
      {required this.id,
      required this.stoneType,
      required this.name,
      required this.friendName,
      required this.friendId,
      required this.createdAt,
      this.lastTouchedByOwner,
      this.lastReceivedComfort,
      this.totalTouches = 0,
      this.totalComfortReceived = 0,
      this.isReceivingComfort = false,
      this.isSendingComfort = false,
      this.intention,
      this.isQuickAccess = false,
      this.connectionStrength = 0.5});

  factory _$ConnectionStoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionStoneImplFromJson(json);

  /// Unique identifier for the stone
  @override
  final String id;

  /// The type of stone with its visual and emotional properties
  @override
  final StoneType stoneType;

  /// Name given to this specific stone
  @override
  final String name;

  /// Friend this stone is connected to
  @override
  final String friendName;

  /// Friend's user ID for real-time connections
  @override
  final String friendId;

  /// When this stone was created
  @override
  final DateTime createdAt;

  /// Last time this stone was touched by the owner
  @override
  final DateTime? lastTouchedByOwner;

  /// Last time this stone received comfort from the friend
  @override
  final DateTime? lastReceivedComfort;

  /// Total times this stone has been touched by owner
  @override
  @JsonKey()
  final int totalTouches;

  /// Total times comfort has been received through this stone
  @override
  @JsonKey()
  final int totalComfortReceived;

  /// Whether this stone is currently receiving comfort
  @override
  @JsonKey()
  final bool isReceivingComfort;

  /// Whether this stone is currently being touched (sending comfort)
  @override
  @JsonKey()
  final bool isSendingComfort;

  /// Custom message or intention set for this stone
  @override
  final String? intention;

  /// Whether this stone is part of the quick touch bar
  @override
  @JsonKey()
  final bool isQuickAccess;

  /// Connection strength (0.0 to 1.0) based on usage
  @override
  @JsonKey()
  final double connectionStrength;

  @override
  String toString() {
    return 'ConnectionStone(id: $id, stoneType: $stoneType, name: $name, friendName: $friendName, friendId: $friendId, createdAt: $createdAt, lastTouchedByOwner: $lastTouchedByOwner, lastReceivedComfort: $lastReceivedComfort, totalTouches: $totalTouches, totalComfortReceived: $totalComfortReceived, isReceivingComfort: $isReceivingComfort, isSendingComfort: $isSendingComfort, intention: $intention, isQuickAccess: $isQuickAccess, connectionStrength: $connectionStrength)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionStoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stoneType, stoneType) ||
                other.stoneType == stoneType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.friendName, friendName) ||
                other.friendName == friendName) &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastTouchedByOwner, lastTouchedByOwner) ||
                other.lastTouchedByOwner == lastTouchedByOwner) &&
            (identical(other.lastReceivedComfort, lastReceivedComfort) ||
                other.lastReceivedComfort == lastReceivedComfort) &&
            (identical(other.totalTouches, totalTouches) ||
                other.totalTouches == totalTouches) &&
            (identical(other.totalComfortReceived, totalComfortReceived) ||
                other.totalComfortReceived == totalComfortReceived) &&
            (identical(other.isReceivingComfort, isReceivingComfort) ||
                other.isReceivingComfort == isReceivingComfort) &&
            (identical(other.isSendingComfort, isSendingComfort) ||
                other.isSendingComfort == isSendingComfort) &&
            (identical(other.intention, intention) ||
                other.intention == intention) &&
            (identical(other.isQuickAccess, isQuickAccess) ||
                other.isQuickAccess == isQuickAccess) &&
            (identical(other.connectionStrength, connectionStrength) ||
                other.connectionStrength == connectionStrength));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      stoneType,
      name,
      friendName,
      friendId,
      createdAt,
      lastTouchedByOwner,
      lastReceivedComfort,
      totalTouches,
      totalComfortReceived,
      isReceivingComfort,
      isSendingComfort,
      intention,
      isQuickAccess,
      connectionStrength);

  /// Create a copy of ConnectionStone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionStoneImplCopyWith<_$ConnectionStoneImpl> get copyWith =>
      __$$ConnectionStoneImplCopyWithImpl<_$ConnectionStoneImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionStoneImplToJson(
      this,
    );
  }
}

abstract class _ConnectionStone implements ConnectionStone {
  const factory _ConnectionStone(
      {required final String id,
      required final StoneType stoneType,
      required final String name,
      required final String friendName,
      required final String friendId,
      required final DateTime createdAt,
      final DateTime? lastTouchedByOwner,
      final DateTime? lastReceivedComfort,
      final int totalTouches,
      final int totalComfortReceived,
      final bool isReceivingComfort,
      final bool isSendingComfort,
      final String? intention,
      final bool isQuickAccess,
      final double connectionStrength}) = _$ConnectionStoneImpl;

  factory _ConnectionStone.fromJson(Map<String, dynamic> json) =
      _$ConnectionStoneImpl.fromJson;

  /// Unique identifier for the stone
  @override
  String get id;

  /// The type of stone with its visual and emotional properties
  @override
  StoneType get stoneType;

  /// Name given to this specific stone
  @override
  String get name;

  /// Friend this stone is connected to
  @override
  String get friendName;

  /// Friend's user ID for real-time connections
  @override
  String get friendId;

  /// When this stone was created
  @override
  DateTime get createdAt;

  /// Last time this stone was touched by the owner
  @override
  DateTime? get lastTouchedByOwner;

  /// Last time this stone received comfort from the friend
  @override
  DateTime? get lastReceivedComfort;

  /// Total times this stone has been touched by owner
  @override
  int get totalTouches;

  /// Total times comfort has been received through this stone
  @override
  int get totalComfortReceived;

  /// Whether this stone is currently receiving comfort
  @override
  bool get isReceivingComfort;

  /// Whether this stone is currently being touched (sending comfort)
  @override
  bool get isSendingComfort;

  /// Custom message or intention set for this stone
  @override
  String? get intention;

  /// Whether this stone is part of the quick touch bar
  @override
  bool get isQuickAccess;

  /// Connection strength (0.0 to 1.0) based on usage
  @override
  double get connectionStrength;

  /// Create a copy of ConnectionStone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionStoneImplCopyWith<_$ConnectionStoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
