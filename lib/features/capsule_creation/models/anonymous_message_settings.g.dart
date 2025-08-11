// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_message_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousMessageSettingsImpl _$$AnonymousMessageSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$AnonymousMessageSettingsImpl(
      notifyAboutCapsule: json['notifyAboutCapsule'] as bool? ?? true,
      identityRevealOption: $enumDecodeNullable(
              _$IdentityRevealOptionEnumMap, json['identityRevealOption']) ??
          IdentityRevealOption.stayAnonymous,
      oneTimeView: json['oneTimeView'] as bool? ?? false,
      includeDeliveryHint: json['includeDeliveryHint'] as bool? ?? false,
      customDeliveryHint: json['customDeliveryHint'] as String?,
      deliveryMethod: $enumDecodeNullable(
              _$AnonymousDeliveryMethodEnumMap, json['deliveryMethod']) ??
          AnonymousDeliveryMethod.silent,
    );

Map<String, dynamic> _$$AnonymousMessageSettingsImplToJson(
        _$AnonymousMessageSettingsImpl instance) =>
    <String, dynamic>{
      'notifyAboutCapsule': instance.notifyAboutCapsule,
      'identityRevealOption':
          _$IdentityRevealOptionEnumMap[instance.identityRevealOption]!,
      'oneTimeView': instance.oneTimeView,
      'includeDeliveryHint': instance.includeDeliveryHint,
      'customDeliveryHint': instance.customDeliveryHint,
      'deliveryMethod':
          _$AnonymousDeliveryMethodEnumMap[instance.deliveryMethod]!,
    };

const _$IdentityRevealOptionEnumMap = {
  IdentityRevealOption.stayAnonymous: 'stay_anonymous',
  IdentityRevealOption.canRevealLater: 'can_reveal_later',
};

const _$AnonymousDeliveryMethodEnumMap = {
  AnonymousDeliveryMethod.silent: 'silent',
  AnonymousDeliveryMethod.mysterious: 'mysterious',
  AnonymousDeliveryMethod.gentle: 'gentle',
};
