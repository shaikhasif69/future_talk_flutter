// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_capsule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimeCapsule _$TimeCapsuleFromJson(Map<String, dynamic> json) {
  return _TimeCapsule.fromJson(json);
}

/// @nodoc
mixin _$TimeCapsule {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  String get recipientName => throw _privateConstructorUsedError;
  String get recipientInitial => throw _privateConstructorUsedError;
  DateTime get plantedAt => throw _privateConstructorUsedError;
  DateTime get deliveryAt => throw _privateConstructorUsedError;
  CapsuleGrowthStage get growthStage => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  CapsuleType get type => throw _privateConstructorUsedError;
  bool get isReady => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String? get theme => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this TimeCapsule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeCapsule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeCapsuleCopyWith<TimeCapsule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeCapsuleCopyWith<$Res> {
  factory $TimeCapsuleCopyWith(
    TimeCapsule value,
    $Res Function(TimeCapsule) then,
  ) = _$TimeCapsuleCopyWithImpl<$Res, TimeCapsule>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String recipientId,
    String recipientName,
    String recipientInitial,
    DateTime plantedAt,
    DateTime deliveryAt,
    CapsuleGrowthStage growthStage,
    String emoji,
    CapsuleType type,
    bool isReady,
    double progress,
    String? theme,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$TimeCapsuleCopyWithImpl<$Res, $Val extends TimeCapsule>
    implements $TimeCapsuleCopyWith<$Res> {
  _$TimeCapsuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeCapsule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? recipientId = null,
    Object? recipientName = null,
    Object? recipientInitial = null,
    Object? plantedAt = null,
    Object? deliveryAt = null,
    Object? growthStage = null,
    Object? emoji = null,
    Object? type = null,
    Object? isReady = null,
    Object? progress = null,
    Object? theme = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientId: null == recipientId
                ? _value.recipientId
                : recipientId // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientName: null == recipientName
                ? _value.recipientName
                : recipientName // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientInitial: null == recipientInitial
                ? _value.recipientInitial
                : recipientInitial // ignore: cast_nullable_to_non_nullable
                      as String,
            plantedAt: null == plantedAt
                ? _value.plantedAt
                : plantedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deliveryAt: null == deliveryAt
                ? _value.deliveryAt
                : deliveryAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            growthStage: null == growthStage
                ? _value.growthStage
                : growthStage // ignore: cast_nullable_to_non_nullable
                      as CapsuleGrowthStage,
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as CapsuleType,
            isReady: null == isReady
                ? _value.isReady
                : isReady // ignore: cast_nullable_to_non_nullable
                      as bool,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            theme: freezed == theme
                ? _value.theme
                : theme // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeCapsuleImplCopyWith<$Res>
    implements $TimeCapsuleCopyWith<$Res> {
  factory _$$TimeCapsuleImplCopyWith(
    _$TimeCapsuleImpl value,
    $Res Function(_$TimeCapsuleImpl) then,
  ) = __$$TimeCapsuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String recipientId,
    String recipientName,
    String recipientInitial,
    DateTime plantedAt,
    DateTime deliveryAt,
    CapsuleGrowthStage growthStage,
    String emoji,
    CapsuleType type,
    bool isReady,
    double progress,
    String? theme,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$TimeCapsuleImplCopyWithImpl<$Res>
    extends _$TimeCapsuleCopyWithImpl<$Res, _$TimeCapsuleImpl>
    implements _$$TimeCapsuleImplCopyWith<$Res> {
  __$$TimeCapsuleImplCopyWithImpl(
    _$TimeCapsuleImpl _value,
    $Res Function(_$TimeCapsuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeCapsule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? recipientId = null,
    Object? recipientName = null,
    Object? recipientInitial = null,
    Object? plantedAt = null,
    Object? deliveryAt = null,
    Object? growthStage = null,
    Object? emoji = null,
    Object? type = null,
    Object? isReady = null,
    Object? progress = null,
    Object? theme = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$TimeCapsuleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientId: null == recipientId
            ? _value.recipientId
            : recipientId // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientName: null == recipientName
            ? _value.recipientName
            : recipientName // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientInitial: null == recipientInitial
            ? _value.recipientInitial
            : recipientInitial // ignore: cast_nullable_to_non_nullable
                  as String,
        plantedAt: null == plantedAt
            ? _value.plantedAt
            : plantedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deliveryAt: null == deliveryAt
            ? _value.deliveryAt
            : deliveryAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        growthStage: null == growthStage
            ? _value.growthStage
            : growthStage // ignore: cast_nullable_to_non_nullable
                  as CapsuleGrowthStage,
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as CapsuleType,
        isReady: null == isReady
            ? _value.isReady
            : isReady // ignore: cast_nullable_to_non_nullable
                  as bool,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        theme: freezed == theme
            ? _value.theme
            : theme // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeCapsuleImpl implements _TimeCapsule {
  const _$TimeCapsuleImpl({
    required this.id,
    required this.title,
    required this.content,
    required this.recipientId,
    required this.recipientName,
    required this.recipientInitial,
    required this.plantedAt,
    required this.deliveryAt,
    required this.growthStage,
    required this.emoji,
    required this.type,
    this.isReady = false,
    this.progress = 0.0,
    this.theme,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$TimeCapsuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeCapsuleImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final String recipientId;
  @override
  final String recipientName;
  @override
  final String recipientInitial;
  @override
  final DateTime plantedAt;
  @override
  final DateTime deliveryAt;
  @override
  final CapsuleGrowthStage growthStage;
  @override
  final String emoji;
  @override
  final CapsuleType type;
  @override
  @JsonKey()
  final bool isReady;
  @override
  @JsonKey()
  final double progress;
  @override
  final String? theme;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TimeCapsule(id: $id, title: $title, content: $content, recipientId: $recipientId, recipientName: $recipientName, recipientInitial: $recipientInitial, plantedAt: $plantedAt, deliveryAt: $deliveryAt, growthStage: $growthStage, emoji: $emoji, type: $type, isReady: $isReady, progress: $progress, theme: $theme, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeCapsuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.recipientInitial, recipientInitial) ||
                other.recipientInitial == recipientInitial) &&
            (identical(other.plantedAt, plantedAt) ||
                other.plantedAt == plantedAt) &&
            (identical(other.deliveryAt, deliveryAt) ||
                other.deliveryAt == deliveryAt) &&
            (identical(other.growthStage, growthStage) ||
                other.growthStage == growthStage) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isReady, isReady) || other.isReady == isReady) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    content,
    recipientId,
    recipientName,
    recipientInitial,
    plantedAt,
    deliveryAt,
    growthStage,
    emoji,
    type,
    isReady,
    progress,
    theme,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of TimeCapsule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeCapsuleImplCopyWith<_$TimeCapsuleImpl> get copyWith =>
      __$$TimeCapsuleImplCopyWithImpl<_$TimeCapsuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeCapsuleImplToJson(this);
  }
}

abstract class _TimeCapsule implements TimeCapsule {
  const factory _TimeCapsule({
    required final String id,
    required final String title,
    required final String content,
    required final String recipientId,
    required final String recipientName,
    required final String recipientInitial,
    required final DateTime plantedAt,
    required final DateTime deliveryAt,
    required final CapsuleGrowthStage growthStage,
    required final String emoji,
    required final CapsuleType type,
    final bool isReady,
    final double progress,
    final String? theme,
    final Map<String, dynamic>? metadata,
  }) = _$TimeCapsuleImpl;

  factory _TimeCapsule.fromJson(Map<String, dynamic> json) =
      _$TimeCapsuleImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  String get recipientId;
  @override
  String get recipientName;
  @override
  String get recipientInitial;
  @override
  DateTime get plantedAt;
  @override
  DateTime get deliveryAt;
  @override
  CapsuleGrowthStage get growthStage;
  @override
  String get emoji;
  @override
  CapsuleType get type;
  @override
  bool get isReady;
  @override
  double get progress;
  @override
  String? get theme;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of TimeCapsule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeCapsuleImplCopyWith<_$TimeCapsuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GardenStats _$GardenStatsFromJson(Map<String, dynamic> json) {
  return _GardenStats.fromJson(json);
}

/// @nodoc
mixin _$GardenStats {
  int get totalPlanted => throw _privateConstructorUsedError;
  int get growing => throw _privateConstructorUsedError;
  int get ready => throw _privateConstructorUsedError;
  int get delivered => throw _privateConstructorUsedError;
  int get recentlyPlanted => throw _privateConstructorUsedError;
  double get averageGrowthProgress => throw _privateConstructorUsedError;

  /// Serializes this GardenStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GardenStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GardenStatsCopyWith<GardenStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenStatsCopyWith<$Res> {
  factory $GardenStatsCopyWith(
    GardenStats value,
    $Res Function(GardenStats) then,
  ) = _$GardenStatsCopyWithImpl<$Res, GardenStats>;
  @useResult
  $Res call({
    int totalPlanted,
    int growing,
    int ready,
    int delivered,
    int recentlyPlanted,
    double averageGrowthProgress,
  });
}

/// @nodoc
class _$GardenStatsCopyWithImpl<$Res, $Val extends GardenStats>
    implements $GardenStatsCopyWith<$Res> {
  _$GardenStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GardenStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlanted = null,
    Object? growing = null,
    Object? ready = null,
    Object? delivered = null,
    Object? recentlyPlanted = null,
    Object? averageGrowthProgress = null,
  }) {
    return _then(
      _value.copyWith(
            totalPlanted: null == totalPlanted
                ? _value.totalPlanted
                : totalPlanted // ignore: cast_nullable_to_non_nullable
                      as int,
            growing: null == growing
                ? _value.growing
                : growing // ignore: cast_nullable_to_non_nullable
                      as int,
            ready: null == ready
                ? _value.ready
                : ready // ignore: cast_nullable_to_non_nullable
                      as int,
            delivered: null == delivered
                ? _value.delivered
                : delivered // ignore: cast_nullable_to_non_nullable
                      as int,
            recentlyPlanted: null == recentlyPlanted
                ? _value.recentlyPlanted
                : recentlyPlanted // ignore: cast_nullable_to_non_nullable
                      as int,
            averageGrowthProgress: null == averageGrowthProgress
                ? _value.averageGrowthProgress
                : averageGrowthProgress // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GardenStatsImplCopyWith<$Res>
    implements $GardenStatsCopyWith<$Res> {
  factory _$$GardenStatsImplCopyWith(
    _$GardenStatsImpl value,
    $Res Function(_$GardenStatsImpl) then,
  ) = __$$GardenStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalPlanted,
    int growing,
    int ready,
    int delivered,
    int recentlyPlanted,
    double averageGrowthProgress,
  });
}

/// @nodoc
class __$$GardenStatsImplCopyWithImpl<$Res>
    extends _$GardenStatsCopyWithImpl<$Res, _$GardenStatsImpl>
    implements _$$GardenStatsImplCopyWith<$Res> {
  __$$GardenStatsImplCopyWithImpl(
    _$GardenStatsImpl _value,
    $Res Function(_$GardenStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GardenStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlanted = null,
    Object? growing = null,
    Object? ready = null,
    Object? delivered = null,
    Object? recentlyPlanted = null,
    Object? averageGrowthProgress = null,
  }) {
    return _then(
      _$GardenStatsImpl(
        totalPlanted: null == totalPlanted
            ? _value.totalPlanted
            : totalPlanted // ignore: cast_nullable_to_non_nullable
                  as int,
        growing: null == growing
            ? _value.growing
            : growing // ignore: cast_nullable_to_non_nullable
                  as int,
        ready: null == ready
            ? _value.ready
            : ready // ignore: cast_nullable_to_non_nullable
                  as int,
        delivered: null == delivered
            ? _value.delivered
            : delivered // ignore: cast_nullable_to_non_nullable
                  as int,
        recentlyPlanted: null == recentlyPlanted
            ? _value.recentlyPlanted
            : recentlyPlanted // ignore: cast_nullable_to_non_nullable
                  as int,
        averageGrowthProgress: null == averageGrowthProgress
            ? _value.averageGrowthProgress
            : averageGrowthProgress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GardenStatsImpl implements _GardenStats {
  const _$GardenStatsImpl({
    this.totalPlanted = 0,
    this.growing = 0,
    this.ready = 0,
    this.delivered = 0,
    this.recentlyPlanted = 0,
    this.averageGrowthProgress = 0.0,
  });

  factory _$GardenStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GardenStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalPlanted;
  @override
  @JsonKey()
  final int growing;
  @override
  @JsonKey()
  final int ready;
  @override
  @JsonKey()
  final int delivered;
  @override
  @JsonKey()
  final int recentlyPlanted;
  @override
  @JsonKey()
  final double averageGrowthProgress;

  @override
  String toString() {
    return 'GardenStats(totalPlanted: $totalPlanted, growing: $growing, ready: $ready, delivered: $delivered, recentlyPlanted: $recentlyPlanted, averageGrowthProgress: $averageGrowthProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenStatsImpl &&
            (identical(other.totalPlanted, totalPlanted) ||
                other.totalPlanted == totalPlanted) &&
            (identical(other.growing, growing) || other.growing == growing) &&
            (identical(other.ready, ready) || other.ready == ready) &&
            (identical(other.delivered, delivered) ||
                other.delivered == delivered) &&
            (identical(other.recentlyPlanted, recentlyPlanted) ||
                other.recentlyPlanted == recentlyPlanted) &&
            (identical(other.averageGrowthProgress, averageGrowthProgress) ||
                other.averageGrowthProgress == averageGrowthProgress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalPlanted,
    growing,
    ready,
    delivered,
    recentlyPlanted,
    averageGrowthProgress,
  );

  /// Create a copy of GardenStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenStatsImplCopyWith<_$GardenStatsImpl> get copyWith =>
      __$$GardenStatsImplCopyWithImpl<_$GardenStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GardenStatsImplToJson(this);
  }
}

abstract class _GardenStats implements GardenStats {
  const factory _GardenStats({
    final int totalPlanted,
    final int growing,
    final int ready,
    final int delivered,
    final int recentlyPlanted,
    final double averageGrowthProgress,
  }) = _$GardenStatsImpl;

  factory _GardenStats.fromJson(Map<String, dynamic> json) =
      _$GardenStatsImpl.fromJson;

  @override
  int get totalPlanted;
  @override
  int get growing;
  @override
  int get ready;
  @override
  int get delivered;
  @override
  int get recentlyPlanted;
  @override
  double get averageGrowthProgress;

  /// Create a copy of GardenStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GardenStatsImplCopyWith<_$GardenStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GardenSection _$GardenSectionFromJson(Map<String, dynamic> json) {
  return _GardenSection.fromJson(json);
}

/// @nodoc
mixin _$GardenSection {
  String get title => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  List<TimeCapsule> get capsules => throw _privateConstructorUsedError;
  GardenSectionType get type => throw _privateConstructorUsedError;

  /// Serializes this GardenSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GardenSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GardenSectionCopyWith<GardenSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenSectionCopyWith<$Res> {
  factory $GardenSectionCopyWith(
    GardenSection value,
    $Res Function(GardenSection) then,
  ) = _$GardenSectionCopyWithImpl<$Res, GardenSection>;
  @useResult
  $Res call({
    String title,
    String emoji,
    List<TimeCapsule> capsules,
    GardenSectionType type,
  });
}

/// @nodoc
class _$GardenSectionCopyWithImpl<$Res, $Val extends GardenSection>
    implements $GardenSectionCopyWith<$Res> {
  _$GardenSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GardenSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? emoji = null,
    Object? capsules = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String,
            capsules: null == capsules
                ? _value.capsules
                : capsules // ignore: cast_nullable_to_non_nullable
                      as List<TimeCapsule>,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as GardenSectionType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GardenSectionImplCopyWith<$Res>
    implements $GardenSectionCopyWith<$Res> {
  factory _$$GardenSectionImplCopyWith(
    _$GardenSectionImpl value,
    $Res Function(_$GardenSectionImpl) then,
  ) = __$$GardenSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String emoji,
    List<TimeCapsule> capsules,
    GardenSectionType type,
  });
}

/// @nodoc
class __$$GardenSectionImplCopyWithImpl<$Res>
    extends _$GardenSectionCopyWithImpl<$Res, _$GardenSectionImpl>
    implements _$$GardenSectionImplCopyWith<$Res> {
  __$$GardenSectionImplCopyWithImpl(
    _$GardenSectionImpl _value,
    $Res Function(_$GardenSectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GardenSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? emoji = null,
    Object? capsules = null,
    Object? type = null,
  }) {
    return _then(
      _$GardenSectionImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String,
        capsules: null == capsules
            ? _value._capsules
            : capsules // ignore: cast_nullable_to_non_nullable
                  as List<TimeCapsule>,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as GardenSectionType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GardenSectionImpl implements _GardenSection {
  const _$GardenSectionImpl({
    required this.title,
    required this.emoji,
    required final List<TimeCapsule> capsules,
    required this.type,
  }) : _capsules = capsules;

  factory _$GardenSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$GardenSectionImplFromJson(json);

  @override
  final String title;
  @override
  final String emoji;
  final List<TimeCapsule> _capsules;
  @override
  List<TimeCapsule> get capsules {
    if (_capsules is EqualUnmodifiableListView) return _capsules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capsules);
  }

  @override
  final GardenSectionType type;

  @override
  String toString() {
    return 'GardenSection(title: $title, emoji: $emoji, capsules: $capsules, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenSectionImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            const DeepCollectionEquality().equals(other._capsules, _capsules) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    emoji,
    const DeepCollectionEquality().hash(_capsules),
    type,
  );

  /// Create a copy of GardenSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenSectionImplCopyWith<_$GardenSectionImpl> get copyWith =>
      __$$GardenSectionImplCopyWithImpl<_$GardenSectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GardenSectionImplToJson(this);
  }
}

abstract class _GardenSection implements GardenSection {
  const factory _GardenSection({
    required final String title,
    required final String emoji,
    required final List<TimeCapsule> capsules,
    required final GardenSectionType type,
  }) = _$GardenSectionImpl;

  factory _GardenSection.fromJson(Map<String, dynamic> json) =
      _$GardenSectionImpl.fromJson;

  @override
  String get title;
  @override
  String get emoji;
  @override
  List<TimeCapsule> get capsules;
  @override
  GardenSectionType get type;

  /// Create a copy of GardenSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GardenSectionImplCopyWith<_$GardenSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
