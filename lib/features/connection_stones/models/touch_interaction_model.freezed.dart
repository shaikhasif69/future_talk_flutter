// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'touch_interaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TouchInteraction _$TouchInteractionFromJson(Map<String, dynamic> json) {
  return _TouchInteraction.fromJson(json);
}

/// @nodoc
mixin _$TouchInteraction {
  /// Unique identifier for this interaction
  String get id => throw _privateConstructorUsedError;

  /// ID of the stone that was touched
  String get stoneId => throw _privateConstructorUsedError;

  /// Type of interaction
  TouchType get touchType => throw _privateConstructorUsedError;

  /// When the interaction occurred
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Duration of the touch (for long presses)
  Duration? get duration => throw _privateConstructorUsedError;

  /// Whether this was sent or received
  TouchDirection get direction => throw _privateConstructorUsedError;

  /// Friend involved in the interaction
  String get friendId => throw _privateConstructorUsedError;

  /// Optional message sent with the touch
  String? get message => throw _privateConstructorUsedError;

  /// Intensity of the touch (0.0 to 1.0)
  double get intensity => throw _privateConstructorUsedError;

  /// Whether this interaction included haptic feedback
  bool get hadHapticFeedback => throw _privateConstructorUsedError;

  /// Location on screen where touch occurred (for ripple effects)
  TouchLocation? get touchLocation => throw _privateConstructorUsedError;

  /// Serializes this TouchInteraction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TouchInteraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TouchInteractionCopyWith<TouchInteraction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TouchInteractionCopyWith<$Res> {
  factory $TouchInteractionCopyWith(
    TouchInteraction value,
    $Res Function(TouchInteraction) then,
  ) = _$TouchInteractionCopyWithImpl<$Res, TouchInteraction>;
  @useResult
  $Res call({
    String id,
    String stoneId,
    TouchType touchType,
    DateTime timestamp,
    Duration? duration,
    TouchDirection direction,
    String friendId,
    String? message,
    double intensity,
    bool hadHapticFeedback,
    TouchLocation? touchLocation,
  });

  $TouchLocationCopyWith<$Res>? get touchLocation;
}

