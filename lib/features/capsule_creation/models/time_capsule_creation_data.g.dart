// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_capsule_creation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeCapsuleCreationDataImpl _$$TimeCapsuleCreationDataImplFromJson(
  Map<String, dynamic> json,
) => _$TimeCapsuleCreationDataImpl(
  selectedPurpose: $enumDecodeNullable(
    _$TimeCapsulePurposeEnumMap,
    json['selectedPurpose'],
  ),
  currentStep: (json['currentStep'] as num?)?.toInt() ?? 1,
  showContinueButton: json['showContinueButton'] as bool? ?? false,
  selectedQuickStart: $enumDecodeNullable(
    _$QuickStartTypeEnumMap,
    json['selectedQuickStart'],
  ),
  isLoading: json['isLoading'] as bool? ?? false,
  creationStartedAt: json['creationStartedAt'] == null
      ? null
      : DateTime.parse(json['creationStartedAt'] as String),
);

Map<String, dynamic> _$$TimeCapsuleCreationDataImplToJson(
  _$TimeCapsuleCreationDataImpl instance,
) => <String, dynamic>{
  'selectedPurpose': _$TimeCapsulePurposeEnumMap[instance.selectedPurpose],
  'currentStep': instance.currentStep,
  'showContinueButton': instance.showContinueButton,
  'selectedQuickStart': _$QuickStartTypeEnumMap[instance.selectedQuickStart],
  'isLoading': instance.isLoading,
  'creationStartedAt': instance.creationStartedAt?.toIso8601String(),
};

const _$TimeCapsulePurposeEnumMap = {
  TimeCapsulePurpose.futureMe: 'future-me',
  TimeCapsulePurpose.someoneSpecial: 'someone-special',
  TimeCapsulePurpose.anonymous: 'anonymous',
};

const _$QuickStartTypeEnumMap = {
  QuickStartType.birthday: 'birthday',
  QuickStartType.encouragement: 'encouragement',
  QuickStartType.anniversary: 'anniversary',
  QuickStartType.gratitude: 'gratitude',
};
