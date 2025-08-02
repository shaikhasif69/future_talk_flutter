// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_message_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousMessageSettings _$AnonymousMessageSettingsFromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousMessageSettings.fromJson(json);
}

/// @nodoc
mixin _$AnonymousMessageSettings {
  /// Whether to notify the recipient about the incoming anonymous capsule
  bool get notifyAboutCapsule => throw _privateConstructorUsedError;

  /// Identity reveal preference for the sender
  IdentityRevealOption get identityRevealOption =>
      throw _privateConstructorUsedError;

  /// Whether the message should disappear after being read once
  bool get oneTimeView => throw _privateConstructorUsedError;

  /// Whether to include a delivery hint about who might have sent this
  bool get includeDeliveryHint => throw _privateConstructorUsedError;

  /// Custom delivery hint text (optional)
  String? get customDeliveryHint => throw _privateConstructorUsedError;

  /// Anonymous delivery method preference
  AnonymousDeliveryMethod get deliveryMethod =>
      throw _privateConstructorUsedError;

  /// Serializes this AnonymousMessageSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousMessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousMessageSettingsCopyWith<AnonymousMessageSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousMessageSettingsCopyWith<$Res> {
  factory $AnonymousMessageSettingsCopyWith(
    AnonymousMessageSettings value,
    $Res Function(AnonymousMessageSettings) then,
  ) = _$AnonymousMessageSettingsCopyWithImpl<$Res, AnonymousMessageSettings>;
  @useResult
  $Res call({
    bool notifyAboutCapsule,
    IdentityRevealOption identityRevealOption,
    bool oneTimeView,
    bool includeDeliveryHint,
    String? customDeliveryHint,
    AnonymousDeliveryMethod deliveryMethod,
  });
}

/// @nodoc
class _$AnonymousMessageSettingsCopyWithImpl<
  $Res,
  $Val extends AnonymousMessageSettings