/// @nodoc
class _$TouchInteractionCopyWithImpl<$Res, $Val extends TouchInteraction>
    implements $TouchInteractionCopyWith<$Res> {
  _$TouchInteractionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TouchInteraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stoneId = null,
    Object? touchType = null,
    Object? timestamp = null,
    Object? duration = freezed,
    Object? direction = null,
    Object? friendId = null,
    Object? message = freezed,
    Object? intensity = null,
    Object? hadHapticFeedback = null,
    Object? touchLocation = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            stoneId: null == stoneId
                ? _value.stoneId
                : stoneId // ignore: cast_nullable_to_non_nullable
                      as String,
            touchType: null == touchType
                ? _value.touchType
                : touchType // ignore: cast_nullable_to_non_nullable
                      as TouchType,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration?,
            direction: null == direction
                ? _value.direction
                : direction // ignore: cast_nullable_to_non_nullable
                      as TouchDirection,
            friendId: null == friendId
                ? _value.friendId
                : friendId // ignore: cast_nullable_to_non_nullable
                      as String,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            intensity: null == intensity
                ? _value.intensity
                : intensity // ignore: cast_nullable_to_non_nullable
                      as double,
            hadHapticFeedback: null == hadHapticFeedback
                ? _value.hadHapticFeedback
                : hadHapticFeedback // ignore: cast_nullable_to_non_nullable
                      as bool,
            touchLocation: freezed == touchLocation
                ? _value.touchLocation
                : touchLocation // ignore: cast_nullable_to_non_nullable
                      as TouchLocation?,
          )
          as $Val,
    );
  }

  /// Create a copy of TouchInteraction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TouchLocationCopyWith<$Res>? get touchLocation {
    if (_value.touchLocation == null) {
      return null;
    }

    return $TouchLocationCopyWith<$Res>(_value.touchLocation!, (value) {
      return _then(_value.copyWith(touchLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TouchInteractionImplCopyWith<$Res>
    implements $TouchInteractionCopyWith<$Res> {
  factory _$$TouchInteractionImplCopyWith(
    _$TouchInteractionImpl value,
    $Res Function(_$TouchInteractionImpl) then,
  ) = __$$TouchInteractionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String stoneId,
    TouchType touchType,
    DateTime timestamp,
    Duration? duration,
    TouchDirection direction,
    String friendId,
    String? message,
    double intensity,
    bool hadHapticFeedback,
    TouchLocation? touchLocation,
  });

  @override
  $TouchLocationCopyWith<$Res>? get touchLocation;
}

/// @nodoc
class __$$TouchInteractionImplCopyWithImpl<$Res>
    extends _$TouchInteractionCopyWithImpl<$Res, _$TouchInteractionImpl>
    implements _$$TouchInteractionImplCopyWith<$Res> {
  __$$TouchInteractionImplCopyWithImpl(
    _$TouchInteractionImpl _value,
    $Res Function(_$TouchInteractionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TouchInteraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stoneId = null,
    Object? touchType = null,
    Object? timestamp = null,
    Object? duration = freezed,
    Object? direction = null,
    Object? friendId = null,
    Object? message = freezed,
    Object? intensity = null,
    Object? hadHapticFeedback = null,
    Object? touchLocation = freezed,
  }) {
    return _then(
      _$TouchInteractionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        stoneId: null == stoneId
            ? _value.stoneId
            : stoneId // ignore: cast_nullable_to_non_nullable
                  as String,
        touchType: null == touchType
            ? _value.touchType
            : touchType // ignore: cast_nullable_to_non_nullable
                  as TouchType,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration?,
        direction: null == direction
            ? _value.direction
            : direction // ignore: cast_nullable_to_non_nullable
                  as TouchDirection,
        friendId: null == friendId
            ? _value.friendId
            : friendId // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        intensity: null == intensity
            ? _value.intensity
            : intensity // ignore: cast_nullable_to_non_nullable
                  as double,
        hadHapticFeedback: null == hadHapticFeedback
            ? _value.hadHapticFeedback
            : hadHapticFeedback // ignore: cast_nullable_to_non_nullable
                  as bool,
        touchLocation: freezed == touchLocation
            ? _value.touchLocation
            : touchLocation // ignore: cast_nullable_to_non_nullable
                  as TouchLocation?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TouchInteractionImpl implements _TouchInteraction {
  const _$TouchInteractionImpl({
    required this.id,
    required this.stoneId,
    required this.touchType,
    required this.timestamp,
    this.duration,
    required this.direction,
    required this.friendId,
    this.message,
    this.intensity = 1.0,
    this.hadHapticFeedback = true,
    this.touchLocation,
  });

  factory _$TouchInteractionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TouchInteractionImplFromJson(json);

  /// Unique identifier for this interaction
  @override
  final String id;

  /// ID of the stone that was touched
  @override
  final String stoneId;

  /// Type of interaction
  @override
  final TouchType touchType;

  /// When the interaction occurred
  @override
  final DateTime timestamp;

  /// Duration of the touch (for long presses)
  @override
  final Duration? duration;

  /// Whether this was sent or received
  @override
  final TouchDirection direction;

  /// Friend involved in the interaction
  @override
  final String friendId;

  /// Optional message sent with the touch
  @override
  final String? message;

  /// Intensity of the touch (0.0 to 1.0)
  @override
  @JsonKey()
  final double intensity;

  /// Whether this interaction included haptic feedback
  @override
  @JsonKey()
  final bool hadHapticFeedback;

  /// Location on screen where touch occurred (for ripple effects)
  @override
  final TouchLocation? touchLocation;

  @override
  String toString() {
    return 'TouchInteraction(id: $id, stoneId: $stoneId, touchType: $touchType, timestamp: $timestamp, duration: $duration, direction: $direction, friendId: $friendId, message: $message, intensity: $intensity, hadHapticFeedback: $hadHapticFeedback, touchLocation: $touchLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TouchInteractionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stoneId, stoneId) || other.stoneId == stoneId) &&
            (identical(other.touchType, touchType) ||
                other.touchType == touchType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity) &&
            (identical(other.hadHapticFeedback, hadHapticFeedback) ||
                other.hadHapticFeedback == hadHapticFeedback) &&
            (identical(other.touchLocation, touchLocation) ||
                other.touchLocation == touchLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    stoneId,
    touchType,
    timestamp,
    duration,
    direction,
    friendId,
    message,
    intensity,
    hadHapticFeedback,
    touchLocation,
  );

  /// Create a copy of TouchInteraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TouchInteractionImplCopyWith<_$TouchInteractionImpl> get copyWith =>
      __$$TouchInteractionImplCopyWithImpl<_$TouchInteractionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TouchInteractionImplToJson(this);
  }
}

abstract class _TouchInteraction implements TouchInteraction {
  const factory _TouchInteraction({
    required final String id,
    required final String stoneId,
    required final TouchType touchType,
    required final DateTime timestamp,
    final Duration? duration,
    required final TouchDirection direction,
    required final String friendId,
    final String? message,
    final double intensity,
    final bool hadHapticFeedback,
    final TouchLocation? touchLocation,
  }) = _$TouchInteractionImpl;

  factory _TouchInteraction.fromJson(Map<String, dynamic> json) =
      _$TouchInteractionImpl.fromJson;

  /// Unique identifier for this interaction
  @override
  String get id;

  /// ID of the stone that was touched
  @override
  String get stoneId;

  /// Type of interaction
  @override
  TouchType get touchType;

  /// When the interaction occurred
  @override
  DateTime get timestamp;

  /// Duration of the touch (for long presses)
  @override
  Duration? get duration;

  /// Whether this was sent or received
  @override
  TouchDirection get direction;

  /// Friend involved in the interaction
  @override
  String get friendId;

  /// Optional message sent with the touch
  @override
  String? get message;

  /// Intensity of the touch (0.0 to 1.0)
  @override
  double get intensity;

  /// Whether this interaction included haptic feedback
  @override
  bool get hadHapticFeedback;

  /// Location on screen where touch occurred (for ripple effects)
  @override
  TouchLocation? get touchLocation;

  /// Create a copy of TouchInteraction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TouchInteractionImplCopyWith<_$TouchInteractionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TouchLocation _$TouchLocationFromJson(Map<String, dynamic> json) {
  return _TouchLocation.fromJson(json);
}

/// @nodoc
mixin _$TouchLocation {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get size => throw _privateConstructorUsedError;

  /// Serializes this TouchLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TouchLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TouchLocationCopyWith<TouchLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TouchLocationCopyWith<$Res> {
  factory $TouchLocationCopyWith(
    TouchLocation value,
    $Res Function(TouchLocation) then,
  ) = _$TouchLocationCopyWithImpl<$Res, TouchLocation>;
  @useResult
  $Res call({double x, double y, double size});
}

/// @nodoc
class _$TouchLocationCopyWithImpl<$Res, $Val extends TouchLocation>
    implements $TouchLocationCopyWith<$Res> {
  _$TouchLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TouchLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null, Object? size = null}) {
    return _then(
      _value.copyWith(
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TouchLocationImplCopyWith<$Res>
    implements $TouchLocationCopyWith<$Res> {
  factory _$$TouchLocationImplCopyWith(
    _$TouchLocationImpl value,
    $Res Function(_$TouchLocationImpl) then,
  ) = __$$TouchLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y, double size});
}

/// @nodoc
class __$$TouchLocationImplCopyWithImpl<$Res>
    extends _$TouchLocationCopyWithImpl<$Res, _$TouchLocationImpl>
    implements _$$TouchLocationImplCopyWith<$Res> {
  __$$TouchLocationImplCopyWithImpl(
    _$TouchLocationImpl _value,
    $Res Function(_$TouchLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TouchLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? x = null, Object? y = null, Object? size = null}) {
    return _then(
      _$TouchLocationImpl(
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TouchLocationImpl implements _TouchLocation {
  const _$TouchLocationImpl({
    required this.x,
    required this.y,
    this.size = 50.0,
  });

  factory _$TouchLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TouchLocationImplFromJson(json);

  @override
  final double x;
  @override
  final double y;
  @override
  @JsonKey()
  final double size;

  @override
  String toString() {
    return 'TouchLocation(x: $x, y: $y, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TouchLocationImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, size);

  /// Create a copy of TouchLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TouchLocationImplCopyWith<_$TouchLocationImpl> get copyWith =>
      __$$TouchLocationImplCopyWithImpl<_$TouchLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TouchLocationImplToJson(this);
  }
}

abstract class _TouchLocation implements TouchLocation {
  const factory _TouchLocation({
    required final double x,
    required final double y,
    final double size,
  }) = _$TouchLocationImpl;

  factory _TouchLocation.fromJson(Map<String, dynamic> json) =
      _$TouchLocationImpl.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  double get size;

  /// Create a copy of TouchLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TouchLocationImplCopyWith<_$TouchLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ComfortStats _$ComfortStatsFromJson(Map<String, dynamic> json) {
  return _ComfortStats.fromJson(json);
}

/// @nodoc
mixin _$ComfortStats {
  /// Total comfort touches given
  int get touchesGiven => throw _privateConstructorUsedError;

  /// Total comfort received
  int get comfortReceived => throw _privateConstructorUsedError;

  /// Number of sacred stones (highly connected)
  int get sacredStones => throw _privateConstructorUsedError;

  /// Current streak of daily interactions
  int get dailyStreak => throw _privateConstructorUsedError;

  /// Total stones created
  int get totalStones => throw _privateConstructorUsedError;

  /// Favorite stone type
  String? get favoriteStoneType => throw _privateConstructorUsedError;

  /// Most connected friend
  String? get mostConnectedFriend => throw _privateConstructorUsedError;

  /// Weekly touch goal
  int get weeklyTouchGoal => throw _privateConstructorUsedError;

  /// Current week's touches
  int get weeklyTouches => throw _privateConstructorUsedError;

  /// Monthly comfort received goal
  int get monthlyComfortGoal => throw _privateConstructorUsedError;

  /// Current month's comfort received
  int get monthlyComfortReceived => throw _privateConstructorUsedError;

  /// Serializes this ComfortStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComfortStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComfortStatsCopyWith<ComfortStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComfortStatsCopyWith<$Res> {
  factory $ComfortStatsCopyWith(
    ComfortStats value,
    $Res Function(ComfortStats) then,
  ) = _$ComfortStatsCopyWithImpl<$Res, ComfortStats>;
  @useResult
  $Res call({
    int touchesGiven,
    int comfortReceived,
    int sacredStones,
    int dailyStreak,
    int totalStones,
    String? favoriteStoneType,
    String? mostConnectedFriend,
    int weeklyTouchGoal,
    int weeklyTouches,
    int monthlyComfortGoal,
    int monthlyComfortReceived,
  });
}

/// @nodoc
class _$ComfortStatsCopyWithImpl<$Res, $Val extends ComfortStats>
    implements $ComfortStatsCopyWith<$Res> {
  _$ComfortStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComfortStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? touchesGiven = null,
    Object? comfortReceived = null,
    Object? sacredStones = null,
    Object? dailyStreak = null,
    Object? totalStones = null,
    Object? favoriteStoneType = freezed,
    Object? mostConnectedFriend = freezed,
    Object? weeklyTouchGoal = null,
    Object? weeklyTouches = null,
    Object? monthlyComfortGoal = null,
    Object? monthlyComfortReceived = null,
  }) {
    return _then(
      _value.copyWith(
            touchesGiven: null == touchesGiven
                ? _value.touchesGiven
                : touchesGiven // ignore: cast_nullable_to_non_nullable
                      as int,
            comfortReceived: null == comfortReceived
                ? _value.comfortReceived
                : comfortReceived // ignore: cast_nullable_to_non_nullable
                      as int,
            sacredStones: null == sacredStones
                ? _value.sacredStones
                : sacredStones // ignore: cast_nullable_to_non_nullable
                      as int,
            dailyStreak: null == dailyStreak
                ? _value.dailyStreak
                : dailyStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalStones: null == totalStones
                ? _value.totalStones
                : totalStones // ignore: cast_nullable_to_non_nullable
                      as int,
            favoriteStoneType: freezed == favoriteStoneType
                ? _value.favoriteStoneType
                : favoriteStoneType // ignore: cast_nullable_to_non_nullable
                      as String?,
            mostConnectedFriend: freezed == mostConnectedFriend
                ? _value.mostConnectedFriend
                : mostConnectedFriend // ignore: cast_nullable_to_non_nullable
                      as String?,
            weeklyTouchGoal: null == weeklyTouchGoal
                ? _value.weeklyTouchGoal
                : weeklyTouchGoal // ignore: cast_nullable_to_non_nullable
                      as int,
            weeklyTouches: null == weeklyTouches
                ? _value.weeklyTouches
                : weeklyTouches // ignore: cast_nullable_to_non_nullable
                      as int,
            monthlyComfortGoal: null == monthlyComfortGoal
                ? _value.monthlyComfortGoal
                : monthlyComfortGoal // ignore: cast_nullable_to_non_nullable
                      as int,
            monthlyComfortReceived: null == monthlyComfortReceived
                ? _value.monthlyComfortReceived
                : monthlyComfortReceived // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComfortStatsImplCopyWith<$Res>
    implements $ComfortStatsCopyWith<$Res> {
  factory _$$ComfortStatsImplCopyWith(
    _$ComfortStatsImpl value,
    $Res Function(_$ComfortStatsImpl) then,
  ) = __$$ComfortStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int touchesGiven,
    int comfortReceived,
    int sacredStones,
    int dailyStreak,
    int totalStones,
    String? favoriteStoneType,
    String? mostConnectedFriend,
    int weeklyTouchGoal,
    int weeklyTouches,
    int monthlyComfortGoal,
    int monthlyComfortReceived,
  });
}

/// @nodoc
class __$$ComfortStatsImplCopyWithImpl<$Res>
    extends _$ComfortStatsCopyWithImpl<$Res, _$ComfortStatsImpl>
    implements _$$ComfortStatsImplCopyWith<$Res> {
  __$$ComfortStatsImplCopyWithImpl(
    _$ComfortStatsImpl _value,
    $Res Function(_$ComfortStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ComfortStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? touchesGiven = null,
    Object? comfortReceived = null,
    Object? sacredStones = null,
    Object? dailyStreak = null,
    Object? totalStones = null,
    Object? favoriteStoneType = freezed,
    Object? mostConnectedFriend = freezed,
    Object? weeklyTouchGoal = null,
    Object? weeklyTouches = null,
    Object? monthlyComfortGoal = null,
    Object? monthlyComfortReceived = null,
  }) {
    return _then(
      _$ComfortStatsImpl(
        touchesGiven: null == touchesGiven
            ? _value.touchesGiven
            : touchesGiven // ignore: cast_nullable_to_non_nullable
                  as int,
        comfortReceived: null == comfortReceived
            ? _value.comfortReceived
            : comfortReceived // ignore: cast_nullable_to_non_nullable
                  as int,
        sacredStones: null == sacredStones
            ? _value.sacredStones
            : sacredStones // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyStreak: null == dailyStreak
            ? _value.dailyStreak
            : dailyStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalStones: null == totalStones
            ? _value.totalStones
            : totalStones // ignore: cast_nullable_to_non_nullable
                  as int,
        favoriteStoneType: freezed == favoriteStoneType
            ? _value.favoriteStoneType
            : favoriteStoneType // ignore: cast_nullable_to_non_nullable
                  as String?,
        mostConnectedFriend: freezed == mostConnectedFriend
            ? _value.mostConnectedFriend
            : mostConnectedFriend // ignore: cast_nullable_to_non_nullable
                  as String?,
        weeklyTouchGoal: null == weeklyTouchGoal
            ? _value.weeklyTouchGoal
            : weeklyTouchGoal // ignore: cast_nullable_to_non_nullable
                  as int,
        weeklyTouches: null == weeklyTouches
            ? _value.weeklyTouches
            : weeklyTouches // ignore: cast_nullable_to_non_nullable
                  as int,
        monthlyComfortGoal: null == monthlyComfortGoal
            ? _value.monthlyComfortGoal
            : monthlyComfortGoal // ignore: cast_nullable_to_non_nullable
                  as int,
        monthlyComfortReceived: null == monthlyComfortReceived
            ? _value.monthlyComfortReceived
            : monthlyComfortReceived // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ComfortStatsImpl implements _ComfortStats {
  const _$ComfortStatsImpl({
    this.touchesGiven = 0,
    this.comfortReceived = 0,
    this.sacredStones = 0,
    this.dailyStreak = 0,
    this.totalStones = 0,
    this.favoriteStoneType,
    this.mostConnectedFriend,
    this.weeklyTouchGoal = 21,
    this.weeklyTouches = 0,
    this.monthlyComfortGoal = 30,
    this.monthlyComfortReceived = 0,
  });

  factory _$ComfortStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComfortStatsImplFromJson(json);

  /// Total comfort touches given
  @override
  @JsonKey()
  final int touchesGiven;

  /// Total comfort received
  @override
  @JsonKey()
  final int comfortReceived;

  /// Number of sacred stones (highly connected)
  @override
  @JsonKey()
  final int sacredStones;

  /// Current streak of daily interactions
  @override
  @JsonKey()
  final int dailyStreak;

  /// Total stones created
  @override
  @JsonKey()
  final int totalStones;

  /// Favorite stone type
  @override
  final String? favoriteStoneType;

  /// Most connected friend
  @override
  final String? mostConnectedFriend;

  /// Weekly touch goal
  @override
  @JsonKey()
  final int weeklyTouchGoal;

  /// Current week's touches
  @override
  @JsonKey()
  final int weeklyTouches;

  /// Monthly comfort received goal
  @override
  @JsonKey()
  final int monthlyComfortGoal;

  /// Current month's comfort received
  @override
  @JsonKey()
  final int monthlyComfortReceived;

  @override
  String toString() {
    return 'ComfortStats(touchesGiven: $touchesGiven, comfortReceived: $comfortReceived, sacredStones: $sacredStones, dailyStreak: $dailyStreak, totalStones: $totalStones, favoriteStoneType: $favoriteStoneType, mostConnectedFriend: $mostConnectedFriend, weeklyTouchGoal: $weeklyTouchGoal, weeklyTouches: $weeklyTouches, monthlyComfortGoal: $monthlyComfortGoal, monthlyComfortReceived: $monthlyComfortReceived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComfortStatsImpl &&
            (identical(other.touchesGiven, touchesGiven) ||
                other.touchesGiven == touchesGiven) &&
            (identical(other.comfortReceived, comfortReceived) ||
                other.comfortReceived == comfortReceived) &&
            (identical(other.sacredStones, sacredStones) ||
                other.sacredStones == sacredStones) &&
            (identical(other.dailyStreak, dailyStreak) ||
                other.dailyStreak == dailyStreak) &&
            (identical(other.totalStones, totalStones) ||
                other.totalStones == totalStones) &&
            (identical(other.favoriteStoneType, favoriteStoneType) ||
                other.favoriteStoneType == favoriteStoneType) &&
            (identical(other.mostConnectedFriend, mostConnectedFriend) ||
                other.mostConnectedFriend == mostConnectedFriend) &&
            (identical(other.weeklyTouchGoal, weeklyTouchGoal) ||
                other.weeklyTouchGoal == weeklyTouchGoal) &&
            (identical(other.weeklyTouches, weeklyTouches) ||
                other.weeklyTouches == weeklyTouches) &&
            (identical(other.monthlyComfortGoal, monthlyComfortGoal) ||
                other.monthlyComfortGoal == monthlyComfortGoal) &&
            (identical(other.monthlyComfortReceived, monthlyComfortReceived) ||
                other.monthlyComfortReceived == monthlyComfortReceived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    touchesGiven,
    comfortReceived,
    sacredStones,
    dailyStreak,
    totalStones,
    favoriteStoneType,
    mostConnectedFriend,
    weeklyTouchGoal,
    weeklyTouches,
    monthlyComfortGoal,
    monthlyComfortReceived,
  );

  /// Create a copy of ComfortStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComfortStatsImplCopyWith<_$ComfortStatsImpl> get copyWith =>
      __$$ComfortStatsImplCopyWithImpl<_$ComfortStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComfortStatsImplToJson(this);
  }
}

abstract class _ComfortStats implements ComfortStats {
  const factory _ComfortStats({
    final int touchesGiven,
    final int comfortReceived,
    final int sacredStones,
    final int dailyStreak,
    final int totalStones,
    final String? favoriteStoneType,
    final String? mostConnectedFriend,
    final int weeklyTouchGoal,
    final int weeklyTouches,
    final int monthlyComfortGoal,
    final int monthlyComfortReceived,
  }) = _$ComfortStatsImpl;

  factory _ComfortStats.fromJson(Map<String, dynamic> json) =
      _$ComfortStatsImpl.fromJson;

  /// Total comfort touches given
  @override
  int get touchesGiven;

  /// Total comfort received
  @override
  int get comfortReceived;

  /// Number of sacred stones (highly connected)
  @override
  int get sacredStones;

  /// Current streak of daily interactions
  @override
  int get dailyStreak;

  /// Total stones created
  @override
  int get totalStones;

  /// Favorite stone type
  @override
  String? get favoriteStoneType;

  /// Most connected friend
  @override
  String? get mostConnectedFriend;

  /// Weekly touch goal
  @override
  int get weeklyTouchGoal;

  /// Current week's touches
  @override
  int get weeklyTouches;

  /// Monthly comfort received goal
  @override
  int get monthlyComfortGoal;

  /// Current month's comfort received
  @override
  int get monthlyComfortReceived;

  /// Create a copy of ComfortStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComfortStatsImplCopyWith<_$ComfortStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
