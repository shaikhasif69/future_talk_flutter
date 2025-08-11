// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_creation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageCreationDataImpl _$$MessageCreationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageCreationDataImpl(
      textContent: json['textContent'] as String? ?? '',
      voiceRecordings: (json['voiceRecordings'] as List<dynamic>?)
              ?.map((e) => VoiceRecording.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      mode: $enumDecodeNullable(_$MessageModeEnumMap, json['mode']) ??
          MessageMode.write,
      selectedFont:
          $enumDecodeNullable(_$MessageFontEnumMap, json['selectedFont']) ??
              MessageFont.crimsonPro,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
      wordCount: (json['wordCount'] as num?)?.toInt() ?? 0,
      characterCount: (json['characterCount'] as num?)?.toInt() ?? 0,
      isRecording: json['isRecording'] as bool? ?? false,
      recordingDuration: (json['recordingDuration'] as num?)?.toInt() ?? 0,
      isLoading: json['isLoading'] as bool? ?? false,
      lastAutoSave: json['lastAutoSave'] == null
          ? null
          : DateTime.parse(json['lastAutoSave'] as String),
      draftId: json['draftId'] as String?,
      hasUnsavedChanges: json['hasUnsavedChanges'] as bool? ?? false,
      sessionStartTime: json['sessionStartTime'] == null
          ? null
          : DateTime.parse(json['sessionStartTime'] as String),
      totalWritingTime: (json['totalWritingTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MessageCreationDataImplToJson(
        _$MessageCreationDataImpl instance) =>
    <String, dynamic>{
      'textContent': instance.textContent,
      'voiceRecordings': instance.voiceRecordings,
      'mode': _$MessageModeEnumMap[instance.mode]!,
      'selectedFont': _$MessageFontEnumMap[instance.selectedFont]!,
      'fontSize': instance.fontSize,
      'wordCount': instance.wordCount,
      'characterCount': instance.characterCount,
      'isRecording': instance.isRecording,
      'recordingDuration': instance.recordingDuration,
      'isLoading': instance.isLoading,
      'lastAutoSave': instance.lastAutoSave?.toIso8601String(),
      'draftId': instance.draftId,
      'hasUnsavedChanges': instance.hasUnsavedChanges,
      'sessionStartTime': instance.sessionStartTime?.toIso8601String(),
      'totalWritingTime': instance.totalWritingTime,
    };

const _$MessageModeEnumMap = {
  MessageMode.write: 'write',
  MessageMode.record: 'record',
};

const _$MessageFontEnumMap = {
  MessageFont.crimsonPro: 'crimson-pro',
  MessageFont.playfairDisplay: 'playfair-display',
  MessageFont.dancingScript: 'dancing-script',
  MessageFont.caveat: 'caveat',
  MessageFont.kalam: 'kalam',
  MessageFont.patrickHand: 'patrick-hand',
  MessageFont.satisfy: 'satisfy',
  MessageFont.system: 'system',
};

_$VoiceRecordingImpl _$$VoiceRecordingImplFromJson(Map<String, dynamic> json) =>
    _$VoiceRecordingImpl(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      duration: (json['duration'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      waveformData: (json['waveformData'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      quality: $enumDecodeNullable(_$RecordingQualityEnumMap, json['quality']),
      isEmbedded: json['isEmbedded'] as bool? ?? false,
      textPosition: (json['textPosition'] as num?)?.toInt(),
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$$VoiceRecordingImplToJson(
        _$VoiceRecordingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filePath': instance.filePath,
      'duration': instance.duration,
      'createdAt': instance.createdAt.toIso8601String(),
      'waveformData': instance.waveformData,
      'quality': _$RecordingQualityEnumMap[instance.quality],
      'isEmbedded': instance.isEmbedded,
      'textPosition': instance.textPosition,
      'displayName': instance.displayName,
    };

const _$RecordingQualityEnumMap = {
  RecordingQuality.low: 'low',
  RecordingQuality.medium: 'medium',
  RecordingQuality.high: 'high',
};

_$WritingPromptImpl _$$WritingPromptImplFromJson(Map<String, dynamic> json) =>
    _$WritingPromptImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      category: $enumDecode(_$PromptCategoryEnumMap, json['category']),
      subtitle: json['subtitle'] as String?,
      inspiration: json['inspiration'] as String?,
    );

Map<String, dynamic> _$$WritingPromptImplToJson(_$WritingPromptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'category': _$PromptCategoryEnumMap[instance.category]!,
      'subtitle': instance.subtitle,
      'inspiration': instance.inspiration,
    };

const _$PromptCategoryEnumMap = {
  PromptCategory.gratitude: 'gratitude',
  PromptCategory.growth: 'growth',
  PromptCategory.hopes: 'hopes',
  PromptCategory.memories: 'memories',
  PromptCategory.advice: 'advice',
  PromptCategory.encouragement: 'encouragement',
};