>
    implements $AnonymousMessageSettingsCopyWith<$Res> {
  _$AnonymousMessageSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousMessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifyAboutCapsule = null,
    Object? identityRevealOption = null,
    Object? oneTimeView = null,
    Object? includeDeliveryHint = null,
    Object? customDeliveryHint = freezed,
    Object? deliveryMethod = null,
  }) {
    return _then(
      _value.copyWith(
            notifyAboutCapsule: null == notifyAboutCapsule
                ? _value.notifyAboutCapsule
                : notifyAboutCapsule // ignore: cast_nullable_to_non_nullable
                      as bool,
            identityRevealOption: null == identityRevealOption
                ? _value.identityRevealOption
                : identityRevealOption // ignore: cast_nullable_to_non_nullable
                      as IdentityRevealOption,
            oneTimeView: null == oneTimeView
                ? _value.oneTimeView
                : oneTimeView // ignore: cast_nullable_to_non_nullable
                      as bool,
            includeDeliveryHint: null == includeDeliveryHint
                ? _value.includeDeliveryHint
                : includeDeliveryHint // ignore: cast_nullable_to_non_nullable
                      as bool,
            customDeliveryHint: freezed == customDeliveryHint
                ? _value.customDeliveryHint
                : customDeliveryHint // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryMethod: null == deliveryMethod
                ? _value.deliveryMethod
                : deliveryMethod // ignore: cast_nullable_to_non_nullable
                      as AnonymousDeliveryMethod,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnonymousMessageSettingsImplCopyWith<$Res>
    implements $AnonymousMessageSettingsCopyWith<$Res> {
  factory _$$AnonymousMessageSettingsImplCopyWith(
    _$AnonymousMessageSettingsImpl value,
    $Res Function(_$AnonymousMessageSettingsImpl) then,
  ) = __$$AnonymousMessageSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool notifyAboutCapsule,
    IdentityRevealOption identityRevealOption,
    bool oneTimeView,
    bool includeDeliveryHint,
    String? customDeliveryHint,
    AnonymousDeliveryMethod deliveryMethod,
  });
}

/// @nodoc
class __$$AnonymousMessageSettingsImplCopyWithImpl<$Res>
    extends
        _$AnonymousMessageSettingsCopyWithImpl<
          $Res,
          _$AnonymousMessageSettingsImpl
        >
    implements _$$AnonymousMessageSettingsImplCopyWith<$Res> {
  __$$AnonymousMessageSettingsImplCopyWithImpl(
    _$AnonymousMessageSettingsImpl _value,
    $Res Function(_$AnonymousMessageSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousMessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifyAboutCapsule = null,
    Object? identityRevealOption = null,
    Object? oneTimeView = null,
    Object? includeDeliveryHint = null,
    Object? customDeliveryHint = freezed,
    Object? deliveryMethod = null,
  }) {
    return _then(
      _$AnonymousMessageSettingsImpl(
        notifyAboutCapsule: null == notifyAboutCapsule
            ? _value.notifyAboutCapsule
            : notifyAboutCapsule // ignore: cast_nullable_to_non_nullable
                  as bool,
        identityRevealOption: null == identityRevealOption
            ? _value.identityRevealOption
            : identityRevealOption // ignore: cast_nullable_to_non_nullable
                  as IdentityRevealOption,
        oneTimeView: null == oneTimeView
            ? _value.oneTimeView
            : oneTimeView // ignore: cast_nullable_to_non_nullable
                  as bool,
        includeDeliveryHint: null == includeDeliveryHint
            ? _value.includeDeliveryHint
            : includeDeliveryHint // ignore: cast_nullable_to_non_nullable
                  as bool,
        customDeliveryHint: freezed == customDeliveryHint
            ? _value.customDeliveryHint
            : customDeliveryHint // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryMethod: null == deliveryMethod
            ? _value.deliveryMethod
            : deliveryMethod // ignore: cast_nullable_to_non_nullable
                  as AnonymousDeliveryMethod,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousMessageSettingsImpl implements _AnonymousMessageSettings {
  const _$AnonymousMessageSettingsImpl({
    this.notifyAboutCapsule = true,
    this.identityRevealOption = IdentityRevealOption.stayAnonymous,
    this.oneTimeView = false,
    this.includeDeliveryHint = false,
    this.customDeliveryHint,
    this.deliveryMethod = AnonymousDeliveryMethod.silent,
  });

  factory _$AnonymousMessageSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousMessageSettingsImplFromJson(json);

  /// Whether to notify the recipient about the incoming anonymous capsule
  @override
  @JsonKey()
  final bool notifyAboutCapsule;

  /// Identity reveal preference for the sender
  @override
  @JsonKey()
  final IdentityRevealOption identityRevealOption;

  /// Whether the message should disappear after being read once
  @override
  @JsonKey()
  final bool oneTimeView;

  /// Whether to include a delivery hint about who might have sent this
  @override
  @JsonKey()
  final bool includeDeliveryHint;

  /// Custom delivery hint text (optional)
  @override
  final String? customDeliveryHint;

  /// Anonymous delivery method preference
  @override
  @JsonKey()
  final AnonymousDeliveryMethod deliveryMethod;

  @override
  String toString() {
    return 'AnonymousMessageSettings(notifyAboutCapsule: $notifyAboutCapsule, identityRevealOption: $identityRevealOption, oneTimeView: $oneTimeView, includeDeliveryHint: $includeDeliveryHint, customDeliveryHint: $customDeliveryHint, deliveryMethod: $deliveryMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousMessageSettingsImpl &&
            (identical(other.notifyAboutCapsule, notifyAboutCapsule) ||
                other.notifyAboutCapsule == notifyAboutCapsule) &&
            (identical(other.identityRevealOption, identityRevealOption) ||
                other.identityRevealOption == identityRevealOption) &&
            (identical(other.oneTimeView, oneTimeView) ||
                other.oneTimeView == oneTimeView) &&
            (identical(other.includeDeliveryHint, includeDeliveryHint) ||
                other.includeDeliveryHint == includeDeliveryHint) &&
            (identical(other.customDeliveryHint, customDeliveryHint) ||
                other.customDeliveryHint == customDeliveryHint) &&
            (identical(other.deliveryMethod, deliveryMethod) ||
                other.deliveryMethod == deliveryMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    notifyAboutCapsule,
    identityRevealOption,
    oneTimeView,
    includeDeliveryHint,
    customDeliveryHint,
    deliveryMethod,
  );

  /// Create a copy of AnonymousMessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousMessageSettingsImplCopyWith<_$AnonymousMessageSettingsImpl>
  get copyWith =>
      __$$AnonymousMessageSettingsImplCopyWithImpl<
        _$AnonymousMessageSettingsImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousMessageSettingsImplToJson(this);
  }
}

abstract class _AnonymousMessageSettings implements AnonymousMessageSettings {
  const factory _AnonymousMessageSettings({
    final bool notifyAboutCapsule,
    final IdentityRevealOption identityRevealOption,
    final bool oneTimeView,
    final bool includeDeliveryHint,
    final String? customDeliveryHint,
    final AnonymousDeliveryMethod deliveryMethod,
  }) = _$AnonymousMessageSettingsImpl;

  factory _AnonymousMessageSettings.fromJson(Map<String, dynamic> json) =
      _$AnonymousMessageSettingsImpl.fromJson;

  /// Whether to notify the recipient about the incoming anonymous capsule
  @override
  bool get notifyAboutCapsule;

  /// Identity reveal preference for the sender
  @override
  IdentityRevealOption get identityRevealOption;

  /// Whether the message should disappear after being read once
  @override
  bool get oneTimeView;

  /// Whether to include a delivery hint about who might have sent this
  @override
  bool get includeDeliveryHint;

  /// Custom delivery hint text (optional)
  @override
  String? get customDeliveryHint;

  /// Anonymous delivery method preference
  @override
  AnonymousDeliveryMethod get deliveryMethod;

  /// Create a copy of AnonymousMessageSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousMessageSettingsImplCopyWith<_$AnonymousMessageSettingsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
