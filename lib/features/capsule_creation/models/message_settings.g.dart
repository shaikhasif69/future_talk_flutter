// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageSettingsImpl _$$MessageSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$MessageSettingsImpl(
  notifyAboutCapsule: json['notifyAboutCapsule'] as bool? ?? true,
  anonymousSending: json['anonymousSending'] as bool? ?? false,
  oneTimeView: json['oneTimeView'] as bool? ?? false,
  deliveryMethod:
      $enumDecodeNullable(_$DeliveryMethodEnumMap, json['deliveryMethod']) ??
      DeliveryMethod.appOnly,
  allowSharing: json['allowSharing'] as bool? ?? true,
  sendDeliveryConfirmation: json['sendDeliveryConfirmation'] as bool? ?? true,
  customTimeZone: json['customTimeZone'] as String?,
  deliveryNotes: json['deliveryNotes'] as String?,
);

Map<String, dynamic> _$$MessageSettingsImplToJson(
  _$MessageSettingsImpl instance,
) => <String, dynamic>{
  'notifyAboutCapsule': instance.notifyAboutCapsule,
  'anonymousSending': instance.anonymousSending,
  'oneTimeView': instance.oneTimeView,
  'deliveryMethod': _$DeliveryMethodEnumMap[instance.deliveryMethod]!,
  'allowSharing': instance.allowSharing,
  'sendDeliveryConfirmation': instance.sendDeliveryConfirmation,
  'customTimeZone': instance.customTimeZone,
  'deliveryNotes': instance.deliveryNotes,
};

const _$DeliveryMethodEnumMap = {
  DeliveryMethod.appOnly: 'app-only',
  DeliveryMethod.appAndEmail: 'app-and-email',
  DeliveryMethod.emailOnly: 'email-only',
};
