// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageSettings _$MessageSettingsFromJson(Map<String, dynamic> json) {
  return _MessageSettings.fromJson(json);
}

/// @nodoc
mixin _$MessageSettings {
  /// Whether to notify the recipient about the capsule
  /// Default: true - Let them know a time capsule is waiting
  bool get notifyAboutCapsule => throw _privateConstructorUsedError;

  /// Whether to send the capsule anonymously
  /// Default: false - Sender identity is revealed by default
  bool get anonymousSending => throw _privateConstructorUsedError;

  /// Whether the message can only be viewed once
  /// Default: false - Message can be re-read
  bool get oneTimeView => throw _privateConstructorUsedError;

  /// How the final message should be delivered
  /// Default: app only
  DeliveryMethod get deliveryMethod => throw _privateConstructorUsedError;

  /// Whether to allow the recipient to share the message
  /// Default: true - Recipient can share with others
  bool get allowSharing => throw _privateConstructorUsedError;

  /// Whether to send delivery confirmation to sender
  /// Default: true - Sender gets notified when message is read
  bool get sendDeliveryConfirmation => throw _privateConstructorUsedError;

  /// Custom delivery time zone (if different from sender's)
  String? get customTimeZone => throw _privateConstructorUsedError;

  /// Additional delivery instructions or notes
  String? get deliveryNotes => throw _privateConstructorUsedError;

  /// Serializes this MessageSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageSettingsCopyWith<MessageSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageSettingsCopyWith<$Res> {
  factory $MessageSettingsCopyWith(
    MessageSettings value,
    $Res Function(MessageSettings) then,
  ) = _$MessageSettingsCopyWithImpl<$Res, MessageSettings>;
  @useResult
  $Res call({
    bool notifyAboutCapsule,
    bool anonymousSending,
    bool oneTimeView,
    DeliveryMethod deliveryMethod,
    bool allowSharing,
    bool sendDeliveryConfirmation,
    String? customTimeZone,
    String? deliveryNotes,
  });
}

