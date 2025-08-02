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
  selectedTimeOption: $enumDecodeNullable(
    _$TimeOptionEnumMap,
    json['selectedTimeOption'],
  ),
  selectedOccasion: $enumDecodeNullable(
    _$SpecialOccasionEnumMap,
    json['selectedOccasion'],
  ),
  customDateTime: json['customDateTime'] == null
      ? null
      : CustomDateTime.fromJson(json['customDateTime'] as Map<String, dynamic>),
  timeMetaphor: json['timeMetaphor'] as String? ?? '🌰',
  timeDisplay: json['timeDisplay'] as String? ?? 'Select Time',
  timeDescription:
      json['timeDescription'] as String? ??
      'Choose when you\'d like to receive this message',
  growthStage: json['growthStage'] as String? ?? 'Ready to Plant',
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
  'selectedTimeOption': _$TimeOptionEnumMap[instance.selectedTimeOption],
  'selectedOccasion': _$SpecialOccasionEnumMap[instance.selectedOccasion],
  'customDateTime': instance.customDateTime,
  'timeMetaphor': instance.timeMetaphor,
  'timeDisplay': instance.timeDisplay,
  'timeDescription': instance.timeDescription,
  'growthStage': instance.growthStage,
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

const _$TimeOptionEnumMap = {
  TimeOption.oneHour: '1-hour',
  TimeOption.oneDay: '1-day',
  TimeOption.oneWeek: '1-week',
  TimeOption.oneMonth: '1-month',
  TimeOption.sixMonths: '6-months',
  TimeOption.oneYear: '1-year',
};

const _$SpecialOccasionEnumMap = {
  SpecialOccasion.birthday: 'birthday',
  SpecialOccasion.newYear: 'new-year',
  SpecialOccasion.graduation: 'graduation',
  SpecialOccasion.jobStart: 'job-start',
  SpecialOccasion.anniversary: 'anniversary',
  SpecialOccasion.milestone: 'milestone',
};

_$CustomDateTimeImpl _$$CustomDateTimeImplFromJson(Map<String, dynamic> json) =>
    _$CustomDateTimeImpl(
      dateTime: DateTime.parse(json['dateTime'] as String),
      previewText: json['previewText'] as String,
    );

Map<String, dynamic> _$$CustomDateTimeImplToJson(
  _$CustomDateTimeImpl instance,
) => <String, dynamic>{
  'dateTime': instance.dateTime.toIso8601String(),
  'previewText': instance.previewText,
};
