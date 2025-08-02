// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VoiceMessage _$VoiceMessageFromJson(Map<String, dynamic> json) {
  return _VoiceMessage.fromJson(json);
}

/// @nodoc
mixin _$VoiceMessage {
  String get audioUrl => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String? get waveformData => throw _privateConstructorUsedError;

  /// Serializes this VoiceMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VoiceMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoiceMessageCopyWith<VoiceMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoiceMessageCopyWith<$Res> {
  factory $VoiceMessageCopyWith(
    VoiceMessage value,
    $Res Function(VoiceMessage) then,
  ) = _$VoiceMessageCopyWithImpl<$Res, VoiceMessage>;
  @useResult
  $Res call({
    String audioUrl,
    Duration duration,
    bool isPlaying,
    double progress,
    String? waveformData,
  });
}

/// @nodoc
class _$VoiceMessageCopyWithImpl<$Res, $Val extends VoiceMessage>
    implements $VoiceMessageCopyWith<$Res> {
  _$VoiceMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VoiceMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioUrl = null,
    Object? duration = null,
    Object? isPlaying = null,
    Object? progress = null,
    Object? waveformData = freezed,
  }) {
    return _then(
      _value.copyWith(
            audioUrl: null == audioUrl
                ? _value.audioUrl
                : audioUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            isPlaying: null == isPlaying
                ? _value.isPlaying
                : isPlaying // ignore: cast_nullable_to_non_nullable
                      as bool,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            waveformData: freezed == waveformData
                ? _value.waveformData
                : waveformData // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VoiceMessageImplCopyWith<$Res>
    implements $VoiceMessageCopyWith<$Res> {
  factory _$$VoiceMessageImplCopyWith(
    _$VoiceMessageImpl value,
    $Res Function(_$VoiceMessageImpl) then,
  ) = __$$VoiceMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String audioUrl,
    Duration duration,
    bool isPlaying,
    double progress,
    String? waveformData,
  });
}

/// @nodoc
class __$$VoiceMessageImplCopyWithImpl<$Res>
    extends _$VoiceMessageCopyWithImpl<$Res, _$VoiceMessageImpl>
    implements _$$VoiceMessageImplCopyWith<$Res> {
  __$$VoiceMessageImplCopyWithImpl(
    _$VoiceMessageImpl _value,
    $Res Function(_$VoiceMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VoiceMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioUrl = null,
    Object? duration = null,
    Object? isPlaying = null,
    Object? progress = null,
    Object? waveformData = freezed,
  }) {
    return _then(
      _$VoiceMessageImpl(
        audioUrl: null == audioUrl
            ? _value.audioUrl
            : audioUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        isPlaying: null == isPlaying
            ? _value.isPlaying
            : isPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        waveformData: freezed == waveformData
            ? _value.waveformData
            : waveformData // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VoiceMessageImpl implements _VoiceMessage {
  const _$VoiceMessageImpl({
    required this.audioUrl,
    required this.duration,
    this.isPlaying = false,
    this.progress = 0.0,
    this.waveformData,
  });

  factory _$VoiceMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoiceMessageImplFromJson(json);

  @override
  final String audioUrl;
  @override
  final Duration duration;
  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final double progress;
  @override
  final String? waveformData;

  @override
  String toString() {
    return 'VoiceMessage(audioUrl: $audioUrl, duration: $duration, isPlaying: $isPlaying, progress: $progress, waveformData: $waveformData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoiceMessageImpl &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.waveformData, waveformData) ||
                other.waveformData == waveformData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    audioUrl,
    duration,
    isPlaying,
    progress,
    waveformData,
  );

  /// Create a copy of VoiceMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoiceMessageImplCopyWith<_$VoiceMessageImpl> get copyWith =>
      __$$VoiceMessageImplCopyWithImpl<_$VoiceMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoiceMessageImplToJson(this);
  }
}

abstract class _VoiceMessage implements VoiceMessage {
  const factory _VoiceMessage({
    required final String audioUrl,
    required final Duration duration,
    final bool isPlaying,
    final double progress,
    final String? waveformData,
  }) = _$VoiceMessageImpl;

  factory _VoiceMessage.fromJson(Map<String, dynamic> json) =
      _$VoiceMessageImpl.fromJson;

  @override
  String get audioUrl;
  @override
  Duration get duration;
  @override
  bool get isPlaying;
  @override
  double get progress;
  @override
  String? get waveformData;

  /// Create a copy of VoiceMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoiceMessageImplCopyWith<_$VoiceMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImageMessage _$ImageMessageFromJson(Map<String, dynamic> json) {
  return _ImageMessage.fromJson(json);
}

/// @nodoc
mixin _$ImageMessage {
  String get imageUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;

  /// Serializes this ImageMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageMessageCopyWith<ImageMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageMessageCopyWith<$Res> {
  factory $ImageMessageCopyWith(
    ImageMessage value,
    $Res Function(ImageMessage) then,
  ) = _$ImageMessageCopyWithImpl<$Res, ImageMessage>;
  @useResult
  $Res call({
    String imageUrl,
    String? thumbnailUrl,
    String? caption,
    double? width,
    double? height,
  });
}

/// @nodoc
class _$ImageMessageCopyWithImpl<$Res, $Val extends ImageMessage>
    implements $ImageMessageCopyWith<$Res> {
  _$ImageMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = null,
    Object? thumbnailUrl = freezed,
    Object? caption = freezed,
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(
      _value.copyWith(
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as double?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImageMessageImplCopyWith<$Res>
    implements $ImageMessageCopyWith<$Res> {
  factory _$$ImageMessageImplCopyWith(
    _$ImageMessageImpl value,
    $Res Function(_$ImageMessageImpl) then,
  ) = __$$ImageMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String imageUrl,
    String? thumbnailUrl,
    String? caption,
    double? width,
    double? height,
  });
}

/// @nodoc
class __$$ImageMessageImplCopyWithImpl<$Res>
    extends _$ImageMessageCopyWithImpl<$Res, _$ImageMessageImpl>
    implements _$$ImageMessageImplCopyWith<$Res> {
  __$$ImageMessageImplCopyWithImpl(
    _$ImageMessageImpl _value,
    $Res Function(_$ImageMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = null,
    Object? thumbnailUrl = freezed,
    Object? caption = freezed,
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(
      _$ImageMessageImpl(
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as double?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageMessageImpl implements _ImageMessage {
  const _$ImageMessageImpl({
    required this.imageUrl,
    this.thumbnailUrl,
    this.caption,
    this.width,
    this.height,
  });

  factory _$ImageMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageMessageImplFromJson(json);

  @override
  final String imageUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? caption;
  @override
  final double? width;
  @override
  final double? height;

  @override
  String toString() {
    return 'ImageMessage(imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, caption: $caption, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageMessageImpl &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imageUrl, thumbnailUrl, caption, width, height);

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageMessageImplCopyWith<_$ImageMessageImpl> get copyWith =>
      __$$ImageMessageImplCopyWithImpl<_$ImageMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageMessageImplToJson(this);
  }
}

abstract class _ImageMessage implements ImageMessage {
  const factory _ImageMessage({
    required final String imageUrl,
    final String? thumbnailUrl,
    final String? caption,
    final double? width,
    final double? height,
  }) = _$ImageMessageImpl;

  factory _ImageMessage.fromJson(Map<String, dynamic> json) =
      _$ImageMessageImpl.fromJson;

  @override
  String get imageUrl;
  @override
  String? get thumbnailUrl;
  @override
  String? get caption;
  @override
  double? get width;
  @override
  double? get height;

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageMessageImplCopyWith<_$ImageMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectionStoneMessage _$ConnectionStoneMessageFromJson(
  Map<String, dynamic> json,
) {
  return _ConnectionStoneMessage.fromJson(json);
}

/// @nodoc
mixin _$ConnectionStoneMessage {
  String get stoneType => throw _privateConstructorUsedError;
  String get emotion => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ConnectionStoneMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionStoneMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionStoneMessageCopyWith<ConnectionStoneMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionStoneMessageCopyWith<$Res> {
  factory $ConnectionStoneMessageCopyWith(
    ConnectionStoneMessage value,
    $Res Function(ConnectionStoneMessage) then,
  ) = _$ConnectionStoneMessageCopyWithImpl<$Res, ConnectionStoneMessage>;
  @useResult
  $Res call({
    String stoneType,
    String emotion,
    String message,
    DateTime? timestamp,
  });
}

/// @nodoc
class _$ConnectionStoneMessageCopyWithImpl<
  $Res,
  $Val extends ConnectionStoneMessage
>
    implements $ConnectionStoneMessageCopyWith<$Res> {
  _$ConnectionStoneMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionStoneMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stoneType = null,
    Object? emotion = null,
    Object? message = null,
    Object? timestamp = freezed,
  }) {
    return _then(
      _value.copyWith(
            stoneType: null == stoneType
                ? _value.stoneType
                : stoneType // ignore: cast_nullable_to_non_nullable
                      as String,
            emotion: null == emotion
                ? _value.emotion
                : emotion // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConnectionStoneMessageImplCopyWith<$Res>
    implements $ConnectionStoneMessageCopyWith<$Res> {
  factory _$$ConnectionStoneMessageImplCopyWith(
    _$ConnectionStoneMessageImpl value,
    $Res Function(_$ConnectionStoneMessageImpl) then,
  ) = __$$ConnectionStoneMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String stoneType,
    String emotion,
    String message,
    DateTime? timestamp,
  });
}

/// @nodoc
class __$$ConnectionStoneMessageImplCopyWithImpl<$Res>
    extends
        _$ConnectionStoneMessageCopyWithImpl<$Res, _$ConnectionStoneMessageImpl>
    implements _$$ConnectionStoneMessageImplCopyWith<$Res> {
  __$$ConnectionStoneMessageImplCopyWithImpl(
    _$ConnectionStoneMessageImpl _value,
    $Res Function(_$ConnectionStoneMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectionStoneMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stoneType = null,
    Object? emotion = null,
    Object? message = null,
    Object? timestamp = freezed,
  }) {
    return _then(
      _$ConnectionStoneMessageImpl(
        stoneType: null == stoneType
            ? _value.stoneType
            : stoneType // ignore: cast_nullable_to_non_nullable
                  as String,
        emotion: null == emotion
            ? _value.emotion
            : emotion // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionStoneMessageImpl implements _ConnectionStoneMessage {
  const _$ConnectionStoneMessageImpl({
    required this.stoneType,
    required this.emotion,
    this.message = '',
    this.timestamp,
  });

  factory _$ConnectionStoneMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionStoneMessageImplFromJson(json);

  @override
  final String stoneType;
  @override
  final String emotion;
  @override
  @JsonKey()
  final String message;
  @override
  final DateTime? timestamp;

  @override
  String toString() {
    return 'ConnectionStoneMessage(stoneType: $stoneType, emotion: $emotion, message: $message, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionStoneMessageImpl &&
            (identical(other.stoneType, stoneType) ||
                other.stoneType == stoneType) &&
            (identical(other.emotion, emotion) || other.emotion == emotion) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stoneType, emotion, message, timestamp);

  /// Create a copy of ConnectionStoneMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionStoneMessageImplCopyWith<_$ConnectionStoneMessageImpl>
  get copyWith =>
      __$$ConnectionStoneMessageImplCopyWithImpl<_$ConnectionStoneMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionStoneMessageImplToJson(this);
  }
}

abstract class _ConnectionStoneMessage implements ConnectionStoneMessage {
  const factory _ConnectionStoneMessage({
    required final String stoneType,
    required final String emotion,
    final String message,
    final DateTime? timestamp,
  }) = _$ConnectionStoneMessageImpl;

  factory _ConnectionStoneMessage.fromJson(Map<String, dynamic> json) =
      _$ConnectionStoneMessageImpl.fromJson;

  @override
  String get stoneType;
  @override
  String get emotion;
  @override
  String get message;
  @override
  DateTime? get timestamp;

  /// Create a copy of ConnectionStoneMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionStoneMessageImplCopyWith<_$ConnectionStoneMessageImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MessageReaction _$MessageReactionFromJson(Map<String, dynamic> json) {
  return _MessageReaction.fromJson(json);
}

/// @nodoc
mixin _$MessageReaction {
  String get id => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isFromMe => throw _privateConstructorUsedError;

  /// Serializes this MessageReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageReactionCopyWith<MessageReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReactionCopyWith<$Res> {
  factory $MessageReactionCopyWith(
    MessageReaction value,
    $Res Function(MessageReaction) then,
  ) = _$MessageReactionCopyWithImpl<$Res, MessageReaction>;
  @useResult
  $Res call({
    String id,
    String emoji,
    String userId,
    String userName,
    DateTime timestamp,
    bool isFromMe,
  });
}

/// @nodoc
class _$MessageReactionCopyWithImpl<$Res, $Val extends MessageReaction>
    implements $MessageReactionCopyWith<$Res> {
  _$MessageReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? emoji = null,
    Object? userId = null,
    Object? userName = null,
    Object? timestamp = null,
    Object? isFromMe = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isFromMe: null == isFromMe
                ? _value.isFromMe
                : isFromMe // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageReactionImplCopyWith<$Res>
    implements $MessageReactionCopyWith<$Res> {
  factory _$$MessageReactionImplCopyWith(
    _$MessageReactionImpl value,
    $Res Function(_$MessageReactionImpl) then,
  ) = __$$MessageReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String emoji,
    String userId,
    String userName,
    DateTime timestamp,
    bool isFromMe,
  });
}

/// @nodoc
class __$$MessageReactionImplCopyWithImpl<$Res>
    extends _$MessageReactionCopyWithImpl<$Res, _$MessageReactionImpl>
    implements _$$MessageReactionImplCopyWith<$Res> {
  __$$MessageReactionImplCopyWithImpl(
    _$MessageReactionImpl _value,
    $Res Function(_$MessageReactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? emoji = null,
    Object? userId = null,
    Object? userName = null,
    Object? timestamp = null,
    Object? isFromMe = null,
  }) {
    return _then(
      _$MessageReactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isFromMe: null == isFromMe
            ? _value.isFromMe
            : isFromMe // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageReactionImpl implements _MessageReaction {
  const _$MessageReactionImpl({
    required this.id,
    required this.emoji,
    required this.userId,
    required this.userName,
    required this.timestamp,
    this.isFromMe = false,
  });

  factory _$MessageReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageReactionImplFromJson(json);

  @override
  final String id;
  @override
  final String emoji;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isFromMe;

  @override
  String toString() {
    return 'MessageReaction(id: $id, emoji: $emoji, userId: $userId, userName: $userName, timestamp: $timestamp, isFromMe: $isFromMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageReactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isFromMe, isFromMe) ||
                other.isFromMe == isFromMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    emoji,
    userId,
    userName,
    timestamp,
    isFromMe,
  );

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageReactionImplCopyWith<_$MessageReactionImpl> get copyWith =>
      __$$MessageReactionImplCopyWithImpl<_$MessageReactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageReactionImplToJson(this);
  }
}

abstract class _MessageReaction implements MessageReaction {
  const factory _MessageReaction({
    required final String id,
    required final String emoji,
    required final String userId,
    required final String userName,
    required final DateTime timestamp,
    final bool isFromMe,
  }) = _$MessageReactionImpl;

  factory _MessageReaction.fromJson(Map<String, dynamic> json) =
      _$MessageReactionImpl.fromJson;

  @override
  String get id;
  @override
  String get emoji;
  @override
  String get userId;
  @override
  String get userName;
  @override
  DateTime get timestamp;
  @override
  bool get isFromMe;

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageReactionImplCopyWith<_$MessageReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SelfDestructMessage _$SelfDestructMessageFromJson(Map<String, dynamic> json) {
  return _SelfDestructMessage.fromJson(json);
}

/// @nodoc
mixin _$SelfDestructMessage {
  Duration get countdown => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isExpired => throw _privateConstructorUsedError;

  /// Serializes this SelfDestructMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelfDestructMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelfDestructMessageCopyWith<SelfDestructMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelfDestructMessageCopyWith<$Res> {
  factory $SelfDestructMessageCopyWith(
    SelfDestructMessage value,
    $Res Function(SelfDestructMessage) then,
  ) = _$SelfDestructMessageCopyWithImpl<$Res, SelfDestructMessage>;
  @useResult
  $Res call({Duration countdown, DateTime createdAt, bool isExpired});
}

/// @nodoc
class _$SelfDestructMessageCopyWithImpl<$Res, $Val extends SelfDestructMessage>
    implements $SelfDestructMessageCopyWith<$Res> {
  _$SelfDestructMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelfDestructMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countdown = null,
    Object? createdAt = null,
    Object? isExpired = null,
  }) {
    return _then(
      _value.copyWith(
            countdown: null == countdown
                ? _value.countdown
                : countdown // ignore: cast_nullable_to_non_nullable
                      as Duration,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isExpired: null == isExpired
                ? _value.isExpired
                : isExpired // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SelfDestructMessageImplCopyWith<$Res>
    implements $SelfDestructMessageCopyWith<$Res> {
  factory _$$SelfDestructMessageImplCopyWith(
    _$SelfDestructMessageImpl value,
    $Res Function(_$SelfDestructMessageImpl) then,
  ) = __$$SelfDestructMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Duration countdown, DateTime createdAt, bool isExpired});
}

/// @nodoc
class __$$SelfDestructMessageImplCopyWithImpl<$Res>
    extends _$SelfDestructMessageCopyWithImpl<$Res, _$SelfDestructMessageImpl>
    implements _$$SelfDestructMessageImplCopyWith<$Res> {
  __$$SelfDestructMessageImplCopyWithImpl(
    _$SelfDestructMessageImpl _value,
    $Res Function(_$SelfDestructMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelfDestructMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countdown = null,
    Object? createdAt = null,
    Object? isExpired = null,
  }) {
    return _then(
      _$SelfDestructMessageImpl(
        countdown: null == countdown
            ? _value.countdown
            : countdown // ignore: cast_nullable_to_non_nullable
                  as Duration,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isExpired: null == isExpired
            ? _value.isExpired
            : isExpired // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SelfDestructMessageImpl extends _SelfDestructMessage {
  const _$SelfDestructMessageImpl({
    required this.countdown,
    required this.createdAt,
    this.isExpired = false,
  }) : super._();

  factory _$SelfDestructMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelfDestructMessageImplFromJson(json);

  @override
  final Duration countdown;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isExpired;

  @override
  String toString() {
    return 'SelfDestructMessage(countdown: $countdown, createdAt: $createdAt, isExpired: $isExpired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelfDestructMessageImpl &&
            (identical(other.countdown, countdown) ||
                other.countdown == countdown) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, countdown, createdAt, isExpired);

  /// Create a copy of SelfDestructMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelfDestructMessageImplCopyWith<_$SelfDestructMessageImpl> get copyWith =>
      __$$SelfDestructMessageImplCopyWithImpl<_$SelfDestructMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SelfDestructMessageImplToJson(this);
  }
}

abstract class _SelfDestructMessage extends SelfDestructMessage {
  const factory _SelfDestructMessage({
    required final Duration countdown,
    required final DateTime createdAt,
    final bool isExpired,
  }) = _$SelfDestructMessageImpl;
  const _SelfDestructMessage._() : super._();

  factory _SelfDestructMessage.fromJson(Map<String, dynamic> json) =
      _$SelfDestructMessageImpl.fromJson;

  @override
  Duration get countdown;
  @override
  DateTime get createdAt;
  @override
  bool get isExpired;

  /// Create a copy of SelfDestructMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelfDestructMessageImplCopyWith<_$SelfDestructMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  MessageStatus get status => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<MessageReaction> get reactions => throw _privateConstructorUsedError;
  bool get isFromMe => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  DateTime? get editedAt => throw _privateConstructorUsedError;
  String? get replyToMessageId => throw _privateConstructorUsedError;
  VoiceMessage? get voiceMessage => throw _privateConstructorUsedError;
  ImageMessage? get imageMessage => throw _privateConstructorUsedError;
  ConnectionStoneMessage? get connectionStone =>
      throw _privateConstructorUsedError;
  SelfDestructMessage? get selfDestruct => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
    ChatMessage value,
    $Res Function(ChatMessage) then,
  ) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({
    String id,
    String senderId,
    String senderName,
    String conversationId,
    MessageType type,
    DateTime timestamp,
    MessageStatus status,
    String content,
    List<MessageReaction> reactions,
    bool isFromMe,
    bool isEdited,
    DateTime? editedAt,
    String? replyToMessageId,
    VoiceMessage? voiceMessage,
    ImageMessage? imageMessage,
    ConnectionStoneMessage? connectionStone,
    SelfDestructMessage? selfDestruct,
  });

  $VoiceMessageCopyWith<$Res>? get voiceMessage;
  $ImageMessageCopyWith<$Res>? get imageMessage;
  $ConnectionStoneMessageCopyWith<$Res>? get connectionStone;
  $SelfDestructMessageCopyWith<$Res>? get selfDestruct;
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? conversationId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? status = null,
    Object? content = null,
    Object? reactions = null,
    Object? isFromMe = null,
    Object? isEdited = null,
    Object? editedAt = freezed,
    Object? replyToMessageId = freezed,
    Object? voiceMessage = freezed,
    Object? imageMessage = freezed,
    Object? connectionStone = freezed,
    Object? selfDestruct = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationId: null == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MessageType,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MessageStatus,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            reactions: null == reactions
                ? _value.reactions
                : reactions // ignore: cast_nullable_to_non_nullable
                      as List<MessageReaction>,
            isFromMe: null == isFromMe
                ? _value.isFromMe
                : isFromMe // ignore: cast_nullable_to_non_nullable
                      as bool,
            isEdited: null == isEdited
                ? _value.isEdited
                : isEdited // ignore: cast_nullable_to_non_nullable
                      as bool,
            editedAt: freezed == editedAt
                ? _value.editedAt
                : editedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            replyToMessageId: freezed == replyToMessageId
                ? _value.replyToMessageId
                : replyToMessageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            voiceMessage: freezed == voiceMessage
                ? _value.voiceMessage
                : voiceMessage // ignore: cast_nullable_to_non_nullable
                      as VoiceMessage?,
            imageMessage: freezed == imageMessage
                ? _value.imageMessage
                : imageMessage // ignore: cast_nullable_to_non_nullable
                      as ImageMessage?,
            connectionStone: freezed == connectionStone
                ? _value.connectionStone
                : connectionStone // ignore: cast_nullable_to_non_nullable
                      as ConnectionStoneMessage?,
            selfDestruct: freezed == selfDestruct
                ? _value.selfDestruct
                : selfDestruct // ignore: cast_nullable_to_non_nullable
                      as SelfDestructMessage?,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VoiceMessageCopyWith<$Res>? get voiceMessage {
    if (_value.voiceMessage == null) {
      return null;
    }

    return $VoiceMessageCopyWith<$Res>(_value.voiceMessage!, (value) {
      return _then(_value.copyWith(voiceMessage: value) as $Val);
    });
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImageMessageCopyWith<$Res>? get imageMessage {
    if (_value.imageMessage == null) {
      return null;
    }

    return $ImageMessageCopyWith<$Res>(_value.imageMessage!, (value) {
      return _then(_value.copyWith(imageMessage: value) as $Val);
    });
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConnectionStoneMessageCopyWith<$Res>? get connectionStone {
    if (_value.connectionStone == null) {
      return null;
    }

    return $ConnectionStoneMessageCopyWith<$Res>(_value.connectionStone!, (
      value,
    ) {
      return _then(_value.copyWith(connectionStone: value) as $Val);
    });
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SelfDestructMessageCopyWith<$Res>? get selfDestruct {
    if (_value.selfDestruct == null) {
      return null;
    }

    return $SelfDestructMessageCopyWith<$Res>(_value.selfDestruct!, (value) {
      return _then(_value.copyWith(selfDestruct: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
    _$ChatMessageImpl value,
    $Res Function(_$ChatMessageImpl) then,
  ) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String senderId,
    String senderName,
    String conversationId,
    MessageType type,
    DateTime timestamp,
    MessageStatus status,
    String content,
    List<MessageReaction> reactions,
    bool isFromMe,
    bool isEdited,
    DateTime? editedAt,
    String? replyToMessageId,
    VoiceMessage? voiceMessage,
    ImageMessage? imageMessage,
    ConnectionStoneMessage? connectionStone,
    SelfDestructMessage? selfDestruct,
  });

  @override
  $VoiceMessageCopyWith<$Res>? get voiceMessage;
  @override
  $ImageMessageCopyWith<$Res>? get imageMessage;
  @override
  $ConnectionStoneMessageCopyWith<$Res>? get connectionStone;
  @override
  $SelfDestructMessageCopyWith<$Res>? get selfDestruct;
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
    _$ChatMessageImpl _value,
    $Res Function(_$ChatMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? conversationId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? status = null,
    Object? content = null,
    Object? reactions = null,
    Object? isFromMe = null,
    Object? isEdited = null,
    Object? editedAt = freezed,
    Object? replyToMessageId = freezed,
    Object? voiceMessage = freezed,
    Object? imageMessage = freezed,
    Object? connectionStone = freezed,
    Object? selfDestruct = freezed,
  }) {
    return _then(
      _$ChatMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationId: null == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MessageType,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MessageStatus,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        reactions: null == reactions
            ? _value._reactions
            : reactions // ignore: cast_nullable_to_non_nullable
                  as List<MessageReaction>,
        isFromMe: null == isFromMe
            ? _value.isFromMe
            : isFromMe // ignore: cast_nullable_to_non_nullable
                  as bool,
        isEdited: null == isEdited
            ? _value.isEdited
            : isEdited // ignore: cast_nullable_to_non_nullable
                  as bool,
        editedAt: freezed == editedAt
            ? _value.editedAt
            : editedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        replyToMessageId: freezed == replyToMessageId
            ? _value.replyToMessageId
            : replyToMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        voiceMessage: freezed == voiceMessage
            ? _value.voiceMessage
            : voiceMessage // ignore: cast_nullable_to_non_nullable
                  as VoiceMessage?,
        imageMessage: freezed == imageMessage
            ? _value.imageMessage
            : imageMessage // ignore: cast_nullable_to_non_nullable
                  as ImageMessage?,
        connectionStone: freezed == connectionStone
            ? _value.connectionStone
            : connectionStone // ignore: cast_nullable_to_non_nullable
                  as ConnectionStoneMessage?,
        selfDestruct: freezed == selfDestruct
            ? _value.selfDestruct
            : selfDestruct // ignore: cast_nullable_to_non_nullable
                  as SelfDestructMessage?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl extends _ChatMessage {
  const _$ChatMessageImpl({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.conversationId,
    required this.type,
    required this.timestamp,
    required this.status,
    this.content = '',
    final List<MessageReaction> reactions = const [],
    this.isFromMe = false,
    this.isEdited = false,
    this.editedAt,
    this.replyToMessageId,
    this.voiceMessage,
    this.imageMessage,
    this.connectionStone,
    this.selfDestruct,
  }) : _reactions = reactions,
       super._();

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String conversationId;
  @override
  final MessageType type;
  @override
  final DateTime timestamp;
  @override
  final MessageStatus status;
  @override
  @JsonKey()
  final String content;
  final List<MessageReaction> _reactions;
  @override
  @JsonKey()
  List<MessageReaction> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  @override
  @JsonKey()
  final bool isFromMe;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  final DateTime? editedAt;
  @override
  final String? replyToMessageId;
  @override
  final VoiceMessage? voiceMessage;
  @override
  final ImageMessage? imageMessage;
  @override
  final ConnectionStoneMessage? connectionStone;
  @override
  final SelfDestructMessage? selfDestruct;

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, senderName: $senderName, conversationId: $conversationId, type: $type, timestamp: $timestamp, status: $status, content: $content, reactions: $reactions, isFromMe: $isFromMe, isEdited: $isEdited, editedAt: $editedAt, replyToMessageId: $replyToMessageId, voiceMessage: $voiceMessage, imageMessage: $imageMessage, connectionStone: $connectionStone, selfDestruct: $selfDestruct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(
              other._reactions,
              _reactions,
            ) &&
            (identical(other.isFromMe, isFromMe) ||
                other.isFromMe == isFromMe) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            (identical(other.replyToMessageId, replyToMessageId) ||
                other.replyToMessageId == replyToMessageId) &&
            (identical(other.voiceMessage, voiceMessage) ||
                other.voiceMessage == voiceMessage) &&
            (identical(other.imageMessage, imageMessage) ||
                other.imageMessage == imageMessage) &&
            (identical(other.connectionStone, connectionStone) ||
                other.connectionStone == connectionStone) &&
            (identical(other.selfDestruct, selfDestruct) ||
                other.selfDestruct == selfDestruct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    senderId,
    senderName,
    conversationId,
    type,
    timestamp,
    status,
    content,
    const DeepCollectionEquality().hash(_reactions),
    isFromMe,
    isEdited,
    editedAt,
    replyToMessageId,
    voiceMessage,
    imageMessage,
    connectionStone,
    selfDestruct,
  );

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(this);
  }
}

abstract class _ChatMessage extends ChatMessage {
  const factory _ChatMessage({
    required final String id,
    required final String senderId,
    required final String senderName,
    required final String conversationId,
    required final MessageType type,
    required final DateTime timestamp,
    required final MessageStatus status,
    final String content,
    final List<MessageReaction> reactions,
    final bool isFromMe,
    final bool isEdited,
    final DateTime? editedAt,
    final String? replyToMessageId,
    final VoiceMessage? voiceMessage,
    final ImageMessage? imageMessage,
    final ConnectionStoneMessage? connectionStone,
    final SelfDestructMessage? selfDestruct,
  }) = _$ChatMessageImpl;
  const _ChatMessage._() : super._();

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String get conversationId;
  @override
  MessageType get type;
  @override
  DateTime get timestamp;
  @override
  MessageStatus get status;
  @override
  String get content;
  @override
  List<MessageReaction> get reactions;
  @override
  bool get isFromMe;
  @override
  bool get isEdited;
  @override
  DateTime? get editedAt;
  @override
  String? get replyToMessageId;
  @override
  VoiceMessage? get voiceMessage;
  @override
  ImageMessage? get imageMessage;
  @override
  ConnectionStoneMessage? get connectionStone;
  @override
  SelfDestructMessage? get selfDestruct;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageDraft _$MessageDraftFromJson(Map<String, dynamic> json) {
  return _MessageDraft.fromJson(json);
}

/// @nodoc
mixin _$MessageDraft {
  String get content => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  String? get replyToMessageId => throw _privateConstructorUsedError;
  VoiceMessage? get voiceMessage => throw _privateConstructorUsedError;
  ImageMessage? get imageMessage => throw _privateConstructorUsedError;
  bool get isSelfDestruct => throw _privateConstructorUsedError;
  Duration? get selfDestructDuration => throw _privateConstructorUsedError;

  /// Serializes this MessageDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageDraftCopyWith<MessageDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDraftCopyWith<$Res> {
  factory $MessageDraftCopyWith(
    MessageDraft value,
    $Res Function(MessageDraft) then,
  ) = _$MessageDraftCopyWithImpl<$Res, MessageDraft>;
  @useResult
  $Res call({
    String content,
    MessageType type,
    String? replyToMessageId,
    VoiceMessage? voiceMessage,
    ImageMessage? imageMessage,
    bool isSelfDestruct,
    Duration? selfDestructDuration,
  });

  $VoiceMessageCopyWith<$Res>? get voiceMessage;
  $ImageMessageCopyWith<$Res>? get imageMessage;
}

/// @nodoc
class _$MessageDraftCopyWithImpl<$Res, $Val extends MessageDraft>
    implements $MessageDraftCopyWith<$Res> {
  _$MessageDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? type = null,
    Object? replyToMessageId = freezed,
    Object? voiceMessage = freezed,
    Object? imageMessage = freezed,
    Object? isSelfDestruct = null,
    Object? selfDestructDuration = freezed,
  }) {
    return _then(
      _value.copyWith(
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MessageType,
            replyToMessageId: freezed == replyToMessageId
                ? _value.replyToMessageId
                : replyToMessageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            voiceMessage: freezed == voiceMessage
                ? _value.voiceMessage
                : voiceMessage // ignore: cast_nullable_to_non_nullable
                      as VoiceMessage?,
            imageMessage: freezed == imageMessage
                ? _value.imageMessage
                : imageMessage // ignore: cast_nullable_to_non_nullable
                      as ImageMessage?,
            isSelfDestruct: null == isSelfDestruct
                ? _value.isSelfDestruct
                : isSelfDestruct // ignore: cast_nullable_to_non_nullable
                      as bool,
            selfDestructDuration: freezed == selfDestructDuration
                ? _value.selfDestructDuration
                : selfDestructDuration // ignore: cast_nullable_to_non_nullable
                      as Duration?,
          )
          as $Val,
    );
  }

  /// Create a copy of MessageDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VoiceMessageCopyWith<$Res>? get voiceMessage {
    if (_value.voiceMessage == null) {
      return null;
    }

    return $VoiceMessageCopyWith<$Res>(_value.voiceMessage!, (value) {
      return _then(_value.copyWith(voiceMessage: value) as $Val);
    });
  }

  /// Create a copy of MessageDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImageMessageCopyWith<$Res>? get imageMessage {
    if (_value.imageMessage == null) {
      return null;
    }

    return $ImageMessageCopyWith<$Res>(_value.imageMessage!, (value) {
      return _then(_value.copyWith(imageMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageDraftImplCopyWith<$Res>
    implements $MessageDraftCopyWith<$Res> {
  factory _$$MessageDraftImplCopyWith(
    _$MessageDraftImpl value,
    $Res Function(_$MessageDraftImpl) then,
  ) = __$$MessageDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String content,
    MessageType type,
    String? replyToMessageId,
    VoiceMessage? voiceMessage,
    ImageMessage? imageMessage,
    bool isSelfDestruct,
    Duration? selfDestructDuration,
  });

  @override
  $VoiceMessageCopyWith<$Res>? get voiceMessage;
  @override
  $ImageMessageCopyWith<$Res>? get imageMessage;
}

/// @nodoc
class __$$MessageDraftImplCopyWithImpl<$Res>
    extends _$MessageDraftCopyWithImpl<$Res, _$MessageDraftImpl>
    implements _$$MessageDraftImplCopyWith<$Res> {
  __$$MessageDraftImplCopyWithImpl(
    _$MessageDraftImpl _value,
    $Res Function(_$MessageDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? type = null,
    Object? replyToMessageId = freezed,
    Object? voiceMessage = freezed,
    Object? imageMessage = freezed,
    Object? isSelfDestruct = null,
    Object? selfDestructDuration = freezed,
  }) {
    return _then(
      _$MessageDraftImpl(
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MessageType,
        replyToMessageId: freezed == replyToMessageId
            ? _value.replyToMessageId
            : replyToMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        voiceMessage: freezed == voiceMessage
            ? _value.voiceMessage
            : voiceMessage // ignore: cast_nullable_to_non_nullable
                  as VoiceMessage?,
        imageMessage: freezed == imageMessage
            ? _value.imageMessage
            : imageMessage // ignore: cast_nullable_to_non_nullable
                  as ImageMessage?,
        isSelfDestruct: null == isSelfDestruct
            ? _value.isSelfDestruct
            : isSelfDestruct // ignore: cast_nullable_to_non_nullable
                  as bool,
        selfDestructDuration: freezed == selfDestructDuration
            ? _value.selfDestructDuration
            : selfDestructDuration // ignore: cast_nullable_to_non_nullable
                  as Duration?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageDraftImpl extends _MessageDraft {
  const _$MessageDraftImpl({
    this.content = '',
    this.type = MessageType.text,
    this.replyToMessageId,
    this.voiceMessage,
    this.imageMessage,
    this.isSelfDestruct = false,
    this.selfDestructDuration,
  }) : super._();

  factory _$MessageDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageDraftImplFromJson(json);

  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final MessageType type;
  @override
  final String? replyToMessageId;
  @override
  final VoiceMessage? voiceMessage;
  @override
  final ImageMessage? imageMessage;
  @override
  @JsonKey()
  final bool isSelfDestruct;
  @override
  final Duration? selfDestructDuration;

  @override
  String toString() {
    return 'MessageDraft(content: $content, type: $type, replyToMessageId: $replyToMessageId, voiceMessage: $voiceMessage, imageMessage: $imageMessage, isSelfDestruct: $isSelfDestruct, selfDestructDuration: $selfDestructDuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDraftImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.replyToMessageId, replyToMessageId) ||
                other.replyToMessageId == replyToMessageId) &&
            (identical(other.voiceMessage, voiceMessage) ||
                other.voiceMessage == voiceMessage) &&
            (identical(other.imageMessage, imageMessage) ||
                other.imageMessage == imageMessage) &&
            (identical(other.isSelfDestruct, isSelfDestruct) ||
                other.isSelfDestruct == isSelfDestruct) &&
            (identical(other.selfDestructDuration, selfDestructDuration) ||
                other.selfDestructDuration == selfDestructDuration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    content,
    type,
    replyToMessageId,
    voiceMessage,
    imageMessage,
    isSelfDestruct,
    selfDestructDuration,
  );

  /// Create a copy of MessageDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageDraftImplCopyWith<_$MessageDraftImpl> get copyWith =>
      __$$MessageDraftImplCopyWithImpl<_$MessageDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageDraftImplToJson(this);
  }
}

abstract class _MessageDraft extends MessageDraft {
  const factory _MessageDraft({
    final String content,
    final MessageType type,
    final String? replyToMessageId,
    final VoiceMessage? voiceMessage,
    final ImageMessage? imageMessage,
    final bool isSelfDestruct,
    final Duration? selfDestructDuration,
  }) = _$MessageDraftImpl;
  const _MessageDraft._() : super._();

  factory _MessageDraft.fromJson(Map<String, dynamic> json) =
      _$MessageDraftImpl.fromJson;

  @override
  String get content;
  @override
  MessageType get type;
  @override
  String? get replyToMessageId;
  @override
  VoiceMessage? get voiceMessage;
  @override
  ImageMessage? get imageMessage;
  @override
  bool get isSelfDestruct;
  @override
  Duration? get selfDestructDuration;

  /// Create a copy of MessageDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageDraftImplCopyWith<_$MessageDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TypingIndicator _$TypingIndicatorFromJson(Map<String, dynamic> json) {
  return _TypingIndicator.fromJson(json);
}

/// @nodoc
mixin _$TypingIndicator {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this TypingIndicator to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TypingIndicatorCopyWith<TypingIndicator> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypingIndicatorCopyWith<$Res> {
  factory $TypingIndicatorCopyWith(
    TypingIndicator value,
    $Res Function(TypingIndicator) then,
  ) = _$TypingIndicatorCopyWithImpl<$Res, TypingIndicator>;
  @useResult
  $Res call({
    String userId,
    String userName,
    DateTime startedAt,
    bool isActive,
  });
}

/// @nodoc
class _$TypingIndicatorCopyWithImpl<$Res, $Val extends TypingIndicator>
    implements $TypingIndicatorCopyWith<$Res> {
  _$TypingIndicatorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? startedAt = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TypingIndicatorImplCopyWith<$Res>
    implements $TypingIndicatorCopyWith<$Res> {
  factory _$$TypingIndicatorImplCopyWith(
    _$TypingIndicatorImpl value,
    $Res Function(_$TypingIndicatorImpl) then,
  ) = __$$TypingIndicatorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String userName,
    DateTime startedAt,
    bool isActive,
  });
}

/// @nodoc
class __$$TypingIndicatorImplCopyWithImpl<$Res>
    extends _$TypingIndicatorCopyWithImpl<$Res, _$TypingIndicatorImpl>
    implements _$$TypingIndicatorImplCopyWith<$Res> {
  __$$TypingIndicatorImplCopyWithImpl(
    _$TypingIndicatorImpl _value,
    $Res Function(_$TypingIndicatorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? startedAt = null,
    Object? isActive = null,
  }) {
    return _then(
      _$TypingIndicatorImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TypingIndicatorImpl extends _TypingIndicator {
  const _$TypingIndicatorImpl({
    required this.userId,
    required this.userName,
    required this.startedAt,
    this.isActive = false,
  }) : super._();

  factory _$TypingIndicatorImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypingIndicatorImplFromJson(json);

  @override
  final String userId;
  @override
  final String userName;
  @override
  final DateTime startedAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'TypingIndicator(userId: $userId, userName: $userName, startedAt: $startedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypingIndicatorImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, userName, startedAt, isActive);

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TypingIndicatorImplCopyWith<_$TypingIndicatorImpl> get copyWith =>
      __$$TypingIndicatorImplCopyWithImpl<_$TypingIndicatorImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TypingIndicatorImplToJson(this);
  }
}

abstract class _TypingIndicator extends TypingIndicator {
  const factory _TypingIndicator({
    required final String userId,
    required final String userName,
    required final DateTime startedAt,
    final bool isActive,
  }) = _$TypingIndicatorImpl;
  const _TypingIndicator._() : super._();

  factory _TypingIndicator.fromJson(Map<String, dynamic> json) =
      _$TypingIndicatorImpl.fromJson;

  @override
  String get userId;
  @override
  String get userName;
  @override
  DateTime get startedAt;
  @override
  bool get isActive;

  /// Create a copy of TypingIndicator
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TypingIndicatorImplCopyWith<_$TypingIndicatorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReadReceipt _$ReadReceiptFromJson(Map<String, dynamic> json) {
  return _ReadReceipt.fromJson(json);
}

/// @nodoc
mixin _$ReadReceipt {
  String get messageId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  DateTime get readAt => throw _privateConstructorUsedError;

  /// Serializes this ReadReceipt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadReceiptCopyWith<ReadReceipt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadReceiptCopyWith<$Res> {
  factory $ReadReceiptCopyWith(
    ReadReceipt value,
    $Res Function(ReadReceipt) then,
  ) = _$ReadReceiptCopyWithImpl<$Res, ReadReceipt>;
  @useResult
  $Res call({
    String messageId,
    String userId,
    String userName,
    DateTime readAt,
  });
}

/// @nodoc
class _$ReadReceiptCopyWithImpl<$Res, $Val extends ReadReceipt>
    implements $ReadReceiptCopyWith<$Res> {
  _$ReadReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? userId = null,
    Object? userName = null,
    Object? readAt = null,
  }) {
    return _then(
      _value.copyWith(
            messageId: null == messageId
                ? _value.messageId
                : messageId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            readAt: null == readAt
                ? _value.readAt
                : readAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadReceiptImplCopyWith<$Res>
    implements $ReadReceiptCopyWith<$Res> {
  factory _$$ReadReceiptImplCopyWith(
    _$ReadReceiptImpl value,
    $Res Function(_$ReadReceiptImpl) then,
  ) = __$$ReadReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String messageId,
    String userId,
    String userName,
    DateTime readAt,
  });
}

/// @nodoc
class __$$ReadReceiptImplCopyWithImpl<$Res>
    extends _$ReadReceiptCopyWithImpl<$Res, _$ReadReceiptImpl>
    implements _$$ReadReceiptImplCopyWith<$Res> {
  __$$ReadReceiptImplCopyWithImpl(
    _$ReadReceiptImpl _value,
    $Res Function(_$ReadReceiptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? userId = null,
    Object? userName = null,
    Object? readAt = null,
  }) {
    return _then(
      _$ReadReceiptImpl(
        messageId: null == messageId
            ? _value.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        readAt: null == readAt
            ? _value.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadReceiptImpl implements _ReadReceipt {
  const _$ReadReceiptImpl({
    required this.messageId,
    required this.userId,
    required this.userName,
    required this.readAt,
  });

  factory _$ReadReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadReceiptImplFromJson(json);

  @override
  final String messageId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final DateTime readAt;

  @override
  String toString() {
    return 'ReadReceipt(messageId: $messageId, userId: $userId, userName: $userName, readAt: $readAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadReceiptImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.readAt, readAt) || other.readAt == readAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, messageId, userId, userName, readAt);

  /// Create a copy of ReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadReceiptImplCopyWith<_$ReadReceiptImpl> get copyWith =>
      __$$ReadReceiptImplCopyWithImpl<_$ReadReceiptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadReceiptImplToJson(this);
  }
}

abstract class _ReadReceipt implements ReadReceipt {
  const factory _ReadReceipt({
    required final String messageId,
    required final String userId,
    required final String userName,
    required final DateTime readAt,
  }) = _$ReadReceiptImpl;

  factory _ReadReceipt.fromJson(Map<String, dynamic> json) =
      _$ReadReceiptImpl.fromJson;

  @override
  String get messageId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  DateTime get readAt;

  /// Create a copy of ReadReceipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadReceiptImplCopyWith<_$ReadReceiptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