/// @nodoc
class _$MessageSettingsCopyWithImpl<$Res, $Val extends MessageSettings>
    implements $MessageSettingsCopyWith<$Res> {
  _$MessageSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifyAboutCapsule = null,
    Object? anonymousSending = null,
    Object? oneTimeView = null,
    Object? deliveryMethod = null,
    Object? allowSharing = null,
    Object? sendDeliveryConfirmation = null,
    Object? customTimeZone = freezed,
    Object? deliveryNotes = freezed,
  }) {
    return _then(
      _value.copyWith(
            notifyAboutCapsule: null == notifyAboutCapsule
                ? _value.notifyAboutCapsule
                : notifyAboutCapsule // ignore: cast_nullable_to_non_nullable
                      as bool,
            anonymousSending: null == anonymousSending
                ? _value.anonymousSending
                : anonymousSending // ignore: cast_nullable_to_non_nullable
                      as bool,
            oneTimeView: null == oneTimeView
                ? _value.oneTimeView
                : oneTimeView // ignore: cast_nullable_to_non_nullable
                      as bool,
            deliveryMethod: null == deliveryMethod
                ? _value.deliveryMethod
                : deliveryMethod // ignore: cast_nullable_to_non_nullable
                      as DeliveryMethod,
            allowSharing: null == allowSharing
                ? _value.allowSharing
                : allowSharing // ignore: cast_nullable_to_non_nullable
                      as bool,
            sendDeliveryConfirmation: null == sendDeliveryConfirmation
                ? _value.sendDeliveryConfirmation
                : sendDeliveryConfirmation // ignore: cast_nullable_to_non_nullable
                      as bool,
            customTimeZone: freezed == customTimeZone
                ? _value.customTimeZone
                : customTimeZone // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryNotes: freezed == deliveryNotes
                ? _value.deliveryNotes
                : deliveryNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageSettingsImplCopyWith<$Res>
    implements $MessageSettingsCopyWith<$Res> {
  factory _$$MessageSettingsImplCopyWith(
    _$MessageSettingsImpl value,
    $Res Function(_$MessageSettingsImpl) then,
  ) = __$$MessageSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool notifyAboutCapsule,
    bool anonymousSending,
    bool oneTimeView,
    DeliveryMethod deliveryMethod,
    bool allowSharing,
    bool sendDeliveryConfirmation,
    String? customTimeZone,
    String? deliveryNotes,
  });
}

/// @nodoc
class __$$MessageSettingsImplCopyWithImpl<$Res>
    extends _$MessageSettingsCopyWithImpl<$Res, _$MessageSettingsImpl>
    implements _$$MessageSettingsImplCopyWith<$Res> {
  __$$MessageSettingsImplCopyWithImpl(
    _$MessageSettingsImpl _value,
    $Res Function(_$MessageSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifyAboutCapsule = null,
    Object? anonymousSending = null,
    Object? oneTimeView = null,
    Object? deliveryMethod = null,
    Object? allowSharing = null,
    Object? sendDeliveryConfirmation = null,
    Object? customTimeZone = freezed,
    Object? deliveryNotes = freezed,
  }) {
    return _then(
      _$MessageSettingsImpl(
        notifyAboutCapsule: null == notifyAboutCapsule
            ? _value.notifyAboutCapsule
            : notifyAboutCapsule // ignore: cast_nullable_to_non_nullable
                  as bool,
        anonymousSending: null == anonymousSending
            ? _value.anonymousSending
            : anonymousSending // ignore: cast_nullable_to_non_nullable
                  as bool,
        oneTimeView: null == oneTimeView
            ? _value.oneTimeView
            : oneTimeView // ignore: cast_nullable_to_non_nullable
                  as bool,
        deliveryMethod: null == deliveryMethod
            ? _value.deliveryMethod
            : deliveryMethod // ignore: cast_nullable_to_non_nullable
                  as DeliveryMethod,
        allowSharing: null == allowSharing
            ? _value.allowSharing
            : allowSharing // ignore: cast_nullable_to_non_nullable
                  as bool,
        sendDeliveryConfirmation: null == sendDeliveryConfirmation
            ? _value.sendDeliveryConfirmation
            : sendDeliveryConfirmation // ignore: cast_nullable_to_non_nullable
                  as bool,
        customTimeZone: freezed == customTimeZone
            ? _value.customTimeZone
            : customTimeZone // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryNotes: freezed == deliveryNotes
            ? _value.deliveryNotes
            : deliveryNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageSettingsImpl implements _MessageSettings {
  const _$MessageSettingsImpl({
    this.notifyAboutCapsule = true,
    this.anonymousSending = false,
    this.oneTimeView = false,
    this.deliveryMethod = DeliveryMethod.appOnly,
    this.allowSharing = true,
    this.sendDeliveryConfirmation = true,
    this.customTimeZone,
    this.deliveryNotes,
  });

  factory _$MessageSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageSettingsImplFromJson(json);

  /// Whether to notify the recipient about the capsule
  /// Default: true - Let them know a time capsule is waiting
  @override
  @JsonKey()
  final bool notifyAboutCapsule;

  /// Whether to send the capsule anonymously
  /// Default: false - Sender identity is revealed by default
  @override
  @JsonKey()
  final bool anonymousSending;

  /// Whether the message can only be viewed once
  /// Default: false - Message can be re-read
  @override
  @JsonKey()
  final bool oneTimeView;

  /// How the final message should be delivered
  /// Default: app only
  @override
  @JsonKey()
  final DeliveryMethod deliveryMethod;

  /// Whether to allow the recipient to share the message
  /// Default: true - Recipient can share with others
  @override
  @JsonKey()
  final bool allowSharing;

  /// Whether to send delivery confirmation to sender
  /// Default: true - Sender gets notified when message is read
  @override
  @JsonKey()
  final bool sendDeliveryConfirmation;

  /// Custom delivery time zone (if different from sender's)
  @override
  final String? customTimeZone;

  /// Additional delivery instructions or notes
  @override
  final String? deliveryNotes;

  @override
  String toString() {
    return 'MessageSettings(notifyAboutCapsule: $notifyAboutCapsule, anonymousSending: $anonymousSending, oneTimeView: $oneTimeView, deliveryMethod: $deliveryMethod, allowSharing: $allowSharing, sendDeliveryConfirmation: $sendDeliveryConfirmation, customTimeZone: $customTimeZone, deliveryNotes: $deliveryNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageSettingsImpl &&
            (identical(other.notifyAboutCapsule, notifyAboutCapsule) ||
                other.notifyAboutCapsule == notifyAboutCapsule) &&
            (identical(other.anonymousSending, anonymousSending) ||
                other.anonymousSending == anonymousSending) &&
            (identical(other.oneTimeView, oneTimeView) ||
                other.oneTimeView == oneTimeView) &&
            (identical(other.deliveryMethod, deliveryMethod) ||
                other.deliveryMethod == deliveryMethod) &&
            (identical(other.allowSharing, allowSharing) ||
                other.allowSharing == allowSharing) &&
            (identical(
                  other.sendDeliveryConfirmation,
                  sendDeliveryConfirmation,
                ) ||
                other.sendDeliveryConfirmation == sendDeliveryConfirmation) &&
            (identical(other.customTimeZone, customTimeZone) ||
                other.customTimeZone == customTimeZone) &&
            (identical(other.deliveryNotes, deliveryNotes) ||
                other.deliveryNotes == deliveryNotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    notifyAboutCapsule,
    anonymousSending,
    oneTimeView,
    deliveryMethod,
    allowSharing,
    sendDeliveryConfirmation,
    customTimeZone,
    deliveryNotes,
  );

  /// Create a copy of MessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageSettingsImplCopyWith<_$MessageSettingsImpl> get copyWith =>
      __$$MessageSettingsImplCopyWithImpl<_$MessageSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageSettingsImplToJson(this);
  }
}

abstract class _MessageSettings implements MessageSettings {
  const factory _MessageSettings({
    final bool notifyAboutCapsule,
    final bool anonymousSending,
    final bool oneTimeView,
    final DeliveryMethod deliveryMethod,
    final bool allowSharing,
    final bool sendDeliveryConfirmation,
    final String? customTimeZone,
    final String? deliveryNotes,
  }) = _$MessageSettingsImpl;

  factory _MessageSettings.fromJson(Map<String, dynamic> json) =
      _$MessageSettingsImpl.fromJson;

  /// Whether to notify the recipient about the capsule
  /// Default: true - Let them know a time capsule is waiting
  @override
  bool get notifyAboutCapsule;

  /// Whether to send the capsule anonymously
  /// Default: false - Sender identity is revealed by default
  @override
  bool get anonymousSending;

  /// Whether the message can only be viewed once
  /// Default: false - Message can be re-read
  @override
  bool get oneTimeView;

  /// How the final message should be delivered
  /// Default: app only
  @override
  DeliveryMethod get deliveryMethod;

  /// Whether to allow the recipient to share the message
  /// Default: true - Recipient can share with others
  @override
  bool get allowSharing;

  /// Whether to send delivery confirmation to sender
  /// Default: true - Sender gets notified when message is read
  @override
  bool get sendDeliveryConfirmation;

  /// Custom delivery time zone (if different from sender's)
  @override
  String? get customTimeZone;

  /// Additional delivery instructions or notes
  @override
  String? get deliveryNotes;

  /// Create a copy of MessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageSettingsImplCopyWith<_$MessageSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
